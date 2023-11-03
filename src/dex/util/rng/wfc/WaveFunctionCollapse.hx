package dex.util.rng.wfc;

import dex.types.Direction;
import dex.util.ds.Matrix2D;
import dex.util.ds.PriorityQueue;
import dex.util.ds.TileFlipTable;
import dex.util.ds.TileRotationTable;

using dex.util.DexError;

/**
 * The pseudorandom generation sequence is updated every time `generate()` is called.
 * As such, two consecutive calls to `generate()` will generate different maps, both derived from the initial seed.
 *
 * Terminology:
 * - `tile`: a `UInt` value that represents a tile on a tilemap
 * - `cell`: an area of `KxK` tiles
 * - `wave`: a grid of cells
 */
class WaveFunctionCollapse
{
    final input: Matrix2D<UInt>;
    final kernel: UInt;
    final stride: UInt;
    var rng: Rng;
    var patterns: Array<Pattern>;

    var tileRotationTable: TileRotationTable;
    var tileFlipTable: TileFlipTable;

    /**
     * Initializes a new WFC generator.
     *
     * Given an input of width `W`, height `H`, kernel size `K`, and stride `S`, the number of possible tile patterns will be:
     * `[ 1 + (W - K)/S ]*[ 1 + (H - K)/S ]`.
     *
     * To extract non-overlapping patterns from the input tilemap, set `stride` to the same value as `kernel`.
     *
     * @param input the input tilemap
     * @param kernel the size `K` of the kernel used to extract `KxK` patterns from the input tilemap
     * @param stride the stride is the number of tiles that the kernel window is moved when extracting each pattern from the input tilemap
     * @param seed seed used for the random number generator; if `null`, a time-dependant seed will be used
     */
    public function new(input: Matrix2D<UInt>, kernel: UInt, stride: UInt = 1, ?seed: UInt)
    {
        DexError.assert(input.width > 0);
        DexError.assert(input.height > 0);
        DexError.assert(input.width >= kernel);
        DexError.assert(input.height >= kernel);
        DexError.assertWarn(stride <= kernel, 'stride $stride is larger than kernel size $kernel, this will cause some input tiles to be missed');

        this.input = input;
        this.kernel = kernel;
        this.stride = stride;
        rng = new Rng(seed);

        var patternsPerRow: Int = 1 + Std.int((input.width - kernel) / stride);
        var nofBasicPatterns: UInt = (Std.int((input.width - kernel) / stride) + 1) * (Std.int((input.height - kernel) / stride) + 1);
        patterns = [ for (id in 0...nofBasicPatterns) new Pattern(id, patternsPerRow, stride) ];

        tileRotationTable = null;
        tileFlipTable = null;
    }

    /**
     * Enables a pattern transform for the WFC generation.
     *
     * Patterns cannot be transformed twice. So every time a transform is enabled,
     * it is applied only to the basic non-transformed patterns.
     *
     * Therefore, for every transform that is enabled, the list of patterns is expanded by the number of basic patterns.
     *
     * @param transform the transform to enable
     */
    public function enablePatternTransform(transform: PatternTransform)
    {
        // ensure that this transform wasn't already enabled
        for (p in patterns)
        {
            DexError.assert(p.transform != transform, 'transform $transform has already been enabled');
        }

        switch transform
        {
            case Rotate(_) if (kernel != 2 && kernel != 3):
                DexError.error('rotations are currently supported only for K=2 and K=3');

            default:
        }

        // create a new list of all basic non-transformed patterns
        var basicPatterns: Array<Pattern> = patterns.filter(p -> p.transform == None);

        // create the new transformed patterns
        var transformedPatterns: Array<Pattern> = basicPatterns.map(p -> p.transformed(transform));

        // add to the patterns list
        patterns = patterns.concat(transformedPatterns);
    }

    /**
     * Disables a pattern transform.
     *
     * @param transform the transform to disable
     */
    public inline function disablePatternTransform(transform: PatternTransform)
    {
        patterns = patterns.filter(p -> p.transform != transform);
    }

    /**
     * By default, if a `Rotation` transform is enabled, the individual tiles are not actually changed.
     * For example, for a `Clockwise` rotation a pattern will just take the top-left tile and place it on the top-right.
     *
     * If it is necessary to also rotate the tiles themselves, then this method should be used to pass the tile rotation table used.
     * Then, in the above example the top-left tile would be placed on the top-right of the rotated pattern, and then also the
     * tile would be rotated clockwise using the table.
     *
     * @param tileRotationTable the tile rotation table
     */
    public inline function setTileRotationTable(tileRotationTable: TileRotationTable)
    {
        this.tileRotationTable = tileRotationTable;
    }

    /**
     * By default, if a flip transform is enabled, the individual tiles are not actually changed.
     * For example, for a `tileFlipTable` transform a pattern will just take the top-left tile and place it on the top-right.
     *
     * If it is necessary to also flip the tiles themselves, then this method should be used to pass the tile flip table used.
     * Then, in the above example the top-left tile would be placed on the top-right of the flipped pattern, and then also
     * the tile would be flipped horizontally using the table.
     *
     * @param tileFlipTable the tile flip table
     */
    public inline function setTileFlipTable(tileFlipTable: TileFlipTable)
    {
        this.tileFlipTable = tileFlipTable;
    }

    /**
     * Re-seed the generator.
     *
     * @param seed the seed
     */
    public function setSeed(seed: UInt)
    {
        rng = new Rng(seed);
    }

    /**
     * Generate a tilemap using the WFC algorithm.
     *
     * @param width the width of the generated tilemap
     * @param height the height of the generated tilemap
     * @return the generated tilemap, or `null` if a contradiction state was reached during generation
     */
    public function generate(width: Int, height: Int): Matrix2D<UInt>
    {
        var map: Matrix2D<UInt> = new Matrix2D(width, height, 0);

        var generated: Bool = generateOn(map);

        return generated ? map : null;
    }

    /**
     * Generate a tilemap using the WFC algorithm, by completing a given map.
     *
     * The given map can be used to pass constraints to the algorithm.
     * Tiles in this map that are not `0`, will stay the same in the final generated tilemap.
     *
     * @param map the tilemap of constraints
     * @return `true` if the map was generated, and `false` if a contradiction state was reached
     */
    public function generateOn(map: Matrix2D<UInt>): Bool
    {
        var width: Int = map.width;
        var height: Int = map.height;

        DexError.assert(width % kernel == 0, 'the generated map width ($width) must be divisible by the kernel size ($kernel)');
        DexError.assert(height % kernel == 0, 'the generated map height ($height) must be divisible by the kernel size ($kernel)');

        // ===========================================================================================================
        //                                     INITIALIZE WAVE
        // ===========================================================================================================
        // initialize the wave with all cells unobserved
        var wave: Matrix2D<Cell> = new Matrix2D(Std.int(width / kernel), Std.int(height / kernel), null);
        for (x in 0...wave.width)
        {
            for (y in 0...wave.height)
            {
                var cell: Cell =
                {
                    x: x,
                    y: y,
                    observed: false,
                    seen: false,
                    pattern: null,
                    // cells are initialized with max entropy
                    // i.e all patterns are possible
                    priority: patterns.length,
                    possiblePatterns: patterns,
                };

                wave[ x ][ y ] = cell;
            }
        }


        // ===========================================================================================================
        //                                     APPLY CONSTRAINTS
        // ===========================================================================================================
        // apply constraints if necessary
        // this is done by decreasing the entropy of corresponding cells before starting the algorithm
        // i.e limiting the possible patterns for these tiles, to those that match with the given constraint tiles
        var minEntropyCell: Cell = null;
        var constraints: Matrix2D<UInt> = map;
        for (x in 0...constraints.width)
        {
            for (y in 0...constraints.height)
            {
                var constraint: UInt = constraints[ x ][ y ];
                if (constraint == 0)
                {
                    // no constraint at these coordinates
                    continue;
                }

                // get the corresponding cell and pattern coordinates in the wave
                var wx: Int = Std.int(x / kernel);
                var wy: Int = Std.int(y / kernel);
                var cell: Cell = wave[ wx ][ wy ];
                var kx: Int = x % kernel;
                var ky: Int = y % kernel;

                // limit the possible patterns to only those that include this tile at this position
                function patternMeetsConstraint(p: Pattern)
                {
                    return p.get(input, kernel, kx, ky, tileRotationTable, tileFlipTable) == constraint;
                }
                cell.possiblePatterns = cell.possiblePatterns.filter(patternMeetsConstraint);
                cell.priority = cell.possiblePatterns.length;

                if (cell.priority < patterns.length)
                {
                    // this cell now has lower-than-max entropy
                    if (cell.priority == 0)
                    {
                        // this constraint lead to a contradiction
                        // here we throw an error instead of returning false, since this was caused
                        // entirely by the user's constraints without any randomness introduced
                        DexError.error('no pattern exists that meet the given constraints');
                    }
                    else if (cell.priority == 1)
                    {
                        // the constraints narrowed this cell down to one possibility
                        // this means that this cell has collapsed to a single pattern
                        cell.pattern = cell.possiblePatterns[ 0 ];
                        cell.priority = 0;
                        cell.observed = true;

                        // the cell's possiblePatterns field is left as-is
                        // because if another tile also refers to this cell, it may restrict the possibilities even further
                        // and if the entropy is reduced to 0 as a result, we should end up in the branch above and go into error
                    }
                    else if (minEntropyCell == null || cell.priority < minEntropyCell.priority)
                    {
                        // this is the new cell with the lowest non-zero entropy
                        minEntropyCell = cell;
                    }
                }
            }
        }


        // ===========================================================================================================
        //                                     PICK CELL TO START FROM
        // ===========================================================================================================
        var firstCell: Cell = null;
        if (minEntropyCell == null)
        {
            // pick a random cell to start from
            firstCell = wave[ rng.int(0, wave.width) ][ rng.int(0, wave.height) ];
            // in theory, the first cell should have all possibilities available
            // however we should also support user-imposed constraints, which may limit the possible options
            firstCell.possiblePatterns = getPossiblePatternsFor(wave, firstCell);
        }
        else
        {
            // start from the lowest-entropy cell
            firstCell = minEntropyCell;
        }

        // initialize the priority queue
        var cellQueue: PriorityQueue<Cell> = new PriorityQueue();
        cellQueue.add(firstCell);


        // ===========================================================================================================
        //                                     GENERATION LOOP
        // ===========================================================================================================
        while (cellQueue.length > 0)
        {
            // get the next cell to collapse
            // it should be the cell with the lowest non-zero entropy remaining
            var cell: Cell = cellQueue.getNext();

            DexError.assert(!cell.observed, 'trying to collapse an already-observed cell');
            DexError.assert(cell.possiblePatterns != null, 'trying to collapse a cell without entropy calculated');
            DexError.assert(
                cell.priority == cell.possiblePatterns.length,
                'cell has ${cell.possiblePatterns.length} possible patterns, but its entropy is ${cell.priority}'
            );

            if (cell.priority == 0)
            {
                // we have a problem...
                // this cell has not been observed yet, but it has no entropy left
                // this means we have reached a contradiction
                // the only thing to do now is to exit and start from the beginning
                // @TODO: this can maybe be optimized with backtracking, instead of starting again from the beginning
                //        it may be possible to backtrack to the last cell observation where we made a random choice,
                //        and make a different one
                return false;
            }

            // observe the cell
            // update the cell with its new observed state
            // pick one of the possible patterns at random to assign to it
            // @TODO: this can be optimized by picking a choice that does not lead
            //        to a contradiction on any of the neighbors
            cell.pattern = rng.pick(cell.possiblePatterns);
            cell.possiblePatterns = null;
            cell.priority = 0;
            cell.observed = true;

            // now go through all its neighbors
            // they should have their possible patterns calculated, their entropies updated,
            // and they should be added to the priority queue
            forEachNeighborOf(wave, cell, (dir, neighbor) ->
            {
                if (neighbor.observed)
                {
                    // neighbor has been observed already
                    return true;
                }

                var previousEntropy: Int = neighbor.priority;

                // update the neighbor's possible patterns and entropy
                neighbor.possiblePatterns = getPossiblePatternsFor(wave, neighbor);
                neighbor.priority = neighbor.possiblePatterns.length;

                DexError.assert(neighbor.priority <= previousEntropy, 'neighbors entropy somehow increased?');

                if (!neighbor.seen)
                {
                    // this is the first time this neighbor has been seen
                    // it needs to be added to the priority queue
                    cellQueue.add(neighbor);
                    neighbor.seen = true;
                }
                else if (neighbor.priority != previousEntropy)
                {
                    // neighbor's entropy changed
                    // we need to remove him from the priority queue and add him again
                    cellQueue.remove(neighbor);
                    cellQueue.add(neighbor);
                }
                else
                {
                    // nothing to do
                    // this neighbor has been seen before, and his entropy hasn't changed since then
                }

                return true;
            });
        }


        // ===========================================================================================================
        //                                     EXPAND WAVE TO MAP
        // ===========================================================================================================
        // generation loop done
        // now the wave is a grid of observed cells
        // the final step is to replace generate the final map, where each KxK section will be a filled pattern
        wave.forEach(cell ->
        {
            // for each cell in the wave, generate the KxK area in the final image
            for (kx in 0...kernel)
            {
                for (ky in 0...kernel)
                {
                    DexError.assert(cell.observed, 'moved on to the expansion step with a cell still unobserved');

                    var tileValue: UInt = cell.pattern.get(input, kernel, kx, ky, tileRotationTable, tileFlipTable);

                    var genX: Int = (cell.x * kernel) + kx;
                    var genY: Int = (cell.y * kernel) + ky;

                    map[ genX ][ genY ] = tileValue;
                }
            }
        });

        return true;
    }

    /**
     * Gets all the possible pattern ids for a given cell.
     *
     * This takes the current list `cell.possiblePatterns`, and filters it down to the patterns
     * that are still available for this cell given its neighbors.
     */
    inline function getPossiblePatternsFor(wave: Matrix2D<Cell>, cell: Cell): Array<Pattern>
    {
        // which patterns to consider for this cell?
        var patternstoConsider: Array<Pattern> = cell.possiblePatterns;

        // filter which of these are still possible
        var possiblePatterns: Array<Pattern> = [ ];
        for (pattern in patternstoConsider)
        {
            if (isPatternPossibleFor(wave, cell, pattern))
            {
                possiblePatterns.push(pattern);
            }
        }

        return possiblePatterns;
    }

    /**
     * Checks if a given pattern is compatible with a given cell position.
     *
     * Will return `true` if the pattern can be placed on the `cell` without creating
     * inconsistencies with any of its neighbors.
     */
    function isPatternPossibleFor(wave: Matrix2D<Cell>, cell: Cell, pattern: Pattern): Bool
    {
        var possible: Bool = true;

        // check with all neighbor cells
        forEachNeighborOf(wave, cell, (dir, neighbor) ->
        {
            if (!neighbor.observed)
            {
                // neighbor not observed yet, don't care
                return true;
            }

            if (!doPatternsMatch(pattern, dir, neighbor.pattern))
            {
                // this pattern is incompatible with this neighbor
                possible = false;
                return false;
            }

            return true;
        });

        return possible;
    }

    function doPatternsMatch(pattern: Pattern, direction: Direction, neighborPattern: Pattern): Bool
    {
        switch direction
        {
            case Up:
                {
                    // compare the top of owr own pattern with the bottom of the neighbor's pattern
                    for (x in 0...kernel)
                    {
                        var tile: Int = pattern.get(input, kernel, x, kernel - 1, tileRotationTable, tileFlipTable);
                        var neighborTile: Int = neighborPattern.get(input, kernel, x, 0, tileRotationTable, tileFlipTable);

                        if (tile != neighborTile)
                        {
                            return false;
                        }
                    }
                }

            case Right:
                {
                    // compare the right of owr own pattern with the left of the neighbor's pattern
                    for (y in 0...kernel)
                    {
                        var tile: Int = pattern.get(input, kernel, kernel - 1, y, tileRotationTable, tileFlipTable);
                        var neighborTile: Int = neighborPattern.get(input, kernel, 0, y, tileRotationTable, tileFlipTable);

                        if (tile != neighborTile)
                        {
                            return false;
                        }
                    }
                }

            case Down:
                {
                    // compare the bottom of owr own pattern with the top of the neighbor's pattern
                    for (x in 0...kernel)
                    {
                        var tile: Int = pattern.get(input, kernel, x, 0, tileRotationTable, tileFlipTable);
                        var neighborTile: Int = neighborPattern.get(input, kernel, x, kernel - 1, tileRotationTable, tileFlipTable);

                        if (tile != neighborTile)
                        {
                            return false;
                        }
                    }
                }

            case Left:
                {
                    // compare the left of owr own pattern with the right of the neighbor's pattern
                    for (y in 0...kernel)
                    {
                        var tile: Int = pattern.get(input, kernel, 0, y, tileRotationTable, tileFlipTable);
                        var neighborTile: Int = neighborPattern.get(input, kernel, kernel - 1, y, tileRotationTable, tileFlipTable);

                        if (tile != neighborTile)
                        {
                            return false;
                        }
                    }
                }

            default:
                DexError.error('invalid direction');
        }

        return true;
    }

    /**
     * Iterates over all `4` neighbors of a given cell.
     *
     * @param wave the current wave
     * @param cell the cell whose neighbors to iterate
     * @param callback the callback function for each neighbor; if it returns `false`, the iteration is stopped
     */
    function forEachNeighborOf(wave: Matrix2D<Cell>, cell: Cell, callback: (direction: Direction, neighbor: Cell) -> Bool)
    {
        var directions: Array<Direction> = [ Up, Right, Down, Left ];
        for (dir in directions)
        {
            var neighborX: Int = cell.x + dir.dirX();
            var neighborY: Int = cell.y + dir.dirY();

            if ((neighborX < 0) || (neighborX >= wave.width) || (neighborY < 0) || (neighborY >= wave.height))
            {
                // out of bounds, don't care
                continue;
            }

            if (!callback(dir, wave[ neighborX ][ neighborY ]))
            {
                break;
            }
        }
    }
}
