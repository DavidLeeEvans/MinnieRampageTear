/**

	Thanks to: https://2dengine.com/?p=platformers
**/

package dex.platformer;

import dex.platformer.hashes.PlatformerAnimations;

import dex.wrappers.Tilemap;

import dex.platformer.hashes.PlatformerCollisionGroups;

import defold.Sprite.SpriteMessageAnimationDone;
import defold.Sprite.SpriteMessages;

import dex.wrappers.Sprite;

import defold.Vmath;

import defold.types.Vector3;

import defold.Physics;
import defold.Sys;

import dex.wrappers.GameObject;

import defold.types.Url;
import defold.types.Message;

import defold.support.ScriptOnInputAction;

import defold.types.Hash;

import dex.platformer.Animations.*;

using dex.util.extensions.Vector3Ex;

enum HorizontalContact {
	None;
	WallLeft;
	WallRight;
}

enum FacingDirection {
	Left;
	Right;
	Velocity;
	Maintain;
}

/**
	Any two of the following must be configured:

	- jumpHeight
	- gravityAcceleration
	- jumpInitialVelocity
	- jumpTimeToApex
**/
class Mover extends ScriptComponent {
	static final go:GameObject = GameObject.self;
	static final map:Tilemap = new Tilemap("/map#map", 16, 16);

	/** The animation state of the object's sprite. **/
	public var animationState(default, null):AnimationState;

	/** The acceleration of gravity. **/
	public var gravityAcceleration:Float;

	/** Damping coefficient in effect while grounded. Greater values lead to faster slow-down. **/
	public var groundDamping:Float = 0;

	/** Damping coefficient in effect while not grounded. Greater values lead to faster slow-down. **/
	public var airDamping:Float = 0;

	/** The maximum horizontal velocity in effect while grounded. **/
	public var groundSpeed:Float = 160;

	/** The maximum horizontal velocity in effect while in the air. **/
	public var airSpeed:Float = 80;

	/** The time it takes to reach the maximum speed specified by `groundSpeed`. **/
	public var groundAccelerationTime:Float = 0.1;

	/** Bit mask of available animations on the character's sprite. **/
	public var availableAnimations:Animations = All;

	var animations:Map<Animations, Hash>;

	var velocity:Vector3;
	var grounded:Bool;
	var gravityScale:Float = 1;
	var dampingScale:Float = 1;
	var horizontalContact:HorizontalContact;
	var facingDirection:FacingDirection;
	var actualFacingDirection:FacingDirection;

	public function new() {
		super();

		animationState = new AnimationState("#sprite");
	}

	public override function init() {
		animations = new Map<Animations, Hash>();
		animations[Idle] = PlatformerAnimations.idle;
		animations[Walk] = PlatformerAnimations.walk;

		velocity = Vmath.vector3();
		grounded = false;
		horizontalContact = None;
		facingDirection = Velocity;
		actualFacingDirection = Right;

		animationState.reset();

		if (gravityAcceleration == null) {
			gravityAcceleration = 0;
		}
	}

	public override function update(dt:Float) {
		if (isMoverLocked()) {
			return;
		}

		/**
			Update velocity to enforce constraints.
		**/
		updateVelocityBeforeMove(dt);

		/**
			Update position.
		**/
		updatePosition(dt);

		/**
			Update velocity for the next frame.
		**/
		updateVelocityAfterMove(dt);

		/**
			Update sprite.
		**/
		updateSprite();
	}

	inline function updateVelocityBeforeMove(dt:Float) {
		if (grounded && velocity.y < -2 * gravityAcceleration * dt) {
			// Falling without having jumped.
			grounded = false;
		}

		// Check if there is contact with a wall.
		switch horizontalContact {
			/*
				Setting the velocity to 1 is a hack that will allow us to get collision
				information on the next frame, without actually visibly moving the character into the object.
			 */
			case WallLeft if (velocity.x < 0):
				velocity.x = -1;
				horizontalContact = None;
			case WallLeft if (velocity.x >= 0):
				horizontalContact = None;
			case WallRight if (velocity.x > 0):
				velocity.x = 1;
				horizontalContact = None;
			case WallRight if (velocity.x <= 0):
				horizontalContact = None;
			case _:
		}
	}

	inline function updatePosition(dt:Float) {
		go.setPosition(go.getPosition() + (dt * velocity));
	}

	inline function updateVelocityAfterMove(dt:Float) {
		// Apply gravity.
		velocity.y -= effectiveGravityAcceleration() * dt;

		// Apply damping.
		velocity = velocity * (1 / (1 + effectiveDamping() * dt));
	}

	inline function updateSprite() {
		// Update facing direction.
		if (effectiveFacingDirection() == Right) {
			animationState.sprite.setFlip(false);
			actualFacingDirection = Right;
		} else if (effectiveFacingDirection() == Left) {
			animationState.sprite.setFlip(true);
			actualFacingDirection = Left;
		}

		if (grounded) {
			// Update between idle and run according to horizontal velocity.
			if (Math.abs(velocity.x) >= 1) {
				animationState.set(animations[Walk]);
			} else {
				animationState.set(animations[Idle]);
			}
		} else {
			// If falling fast enough, switch to falling Animations.
			if (availableAnimations & Fall && velocity.y < -80) {
				animationState.set(animations[Fall]);
			}
		}
	}

	public override function onMessage<TMessage>(messageId:Message<TMessage>, message:TMessage, sender:Url) {
		switch messageId {
			case SpriteMessages.animation_done:
				{
					var animationDoneMsg:SpriteMessageAnimationDone = cast message;

					animationState.animationDone(animationDoneMsg.id);
				}

			// Skip other messages if mover is locked.
			case _ if (isMoverLocked()):

			case PhysicsMessages.contact_point_response:
				{
					var contactMsg:PhysicsMessageContactPointResponse = cast message;
					var normal:Vector3 = contactMsg.normal;

					// Ignore false positives.
					if (contactMsg.distance < 0) {
						// I assume it's when separation already happened through another collision?
						return;
					}

					// When going upwards, ignore feet collider.
					if (velocity.y > 0 && contactMsg.own_group == PlatformerCollisionGroups.characters_feet) {
						return;
					}

					// Normalize separation vector.
					var separationRatio:Float = normal.y == 0 ? 1 : Math.abs(normal.x) / Math.abs(normal.y);
					var velocityRatio:Float = velocity.y == 0 ? 1 : Math.abs(velocity.x) / Math.abs(velocity.y);

					// trace('$cycle: ${normal.toString()} ${velocity.toString()} $separationRatio $velocityRatio $grounded');

					// Update velocity.
					if (normal.y * velocity.y < 0 && separationRatio < 1e-3) {
						// Separation counter to velocity.
						velocity.y = 0;

						if (normal.y > 0 && !grounded) {
							// Grounded.
							grounded = true;
							gravityScale = 1;

							if (Math.abs(velocity.x) > 0) {
								animationState.set(animations[Walk]);
							} else {
								animationState.set(animations[Idle]);
							}

							onGrounded();
						}
					}

					if (normal.x * velocity.x < 0 && separationRatio > 0.2) {
						// Separation counter to velocity.
						velocity.x = 0;

						if (!grounded) {
							// Grounded, process contact with walls.
							if (normal.x > 0) {
								horizontalContact = WallLeft;
							} else {
								horizontalContact = WallRight;
							}

							tryClimb(contactMsg);
						}
					} else {
						horizontalContact = None;
					}

					// Separate from other collider.
					go.move(normal, contactMsg.distance);
				}
		}
	}

	public inline function getFacingDirection():FacingDirection {
		return actualFacingDirection;
	}

	function effectiveFacingDirection():FacingDirection {
		return switch facingDirection {
			case Left: Left;
			case Right: Right;
			case Velocity if (velocity.x > 1e-2): Right;
			case Velocity if (velocity.x < -1e-2): Left;
			case _: Maintain;
		}
	}

	function onGrounded() {
		// Override.
	}

	function isMoverLocked():Bool {
		// Override.
		return false;
	}

	function hasMoveControl():Bool {
		// Override.
		return true;
	}

	function climb(tilePosition:Vector3):Bool {
		// Override.
		return false;
	}

	function tryClimb(contactMsg:PhysicsMessageContactPointResponse) {
		if (contactMsg.other_group != PlatformerCollisionGroups.ground) {
			// This is the wrong layer.
			return;
		}

		var collidedTileApproximatePosition:Vector3 = contactMsg.position - (map.tileWidth / 2) * contactMsg.normal;
		var collidedTile = map.positionToTile(collidedTileApproximatePosition);

		var collidedTilePosition:Vector3 = map.tileToPosition(collidedTile.x, collidedTile.y);
		var collidedTileDirection:Vector3 = collidedTilePosition - go.getPosition();

		if (go.getPosition().y > collidedTilePosition.y + (map.tileHeight / 2) + (map.tileHeight / 4)) {
			// The character is above the tile already.
			return;
		}

		if (go.getPosition().y < collidedTilePosition.y - (map.tileHeight / 2)) {
			// Character is too low to climb.
			return;
		}

		// Is the tile above the collided one still in map bounds?
		if (map.inBounds(collidedTile.x, collidedTile.y + 1)) {
			var isAboveEmpty:Bool = map.isEmpty(PlatformerCollisionGroups.ground, collidedTile.x, collidedTile.y + 1);

			if (!isAboveEmpty) {
				// Tile above is not empty.
				return;
			}
		}

		if (collidedTileDirection.x > 0 && map.inBounds(collidedTile.x - 1, collidedTile.y)) {
			var isLeftEmpty:Bool = map.isEmpty(PlatformerCollisionGroups.ground, collidedTile.x - 1, collidedTile.y);

			if (!isLeftEmpty) {
				// Cannot climb from the left of tile.
				return;
			}
		}

		if (collidedTileDirection.x < 0 && map.inBounds(collidedTile.x + 1, collidedTile.y)) {
			var isRightEmpty:Bool = map.isEmpty(PlatformerCollisionGroups.ground, collidedTile.x + 1, collidedTile.y);

			if (!isRightEmpty) {
				// Cannot climb from the right of tile.
				return;
			}
		}

		// Can climb.
		if (climb(collidedTilePosition)) {
			velocity.y = 0;
			grounded = true;
		}
	}

	function effectiveGravityAcceleration():Float {
		return gravityScale * gravityAcceleration;
	}

	inline function effectiveAcceleration():Float {
		return groundSpeed / groundAccelerationTime;
	}

	inline function effectiveDamping():Float {
		return dampingScale * (grounded ? groundDamping : airDamping);
	}
}
