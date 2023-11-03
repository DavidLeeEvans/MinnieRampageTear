package dex.util.extensions;

class FloatEx
{
    /**
     * Returns `true` if floats `a` and `b` are *equal* within `DexMath.eps`.
     */
    public static inline function equals(a: Float, b: Float): Bool
    {
        return (a - b).abs() < DexMath.eps;
    }

    /**
     * Clamp a float value between two limits.
     * The user is responsible for ensuring that `min < max`.
     */
    public static inline function clamp(v: Float, min: Float = -1, max: Float = 1): Float
    {
        return if (v < min)
                min
            else if (v > max)
                max
            else
                v;
    }

    /**
     * Returns `+1` if the number is positive or zero, and `-1` if the number is negative.
     */
    public static inline function sign(v: Float): Int
    {
        return v < 0 ? -1 : 1;
    }

    public static inline function signTo(from: Float, to: Float): Int
    {
        return from < to ? -1 : 1;
    }

    /**
     * Returns the absolute value of the number.
     */
    public static inline function abs(v: Float): Float
    {
        return v < 0 ? -v : v;
    }

    /**
     * Rounds a floating point number to a given amount of decimals.
     */
    public static inline function roundTo(f: Float, decimals: Int): Float
    {
        var roundMult: Float = Math.pow(10, decimals);
        return Math.round(f * roundMult) / roundMult;
    }

    public static inline function absGreater(a: Float, b: Float): Bool
    {
        return a.abs() > b.abs();
    }
}
