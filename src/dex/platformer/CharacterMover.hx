package dex.platformer;

import dex.platformer.hashes.PlatformerMessages;

import defold.types.Message;
import defold.types.Url;

import dex.platformer.hashes.PlatformerAnimations;
import dex.platformer.Animations.*;

/**
	Behavior for terminating a jump when input is released.
**/
enum JumpTerminationTechnique {
	VelocityClamp;
	VelocityReset;
	GravityScale;
	None;
}

@:enum
abstract HorizontalInput(Float) from Float to Float {
	var None = 0.0;
	var Left = -1.0;
	var Right = 1.0;

	@:op(A * B) public inline function mult(f:Float):Float
		return this * f;
}

class CharacterMover extends Mover {
	/** The maximum height reachable by jumping. **/
	public var jumpHeight:Float;

	/** The minimum height reachable by jumping. Defaults to `20%` of `jumpHeight`. **/
	public var jumpMinHeight:Float;

	/** The initial upwards velocity at the moment of jumping. **/
	public var jumpInitialVelocity:Float;

	/** The time it takes to reach `jumpHeight`. **/
	public var jumpTimeToApex:Float;

	/** The behavior to use for terminating a jump when input is released. **/
	public var jumpTerminationTechnique:JumpTerminationTechnique = VelocityClamp;

	/** Scale to apply to the gravity acceleration when descending. **/
	public var gravityFallScale:Float = 1.0;

	/** Applied input on the x-axis. **/
	public var horizontalInput:HorizontalInput;

	var jumpReleased:Bool;
	var jumpQueuedTimer:Float;
	var gravityDisableTimer:Float;
	var forceWalkTimer:Float;

	override function init() {
		horizontalInput = None;
		jumpReleased = false;
		jumpQueuedTimer = 0;
		gravityDisableTimer = 0;
		forceWalkTimer = 0;

		configurePhysics();

		super.init();
	}

	override function update(dt:Float) {
		// Check if jumping should be terminated.
		if (jumpReleased) {
			jumpRelease();
		}

		// Update timers.
		if (jumpQueuedTimer > 0)
			jumpQueuedTimer -= dt;
		if (gravityDisableTimer > 0)
			gravityDisableTimer -= dt;
		if (forceWalkTimer > 0) {
			forceWalkTimer -= dt;

			if (forceWalkTimer <= 0) {
				horizontalInput = None;
			}
		}

		// Cancel input if control is disabled.
		if (!hasMoveControl() && forceWalkTimer <= 0) {
			horizontalInput = None;
		}

		// Apply horizontal input.
		switch horizontalInput {
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
					velocity.x += horizontalInput * effectiveAcceleration() * dt;

					if (Math.abs(velocity.x) > Math.abs(horizontalInput * groundSpeed)) {
						velocity.x = horizontalInput * groundSpeed;
					}
				}

			// In the air with input.
			case _ if (!grounded):
				{
					velocity.x = horizontalInput * Math.max(airSpeed, Math.abs(velocity.x));
				}

			case _:
		}

		// Update animation according to input.
		if (availableAnimations & Run && animations[Walk] == PlatformerAnimations.walk && Math.abs(horizontalInput) >= 0.8) {
			animations[Walk] = PlatformerAnimations.run;
		} else if (animations[Walk] == PlatformerAnimations.run && Math.abs(horizontalInput) < 0.8) {
			animations[Walk] = PlatformerAnimations.walk;
		}

		super.update(dt);
	}

	override function onMessage<TMessage>(messageId:Message<TMessage>, message:TMessage, sender:Url) {
		super.onMessage(messageId, message, sender);

		switch messageId {
			case PlatformerMessages.walk:
				{
					var walkMsg:WalkMessage = cast message;

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
	public inline function getTimeToWalk(distance:Float, speedFactor:Float = 1):Float {
		distance = Math.abs(distance);

		var timeToMaxSpeed:Float = groundSpeed / effectiveAcceleration();
		var distanceToMaxSpeed:Float = effectiveAcceleration() * timeToMaxSpeed * timeToMaxSpeed / 2;

		var totalTime:Float = timeToMaxSpeed;

		if (distanceToMaxSpeed < distance) {
			totalTime += (distance - distanceToMaxSpeed) / groundSpeed;
		}

		return totalTime;
	}

	public inline function jump() {
		if (grounded) {
			grounded = false;
			velocity.y = jumpInitialVelocity;
			jumpReleased = false;

			animationState.set(PlatformerAnimations.jump, Lock | Force);
			animationState.set(PlatformerAnimations.roll, Queue);
		} else {
			// Queue the jump action for when grounded.
			jumpQueuedTimer = 0.5;
		}
	}

	override function onGrounded() {
		super.onGrounded();

		if (jumpQueuedTimer > 0) {
			jump();
		}
	}

	public inline function jumpRelease() {
		if (jumpQueuedTimer > 0) {
			jumpQueuedTimer -= 0.25;
			return;
		}

		jumpReleased = false;

		switch jumpTerminationTechnique {
			case VelocityClamp if (velocity.y > jumpTerminationVelocity()):
				{
					velocity.y = jumpTerminationVelocity();
				}

			case VelocityReset if (velocity.y > 0):
				{
					velocity.y = 0;
				}

			case GravityScale:
				{
					// Case handled in effectiveGravityAcceleration().
				}

			case _:
				{
					// Check again next frame.
					jumpReleased = true;
				}
		}
	}

	public function configurePhysics() {
		if (gravityAcceleration == null) {
			gravityAcceleration = (2 * jumpHeight) / (jumpTimeToApex * jumpTimeToApex);
		}
		if (jumpInitialVelocity == null) {
			jumpInitialVelocity = Math.sqrt(2 * gravityAcceleration * jumpHeight);
		}
		if (jumpTimeToApex == null) {
			jumpTimeToApex = jumpInitialVelocity / gravityAcceleration;
		}
		if (jumpMinHeight == null) {
			jumpMinHeight = 0.2 * jumpHeight;
		}
		// TODO: jumpHeight
	}

	override function effectiveGravityAcceleration():Float {
		if (velocity.y < 0 || (jumpReleased && jumpTerminationTechnique == GravityScale)) {
			// Falling.
			if (gravityDisableTimer > 0) {
				// Gravity currently disabled.
				return 0;
			} else {
				return gravityScale * gravityFallScale * gravityAcceleration;
			}
		} else {
			// Rising.
			return gravityScale * gravityAcceleration;
		}
	}

	public inline function disableGravity(duration:Float) {
		gravityDisableTimer = duration;
	}

	inline function jumpTerminationVelocity():Float {
		return Math.sqrt((jumpInitialVelocity * jumpInitialVelocity) - 2 * effectiveGravityAcceleration() * (jumpHeight - jumpMinHeight));
	}

	inline function jumpTerminationTime():Float {
		return jumpTimeToApex - (2 * (jumpHeight - jumpMinHeight) / (jumpInitialVelocity + jumpTerminationVelocity()));
	}
}
