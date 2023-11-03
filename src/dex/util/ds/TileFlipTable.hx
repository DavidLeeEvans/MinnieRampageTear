package dex.util.ds;

/**
 * This type serves as a lookup table for tiles whose flipped versions exist in the tilesource.
 *
 * It is implemented as a `3xN` array, where:
 * - The first column points each tile to its horizontally flipped variant.
 * - The second column points each tile to its vertically flipped variant.
 * - The third column points each tile to its horizontally+vertically flipped variant.
 *
 * Unless otherwise configured, all tiles are set to stay the same when flipped.
 */
abstract TileFlipTable(Array<Array<UInt>>)
{
    /**
     * Initialize a new tile flip lookup table.
     *
     * @param nofTiles the total number of tiles in the tilesource
     */
    public function new(nofTiles: UInt)
    {
        this = [
            [ for (t in 0...nofTiles + 1) t ],
            [ for (t in 0...nofTiles + 1) t ],
            [ for (t in 0...nofTiles + 1) t ]
        ];
    }

    public inline function getHorizontal(tile: UInt): UInt
    {
        return this[ 0 ][ tile ];
    }

    public inline function getVertical(tile: UInt): UInt
    {
        return this[ 1 ][ tile ];
    }

    public inline function getHorizontalAndVertical(tile: UInt): UInt
    {
        return this[ 2 ][ tile ];
    }

    public inline function addHorizontal(t1: UInt, t2: UInt)
    {
        DexError.assert(t1 < this[ 0 ].length, 'tile $t1 exceeds the maximum tile id');
        DexError.assert(t2 < this[ 0 ].length, 'tile $t2 exceeds the maximum tile id');

        DexError.assert(this[ 0 ][ t1 ] == t1, 'tile $t1 has been defined as having more than one horizontal flip');
        DexError.assert(this[ 0 ][ t2 ] == t2, 'tile $t2 has been defined as having more than one horizontal flip');

        this[ 0 ][ t1 ] = t2;
        this[ 0 ][ t2 ] = t1;
    }

    public inline function addVertical(t1: UInt, t2: UInt)
    {
        DexError.assert(t1 < this[ 1 ].length, 'tile $t1 exceeds the maximum tile id');
        DexError.assert(t2 < this[ 1 ].length, 'tile $t2 exceeds the maximum tile id');

        DexError.assert(this[ 1 ][ t1 ] == t1, 'tile $t1 has been defined as having more than one vertical flip');
        DexError.assert(this[ 1 ][ t2 ] == t2, 'tile $t2 has been defined as having more than one vertical flip');

        this[ 1 ][ t1 ] = t2;
        this[ 1 ][ t2 ] = t1;
    }

    public inline function addHorizontalAndVertical(t1: UInt, t2: UInt)
    {
        DexError.assert(t1 < this[ 2 ].length, 'tile $t1 exceeds the maximum tile id');
        DexError.assert(t2 < this[ 2 ].length, 'tile $t2 exceeds the maximum tile id');

        DexError.assert(this[ 2 ][ t1 ] == t1, 'tile $t1 has been defined as having more than one horizontal+vertical flip');
        DexError.assert(this[ 2 ][ t2 ] == t2, 'tile $t2 has been defined as having more than one horizontal+vertical flip');

        this[ 2 ][ t1 ] = t2;
        this[ 2 ][ t2 ] = t1;
    }

    public inline function add(t: UInt, horizontal: UInt, vertical: UInt, verticalAndHorizontal: UInt)
    {
        addHorizontal(t, horizontal);
        addVertical(t, vertical);
        addHorizontalAndVertical(t, verticalAndHorizontal);
    }

    /**
     * Create a tile flip table from a 2D array of size `Nx4`.
     * Each row of this array should have the following `4` elements:
     * - `[0]:` a tile id `t`
     * - `[1]:` the id of a tile that is `t` flipped horizontally
     * - `[2]:` the id of a tile that is `t` flipped vertically
     * - `[3]:` the id of a tile that is `t` flipped horizontally+vertically
     *
     * @param nofTiles
     * @param table
     * @return TileFlipTable
     */
    public static function fromTable(nofTiles: Int, table: Array<Array<UInt>>): TileFlipTable
    {
        DexError.assert(table.length > 0);

        var flipTable: TileFlipTable = new TileFlipTable(nofTiles);

        for (i in 0...table.length)
        {
            DexError.assert(table[ i ].length == 4);

            flipTable.add(table[ i ][ 0 ], table[ i ][ 1 ], table[ i ][ 2 ], table[ i ][ 3 ]);
        }

        return flipTable;
    }
}
