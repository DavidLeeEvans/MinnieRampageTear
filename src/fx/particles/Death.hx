package fx.particles;

import defold.Go;
import defold.Image;
import defold.Particlefx;
import defold.Sprite;
import defold.Timer;
import defold.Vmath;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;
import lua.Math;
import lua.lib.luasocket.Socket;

@:build(defold.support.HashBuilder.build()) class DeathHash {
	var sprite0;
	var sprite1;
	var sprite2;
	var sprite3;
	var sprite4;
	var sprite5;
	var sprite6;
	var sprite7;
	//
}

@:build(defold.support.HashBuilder.build()) class AnimationDeath {
	var blong_bone;
	var brib_cage;
	var bskull;
	var bsmall_bone;
}

private typedef DeathData = {
	@property(2.0) var remove:Float;
}

class Death extends Script<DeathData> {
	override function init(self:DeathData) {
		lua.Math.randomseed(1000000 * (Socket.gettime() % 1));
		Particlefx.play("#blood_spurt");
		final _pso:ParticleFxStopOptions = {clear: true};
		Particlefx.stop("#blood_spurt", _pso);
		Sprite.play_flipbook("sprite0", AnimationDeath.bskull);
		Sprite.play_flipbook(DeathHash.sprite1, AnimationDeath.brib_cage);
		var _r = Math.random();
		if (_r > .5)
			Sprite.play_flipbook(DeathHash.sprite2, AnimationDeath.blong_bone);
		else
			Sprite.play_flipbook(DeathHash.sprite2, AnimationDeath.bsmall_bone);
		_r = Math.random();
		if (_r > .5)
			Sprite.play_flipbook(DeathHash.sprite3, AnimationDeath.blong_bone);
		else
			Sprite.play_flipbook(DeathHash.sprite3, AnimationDeath.bsmall_bone);
		_r = Math.random();
		if (_r > .5)
			Sprite.play_flipbook(DeathHash.sprite4, AnimationDeath.blong_bone);
		else
			Sprite.play_flipbook(DeathHash.sprite4, AnimationDeath.bsmall_bone);
		_r = Math.random();
		if (_r > .5)
			Sprite.play_flipbook(DeathHash.sprite5, AnimationDeath.blong_bone);
		else
			Sprite.play_flipbook(DeathHash.sprite5, AnimationDeath.bsmall_bone);
		_r = Math.random();
		if (_r > .5)
			Sprite.play_flipbook(DeathHash.sprite6, AnimationDeath.blong_bone);
		else
			Sprite.play_flipbook(DeathHash.sprite6, AnimationDeath.bsmall_bone);
		_r = Math.random();
		if (_r > .5)
			Sprite.play_flipbook(DeathHash.sprite7, AnimationDeath.blong_bone);
		else
			Sprite.play_flipbook(DeathHash.sprite7, AnimationDeath.bsmall_bone);
		_r = Math.random();
		//
		Go.animate(DeathHash.sprite0, "property.xyz", GoPlayback.PLAYBACK_ONCE_FORWARD, Vmath.vector3(10, 10, .1), GoEasing.EASING_LINEAR, 2);
		Timer.delay(self.remove, false, (_, _, _) -> Go.delete()); // TODO should blink
	}

	override function update(self:DeathData, dt:Float):Void {}

	override function on_message<T>(self:DeathData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:DeathData):Void {}

	override function on_reload(self:DeathData):Void {}
}
