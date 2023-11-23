package fx.particles;
import defold.Go.GoMessages;
import defold.Msg;
import Defold.hash;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef FootPrintPersistentData = {}

class FootPrintPersistent extends Script<FootPrintPersistentData> {
	override function init(self:FootPrintPersistentData) {
}

	override function update(self:FootPrintPersistentData, dt:Float):Void {}
	override function on_message<T>(self:FootPrintPersistentData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:FootPrintPersistentData):Void {}

	override function on_reload(self:FootPrintPersistentData):Void {}
}
