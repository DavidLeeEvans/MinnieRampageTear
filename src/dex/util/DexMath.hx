package dex.util;

class DexMath
{
    public static inline var eps: Float = 1e-4;

    public static inline var Pi: Float = 3.14159265358979323846264338327950288;

    public static inline var Pi2: Float = 2 * Pi;

    public static inline var PiHalf: Float = Pi / 2;

    public static inline var radToDeg: Float = 180 / Pi;

    public static inline var degToRad: Float = Pi / 180;

    public static inline function maxInt(a: Int, b: Int): Int
    {
        return a > b ? a : b;
    }

    public static inline function minInt(a: Int, b: Int): Int
    {
        return a < b ? a : b;
    }

    public static inline function floatEquals(a: Float, b: Float): Bool
    {
        return Math.abs(a - b) < eps;
    }

    public static inline function intPow(v: Int, exp: Int): Int
    {
        var acc: Int = v;
        while (--exp > 0)
        {
            acc *= v;
        }
        return acc;
    }

    public static inline function round(v: Float, decimals: Int): Float
    {
        return Math.round(v * roundBases[ decimals ]) / roundBases[ decimals ];
    }

    /**
     * Normalizes an angle in radians so that the result is the angle in the `[0, 2pi)` range.
     */
    public static inline function angleNormalize(angle: Float): Float
    {
        while (angle < 0)
        {
            angle += Pi2;
        }
        while (angle >= Pi2)
        {
            angle -= Pi2;
        }

        return angle;
    }

    /**
     * Computes the angle delta in radians, that is needed to go from one angle to another.
     */
    public static inline function angleDiff(from: Float, to: Float): Float
    {
        return Math.atan2(Math.sin(to - from), Math.cos(to - from));
    }

    static final roundBases: Array<Int> = [ 1, 10, 100, 1000, 10000, 100000 ];
}
