package dex.topdown.components;

import dex.components.RaycastCollider;
import dex.util.Timer;
import dex.util.types.Vector2;
import dex.wrappers.GameObject;

using dex.util.extensions.FloatEx;
using dex.util.extensions.Vector3Ex;

/**
 * This component is a useful abstraction for moving an object in the 2D-plane.
 *
 * The implementation has a built-in velocity accumulation, and is only controlled by
 * directional input.
 *
 * For example if `setDirection(1, 0)` is called, then `velocity.x` will start increasing frame-by-frame,
 * and after the configured `riseTime` it will reach `1.0`.
 * Then the object is moved on each frame by `velocity * speed`.
 *
 * If the script also has a `RaycastCollider` component, it will be respected by this mover to prevent overlaps.
 * In this case, this mover should be used for all movements. For example `setForcedMove()` can force-move the object
 * while still utilizing the raycast collider.
 */
class TopdownMover extends ScriptComponent
{
    /** The time it takes for the character to accelerate to its speed from standing still. **/
    public var riseTime: Float = 0.1;

    /** The time it takes for the character to decelerate from its speed to standing still. **/
    public var fallTime: Float = 0.1;

    /**
     * The normalized accumulated velocity.
     * Both `x` and `y` components are in the `[-1, 1]` range.
     */
    public var velocity(default, null): Vector2;

    var inputDirection: Vector2;
    var speed: Float;
    var forcedMove: Vector2;
    var forcedMoveTimer: Timer;

    var collider: RaycastCollider;
    var gameObject: GameObject;

    public function new(speed: Float)
    {
        super();
        this.speed = speed;
    }

    override function init()
    {
        inputDirection = Vector2.zero;
        velocity = Vector2.zero;
        forcedMove = Vector2.zero;
        forcedMoveTimer = Timer.expired;
        collider = componentList[ RaycastCollider ];
        gameObject = GameObject.self();
    }

    /**
     * Updates the direction that the mover should attempt to move the object in.
     *
     * The vector `(dirX, dirY)` given should be either normalized, or zero.
     */
    public inline function setDirection(dirX: Float, dirY: Float)
    {
        inputDirection.x = dirX;
        inputDirection.y = dirY;
    }

    public inline function setSpeed(speed: Float)
    {
        this.speed = speed;
    }

    /**
     * Apply a forced movement in `pixels/sec`.
     *
     * This method is added to prevent having to manually lock/unlock the mover
     * when a few frames of forced movement is necessary.
     *
     * @param forceX the forced movement along the x-axis
     * @param forceY the forced movement along the y-axis
     * @param duration if not `null`, the forced move will be cleared after this time (in seconds)
     */
    public inline function setForcedMove(forceX: Float, forceY: Float, ?duration: Float)
    {
        forcedMove.x = forceX;
        forcedMove.y = forceY;

        if (duration != null)
        {
            forcedMoveTimer.start(duration);
        }
        else
        {
            forcedMoveTimer = Timer.expired;
        }
    }

    override function update(dt: Float)
    {
        // first update the velocity according to the input direction
        updateVelocity(dt);

        // compute the movement for this frame
        var deltaX: Float = velocity.x * speed * dt;
        var deltaY: Float = velocity.y * speed * dt;

        // apply the forced movement if configured
        deltaX += forcedMove.x * dt;
        deltaY += forcedMove.y * dt;
        if (forcedMoveTimer.tick(dt))
        {
            forcedMove.reset();
        }

        // prevent collisions if necessary
        if (collider != null)
        {
            deltaX = collider.constrainMoveX(deltaX);
            deltaY = collider.constrainMoveY(deltaY);
        }

        gameObject.moveXY(deltaX, deltaY);
    }

    inline function updateVelocity(dt: Float)
    {
        velocity.x = updateVelocityAxis(velocity.x, inputDirection.x, dt);
        velocity.y = updateVelocityAxis(velocity.y, inputDirection.y, dt);
    }

    inline function updateVelocityAxis(vel: Float, input: Float, dt: Float): Float
    {
        if (input.equals(vel))
        {
            // velocity reached the input
        }
        else if ((input * vel >= 0) && input.absGreater(vel))
        {
            // accelerating
            if (input > vel)
            {
                vel += dt / (riseTime + 1e-6);
                vel = vel.clamp(-1, 1);
            }
            else
            {
                vel -= dt / (riseTime + 1e-6);
                vel = vel.clamp(-1, 1);
            }
        }
        else
        {
            // decelerating
            if (input > vel)
            {
                vel += dt / (riseTime + 1e-6);
                vel = vel.clamp(-1, 0);
            }
            else
            {
                vel -= dt / (riseTime + 1e-6);
                vel = vel.clamp(0, 1);
            }
        }

        return vel;
    }
}
