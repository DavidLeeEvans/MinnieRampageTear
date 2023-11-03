package dex.gui;

import defold.Msg;
import defold.Vmath;
import defold.types.Hash;
import defold.types.Vector3;
import dex.scripts.CameraController;
import dex.wrappers.GameObject;

using dex.util.extensions.Vector3Ex;


class ChatBubbleComponent extends ScriptComponent
{
    final guiId: Hash;
    final go: GameObject;

    var active: Bool;

    var previousScreenPosition: Vector3;

    public function new(guiId: Hash)
    {
        super();

        this.guiId = guiId;
        go = GameObject.self();

        active = false;
    }

    override function init()
    {
        previousScreenPosition = Vmath.vector3();
    }

    override function update(dt: Float)
    {
        super.update(dt);

        if (active)
        {
            var screenPosition: Vector3 = CameraController.worldToScreen(go.getPosition());

            if (!screenPosition.equals(previousScreenPosition))
            {
                Msg.post(guiId, ChatBubbleMessages.chat_bubble_update,
                    {
                        position: go.getPosition(),
                        object: GameObject.self()
                    });

                previousScreenPosition = screenPosition;
            }
        }
    }

    public inline function activate()
    {
        active = true;
    }

    public inline function deactivate()
    {
        active = false;
    }
}
