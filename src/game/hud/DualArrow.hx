package game.hud;

import Defold.hash;
import defold.Go.GoMessages;
import defold.Msg;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef DualArrowData = {}

@:build(defold.support.MessageBuilder.build()) class DualArrowMessage {
	var press_up_down:{result:Bool};
	var on_off:{data:Bool};
}

class DualArrow extends Script<DualArrowData> {
	override function init(self:DualArrowData) {
		Msg.post(".", GoMessages.acquire_input_focus);
	}

	override function update(self:DualArrowData, dt:Float):Void {}

	override function on_message<T>(self:DualArrowData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case DualArrowMessage.press_up_down:
			case DualArrowMessage.on_off:
		}
	}

	override function on_input(self:DualArrowData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("jump") || action_id == hash("touch")) {
			if (action.pressed)
				trace('jump(data)');
			else if (action.released)
				trace('abort_jump(data)');
		}

		return false;
	}

	override function final_(self:DualArrowData):Void {}

	override function on_reload(self:DualArrowData):Void {}
}
