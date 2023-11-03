package dex.map;

import dex.types.Direction;
import dex.util.DexError;
import dex.util.ds.Matrix2D;


class Autotitler
{
    var tileBitmasks: Map<UInt, TileBitmask>;
    var tiles: Array<UInt>;
    var baseTile: UInt;

    /**
     * Creates a new auto tiler.
     *
     * The tile bitmasks given, must contain at least one tile which is *full*, i.e whose bit
     * flags are all `1`.
     * That tile is designated as the **base tile**.
     *
     * @param tileBitmasks
     */
    public function new(tileBitmasks: Map<UInt, TileBitmask>)
    {
        this.tileBitmasks = tileBitmasks;
        tiles = [ ];

        baseTile = 0;
        for (tile => bitmask in tileBitmasks)
        {
            tiles.push(tile);
            if (bitmask.isFull())
            {
                DexError.assert(baseTile == 0, 'second base tile found');
                baseTile = tile;
            }
        }
        DexError.assert(baseTile != 0, 'no base tile found');

        // sort the tiles in descending order of bitmask sizes
        // this seems to help make the algorithm prefer "inner" tiles
        // when both inner and corner tiles are possible
        tiles.sort((a, b) -> tileBitmasks[ b ].countFlags() - tileBitmasks[ a ].countFlags());
    }

    /**
     * Performs an autotiling on the given map.
     * The input map is not changed by this method, a new autotiled variant of it is returned instead.
     *
     * All occurences of the base tile in the input map, will be replaced with the appropriate tile
     * according to the tile bitmasks given to the constructor.
     *
     * @param map the input map
     * @return the autotiled map
     */
    public function autotile(map: Matrix2D<UInt>): Matrix2D<UInt>
    {
        // replace all instances of the base tile with 0
        // this is done to later distinguish tiles that have not been determined
        var autoTiled: Matrix2D<Int> = map.map(tile -> tile == baseTile ? -1 : tile);

        // first pass
        // fill in the easy spots that only one tile can satisfy
        for (x in 0...autoTiled.width)
        {
            for (y in 0...autoTiled.height)
            {
                if (autoTiled[ x ][ y ] == -1)
                {
                    // this tile should be replaced
                    autoTiled[ x ][ y ] = determineTile(autoTiled, x, y);
                }
            }
        }

        // second pass
        // start the recursive algorithm for all undetermined tiles
        for (x in 0...autoTiled.width)
        {
            for (y in 0...autoTiled.height)
            {
                if (autoTiled[ x ][ y ] == -1)
                {
                    // from each undetermined tile that needs to be autotitled
                    // start a recursive DFS traversal to fill that tile and all
                    // other reachable tiles
                    var success: Bool = fillMapRecursive(autoTiled, x, y);
                    DexError.assertWarn(success, 'autotiling failed at ($x, $y)');
                }
            }
        }

        return autoTiled;
    }

    function determineTile(map: Matrix2D<Int>, x: Int, y: Int): Int
    {
        for (tile in tiles)
        {
            var bitmask: TileBitmask = tileBitmasks[ tile ];
            var match: Bool = true;

            // edges
            match = match && tileMatches(map, bitmask, x, y, 0, -1);
            match = match && tileMatches(map, bitmask, x, y, -1, 0);
            match = match && tileMatches(map, bitmask, x, y, 1, 0);
            match = match && tileMatches(map, bitmask, x, y, 0, 1);

            // corners
            match = match && tileMatches(map, bitmask, x, y, -1, -1);
            match = match && tileMatches(map, bitmask, x, y, 1, -1);
            match = match && tileMatches(map, bitmask, x, y, -1, 1);
            match = match && tileMatches(map, bitmask, x, y, 1, 1);

            if (match)
            {
                return tile;
            }
        }

        return -1;
    }

    inline function tileMatches(map: Matrix2D<UInt>, bitmask: TileBitmask, x: Int, y: Int, dx: Int, dy: Int): Bool
    {
        var match: Bool = true;

        var tx: Int = x + dx;
        var ty: Int = y + dy;

        if (map.inBounds(tx, ty))
        {
            var neighborOn: Bool = (map[ tx ][ ty ] == -1) || tileBitmasks.exists(map[ tx ][ ty ]);
            var expectOn: Bool = bitmask.get(dx, dy);

            if (expectOn && !neighborOn)
            {
                match = false;
            }
            else if (!expectOn && neighborOn)
            {
                match = false;
            }
        }
        else
        {
            // out of bounds tiles are considered non-matching
            match = false;
        }

        return match;
    }

    /**
     * The algorithm should start from an undetermined tile in the map, and run a DFS traversal
     * to all other reachable tiles.
     *
     * At each step, one possible tile is chosen and placed, and then the recursive filling continues until either all reachable tiles
     * are filled correctly, or a contradiction is reached.
     * When reaching a contradition, all tiles placed after the choice are removed, a new possible tile is chosen and the process continues.
     *
     * For each tile visited:
     * 1. Pick one tile id that can be placed at this position (i.e that connects to all 4 neighbors).
     * 2. Place it on the map
     * 3. Recursively call this method for each of the 4 neighbors.
     * 4. If any of the neighbors' recursive calls return `false`, remove the tile from the map and return to step `1`.
     * 5. If no fitting tiles are left, return `false`.
     *
     * @param map the map, which will be filled in-place
     * @param x the x-position where to start the algorithm
     * @param y the y-position where to start the algorithm
     * @return `true` if the traversal starting from this position was able to autotile the map correctly
     */
    function fillMapRecursive(map: Matrix2D<Int>, x: Int, y: Int): Bool
    {
        if (!map.inBounds(x, y))
        {
            // the recursive algorithm terminates when out of bounds
            return true;
        }

        if (map[ x ][ y ] != -1)
        {
            // this tile has already been filled in
            return true;
        }

        // pick one tile at a time
        for (tile in tiles)
        {
            var bitmask: TileBitmask = tileBitmasks[ tile ];
            var matches: Bool = true;
            matches = matches && tileConnectsToNeighbor(map, bitmask, x, y, Up);
            matches = matches && tileConnectsToNeighbor(map, bitmask, x, y, Right);
            matches = matches && tileConnectsToNeighbor(map, bitmask, x, y, Down);
            matches = matches && tileConnectsToNeighbor(map, bitmask, x, y, Left);
            if (!matches)
            {
                // skip this tile, it doesn't fit into the map as-is
                continue;
            }

            // tile first, place it and attempt to continue
            map[ x ][ y ] = tile;

            // with that tile filled in, attempt to recursively fill the neighbors
            matches = matches && fillMapRecursive(map, x - 1, y);
            matches = matches && fillMapRecursive(map, x + 1, y);
            matches = matches && fillMapRecursive(map, x, y - 1);
            matches = matches && fillMapRecursive(map, x, y + 1);
            if (matches)
            {
                // all neighbors' recursive steps reported that the map was filled in correctly
                // keep the tile that was just placed and return
                return true;
            }

            // placing this tile lead to the map to not being solvable - reset it and try the next one
            // @TODO: one neighbor returned false, but another may have returned true
            //        the traversal trees for the neighbors that returned true might need to be cleared also
            map[ x ][ y ] = -1;
        }

        // all tiles were checked, and none could be placed in this position in a way that satisfies the autotiling
        // at this point this tile should still be -1
        DexError.assert(map[ x ][ y ] == -1);
        return false;
    }

    /**
     * This function returns `true` if:
     * - The neighbor in this direction is out of bounds, and the mid-tile in that side's bitmask expects `0`
     * - The neighbor in this direction is in bounds, and their bitmask's match (e.g for the `Left` direction, this tile's left-side bitmask must much the neighbor's right-side bitmask)
     * - The neighbor in this direction is in bounds, and is not yet filled in
     */
    inline function tileConnectsToNeighbor(map: Matrix2D<Int>, bitmask: TileBitmask, x: Int, y: Int, direction: Direction): Bool
    {
        var dx: Int = direction.dirX();
        var dy: Int = direction.dirY();
        var expectOn: Bool = bitmask.get(dx, dy);

        var tx: Int = x + dx;
        var ty: Int = y + dy;

        if (!map.inBounds(tx, ty))
        {
            return !expectOn;
        }

        var neighbor: Int = map[ tx ][ ty ];
        if (neighbor == -1)
        {
            // assume ok
            return expectOn;
        }
        if (!tileBitmasks.exists(neighbor))
        {
            // neighbor is not an autotiled tile
            // connect only if it's expected that that tile is not part of the pattern
            return !expectOn;
        }

        return bitmask.connectsTo(tileBitmasks[ neighbor ], direction);
    }
}
