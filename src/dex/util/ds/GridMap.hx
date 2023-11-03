package dex.util.ds;

/**
 * This abstract exists to wrap the return value of `GridMap.getColumn()`.
 */
@:forward(exists, iterator, remove, keyValueIterator)
abstract GridMapColumn<T>(Map<Int, T>) from Map<Int, T>
{
    public inline function new()
    {
        this = [ ];
    }

    @:op([ ])
    inline function get(i: Int): T
    {
        return this[ i ];
    }

    @:op([ ])
    inline function set(i: Int, v: T)
    {
        this.set(i, v);
    }
}

/**
 * Simple abstract type representing a 2D grid.
 *
 * The grid is not pre-allocated and has infinite size.
 */
abstract GridMap<T>(Map<Int, Map<Int, T>>)
{
    public function new()
    {
        this = [ ];
    }

    /**
     * Checks if an item exists in the grid map at the given coordinates.
     *
     * @param x the x-coordinate
     * @param y the y-coordinate
     * @return `true` if an item exists
     */
    public inline function exists(x: Int, y: Int): Bool
    {
        return this.exists(x) && this[ x ].exists(y);
    }

    /**
     * Removes an item exists from the grid map at the given coordinates.
     *
     * @param x the x-coordinate
     * @param y the y-coordinate
     * @return `true` if an item existed at was removed
     */
    public inline function remove(x: Int, y: Int): Bool
    {
        return this.exists(x) && this[ x ].remove(y);
    }

    /**
     * Loop over all elements in the grid.
     *
     * @param fn the callback function for each element
     */
    public function forEach(fn: T->Void)
    {
        for (x => column in this)
        {
            for (y => item in column)
            {
                fn(item);
            }
        }
    }

    /**
     * Loop over all elements in the grid.
     *
     * @param fn the callback function for each element and its coordinates in the matrix
     */
    public function forEachXY(fn: (Int, Int, T) -> Void)
    {
        for (x => column in this)
        {
            for (y => item in column)
            {
                fn(x, y, item);
            }
        }
    }

    @:op([ ])
    inline function getColumn(x: Int): GridMapColumn<T>
    {
        if (!this.exists(x))
        {
            this.set(x, [ ]);
        }

        return this[ x ];
    }
}
