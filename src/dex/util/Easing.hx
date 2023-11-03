package dex.util;

import defold.Go.GoEasing;
import defold.Vmath;
import defold.types.Vector;
import dex.util.rng.PerlinNoise;
import dex.util.rng.Rng;

using dex.util.extensions.FloatEx;

/**
 * Collection of utilities for creating looping easings for animations.
 *
 * These easings are designed to work with the `ONCE_FORWARD` playbacks,
 * and may not look good on a `PINGPONG` playback.
 *
 * The intended use is mainly for screenshake effects and other polishing details.
 */
abstract Easing(Vector) from Vector to Vector
{
    public inline function new(values: Array<Float>)
    {
        this = Vmath.vector(values);
    }

    /**
     * Create a sinusodial easing that starts from `0` and returns to `0`.
     *
     * It will oscillate between `-1` and `1`. The final animation amplitude
     * will depend on the target value given to `animate()`.
     *
     * @param periods the number of periods of sine wave that will occur until the end
     *                of the animation
     * @return the easing vector
     */
    public static function sin(periods: UInt = 1): Easing
    {
        DexError.assert(periods > 0);

        var values: Array<Float> = [ ];
        for (p in 0...periods)
        {
            for (t in 0...8)
            {
                var angle: Float = 2 * (t / 8) * Math.PI;
                values.push(Math.sin(angle));
            }
        }

        // return to 0 at the end to complete the last period
        values.push(0);

        return new Easing(values);
    }

    public static function sinDiminishing(periods: UInt = 4): Easing
    {
        DexError.assert(periods > 0);

        var values: Array<Float> = [ ];
        var amplitude: Float = 1.0;
        var diminishFactor: Float = 1 / (periods * 8);

        for (p in 0...periods)
        {
            for (t in 0...8)
            {
                var angle: Float = 2 * (t / 8) * Math.PI;
                values.push(amplitude * Math.sin(angle));

                amplitude -= diminishFactor;
            }
        }

        // return to 0 at the end to complete the last period
        values.push(0);

        return new Easing(values);
    }

    /**
     * Create a random easing that starts from `0` and returns `0`.
     * It is a vector of random values from `-1` to `1`.
     *
     * The random sampling is done from a normal distribution.
     *
     * @param granularity the number of random points in the easing,
     *                    higher numbers should be used for longer animations
     * @return the easing vector
     */
    public static function random(granularity: UInt = 10): Easing
    {
        DexError.assert(granularity > 0);

        var values: Array<Float> = [ 0 ];
        var rng: Rng = new Rng();

        for (_ in 0...granularity)
        {
            var value: Float = rng.normal(0, 0.33);
            values.push(value.clamp(-1, 1));
        }

        // return to 0 at the end
        values.push(0);

        return new Easing(values);
    }

    public static function randomDiminishing(granularity: UInt = 10): Easing
    {
        DexError.assert(granularity > 1);

        var values: Array<Float> = [ 0 ];
        var rng: Rng = new Rng();

        var amplitude: Float = 1.0;
        var diminishFactor: Float = 1 / granularity;

        for (_ in 0...granularity)
        {
            var value: Float = amplitude * rng.normal(0, 0.33);
            values.push(value.clamp(-1, 1));

            amplitude -= diminishFactor;
        }

        // return to 0 at the end
        values.push(0);

        return new Easing(values);
    }

    /**
     * Create a random easing that starts from `0` and returns `0`.
     * It is a vector of random values from `-1` to `1`.
     *
     * The random sampling is done from Perlin noise.
     *
     * @param granularity the number of random points in the easing,
     *                    higher numbers should be used for longer animations
     * @return the easing vector
     */
    public static function randomPerlin(granularity: UInt = 10): Easing
    {
        DexError.assert(granularity > 1);

        var values: Array<Float> = [ 0 ];
        var rng: Rng = new Rng();
        var perlin: PerlinNoise = new PerlinNoise(rng.seed());

        for (t in 0...granularity)
        {
            values.push(perlin.noise1d(t / granularity));
        }

        // return to 0 at the end
        values.push(0);

        return new Easing(values);
    }

    /**
     * Creates a square-pulse easing that starts from `0` and returns to `0`.
     *
     * @param periods the number of pulses that will occur until the end of the animation
     * @param dutyCycle the duty cycle of the pulses, should be a multiple of `0.1`
     */
    public static function square(bottomZero: Bool, periods: UInt = 1, dutyCycle: Float = 0.5): Easing
    {
        DexError.assert(periods > 0);
        DexError.assert(dutyCycle > 0 && dutyCycle < 1);

        var values: Array<Float> = [ 0 ];
        for (p in 0...periods)
        {
            for (t in 0...10)
            {
                if ((t / 10) < dutyCycle)
                {
                    values.push(1.0);
                }
                else if (bottomZero)
                {
                    values.push(0.0);
                }
                else
                {
                    values.push(-1.0);
                }
            }
        }

        // return to 0 at the end
        values.push(0);

        return new Easing(values);
    }

    public static function squareDiminishing(bottomZero: Bool, periods: UInt = 1, dutyCycle: Float = 0.5): Easing
    {
        DexError.assert(periods > 0);
        DexError.assert(dutyCycle > 0 && dutyCycle < 1);

        var values: Array<Float> = [ 0 ];
        var amplitude: Float = 1.0;
        var diminishFactor: Float = 1 / (periods * 10);

        for (p in 0...periods)
        {
            for (t in 0...10)
            {
                if ((t / 10) < dutyCycle)
                {
                    values.push(amplitude);
                }
                else if (bottomZero)
                {
                    values.push(0.0);
                }
                else
                {
                    values.push(-amplitude);
                }

                amplitude -= diminishFactor;
            }
        }

        // return to 0 at the end
        values.push(0);

        return new Easing(values);
    }

    /**
     * Creates a sharp random square easing that starts from `0` and returns to `1`.
     *
     * Each value is randomly assigned either to `+1.0` or `-1.0`.
     *
     * @param granularity the number of points in the easing
     * @return the easing vector
     */
    public static function squareRandom(granularity: UInt = 10): Easing
    {
        DexError.assert(granularity > 0, 'wrong granularity $granularity');

        var values: Array<Float> = [ 0 ];
        var rng: Rng = new Rng();

        for (t in 0...granularity)
        {
            if (rng.bool())
            {
                values.push(1.0);
            }
            else
            {
                values.push(-1.0);
            }
        }

        // return to 0 at the end
        values.push(0);

        return new Easing(values);
    }

    /**
     * Creates a simple out-in easing that starts from `0` and returns to `0`.
     *
     * It follows the function `4 * (sqrt(t) - t)`, which quickly reaches `1.0` and then
     * slowly diminishes until the end.
     *
     * @param granularity the number of points in the easing
     * @return the easing vector
     */
    public static function outIn(granularity: UInt = 10): Easing
    {
        DexError.assert(granularity > 3, 'wrong granularity $granularity');

        var values: Array<Float> = [ ];

        for (i in 0...granularity)
        {
            var t: Float = i / granularity;
            values.push(4 * (Math.sqrt(t) - t));
        }

        // return to 0 at the end
        values.push(0);

        return new Easing(values);
    }

    @:to
    inline function toGoEasing(): GoEasing
    {
        // allow implicit conversion to GoEasing, for use with Go.animate
        return cast this;
    }
}
