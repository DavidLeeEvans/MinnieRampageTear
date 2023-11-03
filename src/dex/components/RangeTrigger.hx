package dex.components;

import defold.Msg;
import defold.Physics.PhysicsMessageTriggerResponse;
import defold.Physics.PhysicsMessages;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import dex.systems.Time;
import dex.wrappers.GameObject;

using dex.util.extensions.ArrayEx;

/**
 * Component to be attached to an object with a trigger collider.
 *
 * This component keeps track of all other objects of the given groups that are
 * currently overlapping with the collider.
 */
class RangeTrigger extends ScriptComponent
{
    public var onEnter: (object: GameObject) -> Void;
    public var onExit: (object: GameObject) -> Void;

    var objectsInRange: Array<GameObject>;
    final ownGroup: Null<Hash>;
    final targetGroups: Array<Hash>;

    /**
     * Initialize a new trigger collider.
     *
     * @param ownGroup if `null`, all trigger interactions on this object will be tracked by this component;
     *                 if a collision group is passed then only triggers from the collider with this group will be tracked
     * @param targetGroups if `null`, all trigger interactions on this object will be tracked by this component;
     *                     if a list of collision groups is passed, then only trigger interactions with these groups will be tracked
     */
    public function new(?ownGroup: Hash, ?targetGroups: Array<Hash>)
    {
        super();

        this.ownGroup = ownGroup;
        this.targetGroups = targetGroups;
        onEnter = null;
        onExit = null;
    }

    override function init()
    {
        objectsInRange = [ ];
    }

    override function update(dt: Float)
    {
        if (Time.everyFrames(300))
        {
            // cleanup the list with some interval
            objectsInRange = objectsInRange.filter(obj -> obj.exists());
        }
    }

    override function onMessage<TMessage>(messageId: Message<TMessage>, message: TMessage, sender: Url)
    {
        switch messageId
        {
            case PhysicsMessages.trigger_response:
                {
                    var triggerMsg: PhysicsMessageTriggerResponse = cast message;
                    if (ownGroup != null && triggerMsg.own_group != ownGroup)
                    {
                        // message is not for this component
                        return;
                    }

                    if (targetGroups != null && !targetGroups.contains(triggerMsg.other_group))
                    {
                        // object that entered the collider is not tracked by this component
                        return;
                    }

                    // handle object
                    if (triggerMsg.enter)
                    {
                        objectsInRange.push(triggerMsg.other_id);

                        if (onEnter != null)
                        {
                            onEnter(triggerMsg.other_id);
                        }
                    }
                    else
                    {
                        objectsInRange.remove(triggerMsg.other_id);

                        if (onExit != null)
                        {
                            onExit(triggerMsg.other_id);
                        }
                    }
                }
        }
    }

    /**
     * Sends a message to all existing objects currently in the trigger range.
     */
    public inline function broadcast<TMessage>(messageId: Message<TMessage>, ?message: TMessage)
    {
        for (obj in objectsInRange)
        {
            if (obj.exists())
            {
                Msg.post(obj, messageId, message);
            }
        }
    }

    /**
     * Loop over all existing objects currently in the trigger range.
     */
    public inline function forEach(fn: GameObject->Void)
    {
        for (obj in objectsInRange)
        {
            if (obj.exists())
            {
                fn(obj);
            }
        }
    }
}
