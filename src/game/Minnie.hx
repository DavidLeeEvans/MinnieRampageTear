package game;

import defold.Vmath;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;

@:build(defold.support.MessageBuilder.build()) class PlayerMessage {
	var button_a:{release:Bool}; // WMD Weapon Menu
	var button_b:{release:Bool}; // Fire Weapon !!
	var move:Vector3; // Assembly Move Vehicle
}

private typedef MinnieData = {
	var speed:Vector3;
}

class Minnie extends Script<MinnieData> {
	override function init(self:MinnieData) {
		self.speed = Vmath.vector3(0, 0, 0);
	}

	override function update(self:MinnieData, dt:Float):Void {}

	override function on_message<T>(self:MinnieData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case PlayerMessage.button_a:
				Defold.pprint("Button A pressed");
			case PlayerMessage.button_b:
				Defold.pprint("Button B pressed");
			case PlayerMessage.move:
		}
	}

	override function final_(self:MinnieData):Void {}

	override function on_reload(self:MinnieData):Void {}
}
