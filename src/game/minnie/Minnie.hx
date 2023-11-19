package game.minnie;

import defold.Go;
import defold.Msg;
import defold.Vmath;
import defold.support.Script;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Quaternion;
import defold.types.Url;
import defold.types.Vector3;

@:build(defold.support.HashBuilder.build()) class MinnieGroupHash {
	var enemy;
	var enemy_weapon;
	var fixture; // TODO fixture collision
	var portal; // TODO portal
}

@:build(defold.support.HashBuilder.build()) class MinnieParticleHash {
	// var /entity#blood_right_leg
	var partical_blood_right_leg;
	var partical_blood_left_leg;
	var partical_blood_right_arm;
	var partical_blood_left_arm;
}

private typedef MinnieData = {
	@property var speed:Vector3;
	// var _active_button_a:Bool;
	// 	var _active_button_b:Bool;
}

@:build(defold.support.MessageBuilder.build()) class MinnieMessage {
	var send_pos;
	var send_rot;
	var receive_pos:{pos:Vector3};
	var receive_rot:{rot:Quaternion};
	var set_wmd:{data:Hash}; // TODO research this dle
}

@:build(defold.support.HashBuilder.build()) class MinnieAnimationHash {
	var Attacking;
	var Walking;
	var Running;
	var Resting;
	var Jumping;
	var Ducking;
	var Throwing;
	var Grasp;
	var Stunned;
	var Teleporting;
	var Hurt;
	var Dying;
	var Reunion;
}

enum abstract MinnieState(Int) {
	var Attacking = 0;
	var Walking;
	var Running;
	var Resting;
	var Jumping;
	var Ducking;
	var Throwing;
	var Grasp;
	var Stunned;
	var Teleporting;
	var Hurt;
	var Dying;
	var Reunion;
}

class Minnie extends Script<MinnieData> {
	override function init(self:MinnieData) {
		self.speed = Vmath.vector3(0, 0, 0);
	}

	override function update(self:MinnieData, dt:Float):Void {
		// final _pos = Go.get_world_position();
		// Defold.pprint("------------ y2k like testing -----------------------");
		// Defold.pprint(_pos);
		// Defold.pprint(self.speed);
		// final _test = Vmath.vector3(-10, 0, 0);
		// Go.set_position(_pos + _test * dt);
	}

	override function on_message<T>(self:MinnieData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case MinnieMessage.send_pos:
				Msg.post(sender, MinnieMessage.receive_pos, {pos: Go.get_position()});
			case MinnieMessage.send_rot:
				Msg.post(sender, MinnieMessage.receive_rot, {rot: Go.get_rotation()});
			case MinnieMessage.set_wmd:
				Go.set_parent(message.data, ".", true);
		}
	}

	override function final_(self:MinnieData):Void {}

	override function on_reload(self:MinnieData):Void {}
}
