package game.minnie;

import defold.Go.GoMessages;
import defold.Msg;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

private typedef SigmaData = {}

class Sigma extends Script<SigmaData> {
	override function init(self:SigmaData) {
	}

	override function update(self:SigmaData, dt:Float):Void {}

	override function on_message<T>(self:SigmaData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:SigmaData):Void {}

	override function on_reload(self:SigmaData):Void {}
}
