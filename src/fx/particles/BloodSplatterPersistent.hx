package fx.particles;
import defold.Go.GoMessages;
import defold.Msg;
import Defold.hash;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef TData = {}

class Entity extends Script<TData> {
	override function init(self:TData) {
}

	override function update(self:TData, dt:Float):Void {}
	override function on_message<T>(self:TData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:TData):Void {}

	override function on_reload(self:TData):Void {}
}
