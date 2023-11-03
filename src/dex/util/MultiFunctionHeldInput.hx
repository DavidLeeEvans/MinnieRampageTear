package dex.util;

import defold.types.Hash;
import defold.support.ScriptOnInputAction;

/**
 * Simple utility component, for controlling a multi-purpose input with the following logic:
 * - An input `Hash` is mapped to multiple functions via an enum.
 * - When the action is pressed, one function is determined using the given `determineFunction` callback.
 * - While the action is held, the function determined will be continuously triggered as long as `determineFunction` returns the same function.
 *
 * ```haxe
 * var handler = new MultiFunctionHeldInput<Myfunctions>(hash("action"), () -> nearEnemy ? Attack : Jump);
 *
 * handler.onInput(action_id, action);
 *
 * switch handler.trigger {
 *     case Myfunctions.Jump:
 *     case Myfunctions.Attack:
 *     case null: // do nothing
 * }
 * ```
 *
 * Use case from player perspective while holding down the input action:
 *
 * 1. Picks up item.
 * 2. Holds down action button to pick up more items that are nearby.
 * 3. While walking, enters in interaction range of a tree.
 *     - In this case, the player must not start chopping the tree while holding down the button that he previously used for picking up items.
 * 4. Walking further, enters in interaction range of another item.
 * 5. Picks up the item.
 */
class MultiFunctionHeldInput<T: EnumValue> extends ScriptComponent
{
    /**
     * The currently triggered function.
     * Will be `null` when no function is currently triggered.
     */
    public var trigger(default, null): T;

    /**
     * This property will be `true` while the input action is held,
     * on the frame when the `trigger` property transitions from `null` to a value.
     */
    public var justTriggered(default, null): Bool;

    var selectedFunction: T;

    var actionId: Hash;
    var determineFunction: Void->T;

    /**
     * Initializes a new multi-function input wrapper.
     *
     * @param actionId the hash of the action the input is mapped to
     * @param determineFunction a callback function, which will be called once on every frame when the
     * mapped input action is held, and should return the appropriate function
     */
    public function new(actionId: Hash, determineFunction: Void->T)
    {
        super();

        trigger = null;
        justTriggered = false;

        selectedFunction = null;

        this.actionId = actionId;
        this.determineFunction = determineFunction;
    }

    override function onBeforeInput()
    {
        trigger = null;
        justTriggered = false;
    }

    override function onInput(actionId: Hash, action: ScriptOnInputAction): Bool
    {
        if (actionId != this.actionId)
        {
            // irrelevant input
            return false;
        }

        /**
         * Set selected function on press, and clear it on release.
         */
        var func: T = determineFunction();

        if (selectedFunction == null)
        {
            selectedFunction = func;
        }
        else if (action.released)
        {
            selectedFunction = null;
        }

        /**
         * Propagate the selected function to the trigger property,
         * only while the action is held and the determined function is the same as the one selected.
         */
        if (selectedFunction != null && func == selectedFunction)
        {
            if (trigger == null)
            {
                justTriggered = true;
            }

            trigger = selectedFunction;
        }
        else
        {
            trigger = null;
        }

        // always consume the input while the input is held
        return true;
    }
}
