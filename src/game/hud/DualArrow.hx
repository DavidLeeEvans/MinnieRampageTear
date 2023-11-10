package game.hud;

import Defold.hash;
import defold.Go;
import defold.Msg;
import defold.Vmath;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;
import dex.lib.orthographic.Camera;

@:build(defold.support.HashBuilder.build()) class DualArrowHash {
	var i0;
	var i1;
	var i2;
	var i3;
	var i4;
	var i5;
	var i6;
	var prompt;
}

private typedef DualArrowData = {
	var start:Vector3;
	var end:Vector3;
	@property(11.1) var length:Float;
	@property var target:Hash;
	@property var top_pt:Vector3;
	@property var bottom_pt:Vector3;
}

@:build(defold.support.MessageBuilder.build()) class DualArrowMessage {
	var press_up_down:{result:Bool};
	var on_off:{data:Bool};
}

class DualArrow extends Script<DualArrowData> {
	override function init(self:DualArrowData) {
		Msg.post(".", GoMessages.acquire_input_focus);
	}

	override function update(self:DualArrowData, dt:Float):Void {
		// var pos = Camera.world_to_screen(Defold.hash("/camera"), Go.get_position("/Minnie/dual_arrow"));
		// var test:RenderMessageDrawLine = {
		// 	start_point: Vmath.vector3(pos.x, pos.y, 0),
		// 	end_point: Vmath.vector3(pos.x + self.top_pt.x, pos.y + self.top_pt.y, 0),
		// 	color: Vmath.vector4(1, 1, 1, 1)
		// }
		// TODO Stopped here.
		// Defold.pprint(pos);
		// var l0:RenderMessageDrawLine = {
		// 	start_point: Vmath.vector3(950, 760, 0),
		// 	end_point: Vmath.vector3(1000, 760, 0),
		// 	color: Vmath.vector4(0, 0, 0, 1)
		// }
		// var l1:RenderMessageDrawLine = {
		// 	start_point: Vmath.vector3(950, 760, 0),
		// 	end_point: Vmath.vector3(1000, 760, 0),
		// 	color: Vmath.vector4(0, 0, 0, 1)
		// }
		// var l2:RenderMessageDrawLine = {
		// 	start_point: Vmath.vector3(950, 760, 0),
		// 	end_point: Vmath.vector3(1000, 760, 0),
		// 	color: Vmath.vector4(0, 0, 0, 1)
		// }
		// var l3:RenderMessageDrawLine = {
		// 	start_point: Vmath.vector3(950, 760, 0),
		// 	end_point: Vmath.vector3(1000, 760, 0),
		// 	color: Vmath.vector4(0, 0, 0, 1)
		// }
		// // TODO debug
		// Msg.post("@render:", RenderMessages.draw_line, l0);
		// Msg.post("@render:", RenderMessages.draw_line, l1);
		// Msg.post("@render:", RenderMessages.draw_line, l2);
		// Msg.post("@render:", RenderMessages.draw_line, l3);
	}

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
		if (action_id == hash("touch")) {
			final bounding_box = Go.get_world_position();
			Defold.pprint(bounding_box);
			Defold.pprint('screenx ${action.screen_x} screeny ${action.screen_y}');
			Defold.pprint('touch x ${action.x} touch y ${action.y}');
			Defold.pprint(' the action_id is $action_id');
			Defold.pprint(' the action is $action');
			Defold.pprint('----------- World Screen -----------------');
			Defold.pprint(Camera.screen_to_world(hash("/camera"), Vmath.vector3(action.screen_x, action.screen_y, 0)));
			if (action.pressed) {
				trace('================================ Dual Arrow Pressed========================================');
			} else if (action.released) {
				trace('=============================== Dual Arrow Released =======================================');
			}
		}

		return true;
	}

	override function final_(self:DualArrowData):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}

	override function on_reload(self:DualArrowData):Void {}
}
