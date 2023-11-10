package game;

import Defold.hash;
import defold.Go.GoMessages;
import defold.Msg;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef MinnieData = {}

class Minnie extends Script<MinnieData> {
	override function init(self:MinnieData) {}

	override function update(self:MinnieData, dt:Float):Void {}

	override function on_message<T>(self:MinnieData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:MinnieData):Void {}

	override function on_reload(self:MinnieData):Void {}
}
