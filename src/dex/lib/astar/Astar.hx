package dex.lib.astar;

/**
    ### defold-astar
    https://github.com/selimanac/defold-astar

    This is a path finder and A* solver (astar or a-star) native extension for Defold Engine build on MicroPather.
**/
@:native("astar")
extern class Astar
{
    /**
        Initializes the **A\*** API with the parameters of the map.

        Rule of thumb for `allocate`:

        - A few thousand points &rarr; Set to maximum to cache all states.
        - Tens of thousands of points &rarr; Set to `1/4` of the amount of states.
        - Larger &rarr; Set to around `5x` to `10x` of the length of an average path.

        @param map_width The width of the map grid in tiles.
        @param map_height The height of the map grid in tiles.
        @param direction The direction of movement that is allowed on the grid.
                        Either `DirectionFour` using Manhattan distance or `DirectionEight` using Euclidean distance.
        @param allocate How many states should be internally allocated at a time. This can be hard to get correct. The higher the value, the more memory the patfinder will use.
        @param typical_adjacent Used to determine cache size. The typical number of adjacent states to a given state. (On a chessboard, `8`.) Higher values use a little more memory.
        @param cache Turn on path caching. Uses more memory but at a huge speed advantage if you may call the pather with the same path or sub-path,
                     which is common for pathing over maps in games.
    **/
    static inline function setup(map_width: Int, map_height: Int, direction: Direction, allocate: Int = 250, typical_adjacent: Int = 6,
            cache: Bool = true): Void
    {
        // Hack to keep unused variables.
        // I did it this way instead of a normal extern, so that the last 3 parameters could be made optional.
        map_width = cast map_width;
        map_height = cast map_height;
        direction = cast direction;
        allocate = cast allocate;
        typical_adjacent = cast typical_adjacent;
        cache = cast cache;

        untyped __lua__('astar.setup(map_width, map_height, direction, allocate, typical_adjacent, cache)');
    }

    /**
        Sets the map data of the world. Setting a new map resets the current cache.

        The numbers in this array are arbitrary and can be chosen freely to represent different types of tiles
        in the map, which may have different costs for moving through them.

        Tiles which are meant to be impassable (i.e walls) can be assigned any number, while tiles means to be passable
        should then have their number mapped to a cost in the `set_costs()` method.

        **Hint:** For this library, you can use `Tilemap.getLayerMask()`.

        @param world The world grid described by an array with `map_width * map_height` elements.
                     The grid should be packed into this array row-by-row.
                     Meaning that the first element should contain tile `1x1`, the second should contain tile `2x1` and so on.
    **/
    static function set_map(world: Array<Int>): Void;

    /**
        Set costs for your walkable tiles on your world table. This table keys determine the walkable area.
        Tile numbers which exist in the `world` passed to `set_map()`, but do not exist as a key in `costs`
        are considered impassable.

        @param costs The map of costs, where each key represents a point in the world, as numbered in `set_map()`.
                     Each point is mapped to an array with 4 or 8 elements, depending on the `direction` specified in `setup()`.
                     Each element is the cost of moving from this point, to a given direction in this order: `E`, `N`, `W`, `S`, `NE`, `NW`, `SW`, `SE`.
    **/
    static function set_costs(costs: Map<Int, Array<Float>>): Void;

    /**
        Solve for the path from start to end.

        @param start_x The x-coordinate of the starting point.
        @param start_y The y-coordinate of the starting point.
        @param end_x The x-coordinate of the target point.
        @param end_y The y-coordinate of the target point.
        @return The resulting `AstarResult`, containing the path.
    **/
    static function solve(start_x: Int, start_y: Int, end_x: Int, end_y: Int): AstarResult;

    /**
        Find all the points within a given cost from starting point.

        @param start_x The x-coordinate of the starting point.
        @param start_y The y-coordinate of the starting point.
        @param max_cost The maximum cost (distance) from the starting point that will be checked.
                        (Higher values return larger 'near' sets and take more time to compute.)
        @return The resulting `AstarNearResult`, containing the list of points.
    **/
    static function solve_near(start_x: Int, start_y: Int, max_cost: Float): AstarNearResult;

    /**
        Resets the A* cache, freeing excess memory.
    **/
    static function reset_cache(): Void;
}
