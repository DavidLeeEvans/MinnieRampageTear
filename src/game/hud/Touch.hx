package game.hud;
import defold.Go.GoMessages;
import defold.Msg;
import Defold.hash;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef TouchData = {}

class Touch extends Script<TouchData> {
	override function init(self:TouchData) {
	Msg.post(".", GoMessages.acquire_input_focus);
}

	override function update(self:TouchData, dt:Float):Void {}

	override function on_message<T>(self:TouchData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function on_input(self:TouchData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("jump") || action_id == hash("touch")) {
			if (action.pressed)
				trace('jump(data)');
			else if (action.released)
				trace('abort_jump(data)');
		}

		return false;
	}

	override function final_(self:TouchData):Void {}

	override function on_reload(self:TouchData):Void {}
}
