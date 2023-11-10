package dex.gui;

import defold.Vmath;

import defold.types.Vector3;

import dex.lib.orthographic.Camera;

import dex.wrappers.GameObject;

import defold.Msg;

import defold.types.Hash;

using dex.util.extensions.Vector3Ex;

class ChatBubbleComponent extends ScriptComponent {
	var guiId:Hash;
	var cameraId:Hash;
	var active:Bool;

	var previousScreenPosition:Vector3;

	public inline function new(guiId:Hash, cameraId:Hash) {
		super();

		this.guiId = guiId;
		this.cameraId = cameraId;
		active = false;
	}

	override function init() {
		previousScreenPosition = Vmath.vector3();
	}

	override function update(dt:Float) {
		super.update(dt);

		if (active) {
			var screenPosition:Vector3 = Camera.world_to_screen(cameraId, GameObject.self.getPosition());

			if (!screenPosition.equals(previousScreenPosition)) {
				Msg.post(guiId, ChatBubbleMessages.chat_bubble_update, {position: GameObject.self.getPosition(), object: GameObject.ownId()});

				previousScreenPosition = screenPosition;
			}
		}
	}

	public inline function activate() {
		active = true;
	}

	public inline function deactivate() {
		active = false;
	}
}
