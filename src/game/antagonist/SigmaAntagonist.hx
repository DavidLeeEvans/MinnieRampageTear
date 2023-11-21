package game.antagonist;

import defold.Go.GoMessages;
import defold.Msg;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

private typedef SigmaAntagonistData = {}

class Sigma extends Script<SigmaAntagonistData> {
	override function init(self:SigmaAntagonistData) {
	}

	override function update(self:SigmaAntagonistData, dt:Float):Void {}

	override function on_message<T>(self:SigmaAntagonistData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:SigmaAntagonistData):Void {}

	override function on_reload(self:SigmaAntagonistData):Void {}
}
