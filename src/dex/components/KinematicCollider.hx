package dex.components;

import defold.Physics.PhysicsMessages;
import defold.types.Message;
import defold.types.Url;
import dex.util.types.Vector2;
import dex.wrappers.GameObject;

/**
 * A collider which uses a kinematic collider on the object to separate it from other objects.
 * This component will handle all `contact_point_response` that are received, so the collision groups
 * should be configured only on the collider itself.
 */
class KinematicCollider extends ScriptComponent
{
    var go: GameObject;
    var correction: Vector2;

    public function new()
    {
        super();
    }

    override function init()
    {
        go = GameObject.self();
        correction = Vector2.zero;
    }

    override function update(dt: Float)
    {
        correction.x = 0;
        correction.y = 0;
    }

    override function onMessage<TMessage>(messageId: Message<TMessage>, message: TMessage, sender: Url)
    {
        switch messageId
        {
            case PhysicsMessages.contact_point_response:
                {
                    if (message.distance <= 0)
                    {
                        // ignore this message, this collision has already been resolved this frame
                        return;
                    }

                    // project the already-accumulated correction on the current separation vector
                    var proj: Float = correction.projectOn(message.normal * message.distance);
                    if (proj >= 1.0)
                    {
                        // projection overshoots
                        return;
                    }

                    // compute compensation vector and add it to the total correction
                    var comp: Vector2 = (message.distance - message.distance * proj) * message.normal;
                    correction.add(comp);

                    // move the object by the compensation vector
                    var pos: Vector2 = go.getPosition();
                    pos.add(comp);
                    go.setPosition(pos);
                }
        }
    }
}
