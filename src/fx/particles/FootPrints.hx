package fx.particles;
import defold.Go.GoMessages;
import defold.Msg;
import Defold.hash;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef FootPrintData = {}

class FootPrint extends Script<FootPrintData> {
	override function init(self:FootPrintData) {
}

	override function update(self:FootPrintData, dt:Float):Void {}
	override function on_message<T>(self:FootPrintData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:FootPrintData):Void {}

	override function on_reload(self:FootPrintData):Void {}
}
