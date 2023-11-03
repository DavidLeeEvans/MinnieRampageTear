package dex.components;

import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import dex.systems.Time;
import dex.util.types.Vector2;
import dex.util.types.Vector2Int;


class Input2D extends ScriptComponent
{
    /**
     * X-axis move input.
     * `-1` left, `+1` right
     */
    public var x(get, never): Int;

    /**
     * Y-axis move input.
     * `-1` down, `+1` up
     */
    public var y(get, never): Int;

    /**
     * Move input as a 2D vector.
     */
    public var move(default, null): Vector2Int;

    /**
     * Is `true` if there was move input during the last call to `onInput()`.
     */
    public var hadMoveInput(default, null): Bool;

    /**
     * The screen x-coordinate of the current mouse position.
     */
    public var mouseX(get, never): Float;

    /**
     * The screen y-coordinate of the current mouse position.
     */
    public var mouseY(get, never): Float;

    /**
     * The mouse screen position as a vector.
     */
    public var mouse(default, null): Vector2;

    /**
     * The mouse movement along the x-axis during the last frame.
     */
    public var mouseDeltaX(get, never): Float;

    /**
     * The mouse movement along the y-axis during the last frame.
     */
    public var mouseDeltaY(get, never): Float;

    /**
     * The mouse movement during the last frame as a vector.
     */
    public var mouseDelta(default, null): Vector2;

    /**
     * The length of the mouse movement during the last frame.
     */
    public var mouseDeltaLength(get, never): Float;

    /**
     * The frame number when the last mouse input was received.
     * The `Time` system needs to be activated for this to work.
     */
    public var lastMouseInputFrame(default, null): Int;

    /**
     * The number of frames that elapsed since the last mouse input was received.
     */
    public var lastMouseInputFramesElapsed(get, never): Int;

    /**
     * Indicates if the input is locked.
     */
    public var locked(default, null): Bool;

    public var inputUp: Hash = Defold.hash("up");
    public var inputDown: Hash = Defold.hash("down");
    public var inputLeft: Hash = Defold.hash("left");
    public var inputRight: Hash = Defold.hash("right");

    var useScreenCoordinates: Bool;

    var prevMouseX: Float;
    var prevMouseY: Float;
    var changed: Bool;

    public function new(useScreenCoordinates: Bool = false)
    {
        super();
        this.useScreenCoordinates = useScreenCoordinates;

        reset();
    }

    public function reset()
    {
        move = Vector2Int.zero;
        hadMoveInput = false;
        mouse = Vector2.zero;
        mouseDelta = Vector2.zero;
        lastMouseInputFrame = Time.frame;
        prevMouseX = 0;
        prevMouseY = 0;
        changed = false;
        locked = false;
    }

    /**
     * Locks the input.
     * While locked, no additional input will be processed.
     *
     * Setting `reset = false`, locking will keep the last recorded inputs.
     *
     * @param reset if `true`, then the class will be reset and all inputs will be set to `0`
     */
    public function lock(reset: Bool = true)
    {
        locked = true;

        if (reset)
        {
            move.x = 0;
            move.y = 0;
            hadMoveInput = false;
            mouseDelta.x = 0;
            mouseDelta.y = 0;
            prevMouseX = 0;
            prevMouseY = 0;
            changed = false;
        }
    }

    /**
     * Unlock the input.
     */
    public function unlock()
    {
        locked = false;
    }

    override function onBeforeInput()
    {
        hadMoveInput = false;
    }

    override function onInput(actionId: Hash, action: ScriptOnInputAction): Bool
    {
        if (locked)
        {
            return false;
        }

        if (actionId == inputUp)
        {
            if (action.pressed || move.y == 0)
            {
                move.y = 1;
                changed = true;
            }
            else if (action.released)
            {
                move.y = 0;
                changed = true;
            }
            hadMoveInput = true;
        }
        else if (actionId == inputDown)
        {
            if (action.pressed || move.y == 0)
            {
                move.y = -1;
                changed = true;
            }
            else if (action.released)
            {
                move.y = 0;
                changed = true;
            }
            hadMoveInput = true;
        }
        else if (actionId == inputLeft)
        {
            if (action.pressed || move.x == 0)
            {
                move.x = -1;
                changed = true;
            }
            else if (action.released)
            {
                move.x = 0;
                changed = true;
            }
            hadMoveInput = true;
        }
        else if (actionId == inputRight)
        {
            if (action.pressed || move.x == 0)
            {
                move.x = 1;
                changed = true;
            }
            else if (action.released)
            {
                move.x = 0;
                changed = true;
            }
            hadMoveInput = true;
        }
        else if (actionId == null)
        {
            prevMouseX = mouse.x;
            prevMouseY = mouse.y;

            if (useScreenCoordinates)
            {
                mouse.x = action.screen_x;
                mouse.y = action.screen_y;
            }
            else
            {
                mouse.x = action.x;
                mouse.y = action.y;
            }

            lastMouseInputFrame = Time.frame;
        }

        mouseDelta.x = mouse.x - prevMouseX;
        mouseDelta.y = mouse.y - prevMouseY;

        return hadMoveInput;
    }

    /**
     * Checks if the current mover input is different to when `wasChanged()` was last called.
     *
     * This does not include mouse movement.
     */
    public inline function wasChanged(): Bool
    {
        if (changed)
        {
            changed = false;
            return true;
        }
        {
            return false;
        }
    }

    inline function get_x(): Int
    {
        return move.x;
    }

    inline function get_y(): Int
    {
        return move.y;
    }

    inline function get_mouseX(): Float
    {
        return mouse.x;
    }

    inline function get_mouseY(): Float
    {
        return mouse.y;
    }

    inline function get_mouseDeltaX(): Float
    {
        return mouseDelta.x;
    }

    inline function get_mouseDeltaY(): Float
    {
        return mouseDelta.y;
    }

    inline function get_mouseDeltaLength(): Float
    {
        return mouseDelta.length();
    }

    inline function get_lastMouseInputFramesElapsed(): Int
    {
        return Time.framesElapsedSince(lastMouseInputFrame);
    }
}
