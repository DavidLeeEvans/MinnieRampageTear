package game;

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
	var speed:Vector3;
	var _active_button_a:Bool;
	var _active_button_b:Bool;
}

private typedef ButtonData = {
	var id:Hash;
	var x:Float;
	var y:Float;
	var pressed:Bool;
	var released:Bool;
	//
}

@:build(defold.support.MessageBuilder.build()) class ControlMessage {
	// var button_a:{data:ButtonData}; // WMD Weapon Menu
	// var button_b:{data:ButtonData}; // Fire Weapon !!
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
}

class Controls extends Script<ControlData> {
	override function init(self:ControlData) {
		self._active_button_a = true;
		self._active_button_b = true;
	}

	override function update(self:ControlData, dt:Float):Void {
		// final _pos = Go.get_world_position();
		// Defold.pprint("------------ y2k like testing -----------------------");
		// Defold.pprint(_pos);
		// Defold.pprint(self.speed);
		// final _test = Vmath.vector3(-10, 0, 0);
		// Go.set_position(_pos + _test * dt);
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
					Msg.post("/go#sack_menu", GuiSackMenuMessage.item_select_rotate); // TODO Testing for rotation Stopped here
					self._active_button_b = false;
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
				if (message.pressed) {
					Defold.pprint('Control.hx Press move x = ${message.x} y = ${message.y}');
					self.speed.x = message.x;
					self.speed.y = message.y;
				} else if (message.released) {
					Defold.pprint('Control.hx Released move x = ${message.x} y = ${message.y}');
					Defold.pprint(message.released);
					self.speed.x = 0;
					self.speed.y = 0;
				}
				/*
					case MinnieMessage.send_pos:
						Msg.post(sender, MinnieMessage.receive_pos, {pos: Go.get_position()});
					case MinnieMessage.send_rot:
						Msg.post(sender, MinnieMessage.receive_rot, {rot: Go.get_rotation()});
					case MinnieMessage.set_wmd:
						Go.set_parent(message.data, ".", true);
				 */
		}
	}

	override function final_(self:ControlData):Void {}

	override function on_reload(self:ControlData):Void {}
}
