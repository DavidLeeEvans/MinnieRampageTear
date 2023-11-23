package fx.particles;
import defold.Go.GoMessages;
import defold.Msg;
import Defold.hash;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef BloodSplatterData = {}

class BloodSplatter extends Script<BloodSplatterData> {
	override function init(self:BloodSplatterData) {
}

	override function update(self:BloodSplatterData, dt:Float):Void {}
	override function on_message<T>(self:BloodSplatterData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:BloodSplatterData):Void {}

	override function on_reload(self:TBloodSplatterData):Void {}
}
