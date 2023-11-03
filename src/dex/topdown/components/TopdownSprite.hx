package dex.topdown.components;

import dex.components.AnimationState;
import dex.topdown.hashes.TopdownAnimations;
import dex.types.FacingDirection;
import dex.util.DexError;
import dex.util.DexMath;
import dex.util.types.SpriteSet;

/**
 * Simple component for managing an object's sprite according to its movement.
 * - The sprite will be flipped horizontally according to the current velocity on the x-axis.
 * - The animation will change between `idle`, `walk`, and `run` according to the current velocity.
 *
 * The following components are required:
 * - `AnimationState`
 * - `TopdownMover`
 */
class TopdownSprite extends AnimationState
{
    var mover: TopdownMover;

    var spriteFacingLeft: Bool;
    var runThresholdSq: Float;
    var walkThresholdSq: Float;
    var facingDir: Null<FacingDirection>;

    /**
     * Configure a new topdown sprite manager.
     *
     * If the `walkThreshold` is specified, then the
     * arguments need to satisfy: `0 < walkThreshold < runThreshold < 1`
     *
     * @param spriteFacingLeft should be `true` if the sprite is facing left by default
     * @param runThreshold a `[0.0, 1.0]` threshold, above which the animation will be set to `run`
     * @param walkThreshold a `[0.0, 1.0]` threshold, above which the animation will be set to `walk`;
     *                      if `null`, the `walk` animation will not be used
     */
    public function new(sprite: SpriteSet, spriteFacingLeft: Bool = false, runThreshold: Float = 0.5, ?walkThreshold: Float)
    {
        super(sprite, TopdownAnimations.idle);

        DexError.assert(runThreshold != null && runThreshold >= 0 && runThreshold <= 1.0);
        DexError.assert(walkThreshold == null || walkThreshold < runThreshold);

        this.spriteFacingLeft = spriteFacingLeft;
        runThresholdSq = runThreshold * runThreshold;
        walkThresholdSq = walkThreshold != null ? walkThreshold * walkThreshold : runThresholdSq;
        // if null, we initialize the walk threshold to the run threshold         ^
        // this ensures that it is never triggered (see the update method)

        facingDir = null;
    }

    /**
     * Sets the facing direction of the sprite.
     *
     * This method is used to override the flipping of the sprite according to the movement.
     *
     * @param facingDir the facing direction, or `null` to disable the overriding and return
     *                  to flipping the sprite according to the movement
     */
    public inline function setFacingDirection(?facingDir: FacingDirection)
    {
        this.facingDir = facingDir;
    }

    override function init()
    {
        mover = componentList.require(TopdownMover);
    }

    override function update(dt: Float)
    {
        if (facingDir != null)
        {
            switch facingDir
            {
                case Right:
                    sprite.setFlip(spriteFacingLeft);

                case Left:
                    sprite.setFlip(!spriteFacingLeft);
            }
        }
        else if (mover.velocity.x > DexMath.eps)
        {
            sprite.setFlip(spriteFacingLeft);
        }
        else if (mover.velocity.x < -DexMath.eps)
        {
            sprite.setFlip(!spriteFacingLeft);
        }

        var velocitySq: Float = mover.velocity.lengthSquared();
        if (velocitySq > runThresholdSq)
        {
            set(TopdownAnimations.run);
        }
        else if (velocitySq > walkThresholdSq)
        {
            set(TopdownAnimations.walk);
        }
        else
        {
            set(TopdownAnimations.idle);
        }
    }
}
