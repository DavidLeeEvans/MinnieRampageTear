package fx.particles;

import defold.Go;
import defold.Particlefx;
import defold.Timer;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;
import lua.Math;
import lua.lib.luasocket.Socket;

@:build(defold.support.HashBuilder.build()) class DeathHash {
	// var sprite0;
	// var sprite1;
	// var sprite2;
	// var sprite3;
	// var sprite4;
	// var sprite5;
	// var sprite6;
	// var sprite7;
	//
}

@:build(defold.support.HashBuilder.build()) class AnimationDeath {
	var blong_bone;
	var brib_cage;
	var bskull;
	var bsmall_bone;
}

private typedef DeathData = {
	@property(4.0) var remove:Float;
}

final object_array = [
	"long_bone0", "long_bone1", "long_bone2", "long_bone3", "long_bone4", "small_bone0", "small_bone1", "small_bone2", "small_bone3", "small_bone4",
	"rib_cage", "skull"
];

final blood_object_array = [
	"blong_bone0", "blong_bone1", "blong_bone2", "blong_bone3", "blong_bone4", "bsmall_bone0", "bsmall_bone1", "bsmall_bone2", "bsmall_bone3", "bsmall_bone4",
	"brib_cage", "bskull"
];

class Death extends Script<DeathData> {
	override function init(self:DeathData) {
		lua.Math.randomseed(1000000 * (Socket.gettime() % 1));
		// Particlefx.play("#blood_spurt");
		final _pso:ParticleFxStopOptions = {clear: true};
		// Particlefx.stop("#blood_spurt", _pso);

		for (_o in blood_object_array) {
			// lua.Math.randomseed(1000000 * (Socket.gettime() % 1));
			Go.animate('/death/' + _o, "position.x", GoPlayback.PLAYBACK_ONCE_FORWARD, Math.random() * 200, GoEasing.EASING_LINEAR, .3, 0,
				(_, _, _) -> Defold.pprint("X Finished"));
			Go.animate('/death/' + _o, "position.y", GoPlayback.PLAYBACK_ONCE_FORWARD, Math.random() * 200, GoEasing.EASING_LINEAR, .3, 0,
				(_, _, _) -> Defold.pprint("Y Finished"));
			Go.animate('/death/' + _o + '#sprite', "tint.w", GoPlayback.PLAYBACK_LOOP_PINGPONG, 0, GoEasing.EASING_INOUTSINE, .2, 2);
		}

		Timer.delay(self.remove, false, (_, _, _) -> Go.delete()); // TODO delete th object flicker
	}

	override function update(self:DeathData, dt:Float):Void {}

	override function on_message<T>(self:DeathData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:DeathData):Void {}

	override function on_reload(self:DeathData):Void {}
}
