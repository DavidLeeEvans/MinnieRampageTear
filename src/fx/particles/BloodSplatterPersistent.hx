package fx.particles;
import defold.Go.GoMessages;
import defold.Msg;
import Defold.hash;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef BloodSplatterPersistentData = {}

class BloodSplatterPersistent extends Script<BloodSplatterPersistentData> {
	override function init(self:BloodSplatterPersistentData) {
}

	override function update(self:BloodSplatterPersistentData, dt:Float):Void {}
	override function on_message<T>(self:BloodSplatterPersistentData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:BloodSplatterPersistentData):Void {}

	override function on_reload(self:BloodSplatterPersistentData):Void {}
}
