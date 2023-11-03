package dex.platformer;

import defold.types.Message;
import defold.types.Url;
import dex.platformer.Animations.*;
import dex.platformer.hashes.PlatformerAnimations;
import dex.platformer.hashes.PlatformerMessages;
import dex.util.DexError;
import dex.util.Timer;

using dex.util.extensions.FloatEx;

/**
    Behavior for terminating a jump when input is released.
**/
enum JumpTerminationTechnique
{
    VelocityClamp;
    VelocityReset;
    GravityScale;
    None;
}

enum abstract HorizontalInput(Float) from Float to Float
{
    var None = 0.0;
    var Left = -1.0;
    var Right = 1.0;

    @:op(A * B) inline function mult(f: Float): Float
        return this * f;
}

class CharacterMover extends Mover
{
    /** The maximum height reachable by jumping. */
    public var jumpHeight: Float;

    /** The minimum jump height; defaults to the same as jumpHeight. */
    public var jumpMinHeight: Float;

    /** The initial upwards velocity at the moment of jumping. */
    public var jumpInitialVelocity: Float;

    /** The time it takes to reach `jumpHeight`. */
    public var jumpTimeToApex: Float;

    /** The amount of time (in seconds) that the jump can be held for a higher climb. */
    public var jumpHoldTime: Float = 0.0;

    /** The behavior to use for terminating a jump when input is released. */
    public var jumpTerminationTechnique: JumpTerminationTechnique = GravityScale;

    /** Scale to apply to the gravity acceleration when descending. */
    public var gravityFallScale: Float = 1.0;

    /** Applied input on the x-axis. **/
    public var horizontalInput: HorizontalInput;

    /** Threshold of the x-axis velocity, after which the animation switches from `Walk` to `Run`. Only applicable if `Run` is among the `availableAnimations`. **/
    public var velocityRunThreshold: Float = 16;

    var jumpTerminalVelocity: Float;

    var jumpHoldTimer: Timer;
    var jumpReleased: Bool;
    var jumpQueuedTimer: Timer;
    var gravityDisableTimer: Timer;
    var forceWalkTimer: Timer;

    override function init()
    {
        jumpHoldTimer = 0;
        jumpReleased = false;
        jumpQueuedTimer = 0;
        gravityDisableTimer = 0;
        forceWalkTimer = 0;
        horizontalInput = None;

        configurePhysics();

        super.init();
    }

    override function update(dt: Float)
    {
        // check if jumping should be terminated
        if (jumpReleased)
        {
            updateVelocityJumpTermination();
        }

        // update timers
        jumpQueuedTimer.tick(dt);
        gravityDisableTimer.tick(dt);
        if (jumpHoldTimer.tick(dt))
        {
            jumpRelease();
        }
        if (forceWalkTimer.tick(dt))
        {
            horizontalInput = None;
        }

        // cancel input if control is disabled
        if (!hasMoveControl() && forceWalkTimer.hasElapsed())
        {
            horizontalInput = None;
        }

        // Apply horizontal input.
        switch horizontalInput
        {
            // No input.
            case None:
                {
                    velocity.x = velocity.x * (1 / (1 + 10 * effectiveDamping() * dt));
                }

            // Grounded with input and direction change.
            case _ if (grounded && horizontalInput * velocity.x < 0):
                {
                    velocity.x = horizontalInput * effectiveAcceleration() * dt;
                }

            // Grounded with input.
            case _ if (grounded):
                {
                    velocity.x = (velocity.x + horizontalInput * effectiveAcceleration() * dt).clamp(-groundSpeed, groundSpeed);
                }

            // In the air with input.
            case _ if (!grounded):
                {
                    velocity.x = horizontalInput * Math.max(airSpeed, Math.abs(velocity.x));
                }

            case _:
        }

        // Update animation according to input.
        if (availableAnimations & Run && animations[ Walk ] == PlatformerAnimations.walk && Math.abs(velocity.x) >= velocityRunThreshold)
        {
            animations[ Walk ] = PlatformerAnimations.run;
        }
        else if (animations[ Walk ] == PlatformerAnimations.run && Math.abs(velocity.x) < velocityRunThreshold)
        {
            animations[ Walk ] = PlatformerAnimations.walk;
        }

        super.update(dt);
    }

    override function onMessage<TMessage>(messageId: Message<TMessage>, message: TMessage, sender: Url)
    {
        super.onMessage(messageId, message, sender);

        switch messageId
        {
            case PlatformerMessages.walk:
                {
                    var walkMsg: WalkMessage = cast message;

                    horizontalInput = walkMsg.distance > 0 ? walkMsg.speedFactor : -walkMsg.speedFactor;
                    forceWalkTimer = getTimeToWalk(walkMsg.distance, walkMsg.speedFactor);
                }
        }
    }

    /**
        Calculates the time needed to cover the given ground distance.

        Will be based on the mover's configured ground speed and effective acceleration.

        This assumes an initial speed of `0`.

        @param distance The distance to cover.
        @param speedFactor Multiplier applied to the input. Used to obtain a calculation for
        an absolute value of `horizontalInput` different from `1`.
    **/
    public inline function getTimeToWalk(distance: Float, speedFactor: Float = 1): Float
    {
        distance = Math.abs(distance);

        var timeToMaxSpeed: Float = groundSpeed / effectiveAcceleration();
        var distanceToMaxSpeed: Float = effectiveAcceleration() * timeToMaxSpeed * timeToMaxSpeed / 2;

        var totalTime: Float = timeToMaxSpeed;

        if (distanceToMaxSpeed < distance)
        {
            totalTime += (distance - distanceToMaxSpeed) / groundSpeed;
        }

        return totalTime;
    }

    public inline function jumpPress()
    {
        if (grounded)
        {
            grounded = false;
            jumpReleased = false;
            velocity.y = jumpInitialVelocity;

            jumpHoldTimer = jumpHoldTime + 1e-6;

            if (availableAnimations & Jump)
            {
                animationState.set(animations[ Jump ], Lock | Force);
            }
            if (availableAnimations & Roll)
            {
                animationState.set(animations[ Roll ], Queue);
            }
        }
        else
        {
            // queue the jump action for when grounded
            jumpQueuedTimer = 0.5;
        }
    }

    public inline function jumpRelease()
    {
        jumpQueuedTimer.tick(0.25);

        jumpReleased = true;

        if (jumpTerminationTechnique == GravityScale)
        {
            gravityScale = gravityFallScale;
        }
    }

    override function onGrounded()
    {
        super.onGrounded();

        if (jumpQueuedTimer)
        {
            jumpQueuedTimer = 0;
            jumpPress();
        }
    }

    inline function updateVelocityJumpTermination()
    {
        switch jumpTerminationTechnique
        {
            case VelocityClamp if (velocity.y > jumpTerminalVelocity):
                {
                    velocity.y = jumpTerminalVelocity;
                }


            case VelocityReset if (velocity.y > 0):
                {
                    velocity.y = 0;
                }


            case GravityScale:
                {
                    // case handled in jumpRelease()
                }


            default:
        }
    }

    function configurePhysics()
    {
        DexError.assert(jumpHeight != null, 'jumpHeight value must be configured');
        DexError.assert(jumpInitialVelocity != null || jumpTimeToApex != null || gravityAcceleration != null,
            'one of [jumpInitialVelocity, jumpTimeToApex or gravityAcceleration] must be configured'
        );

        if (gravityAcceleration == null)
        {
            gravityAcceleration = (2 * jumpHeight) / (jumpTimeToApex * jumpTimeToApex);
        }
        if (jumpInitialVelocity == null)
        {
            jumpInitialVelocity = Math.sqrt(2 * gravityAcceleration * jumpHeight);
        }
        if (jumpTimeToApex == null)
        {
            jumpTimeToApex = jumpInitialVelocity / gravityAcceleration;
        }

        if (jumpMinHeight == null)
        {
            jumpMinHeight = jumpHeight;
        }

        jumpTerminalVelocity = Math.sqrt(jumpInitialVelocity * jumpInitialVelocity + 2 * gravityAcceleration * (jumpHeight - jumpMinHeight));
    }

    override function effectiveGravityAcceleration(): Float
    {
        if (gravityDisableTimer)
        {
            // gravity currently disabled
            return 0;
        }

        return gravityScale * gravityAcceleration;
    }

    public inline function disableGravity(duration: Float)
    {
        gravityDisableTimer = duration;
    }

    inline function hasJumpTerminated(): Bool
    {
        return jumpReleased || jumpHoldTimer.hasElapsed();
    }
}
