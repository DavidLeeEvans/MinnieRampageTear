package game;

import defold.Go;
import defold.Msg;
import defold.Vmath;
import defold.support.Script;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;
import hud.SackMenu.SackMenuMessage;

private typedef ControlData = {
	var x:Float;
	var y:Float;
	var released:Bool;
	var pressed:Bool;
	var id:Hash;
}

@:build(defold.support.MessageBuilder.build()) class ControlMessage {
	var button_a:{release:Bool}; // WMD Weapon Menu
	var button_b:{release:Bool}; // Fire Weapon !!
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

private typedef MinnieData = {
	@property var speed:Vector3;
}

class Minnie extends Script<MinnieData> {
	override function init(self:MinnieData) {
		self.speed = Vmath.vector3(0, 0, 0);
	}

	override function update(self:MinnieData, dt:Float):Void {
		final _pos = Go.get_world_position();
		Defold.pprint("-----------------------------------");
		Defold.pprint(_pos);
		Defold.pprint(self.speed);
		final _test = Vmath.vector3(-10, 0, 0);
		Go.set_position(_pos + _test * dt);
	}

	override function on_message<T>(self:MinnieData, message_id:Message<T>, message:T, sender:Url):Void {
		// Defold.pprint('UNIVERSAL id = $message_id  msg = $message');
		switch (message_id) {
			case ControlMessage.button_a:
				Defold.pprint('Minnie.hx Button A pressed $message');
				Msg.post("/go#sack_menu", SackMenuMessage.on_off_screen, {data: true});
			case ControlMessage.button_b:
				Defold.pprint('Minnie.hx Button B pressed $message');
				Msg.post("/go#sack_menu", SackMenuMessage.item_select_rotate);
			case ControlMessage.analog_released:
				Defold.pprint('Minnie.hx analog_released $message');
			case ControlMessage.analog_pressed:
				Defold.pprint('Minnie.hx analog_pressed $message.');
			case ControlMessage.analog_moved:
				Defold.pprint('Minnie.hx  analog_moved $message');
			// self.speed.x = message.x * 200;
			// self.speed.y = message.y * 200;
			case ControlMessage.move:
				if (message.pressed) {
					Defold.pprint('Minnie.hx Press move x = ${message.x} y = ${message.y}');
					self.speed.x = message.x;
					self.speed.y = message.y;
				} else if (message.released) {
					Defold.pprint('Minnie.hx Released move x = ${message.x} y = ${message.y}');
					Defold.pprint(message.released);
					self.speed.x = 0;
					self.speed.y = 0;
				}
		}
	}

	override function final_(self:MinnieData):Void {}

	override function on_reload(self:MinnieData):Void {}
}
