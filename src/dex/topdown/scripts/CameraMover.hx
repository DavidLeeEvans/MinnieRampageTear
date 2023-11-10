package dex.topdown.scripts;

import defold.Vmath;

import defold.types.Vector3;

import dex.wrappers.GameObject;

import defold.types.Hash;

import defold.support.ScriptOnInputAction;
import defold.support.Script;

typedef CameraMoverProperties = {
	@property("left") var input_left:Hash;
	@property("right") var input_right:Hash;
	@property("up") var input_up:Hash;
	@property("down") var input_down:Hash;

	@property(200) var speed:Float;
	var input:Vector3;
}

class CameraMover extends Script<CameraMoverProperties> {
	static final go:GameObject = GameObject.self;

	override function init(self:CameraMoverProperties) {
		self.input = Vmath.vector3();

		go.acquireInputFocus();
	}

	override function update(self:CameraMoverProperties, dt:Float) {
		go.move(self.input, self.speed * dt);
	}

	override function on_input(self:CameraMoverProperties, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == self.input_left) {
			if (action.pressed || self.input.x == 0) {
				self.input.x = -1;
			} else if (action.released) {
				self.input.x = 0;
			}
		} else if (action_id == self.input_right) {
			if (action.pressed || self.input.x == 0) {
				self.input.x = 1;
			} else if (action.released) {
				self.input.x = 0;
			}
		} else if (action_id == self.input_up) {
			if (action.pressed || self.input.y == 0) {
				self.input.y = 1;
			} else if (action.released) {
				self.input.y = 0;
			}
		} else if (action_id == self.input_down) {
			if (action.pressed || self.input.y == 0) {
				self.input.y = -1;
			} else if (action.released) {
				self.input.y = 0;
			}
		}

		return false;
	}
}
