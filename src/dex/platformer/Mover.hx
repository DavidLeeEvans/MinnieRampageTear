/**

    Thanks to: https://2dengine.com/?p=platformers
**/

package dex.platformer;

import defold.Physics;
import defold.Sprite.SpriteMessages;
import defold.Vmath;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;
import dex.components.AnimationState;
import dex.components.RaycastCollider;
import dex.platformer.Animations.*;
import dex.platformer.hashes.PlatformerAnimations;
import dex.platformer.hashes.PlatformerCollisionGroups;
import dex.util.DexError;
import dex.util.types.Vector2;
import dex.wrappers.GameObject;
import dex.wrappers.Tilemap;

using dex.util.extensions.FloatEx;
using dex.util.extensions.Vector3Ex;


enum HorizontalContact
{
    None;
    WallLeft;
    WallRight;
}

enum FacingDirection
{
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
class Mover extends ScriptComponent
{
    /** The tilemap, used only for climbing. **/
    public var map: Tilemap = new Tilemap("/map#map", 16, 16);

    /** The animation state of the object's sprite. **/
    public var animationState(default, null): AnimationState;

    /** The acceleration of gravity. **/
    public var gravityAcceleration: Float;

    /** Damping coefficient in effect while grounded. Greater values lead to faster slow-down. **/
    public var groundDamping: Float = 0;

    /** Damping coefficient in effect while not grounded. Greater values lead to faster slow-down. **/
    public var airDamping: Float = 0;

    /** The maximum horizontal velocity in effect while grounded. **/
    public var groundSpeed: Float = 160;

    /** The maximum horizontal velocity in effect while in the air. **/
    public var airSpeed: Float = 80;

    /** The time it takes to reach the maximum speed specified by `groundSpeed`. **/
    public var groundAccelerationTime: Float = 0.1;

    /** Bit mask of available animations on the character's sprite. **/
    public var availableAnimations: Animations = All;

    /** The falling velocity, after which the falling animation is set. **/
    public var fallingVelocityThreshold: Float = 60;

    /** Set to true if the default sprite is facing left instead of right. **/
    public var spriteFacingLeft: Bool = false;

    /** The maximum vertical velocity the object will be allowed to reach. **/
    public var terminalVelocity: Float = 400;

    var animations: Map<Animations, Hash>;

    var velocity: Vector3;
    var grounded: Bool;
    var gravityScale: Float = 1;
    var dampingScale: Float = 1;
    var horizontalContact: HorizontalContact;
    var facingDirection: FacingDirection;
    var actualFacingDirection: FacingDirection;

    var collider: RaycastCollider;

    final go: GameObject;

    public function new()
    {
        super();

        go = GameObject.self();
        animationState = new AnimationState("#sprite");
    }

    override function onAddedToList()
    {
        super.onAddedToList();
    }

    override function init()
    {
        animations = new Map<Animations, Hash>();
        animations[ Idle ] = PlatformerAnimations.idle;
        animations[ Walk ] = PlatformerAnimations.walk;
        animations[ WalkBackwards ] = PlatformerAnimations.walk_backwards;
        animations[ Jump ] = PlatformerAnimations.jump;
        animations[ Fall ] = PlatformerAnimations.fall;
        animations[ Roll ] = PlatformerAnimations.roll;
        animations[ Land ] = PlatformerAnimations.land;

        velocity = Vmath.vector3();
        grounded = false;
        horizontalContact = None;
        facingDirection = Velocity;
        actualFacingDirection = Right;

        animationState.reset();

        if (gravityAcceleration == null)
        {
            gravityAcceleration = 0;
        }

        if (collider == null || collider.componentList == null)
        {
            DexError.error('the collider field must be initialized and added to the list before init() is called');
        }
    }

    override function update(dt: Float)
    {
        if (isMoverLocked())
        {
            return;
        }

        /**
         * Resolve collision overlaps.
         */
        udateCollisions(dt);

        /**
         * Update velocity to enforce constraints.
         */
        updateVelocityBeforeMove(dt);

        /**
         * Update position.
         */
        updatePosition(dt);

        /**
         * Update velocity for the next frame.
         */
        updateVelocityAfterMove(dt);

        /**
         * Update sprite.
         */
        updateSprite();
    }

    function udateCollisions(dt: Float)
    {
        var correctionX: Float = 0;
        var correctionY: Float = 0;

        if (collider.marginRight != null && collider.marginRight < 0)
        {
            correctionX = collider.marginRight;
            collider.marginRight = 0;

            onHorizontalContact();
        }
        if (collider.marginLeft != null && collider.marginLeft < 0)
        {
            correctionX = -collider.marginLeft;
            collider.marginLeft = 0;

            onHorizontalContact();
        }

        if (collider.marginTop != null && collider.marginTop < 0)
        {
            correctionY = collider.marginTop;
            collider.marginTop = 0;

            onVerticalContact();
        }
        if (collider.marginBottom != null && collider.marginBottom < 0)
        {
            correctionY = -collider.marginBottom;
            collider.marginBottom = 0;

            onVerticalContact();
        }

        go.moveXY(correctionX, correctionY);
    }

    inline function updateVelocityBeforeMove(dt: Float)
    {
        if (grounded && velocity.y < -2 * gravityAcceleration * dt)
        {
            // Falling without having jumped.
            grounded = false;
        }

        // Check if there is contact with a wall.
        switch horizontalContact
        {
            case WallLeft if (velocity.x >= 0):
                horizontalContact = None;
            case WallRight if (velocity.x <= 0):
                horizontalContact = None;
            case _:
        }
    }

    inline function updatePosition(dt: Float)
    {
        var moveVec: Vector2 = dt * velocity;

        if (collider.marginRight != null && moveVec.x > collider.marginRight)
        {
            moveVec.x = collider.marginRight;

            onHorizontalContact();
        }
        if (collider.marginLeft != null && moveVec.x < -collider.marginLeft)
        {
            moveVec.x = -collider.marginLeft;

            onHorizontalContact();
        }
        if (collider.marginTop != null && moveVec.y > collider.marginTop)
        {
            moveVec.y = collider.marginTop;

            onVerticalContact();
        }
        if (collider.marginBottom != null && moveVec.y < -collider.marginBottom)
        {
            moveVec.y = -collider.marginBottom;

            onVerticalContact();
        }

        go.setPosition(go.getPosition() + moveVec);
    }

    inline function updateVelocityAfterMove(dt: Float)
    {
        // Apply gravity.
        velocity.y -= effectiveGravityAcceleration() * dt;
        if (velocity.y < -terminalVelocity)
        {
            velocity.y = -terminalVelocity;
        }

        // Apply damping.
        velocity = velocity / (1 + effectiveDamping() * dt);
    }

    inline function updateSprite()
    {
        // Update facing direction.
        var walkBackwards: Bool = false;
        switch effectiveFacingDirection()
        {
            case Right:
                {
                    animationState.sprite.setFlip(spriteFacingLeft);
                    actualFacingDirection = Right;

                    if ((velocity.x < -1e-2) && (availableAnimations & WalkBackwards))
                    {
                        walkBackwards = true;
                    }
                }

            case Left:
                {
                    animationState.sprite.setFlip(!spriteFacingLeft);
                    actualFacingDirection = Left;

                    if ((velocity.x > 1e-2) && (availableAnimations & WalkBackwards))
                    {
                        walkBackwards = true;
                    }
                }

            default:
        }

        if (grounded)
        {
            // Update between idle and walk according to horizontal velocity.
            if ((Math.abs(velocity.x) >= 1) && (availableAnimations & Walk))
            {
                if (walkBackwards)
                {
                    animationState.set(animations[ WalkBackwards ]);
                }
                else
                {
                    animationState.set(animations[ Walk ]);
                }
            }
            else
            {
                animationState.set(animations[ Idle ]);
            }
        }
        else
        {
            // If falling fast enough, switch to falling Animations.
            if ((availableAnimations & Fall) && (velocity.y < -fallingVelocityThreshold))
            {
                animationState.set(animations[ Fall ]);
            }
        }
    }

    override function onMessage<TMessage>(messageId: Message<TMessage>, message: TMessage, sender: Url)
    {
        switch messageId
        {
            case SpriteMessages.animation_done:
                {
                    animationState.animationDone();
                }


            // Skip other messages if mover is locked.
            case _ if (isMoverLocked()):
        }
    }

    /**
     * Returns the current actual facing direction of the sprite.
     */
    public inline function getFacingDirection(): FacingDirection
    {
        return actualFacingDirection;
    }

    /**
     * Computes which way the sprite should currently be facing.
     */
    function effectiveFacingDirection(): FacingDirection
    {
        return
            switch facingDirection
            {
                case Left:
                    Left;
                case Right:
                    Right;
                case Velocity if (velocity.x > 1e-2):
                    Right;
                case Velocity if (velocity.x < -1e-2):
                    Left;
                case _:
                    Maintain;
            }
    }

    final function onVerticalContact()
    {
        var velY: Float = velocity.y;
        velocity.y = 0;

        if (!grounded && velY < 0)
        {
            // Grounded.
            grounded = true;
            gravityScale = 1;

            if ((Math.abs(velocity.x) >= 1) && (availableAnimations & Walk))
            {
                animationState.set(animations[ Walk ], Force);
            }
            else
            {
                animationState.set(animations[ Idle ], Force);
            }

            if (availableAnimations & Land)
            {
                animationState.set(animations[ Land ], Force | Restore);
            }

            onGrounded();
        }
    }

    final function onHorizontalContact()
    {
        var velX: Float = velocity.x;

        if (velX > 0)
        {
            horizontalContact = WallRight;
        }
        else
        {
            horizontalContact = WallLeft;
        }

        if (!grounded)
        {
            if (availableAnimations & Climb)
            {
                // TODO:
                // tryClimb(contactMsg);
            }
        }
    }

    function onGrounded()
    {
        // Override.
    }

    function isMoverLocked(): Bool
    {
        // Override.
        return false;
    }

    function hasMoveControl(): Bool
    {
        // Override.
        return true;
    }

    function climb(tilePosition: Vector3): Bool
    {
        // Override.
        return false;
    }

    function tryClimb(contactMsg: PhysicsMessageContactPointResponse)
    {
        if (contactMsg.other_group != PlatformerCollisionGroups.ground)
        {
            // This is the wrong layer.
            return;
        }

        var collidedTileApproximatePosition: Vector3 = contactMsg.position - (map.tileWidth / 2) * contactMsg.normal;
        var collidedTile = map.positionToTile(collidedTileApproximatePosition);

        var collidedTilePosition: Vector3 = map.tileToPosition(collidedTile.x, collidedTile.y);
        var collidedTileDirection: Vector3 = collidedTilePosition - go.getPosition();

        if (go.getPosition().y > collidedTilePosition.y + (map.tileHeight / 2) + (map.tileHeight / 4))
        {
            // The character is above the tile already.
            return;
        }

        if (go.getPosition().y < collidedTilePosition.y - (map.tileHeight / 2))
        {
            // Character is too low to climb.
            return;
        }

        // Is the tile above the collided one still in map bounds?
        if (map.inBounds(collidedTile.x, collidedTile.y + 1))
        {
            var isAboveEmpty: Bool = map.isEmpty(PlatformerCollisionGroups.ground, collidedTile.x, collidedTile.y + 1);

            if (!isAboveEmpty)
            {
                // Tile above is not empty.
                return;
            }
        }

        if (collidedTileDirection.x > 0 && map.inBounds(collidedTile.x - 1, collidedTile.y))
        {
            var isLeftEmpty: Bool = map.isEmpty(PlatformerCollisionGroups.ground, collidedTile.x - 1, collidedTile.y);

            if (!isLeftEmpty)
            {
                // Cannot climb from the left of tile.
                return;
            }
        }

        if (collidedTileDirection.x < 0 && map.inBounds(collidedTile.x + 1, collidedTile.y))
        {
            var isRightEmpty: Bool = map.isEmpty(PlatformerCollisionGroups.ground, collidedTile.x + 1, collidedTile.y);

            if (!isRightEmpty)
            {
                // Cannot climb from the right of tile.
                return;
            }
        }

        // Can climb.
        if (climb(collidedTilePosition))
        {
            velocity.y = 0;
            grounded = true;
        }
    }

    function effectiveGravityAcceleration(): Float
    {
        return gravityScale * gravityAcceleration;
    }

    inline function effectiveAcceleration(): Float
    {
        return groundSpeed / groundAccelerationTime;
    }

    inline function effectiveDamping(): Float
    {
        return dampingScale * (grounded ? groundDamping : airDamping);
    }
}
