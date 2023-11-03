package dex.util.ds;

/**
 * Defold does not currently support rotating tiles in tilemaps.
 * Therefore it is necessary to implement this in the tilesource, where tiles that can be rotated
 * should have their rotated versions also present in the tilesource.
 *
 * This abstract works as a lookup table for tile rotations as an array of integers.
 * Each element in the array points to the tile id which is the 90-degree clockwise rotation of itself.
 * For example for tile with id `t`:
 * - Its 90-degree clockwise rotation will be stored in `table[t]`
 * - Its 180-degree rotation will be stored in `table[table[t]]`
 * - Its 270-degree rotation will be stored in `table[table[table[t]]]`
 * - Finally `table[table[table[table[t]]]]` would be a 360-degree rotation, so it points back to `t`.
 *
 * By default, all entries in the lookup table `table[t]` will be equal to `t`.
 * In other words, tiles wih no rotations specified will just stay the same when rotated.
 */
abstract TileRotationTable(Array<UInt>)
{
    /**
     * Initialize a new tile rotation lookup table.
     *
     * @param nofTiles the total number of tiles in the tilesource
     */
    public function new(nofTiles: UInt)
    {
        // initialize all lookups to the same tile id
        // by default tiles with no rotations defined will just point to themselves
        this = [ for (t in 0...nofTiles + 1) t ];
    }

    /**
     * Adds a rotation sequence to the lookup table.
     *
     * The input `rotationSequence` should be an array with `2` or `4` elements, where each element
     * is the tile id that represents a 90-degree clockwise rotation of the tile before it.
     *
     * So `rotationSequence[1]` is the 90-degree clockwise rotation of `rotationSequence[0]`, and so on...
     *
     * @param rotationSequence the rotation sequence as an array of `2` or `4` elements
     */
    public function add(rotationSequence: Array<UInt>)
    {
        DexError.assert(rotationSequence.length == 2 || rotationSequence.length == 4,
            'rotation sequences need to have exactly 2 or 4 elements, but ${rotationSequence.length} were given'
        );

        for (i in 0...rotationSequence.length)
        {
            var tile: Int = rotationSequence[ i ];
            var next: Int = rotationSequence[ (i + 1) % rotationSequence.length ];

            // ensure that the tile given is valid
            // no need to assert for next, its value will be verified on its own iteration
            DexError.assert(tile < this.length, 'tile ${rotationSequence[ i ]} given in rotation sequence exceeds the maximum tile id');

            // ensure that this tile hasn't already been defined in another rotation sequence
            DexError.assert(this[ tile ] == tile, 'tile $tile has been defined in two rotation sequences, one to ${this[ tile ]} and one to $next');

            this[ tile ] = next;
        }
    }

    /**
     * Get the tile that corresponds to a 90-degree clockwise rotation from a given tile.
     */
    public inline function getClockwise(tile: UInt): UInt
    {
        return this[ tile ];
    }

    /**
     * Get the tile that corresponds to a 180-degree clockwise rotation from a given tile.
     */
    public inline function getSemicircle(tile: UInt): UInt
    {
        return this[ this[ tile ] ];
    }

    /**
     * Get the tile that corresponds to a 270-degree clockwise rotation from a given tile.
     */
    public inline function getCounterClockwise(tile: UInt): UInt
    {
        return this[ this[ this[ tile ] ] ];
    }

    /**
     * Shorthand to creating a rotation table from a 2D array.
     *
     * @param nofTiles the total number of tiles in the tilesource
     * @param rotationSequences the rotation sequences as a Nx4 array
     */
    public static inline function fromArray(nofTiles: UInt, rotationSequences: Array<Array<UInt>>)
    {
        var table: TileRotationTable = new TileRotationTable(nofTiles);

        for (rotationSequence in rotationSequences)
        {
            table.add(rotationSequence);
        }

        return table;
    }
}
