package dex.gui;

import Defold.hash;
import dex.wrappers.GuiNode;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;

using dex.util.extensions.LuaTableEx;


typedef TouchAction =
{
    var x: Float;
    var y: Float;
    var pressed: Bool;
    var released: Bool;
}

class MobileButtonGuiNode extends GuiNode
{
    public var pressScaleIncrease(default, null): Float;
    public var held(default, null): Bool;
    public var heldTouchId(default, null): Int;

    public var onPress: () -> Void;
    public var onRelease: () -> Void;

    var touchAction: Hash;
    var disabled: Bool;

    public function new(?id: String, ?touchAction: Hash, pressScaleIncrease: Float = 0)
    {
        super(id);

        if (touchAction == null)
        {
            touchAction = hash("touch");
        }

        this.touchAction = touchAction;
        this.pressScaleIncrease = pressScaleIncrease;

        held = false;
        heldTouchId = -2;
        disabled = false;
    }

    /**
     * Performs the action check on the button.
     *
     * @return `true` if input was captured by the node, `false` otherwise.
     */
    public function onInput(action_id: Hash, action: ScriptOnInputAction): Bool
    {
        if (!isEnabled() || disabled)
            return false;

        if (action.touch != null)
        {
            action.touch.forEach((_, touch: ScriptOnInputActionTouch) ->
            {
                processAction(touch, touch.id);
            });
        }

        if (action_id == touchAction)
        {
            return processAction(action, -1);
        }

        return false;
    }

    /**
     * Performs the touch action check on the button.
     *
     * @return `true` if input was captured by the node, `false` otherwise.
     */
    public function onTouch(action: ScriptOnInputActionTouch): Bool
    {
        if (!isEnabled() || disabled)
            return false;

        return processAction(action, action.id);
    }

    function processAction(action: TouchAction, touchId: Int): Bool
    {
        var captured: Bool = false;

        if (held && heldTouchId != touchId)
        {
            // Irrelevant touch, held from another touch id.
            return false;
        }

        if (pick(action.x, action.y))
        {
            if (action.pressed)
            {
                held = true;
                heldTouchId = touchId;

                captured = true;

                incrementScale(pressScaleIncrease);

                if (onPress != null)
                    onPress();
            }
            else if (held && action.released)
            {
                captured = true;

                cancelPress();

                if (onRelease != null)
                    onRelease();
            }
        }
        else
        {
            cancelPress();
        }

        return captured;
    }

    public function enableInteraction()
    {
        disabled = false;
    }

    public function disableInteraction()
    {
        disabled = true;
        cancelPress();
    }

    function cancelPress()
    {
        if (held)
        {
            incrementScale(-pressScaleIncrease);
            held = false;
            heldTouchId = -2;
        }
    }
}
