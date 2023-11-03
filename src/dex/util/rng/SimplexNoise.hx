package dex.util.rng;

import Math.floor;

/**
 * Simplex noise generation functions.
 *
 * Ported from: https://github.com/SRombauts/SimplexNoise
 */
class SimplexNoise
{
    /**
     * The 256-element permutation table.
     */
    final perm: Array<Int>;

    /**
     * Initialize a seeded simplex noise generator.
     * An instance of this class is immutable and will always generate the same output for the same input.
     *
     * This constructor allocates and shuffles a 256-element array, so it is recommended to reuse it.
     *
     * If the seed is left `null`, a time-based seed will be used with millisecond precision.
     *
     * @param seed the seed to use
     */
    public function new(?seed: UInt)
    {
        // apply the seed by creating a shuffled permutation table
        perm = [ for (i in 0...256) i ];

        var rng: Rng = new Rng(seed);
        rng.shuffle(perm);
    }

    /**
     * Compute 1D Perlin simplex noise.
     *
     * @param x x-coordinate
     * @return the noise value in the range `[-1, 1]`
     */
    public function noise1d(x: Float): Float
    {
        // No need to skew the input space in 1D

        // Corners coordinates (nearest integer values):
        var i0: Int = floor(x);
        var i1: Int = i0 + 1;
        // Distances to corners (between 0 and 1):
        var x0: Float = x - i0;
        var x1: Float = x0 - 1.0;

        // Calculate the contribution from the first corner
        var t0: Float = 1.0 - x0 * x0;
        //  if(t0 < 0.0f) t0 = 0.0f; // not possible
        t0 *= t0;
        var n0: Float = t0 * t0 * grad1(hash(i0), x0);

        // Calculate the contribution from the second corner
        var t1: Float = 1.0 - x1 * x1;
        //  if(t1 < 0.0f) t1 = 0.0f; // not possible
        t1 *= t1;
        var n1: Float = t1 * t1 * grad1(hash(i1), x1);

        // The maximum value of this noise is 8*(3/4)^4 = 2.53125
        // A factor of 0.395 scales to fit exactly within [-1,1]
        return 0.395 * (n0 + n1);
    }

    /**
     * Compute 2D Perlin simplex noise.
     *
     * @param x x-coordinate
     * @param y y-coordinate
     * @return the noise value in the range `[-1, 1]`
     */
    public function noise2d(x: Float, y: Float): Float
    {
        // Skewing/Unskewing factors for 2D
        final F2: Float = 0.366025403; // F2 = (sqrt(3) - 1) / 2
        final G2: Float = 0.211324865; // G2 = (3 - sqrt(3)) / 6   = F2 / (1 + 2 * K)

        // Skew the input space to determine which simplex cell we're in
        final s: Float = (x + y) * F2; // Hairy factor for 2D
        final xs: Float = x + s;
        final ys: Float = y + s;
        final i: Int = floor(xs);
        final j: Int = floor(ys);

        // Unskew the cell origin back to (x,y) space
        final t: Float = (i + j) * G2;
        final X0: Float = i - t;
        final Y0: Float = j - t;
        final x0: Float = x - X0; // The x,y distances from the cell origin
        final y0: Float = y - Y0;

        // For the 2D case, the simplex shape is an equilateral triangle.
        // Determine which simplex we are in.
        var i1: Int;
        var j1: Int; // Offsets for second (middle) corner of simplex in (i,j) coords
        if (x0 > y0)
        { // lower triangle, XY order: (0,0)->(1,0)->(1,1)
            i1 = 1;
            j1 = 0;
        }
        else
        { // upper triangle, YX order: (0,0)->(0,1)->(1,1)
            i1 = 0;
            j1 = 1;
        }

        // A step of (1,0) in (i,j) means a step of (1-c,-c) in (x,y), and
        // a step of (0,1) in (i,j) means a step of (-c,1-c) in (x,y), where
        // c = (3-sqrt(3))/6

        final x1: Float = x0 - i1 + G2; // Offsets for middle corner in (x,y) unskewed coords
        final y1: Float = y0 - j1 + G2;
        final x2: Float = x0 - 1.0 + 2.0 * G2; // Offsets for last corner in (x,y) unskewed coords
        final y2: Float = y0 - 1.0 + 2.0 * G2;

        // Work out the hashed gradient indices of the three simplex corners
        final gi0: Int = hash(i + hash(j));
        final gi1: Int = hash(i + i1 + hash(j + j1));
        final gi2: Int = hash(i + 1 + hash(j + 1));

        // Calculate the contribution from the first corner
        var t0: Float = 0.5 - x0 * x0 - y0 * y0;
        var n0: Float = 0;
        if (t0 < 0.0)
        {
            n0 = 0.0;
        }
        else
        {
            t0 *= t0;
            n0 = t0 * t0 * grad2(gi0, x0, y0);
        }

        // Calculate the contribution from the second corner
        var t1: Float = 0.5 - x1 * x1 - y1 * y1;
        var n1: Float = 0;
        if (t1 < 0.0)
        {
            n1 = 0.0;
        }
        else
        {
            t1 *= t1;
            n1 = t1 * t1 * grad2(gi1, x1, y1);
        }

        // Calculate the contribution from the third corner
        var t2: Float = 0.5 - x2 * x2 - y2 * y2;
        var n2: Float = 0;
        if (t2 < 0.0)
        {
            n2 = 0.0;
        }
        else
        {
            t2 *= t2;
            n2 = t2 * t2 * grad2(gi2, x2, y2);
        }

        // Add contributions from each corner to get the final noise value.
        // The result is scaled to return values in the interval [-1,1].
        return 45.23065 * (n0 + n1 + n2);
    }

    /**
     * Compute 3D Perlin simplex noise.
     *
     * @param x x-coordinate
     * @param y y-coordinate
     * @param z z-coordinate
     * @return the noise value in the range `[-1, 1]`
     */
    public function noise3d(x: Float, y: Float, z: Float): Float
    {
        // Skewing/Unskewing factors for 3D
        final F3: Float = 1.0 / 3.0;
        final G3: Float = 1.0 / 6.0;

        // Skew the input space to determine which simplex cell we're in
        var s: Float = (x + y + z) * F3; // Very nice and simple skew factor for 3D
        var i: Int = floor(x + s);
        var j: Int = floor(y + s);
        var k: Int = floor(z + s);
        var t: Float = (i + j + k) * G3;
        var X0: Float = i - t; // Unskew the cell origin back to (x,y,z) space
        var Y0: Float = j - t;
        var Z0: Float = k - t;
        var x0: Float = x - X0; // The x,y,z distances from the cell origin
        var y0: Float = y - Y0;
        var z0: Float = z - Z0;

        // For the 3D case, the simplex shape is a slightly irregular tetrahedron.
        // Determine which simplex we are in.
        var i1, j1, k1; // Offsets for second corner of simplex in (i,j,k) coords
        var i2, j2, k2; // Offsets for third corner of simplex in (i,j,k) coords
        if (x0 >= y0)
        {
            if (y0 >= z0)
            {
                i1 = 1;
                j1 = 0;
                k1 = 0;
                i2 = 1;
                j2 = 1;
                k2 = 0; // X Y Z order
            }
            else if (x0 >= z0)
            {
                i1 = 1;
                j1 = 0;
                k1 = 0;
                i2 = 1;
                j2 = 0;
                k2 = 1; // X Z Y order
            }
            else
            {
                i1 = 0;
                j1 = 0;
                k1 = 1;
                i2 = 1;
                j2 = 0;
                k2 = 1; // Z X Y order
            }
        }
        else
        { // x0<y0
            if (y0 < z0)
            {
                i1 = 0;
                j1 = 0;
                k1 = 1;
                i2 = 0;
                j2 = 1;
                k2 = 1; // Z Y X order
            }
            else if (x0 < z0)
            {
                i1 = 0;
                j1 = 1;
                k1 = 0;
                i2 = 0;
                j2 = 1;
                k2 = 1; // Y Z X order
            }
            else
            {
                i1 = 0;
                j1 = 1;
                k1 = 0;
                i2 = 1;
                j2 = 1;
                k2 = 0; // Y X Z order
            }
        }

        // A step of (1,0,0) in (i,j,k) means a step of (1-c,-c,-c) in (x,y,z),
        // a step of (0,1,0) in (i,j,k) means a step of (-c,1-c,-c) in (x,y,z), and
        // a step of (0,0,1) in (i,j,k) means a step of (-c,-c,1-c) in (x,y,z), where
        // c = 1/6.
        var x1: Float = x0 - i1 + G3; // Offsets for second corner in (x,y,z) coords
        var y1: Float = y0 - j1 + G3;
        var z1: Float = z0 - k1 + G3;
        var x2: Float = x0 - i2 + 2.0 * G3; // Offsets for third corner in (x,y,z) coords
        var y2: Float = y0 - j2 + 2.0 * G3;
        var z2: Float = z0 - k2 + 2.0 * G3;
        var x3: Float = x0 - 1.0 + 3.0 * G3; // Offsets for last corner in (x,y,z) coords
        var y3: Float = y0 - 1.0 + 3.0 * G3;
        var z3: Float = z0 - 1.0 + 3.0 * G3;

        // Work out the hashed gradient indices of the four simplex corners
        var gi0: Int = hash(i + hash(j + hash(k)));
        var gi1: Int = hash(i + i1 + hash(j + j1 + hash(k + k1)));
        var gi2: Int = hash(i + i2 + hash(j + j2 + hash(k + k2)));
        var gi3: Int = hash(i + 1 + hash(j + 1 + hash(k + 1)));

        // Calculate the contribution from the four corners
        var t0: Float = 0.6 - x0 * x0 - y0 * y0 - z0 * z0;
        var n0: Float = 0;
        if (t0 < 0)
        {
            n0 = 0.0;
        }
        else
        {
            t0 *= t0;
            n0 = t0 * t0 * grad3(gi0, x0, y0, z0);
        }
        var t1: Float = 0.6 - x1 * x1 - y1 * y1 - z1 * z1;
        var n1: Float = 0;
        if (t1 < 0)
        {
            n1 = 0.0;
        }
        else
        {
            t1 *= t1;
            n1 = t1 * t1 * grad3(gi1, x1, y1, z1);
        }
        var t2: Float = 0.6 - x2 * x2 - y2 * y2 - z2 * z2;
        var n2: Float = 0;
        if (t2 < 0)
        {
            n2 = 0.0;
        }
        else
        {
            t2 *= t2;
            n2 = t2 * t2 * grad3(gi2, x2, y2, z2);
        }
        var t3: Float = 0.6 - x3 * x3 - y3 * y3 - z3 * z3;
        var n3: Float = 0;
        if (t3 < 0)
        {
            n3 = 0.0;
        }
        else
        {
            t3 *= t3;
            n3 = t3 * t3 * grad3(gi3, x3, y3, z3);
        }
        // Add contributions from each corner to get the final noise value.
        // The result is scaled to stay just inside [-1,1]
        return 32.0 * (n0 + n1 + n2 + n3);
    }

    /**
     * Compute a fractal summation of 1D Perlin simplex noise
     *
     * @param x the x-coordinate
     * @param octaves the number of octaves to sum
     * @param frequency the frequency (width) of the first octave of noise
     * @param amplitude the amplitude (height) of the first octave of noise
     * @param lacunarity the frequency multiplier between successive octaves
     * @param persistence the loss of amplitude between successive octaves (usually 1/lacunarity)
     * @return the noise value in the range `[-1, 1]`
     */
    public function fractal1d(x: Float, octaves: UInt, frequency: Float = 1.0, amplitude: Float = 1.0, lacunarity: Float = 2.0,
            persistence: Float = 0.5): Float
    {
        var output: Float = 0.0;
        var denom: Float = 0.0;

        for (i in 0...octaves)
        {
            output += amplitude * noise1d(x * frequency);
            denom += amplitude;

            frequency *= lacunarity;
            amplitude *= persistence;
        }

        return output / denom;
    }

    /**
     * Compute a fractal summation of 2D Perlin simplex noise
     *
     * @param x the x-coordinate
     * @param y the y-coordinate
     * @param octaves the number of octaves to sum
     * @param frequency the frequency (width) of the first octave of noise
     * @param amplitude the amplitude (height) of the first octave of noise
     * @param lacunarity the frequency multiplier between successive octaves
     * @param persistence the loss of amplitude between successive octaves (usually 1/lacunarity)
     * @return the noise value in the range `[-1, 1]`
     */
    public function fractal2d(x: Float, y: Float, octaves: UInt, frequency: Float = 1.0, amplitude: Float = 1.0, lacunarity: Float = 2.0,
            persistence: Float = 0.5): Float
    {
        var output: Float = 0.0;
        var denom: Float = 0.0;

        for (i in 0...octaves)
        {
            output += amplitude * noise2d(x * frequency, y * frequency);
            denom += amplitude;

            frequency *= lacunarity;
            amplitude *= persistence;
        }

        return output / denom;
    }

    /**
     * Compute a fractal summation of 3D Perlin simplex noise
     *
     * @param x the x-coordinate
     * @param y the y-coordinate
     * @param z the z-coordinate
     * @param octaves the number of octaves to sum
     * @param frequency the frequency (width) of the first octave of noise
     * @param amplitude the amplitude (height) of the first octave of noise
     * @param lacunarity the frequency multiplier between successive octaves
     * @param persistence the loss of amplitude between successive octaves (usually 1/lacunarity)
     * @return the noise value in the range `[-1, 1]`
     */
    public function fractal3d(x: Float, y: Float, z: Float, octaves: UInt, frequency: Float = 1.0, amplitude: Float = 1.0, lacunarity: Float = 2.0,
            persistence: Float = 0.5): Float
    {
        var output: Float = 0.0;
        var denom: Float = 0.0;

        for (i in 0...octaves)
        {
            output += amplitude * noise3d(x * frequency, y * frequency, z * frequency);
            denom += amplitude;

            frequency *= lacunarity;
            amplitude *= persistence;
        }

        return output / denom;
    }

    static function grad1(hash: Int, x: Float): Float
    {
        var h: Int = hash & 0x0F; // Convert low 4 bits of hash code
        var grad: Float = 1.0 + (h & 7); // Gradient value 1.0, 2.0, ..., 8.0
        if ((h & 8) != 0)
            grad = -grad; // Set a random sign for the gradient
        return (grad * x); // Multiply the gradient with the distance
    }

    static function grad2(hash: Int, x: Float, y: Float): Float
    {
        var h: Int = hash & 0x3F; // Convert low 3 bits of hash code
        var u: Float = h < 4 ? x : y; // into 8 simple gradient directions,
        var v: Float = h < 4 ? y : x;
        return ((h & 1 != 0) ? -u : u) + ((h & 2 != 0) ? -2.0 * v : 2.0 * v); // and compute the dot product with (x,y).
    }

    static function grad3(hash: Int, x: Float, y: Float, z: Float): Float
    {
        var h: Int = hash & 15; // Convert low 4 bits of hash code into 12 simple
        var u: Float = h < 8 ? x : y; // gradient directions, and compute dot product.
        var v: Float = h < 4 ? y : h == 12 || h == 14 ? x : z; // Fix repeats at h = 12 to 15
        return ((h & 1 != 0) ? -u : u) + ((h & 2 != 0) ? -v : v);
    }

    inline function hash(i: Int): Int
    {
        return perm[ i & 0xFF ];
    }
}
