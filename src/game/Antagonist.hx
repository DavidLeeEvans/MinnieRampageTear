package game;

import Defold.hash;
import defold.Go.GoMessages;
import defold.Msg;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef AntagonistData = {}

class Antagonist extends Script<AntagonistData> {
	override function init(self:AntagonistData) {}

	override function update(self:AntagonistData, dt:Float):Void {}

	override function on_message<T>(self:AntagonistData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:AntagonistData):Void {}

	override function on_reload(self:AntagonistData):Void {}
}
