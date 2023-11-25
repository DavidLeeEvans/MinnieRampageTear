package game.minnie;

import defold.Go;
import defold.Msg;
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
	@property(2.0) var speed:Float;
	@property var state:Int;
}

@:build(defold.support.MessageBuilder.build()) class MinnieMessage {
	var send_pos;
	var send_rot;
	var receive_pos:{pos:Vector3};
	var receive_rot:{rot:Quaternion};
	var set_wmd:{data:Hash}; // TODO research this dle
	//
	var set_state:{state:Int};
}

enum abstract MinnieState(Int) {
	var Attacking = 0;
	var Walking;
	var Running;
	var Resting;
	var Jumping;
	var JumpLanding;
	var Ducking;
	var Throwing;
	var Grasp;
	var Stunned;
	var Teleporting;
	var Hurt;
	var Dying;
	var Reunion;
	var Spawning;
}

class Minnie extends Script<MinnieData> {
	override function init(self:MinnieData) {}

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
			case MinnieMessage.set_state:
				self.state = message.state;
				switch (message.state) {
					case 0:
					// TODO Attack
					case 1:
					// TODO Walking
					case 2:
					// Running
					case 3:
					//
					case 4:
					case 5:
					case 6:
					case 7:
					case 8:
					case 9:
					case 10:
					case 11:
					case 12:
					case 13:
					case 14:
					case 15:
				}
		}
	}

	override function final_(self:MinnieData):Void {}

	override function on_reload(self:MinnieData):Void {}
}
