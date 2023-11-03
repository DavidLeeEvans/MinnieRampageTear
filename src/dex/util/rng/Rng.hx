package dex.util.rng;

using dex.util.extensions.ArrayEx;

/**
 * A minimal zero-overhead implementation of a seeded pseudo-random number generator.
 *
 * The underlying implementation is a simple LCG with fixed parameters found online.
 *
 * It is implemented as an abstract around an integer which represents the state variable `x` of the LCG.
 */
enum abstract Rng(UInt)
{
    /**
     * Initialize a new pseudorandom generator.
     *
     * If the seed is left `null`, a time-based seed will be used with millisecond precision.
     *
     * @param seed the seed to use
     */
    public inline function new(?seed: UInt)
    {
        if (seed == null)
        {
            seed = Math.floor(Lua.time() * 1000);
        }
        this = next(seed);
    }

    /**
     * Returns either `true` or `false` with a specified probability.
     *
     * @param chance the probability that the returned value will be `true`
     */
    public inline function bool(chance: Float = 0.5): Bool
    {
        DexError.assert(chance >= 0.0 && chance <= 1.0);
        return float() < chance;
    }

    /**
     * Returns a random element from an array.
     */
    public inline function pick<T>(arr: Array<T>): T
    {
        var idx: Int = int(0, arr.length);
        return arr[ idx ];
    }

    /**
     * Removes a random element from an array and returns it.
     *
     * This modifies the array in-place and changes the order of elements.
     */
    public inline function take<T>(arr: Array<T>): T
    {
        var idx: Int = int(0, arr.length);
        return arr.removeAt(idx);
    }

    /**
     * Returns a random element from an array, with the choice being made according to given weights.
     *
     * The weights are arbitrary and should not be negative.
     *
     * @param arr the array to pick from
     * @param weights list of the weights for each element, needs to have non-negative numbers and have the same number of elements as `arr`
     * @return the element picked
     */
    public inline function pickWeighted<T>(arr: Array<T>, weights: Array<Float>): T
    {
        DexError.assert(arr.length == weights.length, 'pickWeighted: the weights array needs to have the same size as the array of elements');

        var weightsSum: Float = 0;
        for (w in weights)
        {
            DexError.assert(w >= 0, 'pickWeighted: negative weight found: $w');
            weightsSum += w;
        }

        var pick: Float = float(0, weightsSum);
        var i: Int = 0;
        var accum: Float = 0;
        while (i < arr.length)
        {
            accum += weights[ i ];

            if (accum > pick)
            {
                break;
            }

            i++;
        }

        return arr[ i ];
    }

    /**
     * Generate a random angle in the range `[-pi, pi)`.
     *
     * @return the angle in radians
     */
    public inline function angle(): Float
    {
        return float(-Math.PI, Math.PI);
    }

    /**
     * Generates a random number with a Gaussian distribution.
     *
     * @param mean the mean of the distribution
     * @param std the standard deviation of the distribution
     * @return the number
     */
    public inline function normal(mean: Float = 0, std: Float = 1): Float
    {
        var s: Float;
        var u: Float;
        var v: Float;

        do
        {
            u = float(-1, 1);
            v = float(-1, 1);
            s = (u * u) + (v * v);
        }
        while (s >= 1);

        var norm: Float = u * Math.sqrt(-2 * Math.log(s) / s);
        return mean + (std * norm);
    }

    /**
     * Generate a random roll of a D4 die.
     *
     * @return the result of the die roll
     */
    public inline function d4(): UInt
    {
        return int(1, 5);
    }

    /**
     * Generate a random roll of a D6 die.
     *
     * @return the result of the die roll
     */
    public inline function d6(): UInt
    {
        return int(1, 7);
    }

    /**
     * Generate a random roll of a D8 die.
     *
     * @return the result of the die roll
     */
    public inline function d8(): UInt
    {
        return int(1, 9);
    }

    /**
     * Generate a random roll of a D10 die.
     *
     * @return the result of the die roll
     */
    public inline function d10(): UInt
    {
        return int(1, 11);
    }

    /**
     * Generate a random roll of a D12 die.
     *
     * @return the result of the die roll
     */
    public inline function d12(): UInt
    {
        return int(1, 13);
    }

    /**
     * Generate a random roll of a D20 die.
     *
     * @return the result of the die roll
     */
    public inline function d20(): UInt
    {
        return int(1, 21);
    }

    /**
     * Generate a random roll of a D30 die.
     *
     * @return the result of the die roll
     */
    public inline function d30(): UInt
    {
        return int(1, 31);
    }

    /**
     * Generate a random roll of a D100 die.
     *
     * @return the result of the die roll
     */
    public inline function d100(): UInt
    {
        return int(1, 101);
    }

    /**
     * Generate a dice roll combination of multiple dice in an `NdS` fashion.
     *
     * Inspired by [this article](https://www.redblobgames.com/articles/probability/damage-rolls.html) which
     * illustrates how to get interesting probabilty distribution using just dice.
     *
     * @param nofDice the number of dice to roll
     * @param sides the number of sides on each die
     * @param roll how to combine the dice rolls
     * @return UInt
     */
    public inline function dice(nofDice: UInt, sides: DieSides, roll: DiceRoll = Sum): UInt
    {
        DexError.assert(nofDice > 0);
        DexError.assert(cast(sides, Int) > 0);

        var retVal: UInt = 1 + int(0, sides);

        for (i in 1...nofDice)
        {
            var value: UInt = 1 + int(0, sides);

            switch roll
            {
                case Sum:
                    retVal += value;

                case KeepHighest if (value > retVal):
                    retVal = value;

                case KeepLowest if (value < retVal):
                    retVal = value;

                default:
            }
        }

        return retVal;
    }

    /**
     * Shuffles an array in-place.
     */
    public inline function shuffle<T>(arr: Array<T>)
    {
        var currentIndex: Int = arr.length;

        while (currentIndex > 0)
        {
            var randomIndex: Int = int(0, currentIndex);
            currentIndex--;

            var tmp: T = arr[ randomIndex ];
            arr[ randomIndex ] = arr[ currentIndex ];
            arr[ currentIndex ] = tmp;
        }
    }

    /**
     * Generate a random integer in a given `[min, max)` range.
     *
     * @param min the minimum value (inclusive)
     * @param max the maximum value (exclusive)
     * @return the number
     */
    public inline function int(min: Int, max: Int): Int
    {
        this = next(this);
        return min + (this % (max - min));
    }

    /**
     * Generate a random float in a given `[min, max)` range.
     *
     * @param min the minimum value (inclusive)
     * @param max the maximum value (exclusive)
     * @return the number
     */
    public inline function float(min: Float = 0, max: Float = 1): Float
    {
        this = next(this);
        return min + ((max - min) * (this / 0xFFFFFFFF));
    }

    /**
     * Generates a new random seed.
     *
     * This is simply a shorthand to generating a new `UInt`, all the bits of which are uniformly distributed.
     *
     * @return the seed
     */
    public inline function seed(): UInt
    {
        this = next(this);

        return (this >> 16) | (this << 16);
    }

    /**
     * Generate a new `Rng` instance, whose seed will be determined by the current generator.
     *
     * @return the new instance
     */
    public inline function rng(): Rng
    {
        // to prevent the next instance continuing the same sequence as this one
        // its seed will be initialized to a bit-shifted permutation of this one's state
        return new Rng(seed());
    }

    static inline function next(x: UInt): UInt
    {
        // parameters from: https://en.wikipedia.org/wiki/Linear_congruential_generator#Parameters_in_common_use
        return ((1664525 * x) + 1013904223) & 0xFFFFFFFF;
    }
}
