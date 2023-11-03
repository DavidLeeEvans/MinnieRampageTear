package dex.map;

import dex.types.Direction;
import dex.util.DexError;
import dex.util.ds.Matrix2D;

/**
 * A tile bitmask that is used for autotiling.
 * It is made up of 9 bit flags, with the following layout on the tile:
 *
 *   7 8 9
 *   4 5 6
 * x 1 2 3
 *   y
 *
 * -> bitmask order: 987654321
 */
abstract TileBitmask(UInt)
{
    public static var empty(get, never): TileBitmask;
    public static var center(get, never): TileBitmask;

    static inline function get_empty(): TileBitmask
    {
        return cast(0, TileBitmask);
    }

    static inline function get_center(): TileBitmask
    {
        return cast(1 << 4, TileBitmask);
    }

    /**
     * Create a bitmask from an array of the `xy` positions on the tile: `[ 00, 10, 20, 01, 11, 21, 02, 12, 22 ]`
     */
    public static function fromArray(arr: Array<Bool>): TileBitmask
    {
        DexError.assert(arr.length == 9);

        var bitmask: UInt = 0;

        for (i in 0...9)
        {
            if (arr[ i ])
            {
                bitmask |= (1 << i);
            }
        }

        return cast(bitmask, TileBitmask);
    }

    /**
     * Create a bitmask from a matrix of the `xy` positions on the tile: `[ [ 00, 10, 20 ], [ 01, 11, 21 ], [ 02, 12, 22 ] ]`
     */
    public static function fromMatrix(matrix: Matrix2D<Bool>): TileBitmask
    {
        DexError.assert(matrix.width == 3);
        DexError.assert(matrix.height == 3);

        var bitmask: UInt = 0;

        for (i in 0...9)
        {
            var x: Int = i % 3;
            var y: Int = Std.int(i / 3);

            if (matrix[ x ][ y ])
            {
                bitmask |= (1 << i);
            }
        }

        return cast(bitmask, TileBitmask);
    }

    /**
     * Get the bit flag of a tile's position.
     *
     * The `(0, 0)` position is the tile's center.
     *
     * Note that this method does not check if the `x` and `y` given are inside
     * the `[-1, 1]` bounds. If outside, the results are undefined.
     *
     * @param x the x-coordinate from the bottom-left of the tile
     * @param y the y-coordinate from the bottom-left of the tile
     * @return `true` if the bitmask has a flag set in that position
     */
    public inline function get(x: Int, y: Int): Bool
    {
        var i: Int = (x + 1) + ((y + 1) * 3);

        return (this & (1 << i)) > 0;
    }

    /**
     * Set the bit flag of a tile's position.
     *
     * The `(0, 0)` position is the tile's center.
     *
     * Note that this method does not check if the `x` and `y` given are inside
     * the `[-1, 1]` bounds. If outside, the results are undefined.
     *
     * @param x the x-coordinate from the bottom-left of the tile
     * @param y the y-coordinate from the bottom-left of the tile
     * @param flag `true` if the flag should be set, or `false` if it should be cleared
     */
    public inline function set(x: Int, y: Int, flag: Bool)
    {
        var i: Int = (x + 1) + ((y + 1) * 3);

        if (flag)
        {
            this |= (1 << i);
        }
        else
        {
            this &= ~(1 << i);
        }
    }

    public inline function isFull(): Bool
    {
        return this == 0x01FF;
    }

    public inline function countFlags(): UInt
    {
        var cnt: UInt = 0;

        for (i in 0...9)
        {
            if ((this & (1 << i)) > 0)
            {
                cnt++;
            }
        }

        return cnt;
    }

    public inline function connectsTo(bitmask: TileBitmask, direction: Direction): Bool
    {
        return
            switch direction
            {
                case Up: (get(-1, 1) == bitmask.get(-1, -1)) && (get(0, 1) == bitmask.get(0, -1)) && (get(1, 1) == bitmask.get(1, -1));

                case Right: (get(1, 1) == bitmask.get(-1, 1)) && (get(1, 0) == bitmask.get(-1, 0)) && (get(1, -1) == bitmask.get(-1, -1));

                case Down: (get(-1, -1) == bitmask.get(-1, 1)) && (get(0, -1) == bitmask.get(0, 1)) && (get(1, -1) == bitmask.get(1, 1));

                case Left: (get(-1, -1) == bitmask.get(1, -1)) && (get(-1, 0) == bitmask.get(1, 0)) && (get(-1, 1) == bitmask.get(1, 1));
            }
    }

    public function toString(): String
    {
        return
            '${get(-1, 1) ? 'x' : ' '} ${get(0, 1) ? 'x' : ' '} ${get(1, 1) ? 'x' : ' '}\n${get(-1, 0) ? 'x' : ' '} ${get(0, 0) ? 'x' : ' '} ${get(1, 0) ? 'x' : ' '}\n${get(-1, -1) ? 'x' : ' '} ${get(0, -1) ? 'x' : ' '} ${get(1, -1) ? 'x' : ' '}';
    }
}
