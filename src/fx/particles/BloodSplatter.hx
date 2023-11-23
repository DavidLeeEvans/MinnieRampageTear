package fx.particles;

import Defold.hash;
import defold.Go.GoMessages;
import defold.Msg;
import defold.Particlefx;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef BloodSplatterData = {}

class BloodSplatter extends Script<BloodSplatterData> {
	override function init(self:BloodSplatterData) {
		// TODO testing start the effect component "particles" in the current game object
		Particlefx.play("#particles");
		// TODO testing stop the effect component "particles" in the current game object
		final _pso:ParticleFxStopOptions = {clear: true};
		Particlefx.stop("#particles", _pso);
	}

	override function update(self:BloodSplatterData, dt:Float):Void {}

	override function on_message<T>(self:BloodSplatterData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:BloodSplatterData):Void {}

	override function on_reload(self:BloodSplatterData):Void {}
}
