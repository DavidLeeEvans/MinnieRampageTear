package dex.util.types;

import defold.Go.GoAnimatedProperty;
import defold.Go.GoProperty;
import defold.Vmath;
import defold.types.Vector3;


@:forward
abstract Vector2(Vector3) from Vector3 to Vector3 to GoProperty to GoAnimatedProperty
{
    public static var zero(get, never): Vector2;

    public inline function new(x: Float = 0, y: Float = 0)
    {
        this = Vmath.vector3(x, y, 0);
    }

    public inline function reset()
    {
        this.x = 0;
        this.y = 0;
    }

    public inline function round(): Vector2Int
    {
        return new Vector2Int(Math.round(this.x), Math.round(this.y));
    }

    public inline function ceil(): Vector2Int
    {
        return new Vector2Int(Math.ceil(this.x), Math.ceil(this.y));
    }

    public inline function floor(): Vector2Int
    {
        return new Vector2Int(Math.floor(this.x), Math.floor(this.y));
    }

    public inline function length(): Float
    {
        return Math.sqrt(lengthSquared());
    }

    public inline function lengthSquared(): Float
    {
        return (this.x * this.x) + (this.y * this.y);
    }

    /**
     * Modifies (in-place) the vector's `x` and `y` components to their absolute values.
     *
     * @return the vector
     */
    public inline function abs(): Vector2
    {
        this.x = Math.abs(this.x);
        this.y = Math.abs(this.y);
        return this;
    }

    /**
     * Modifies (in-place) the vector's `x` and `y` components so that the 2D vector is normalized.
     *
     * @return the vector
     */
    public inline function normalize(): Vector2
    {
        var l: Float = Math.sqrt(this.x * this.x + this.y * this.y);
        if (l == 0)
        {
            return cast this;
        }
        this.x /= l;
        this.y /= l;
        return cast this;
    }

    /**
     * Creates a new vector, which is the normalized version of this vector.
     *
     * @return the vector
     */
    public inline function direction(): Vector2
    {
        var l: Float = Math.sqrt(this.x * this.x + this.y * this.y);
        return new Vector2(this.x / l, this.y / l);
    }

    /**
     * Returns the vector's angle in radians.
     */
    public inline function angle(): Float
    {
        return Math.atan2(this.y, this.x);
    }

    /**
     * Returns the angle difference between this vector and another in radians.
     *
     * This is the angle that this vector would have to be rotated by to align with
     * the other vector `v`.
     */
    public inline function angleTo(v: Vector2): Float
    {
        return DexMath.angleDiff(angle(), v.angle());
    }

    /**
     * Returns the distance between this vector and another one.
     */
    public inline function distanceTo(v: Vector2): Float
    {
        var dx: Float = v.x - this.x;
        var dy: Float = v.y - this.y;

        return Math.sqrt((dx * dx) + (dy * dy));
    }

    public inline function copy(): Vector2
    {
        return new Vector2(this.x, this.y);
    }

    public inline function dot(v: Vector2): Float
    {
        return (this.x * v.x) + (this.y * v.y);
    }

    /**
     * Computes the scalar project of this vector, onto the given vector `v`.
     */
    public inline function projectOn(v: Vector2): Float
    {
        return dot(v) / v.length();
    }

    /**
     * Lerps the vector in-place to the target vector's `x` and `y`.
     *
     * @param v the target vector value
     * @param t interpolation parameter, 0-1
     * @return the vector itself
     */
    public inline function lerp(v: Vector2, t: Float): Vector2
    {
        this.x = Vmath.lerp(t, this.x, v.x);
        this.y = Vmath.lerp(t, this.y, v.y);
        return this;
    }

    public inline function add(v: Vector2)
    {
        this.x += v.x;
        this.y += v.y;
    }

    public inline function sub(v: Vector2)
    {
        this.x -= v.x;
        this.y -= v.y;
    }

    public inline function isZero(): Bool
    {
        return (Math.abs(this.x) < DexMath.eps) && (Math.abs(this.y) < DexMath.eps);
    }

    public inline function toString(): String
    {
        return '(${this.x.roundTo(4)}, ${this.y.roundTo(4)})';
    }

    static function get_zero(): Vector2
    {
        return new Vector2(0, 0);
    }

    @:op(a + b)
    static inline function addVec(a: Vector2, b: Vector2): Vector2
    {
        return new Vector2(a.x + b.x, a.y + b.y);
    }

    @:op(a + b) @:commutative
    static inline function addScalar(a: Vector2, b: Float): Vector2
    {
        return new Vector2(a.x + b, a.y + b);
    }

    @:op(a - b)
    static inline function subVec(a: Vector2, b: Vector2): Vector2
    {
        return new Vector2(a.x - b.x, a.y - b.y);
    }

    @:op(a - b)
    static inline function subScalar(a: Vector2, b: Float): Vector2
    {
        return new Vector2(a.x - b, a.y - b);
    }

    @:op(a - b)
    static inline function subFromScalar(a: Float, b: Vector2): Vector2
    {
        return new Vector2(a - b.x, a - b.y);
    }

    @:op(-b)
    static inline function neg(a: Vector2): Vector2
    {
        return new Vector2(-a.x, -a.y);
    }

    @:op(a * b) @:commutative
    static inline function mulScalar(a: Vector2, b: Float): Vector2
    {
        return new Vector2(a.x * b, a.y * b);
    }

    @:op(a / b)
    static inline function divScalar(a: Vector2, b: Float): Vector2
    {
        return new Vector2(a.x / b, a.y / b);
    }

    @:op(a * b)
    static inline function mulVec(a: Vector2, b: Vector2): Vector2
    {
        return new Vector2(a.x * b.x, a.y * b.y);
    }
}
