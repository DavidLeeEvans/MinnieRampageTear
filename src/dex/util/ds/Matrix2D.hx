package dex.util.ds;

using StringTools;

/**
 * This abstract exists to wrap the return value of `Matrix2D.getColumn()`.
 *
 * It only allows array get/set access, while hiding all of the other array methods.
 * Since `Matrix2D` is supposed to maintain a constant size, this helps to prevent accidentally
 * modifying the size of one of the columns.
 *
 * This is needed because Haxe doesn't support regular 2D arrays, so they have to be emulated
 * using an array of arrays.
 */
abstract MatrixColumn<T>(Array<T>) from Array<T>
{
    @:op([ ])
    inline function get(i: Int): T
    {
        return this[ i ];
    }

    @:op([ ])
    inline function set(i: Int, v: T)
    {
        this[ i ] = v;
    }
}

/**
 * Simple abstract type representing a preallocated 2D array of fixed size.
 *
 * The matrix is initialized to some `width` and `height`.
 *
 * Accessing the matrix cells can be done with `matrix[x][y]`, where `0 <= x < width` and `0 <= y < height`.
 */
abstract Matrix2D<T>(Array<Array<T>>)
{
    /**
     * The width of the matrix, i.e the size along the x-axis.
     */
    public var width(get, never): Int;

    /**
     * The height of the matrix, i.e the size along the y-axis.
     */
    public var height(get, never): Int;

    /**
     * Allocate a new 2-dimensional matrix.
     *
     * The matrix will have `width` columns and `height` rows.
     *
     * @param width the width of the matrix
     * @param height the height of the matrix
     * @param initialValue the initial value for all cells in the matrix
     */
    public function new(width: Int, height: Int, initialValue: T)
    {
        DexError.assert(width > 0, 'matrix dimensions need to be greater than 0');
        DexError.assert(height > 0, 'matrix dimensions need to be greater than 0');

        this = [ for (_ in 0...width) [ for (_ in 0...height) initialValue ] ];
    }

    /**
     * Casts an existing 2D array to Matrix2D.
     *
     * This effectively only casts the array to Matrix2D, but also ensures that size of all
     * columns is identical.
     *
     * @param arr the 2D array
     * @return the same array, but cast to Matrix2D
     */
    @:from
    public static function fromArray<T>(arr: Array<Array<T>>): Matrix2D<T>
    {
        DexError.assert(arr.length > 0, 'a 2D array used to create a Matrix2D must not be empty');

        var height: Int = arr[ 0 ].length;
        DexError.assert(height > 0);

        for (column in arr)
        {
            DexError.assert(column.length == height, 'the Matrix2D is initialized with height $height, but a column was found with height: ${column.length}');
        }

        return cast arr;
    }

    /**
     * Generate a string from the given matrix.
     *
     * Each row of the matrix will be one line in the output string,
     * with space-separated values.
     *
     * @return the string representation of the matrix
     */
    public function toString(): String
    {
        var str: StringBuf = new StringBuf();

        for (yn in 0...height)
        {
            var y: Int = height - yn - 1;

            for (x in 0...width)
            {
                str.add('${this[ x ][ y ]}'.lpad(' ', 3));
                str.add(' ');
            }
            str.add('\n');
        }

        return str.toString();
    }

    /**
     * Generate a new matrix with the same dimensions, where each
     * element `e` in the original matrix is mapped by calling `fn(e)`.
     *
     * @param fn the conversion function
     * @return the new matrix
     */
    public function map<Q>(fn: T->Q): Matrix2D<Q>
    {
        var columns: Array<Array<Q>> = [ ];

        for (x in 0...width)
        {
            var column: Array<Q> = [ ];

            for (y in 0...height)
            {
                column.push(fn(this[ x ][ y ]));
            }

            columns.push(column);
        }

        return fromArray(columns);
    }

    /**
     * Loop over all elements in the matrix.
     *
     * The iteration order is column-by-column, for better hypothetical cache adjacency.
     *
     * @param fn the callback function for each element
     */
    public function forEach(fn: T->Void)
    {
        for (x in 0...width)
        {
            for (y in 0...height)
            {
                fn(this[ x ][ y ]);
            }
        }
    }

    /**
     * Loop over all elements in the matrix.
     *
     * The iteration order is column-by-column, for better hypothetical cache adjacency.
     *
     * @param fn the callback function for each element and its coordinates in the matrix
     */
    public function forEachXY(fn: (Int, Int, T) -> Void)
    {
        for (x in 0...width)
        {
            for (y in 0...height)
            {
                fn(x, y, this[ x ][ y ]);
            }
        }
    }

    public inline function inBounds(x: Int, y: Int): Bool
    {
        return x >= 0 && x < width && y >= 0 && y < height;
    }

    public function has(item: T): Bool
    {
        for (x in 0...width)
        {
            for (y in 0...height)
            {
                if (this[ x ][ y ] == item)
                {
                    return true;
                }
            }
        }
        return false;
    }

    public function exists(fn: T->Bool): Bool
    {
        for (x in 0...width)
        {
            for (y in 0...height)
            {
                if (fn(this[ x ][ y ]))
                {
                    return true;
                }
            }
        }
        return false;
    }

    public function count(fn: T->Bool): UInt
    {
        var cnt: UInt = 0;
        for (x in 0...width)
        {
            for (y in 0...height)
            {
                if (fn(this[ x ][ y ]))
                {
                    cnt++;
                }
            }
        }
        return cnt;
    }

    /**
     * Returns the x-th column of the matrix.
     *
     * This allows to read from the matrix by writing: `matrix[x][y]`
     * and also to write to the matrix by writing `matrix[x][y] = 5`.
     *
     * @param x the column-index
     * @return the x-th column
     */
    @:op([ ])
    inline function getColumn(x: Int): MatrixColumn<T>
    {
        return this[ x ];
    }

    inline function get_width(): Int
    {
        return this.length;
    }

    inline function get_height(): Int
    {
        return this[ 0 ].length;
    }
}
