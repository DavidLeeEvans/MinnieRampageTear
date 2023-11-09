package game.hud;

import Defold.hash;
import defold.Go.GoMessages;
import defold.Msg;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;

@:build(defold.support.HashBuilder.build()) class DualArrowHash {
	var i0;
	var i1;
	var i2;
	var i3;
	var i4;
	var i5;
	var i6;
}

private typedef DualArrowData = {
	var start:Vector3;
	var end:Vector3;
}

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
			// if(message.result)
			case DualArrowMessage.on_off:
				if (message.data) {
					Msg.post(".", GoMessages.acquire_input_focus);
					Msg.post(DualArrowHash.i0, GoMessages.disable);
				} else {
					Msg.post(".", GoMessages.release_input_focus);
				}
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
