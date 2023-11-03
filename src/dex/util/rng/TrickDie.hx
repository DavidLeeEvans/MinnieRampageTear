package dex.util.rng;

/**
 * This is a utility class which represents a *fraudulent* dice-roll generator.
 *
 * The dice rolls from this generator will be forced to go through all possible sides of the die
 * over a configurable number of rolls.
 *
 * This is useful in cases where cases of extreme good or bad luck should be avoided.
 *
 * The result can be tuned using the `period` parameter. For example, if rolling `D4` dice:
 * - A `period` of `1` means that the numbers `[1, 2, 3, 4]` will each be rolled at least once in the first `4` rolls, then again in the next `8` etc.
 * - A `period` of `2` means that the numbers `[1, 2, 3, 4]` will each be rolled at least twice in the first `8` rolls, then again in the next `8` etc.
 * - and so on...
 *
 * So with increasing `period` values, the random sequence will become more unpredictable, but also extreme cases will become more likely.
 */
class TrickDie
{
    public final sides: DieSides;
    public final period: UInt;

    var rng: Rng;
    var sequence: Array<UInt>;
    var idx: Int;

    /**
     * Initialize a new trick die generator.
     *
     * @param sides the sides of the dice; you may use the enum or provide any positive integer
     * @param period the number of times that all the possible die values will be present in hyperperiod;
     *               a period of `1` will result in each die roll happening exactly once in every sequence of `#sides` rolls
     * @param seed the seed to use for the random number generation that will pick the dice rolls
     */
    public function new(sides: DieSides, period: UInt, ?seed: UInt)
    {
        DexError.assert(cast(sides, Int) > 0, 'the number of die sides must be a positive number');
        DexError.assert(period > 0, 'the period length must be a positive number');

        this.sides = sides;
        this.period = period;

        rng = new Rng(seed);

        // allocate the sequence array
        var nofValues = cast(sides, Int) * period;
        sequence = [ for (_ in 0...nofValues) 0 ];

        // set the index to the end of the sequence
        // this will force the sequence to get generated at the first call to roll()
        idx = sequence.length;
    }

    /**
     *  Generate the next dice roll.
     *
     * @return the dice roll, as an integer in the range `[1, sides]`.
     */
    public function roll(): UInt
    {
        if (idx >= sequence.length)
        {
            // end of the sequence reached, generate the next one
            generateSequence();
        }

        return sequence[ idx++ ];
    }

    function generateSequence()
    {
        var sides: Int = cast(sides, Int);
        for (p in 0...period)
        {
            for (v in 0...sides)
            {
                sequence[ (sides * p) + v ] = v + 1; // die values are 1-indexed
            }
        }

        // now the array contains [ 1, 2, 3, 4, ..., 1, 2, 3, 4, ... ]

        // so now just shuffle it to create the sequence
        rng.shuffle(sequence);
        idx = 0;
    }
}
