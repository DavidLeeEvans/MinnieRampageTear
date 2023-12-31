package game;

import defold.Go;
import defold.Msg;
import defold.Vmath;
import defold.support.Script;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;
import hud.GuiSackMenu.GuiSackMenuMessage;

private typedef ControlData = {
	var x:Float;
	var y:Float;
	var released:Bool;
	var pressed:Bool;
	var id:Hash;
	//
	var wmd_right_left:Bool;
	//
	var _active_button_a:Bool;
	var _active_button_b:Bool;
	var _run_update:Bool;
	var _vector_move:Vector3;
}

private typedef ButtonData = {
	var id:Hash;
	var x:Float;
	var y:Float;
	var pressed:Bool;
	var released:Bool;
}

@:build(defold.support.MessageBuilder.build()) class ControlMessage {
	var button_a:ButtonData; // WMD Weapon Menu
	var button_b:ButtonData; // Fire Weapon !!
	//
	var move:ControlData; // Assembly Move Vehicle

	var analog_pressed:Bool;
	var analog_released:Bool;
	var analog_moved:Vector3;
	var analog_left:Bool;
	var analog_right:Bool;
	var analog_up:Bool;
	var analog_down:Bool;
	var analog:ButtonData;
}

class Controls extends Script<ControlData> {
	override function init(self:ControlData) {
		self.wmd_right_left = false;
		self._active_button_a = true;
		self._active_button_b = true;
		self._run_update = false;
		self._vector_move = Vmath.vector3(0, 0, 0);
	}

	override function update(self:ControlData, dt:Float):Void {
		if (self._run_update) {
			final _p = Go.get_world_position();
			Go.set_position(self._vector_move + _p);
		}
	}

	override function on_message<T>(self:ControlData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case ControlMessage.button_a:
				if (message.pressed && self._active_button_a) {
					Defold.pprint('Control.hx Button A  released $message');
					Msg.post("/go#sack_menu", GuiSackMenuMessage.on_off_screen, {data: true});
					// TODO Testing WMD launching Button A
					self._active_button_a = false;
				}
				if (message.released)
					self._active_button_a = true;

			case ControlMessage.button_b:
				if (message.pressed && self._active_button_b) {
					Defold.pprint('Control.hx Button B press $message');
					if (self.wmd_right_left) {
						Msg.post("/go#sack_menu", GuiSackMenuMessage.item_select_rotate_right); // TODO Testing for rotation Stopped here
						self._active_button_b = false;
					} else {
						Msg.post("/go#sack_menu", GuiSackMenuMessage.item_select_rotate_left); // TODO Testing for rotation Stopped here
						self._active_button_b = false;
					}
					self.wmd_right_left = !self.wmd_right_left;
				}
				if (message.released)
					self._active_button_b = true;

			case ControlMessage.analog_released:
				Defold.pprint('Control.hx analog_released $message');
			case ControlMessage.analog_pressed:
				Defold.pprint('Control.hx analog_pressed $message.');
			case ControlMessage.analog_moved:
				Defold.pprint('Control.hx  analog_moved $message');
			case ControlMessage.move:
				Defold.pprint("=======================================");
				Defold.pprint(message);
				Defold.pprint("=======================================");
				if (message.x > .5) {
					self._vector_move.x = Go.get("#Minnie", "speed");
					self._run_update = true;
				}
				if (message.x < -.5) {
					self._vector_move.x = -Go.get("#Minnie", "speed");
					self._run_update = true;
				}
				if (message.y > .5) {
					self._vector_move.y = Go.get("#Minnie", "speed");
					self._run_update = true;
				}
				if (message.y < -.5) {
					self._vector_move.y = -Go.get("#Minnie", "speed");
					self._run_update = true;
				}
				if (message.x == 0)
					self._vector_move.x = 0;

				if (message.released) {
					Defold.pprint('Control.hx Released move x = ${message.x} y = ${message.y}');
					Defold.pprint(message.released);
					self._run_update = false;
					self._vector_move.x = 0;
					self._vector_move.y = 0;
				}
				if (self._run_update) {
					var _original_rot = Go.get_world_rotation();
					_original_rot.x = message.x;
					_original_rot.y = message.y;
					final _new_angle = Vmath.quat_rotation_z(Math.atan2(message.x, message.y));
					Go.set_rotation(_new_angle);

					//
					// local crosshair_world = go.get_world_position("crosshair")
					// local player_world = go.get_world_position()
					// local angle = math.atan2(player_world.x - crosshair_world.x, crosshair_world.y - player_world.y)
					// local rotation = vmath.quat_rotation_z(angle)
					// go.set_rotation(rotation
				}
		}
	}

	override function final_(self:ControlData):Void {}

	override function on_reload(self:ControlData):Void {}
}
