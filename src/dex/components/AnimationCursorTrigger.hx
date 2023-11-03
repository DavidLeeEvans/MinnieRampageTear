package dex.components;

import Defold.hash;
import defold.types.Hash;
import dex.util.DexMath;
import dex.wrappers.Sprite;


typedef CursorCallback =
{
    var animation: Hash;
    var threshold: Float;
    var callback: (cursor: Float) -> Void;
    var repeat: Bool;
    var done: Bool;
}

/**
 * This component will monitor the given sprite's animation cursor,
 * and trigger callbacks and configured thresholds.
 */
class AnimationCursorTrigger extends ScriptComponent
{
    static final anyAnimation: Hash = hash("");

    var sprite: Sprite;
    var prevCursor: Float;

    var triggers: Array<CursorCallback>;

    public function new(sprite: Sprite)
    {
        super();

        this.sprite = sprite;
        prevCursor = sprite.getCursor();

        triggers = [ ];
    }

    override function update(dt: Float)
    {
        var animation: Hash = sprite.getAnimation();
        var cursor: Float = sprite.getCursor();

        for (trigger in triggers)
        {
            if (trigger.animation != anyAnimation)
            {
                if (trigger.animation != animation)
                {
                    // this trigger is for another animation
                    continue;
                }
            }

            if (trigger.done && !trigger.repeat)
            {
                // this trigger is already done
                continue;
            }

            if (trigger.threshold >= prevCursor && trigger.threshold < cursor)
            {
                // threshold just reached
                trigger.callback(cursor);
                trigger.done = true;
            }
        }

        prevCursor = cursor;
    }

    public inline function add(threshold: Float, callback: (cursor: Float) -> Void, ?animation: Hash)
    {
        doAdd(threshold, callback, true, animation);
    }

    public inline function addOnce(threshold: Float, callback: (cursor: Float) -> Void, ?animation: Hash)
    {
        doAdd(threshold, callback, false, animation);
    }

    function doAdd(threshold: Float, callback: (cursor: Float) -> Void, repeat: Bool, ?animation: Hash)
    {
        if (animation == null)
        {
            animation = anyAnimation;
        }

        // first check if this trigger already exists
        for (trigger in triggers)
        {
            if (trigger.animation == animation && DexMath.floatEquals(trigger.threshold, threshold) && trigger.done && !trigger.repeat)
            {
                trigger.threshold = threshold;
                trigger.callback = callback;
                trigger.repeat = repeat;
                trigger.done = false;
                return;
            }
        }

        triggers.push(
            {
                animation: animation,
                threshold: threshold,
                callback: callback,
                repeat: repeat,
                done: false
            });
    }
}
