package game.hud;

import Defold.hash;
import defold.Go;
import defold.Msg;
import defold.Physics.PhysicsMessages;
import defold.Vmath;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;
import dex.lib.orthographic.Camera;

private typedef TouchData = {
	@property var target:Hash;
	@property(11.1) var length:Float;
	@property var top_pt:Vector3;
	@property var bottom_pt:Vector3;
	var _working:Bool;
}

class Touch extends Script<TouchData> {
	override function init(self:TouchData) {
		Msg.post(".", GoMessages.acquire_input_focus);
		Go.set_position(Vmath.vector3(-100, -100, 0));
		self._working = false;
	}

	override function update(self:TouchData, dt:Float):Void {
		if (self._working) {
			Defold.pprint("------ update ------");
			Defold.pprint(Go.get_world_position());
			Go.set_position(Go.get_world_position(), self.target);
		}
	}

	override function on_message<T>(self:TouchData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case PhysicsMessages.collision_response:
				Defold.pprint("----- Touch Collision -----");
				Defold.pprint(message);
				self._working = true;
		}
	}

	override function on_input(self:TouchData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("touch")) {
			if (self._working) {
				trace('Touch Press');
				final _v = Vmath.vector3(action.x, action.y, 0);
				final _pos = Camera.screen_to_world(hash("/camera"), _v);
				Go.set_position(_pos, ".");
			}
			if (action.released) {
				trace('Touch Released');
				Go.set_position(Vmath.vector3(-100, -100, 0));
				self._working = false;
			}
			if (action.pressed) {
				final _v = Vmath.vector3(action.x, action.y, 0);
				final _pos = Camera.screen_to_world(hash("/camera"), _v);
				Go.set_position(_pos, ".");
			}
		}

		return false;
	}

	override function final_(self:TouchData):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}

	override function on_reload(self:TouchData):Void {}
}
