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

private typedef DeathData = {}

class Death extends Script<DeathData> {
	override function init(self:DeathData) {
		// TODO testing start the effect component "particles" in the current game object
		Particlefx.play("#particles");
		// TODO testing stop the effect component "particles" in the current game object
		final _pso:ParticleFxStopOptions = {clear: true};
		Particlefx.stop("#particles", _pso);
	}

	override function update(self:DeathData, dt:Float):Void {}

	override function on_message<T>(self:DeathData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:DeathData):Void {}

	override function on_reload(self:DeathData):Void {}
}
