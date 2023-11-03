package dex.components;

import Math.PI;
import defold.Physics;
import defold.types.Hash;
import defold.types.util.LuaArray;
import dex.util.DexError;
import dex.util.types.Vector2;
import dex.wrappers.GameObject;

using lua.Table;
using lua.TableTools;
using dex.util.DexMath;

/**
 * A circular collider which uses radial raycasts to detect collisions with `static` or `kinematic` objects.
 */
class RaycastCollider extends ScriptComponent
{
    public var groups(default, null): Table<Int, Hash>;
    public var offset(default, null): Vector2;
    public var radius(default, null): Float;

    public var marginTop: Null<Float>;
    public var marginBottom: Null<Float>;
    public var marginRight: Null<Float>;
    public var marginLeft: Null<Float>;

    final go: GameObject;

    var raycastLengthFactor: Float = 2;

    // cached cosines and sines of the angles to check
    static final radialCos: Array<Float> = [ for (i in 0...8) i * (PI / 4) ].map(Math.cos);
    static final radialSin: Array<Float> = [ for (i in 0...8) i * (PI / 4) ].map(Math.sin);

    /** Cached vector for raycast targets, to avoid allocating it each frame */
    var castTo: Vector2;

    public function new(groups: Array<Hash>, offset: Vector2, radius: Float)
    {
        super();

        this.groups = Table.fromArray(groups);
        this.radius = radius;
        this.offset = offset;

        go = GameObject.self();

        castTo = Vector2.zero;
    }

    /**
     * Set the multiplicative factor of the raycast lengths.
     *
     * By default rays are cast up to a length of `2*radius`.
     * For faster-moving objects it may be necessary to increase this, in order to
     * get the information about available margins for movement earlier.
     *
     * As a rule of thumb, the factor `F` should be at least big enough, that the quantity `(F-1)*radius`
     * is always bigger than how much the object can move in a single frame.
     *
     * For slower-moving objects a lower value might be preferable, since it will lead to better performance.
     *
     * @param lengthFactor the factor, should be above `1.0`
     */
    public function setLengthFactor(lengthFactor: Float)
    {
        DexError.assert(lengthFactor >= 1.0);
        raycastLengthFactor = lengthFactor;
    }

    override function update(dt: Float)
    {
        var from: Vector2 = go.getPosition() + offset;

        var castLength: Float = raycastLengthFactor * radius;
        marginTop = null;
        marginBottom = null;
        marginRight = null;
        marginLeft = null;

        // raycast on each of the 8 radials
        for (i in [ 0, 2, 4, 6 ])
        {
            castTo.x = from.x + (castLength * radialCos[ i ]);
            castTo.y = from.y + (castLength * radialSin[ i ]);

            #if RAYCAST_DEBUG
            DexUtils.drawLine(from, castTo, Vmath.vector4(1, 0, 0, 1));
            #end

            var results: LuaArray<PhysicsMessageRayCastResponse> = Physics.raycast(from, castTo, groups, {all: false});
            if (results == null)
            {
                continue;
            }

            var result: PhysicsMessageRayCastResponse = results[ 0 ];

            var hitX: Float = result.fraction * castLength * radialCos[ i ];
            var hitY: Float = result.fraction * castLength * radialSin[ i ];

            if (hitX > DexMath.eps)
            {
                var hitRight: Float = hitX - radius;
                if (marginRight == null || hitRight < marginRight)
                {
                    marginRight = hitRight;
                }
            }
            else if (hitX < -DexMath.eps)
            {
                var hitLeft: Float = -hitX - radius;
                if (marginLeft == null || hitLeft < marginLeft)
                {
                    marginLeft = hitLeft;
                }
            }
            if (hitY > DexMath.eps)
            {
                var hitTop: Float = hitY - radius;
                if (marginTop == null || hitTop < marginTop)
                {
                    marginTop = hitTop;
                }
            }
            else if (hitY < -DexMath.eps)
            {
                var hitBottom: Float = -hitY - radius;
                if (marginBottom == null || hitBottom < marginBottom)
                {
                    marginBottom = hitBottom;
                }
            }

            #if RAYCAST_DEBUG
            var toContact: Vector2 = new Vector2(radialCos[ i ], radialSin[ i ]) * castLength * result.fraction;
            DexUtils.drawLine(from, from + toContact, Vmath.vector4(0, 1, 0, 1));
            #end
        }
    }

    /**
     * Checks if there is a collision currently ongoing.
     *
     * @return `true` if the collider currently overlaps with any of the configured collision groups
     */
    public inline function hasOverlap(): Bool
    {
        return (marginRight != null && marginRight < 0)
            || (marginLeft != null && marginLeft < 0)
            || (marginTop != null && marginTop < 0)
            || (marginBottom != null && marginBottom < 0);
    }

    /**
     * Given a planned movment of the object along the x-axis, this method
     * computes and returns a new value which can be used to move the object without
     * overlapping with other objects.
     *
     * @param moveX the planned movement along the x-axis
     * @return the constrained movement along the x-axis
     */
    public inline function constrainMoveX(moveX: Float): Float
    {
        if (marginRight != null && moveX > marginRight)
        {
            moveX = marginRight;
        }
        if (marginLeft != null && moveX < -marginLeft)
        {
            moveX = -marginLeft;
        }
        return moveX;
    }

    /**
     * Given a planned movment of the object along the y-axis, this method
     * computes and returns a new value which can be used to move the object without
     * overlapping with other objects.
     *
     * @param moveY the planned movement along the y-axis
     * @return the constrained movement along the y-axis
     */
    public inline function constrainMoveY(moveY: Float): Float
    {
        if (marginTop != null && moveY > marginTop)
        {
            moveY = marginTop;
        }
        if (marginBottom != null && moveY < -marginBottom)
        {
            moveY = -marginBottom;
        }
        return moveY;
    }

    /**
     * Given a planned movement of the object as a vector, this method
     * updates the vector so that the movement can be used to move the object without
     * overlapping with other objects.
     *
     * @param move the movement vector, it will be modified in-place
     */
    public inline function constrainMove(move: Vector2)
    {
        move.x = constrainMoveX(move.x);
        move.y = constrainMoveY(move.y);
    }

    /**
     * Checks if given a movement vector, a collision would occur to the right
     * if the object were moved by that vector.
     *
     * @param move the movement vector
     * @return `true` if a collision would occur
     */
    public inline function willCollideRight(move: Vector2): Bool
    {
        return (marginRight != null) && (move.x > marginRight);
    }

    /**
     * Checks if given a movement vector, a collision would occur to the left
     * if the object were moved by that vector.
     *
     * @param move the movement vector
     * @return `true` if a collision would occur
     */
    public inline function willCollideLeft(move: Vector2): Bool
    {
        return (marginLeft != null) && (move.x < -marginLeft);
    }

    /**
     * Checks if given a movement vector, a collision would occur to the top
     * if the object were moved by that vector.
     *
     * @param move the movement vector
     * @return `true` if a collision would occur
     */
    public inline function willCollideTop(move: Vector2): Bool
    {
        return (marginTop != null) && (move.y > marginTop);
    }

    /**
     * Checks if given a movement vector, a collision would occur to the bottom
     * if the object were moved by that vector.
     *
     * @param move the movement vector
     * @return `true` if a collision would occur
     */
    public inline function willCollideBottom(move: Vector2): Bool
    {
        return (marginBottom != null) && (move.y < -marginLeft);
    }
}
