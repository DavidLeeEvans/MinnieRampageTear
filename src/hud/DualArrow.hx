package hud;

import defold.Go;
import defold.Msg;
import defold.Vmath;
import defold.support.Script;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;
import lua.Math;

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

private typedef DualArrowData = {}

@:build(defold.support.MessageBuilder.build()) class DualArrowMessage {
	var set_length:{data:Int};
	// 0 - 9
	var set_angle:{data:Float};
	var on_off:{status:Bool};
	var set_position:{data:Vector3};
}

class DualArrow extends Script<DualArrowData> {
	override function init(self:DualArrowData) {}

	override function on_message<TMessage>(self:DualArrowData, message_id:Message<TMessage>, message:TMessage, sender:Url) {
		switch (message_id) {
			case DualArrowMessage.on_off:
				if (message.status) {
					Msg.post(DualArrowHash.prompt, GoMessages.enable);
					Msg.post(DualArrowHash.i0, GoMessages.enable);
					Msg.post(DualArrowHash.i1, GoMessages.enable);
					Msg.post(DualArrowHash.i2, GoMessages.enable);
					Msg.post(DualArrowHash.i3, GoMessages.enable);
					Msg.post(DualArrowHash.i4, GoMessages.enable);
					Msg.post(DualArrowHash.i5, GoMessages.enable);
					Msg.post(DualArrowHash.i6, GoMessages.enable);
				} else {
					Msg.post(DualArrowHash.prompt, GoMessages.disable);
					Msg.post(DualArrowHash.i0, GoMessages.disable);
					Msg.post(DualArrowHash.i1, GoMessages.disable);
					Msg.post(DualArrowHash.i2, GoMessages.disable);
					Msg.post(DualArrowHash.i3, GoMessages.disable);
					Msg.post(DualArrowHash.i4, GoMessages.disable);
					Msg.post(DualArrowHash.i5, GoMessages.disable);
					Msg.post(DualArrowHash.i6, GoMessages.disable);
				}
			case DualArrowMessage.set_angle:
				final _a = Go.get_rotation();
				Go.set_rotation(_a * Vmath.quat_rotation_z(Math.rad(-message.data)));
			case DualArrowMessage.set_length:
				if (message.data > 6 || message.data < 0)
					return;

				switch (message.data) {
					case 0:
					case 1:
					case 2:
					case 3:
					case 4:
					case 5:
					case 6:
				}
			case DualArrowMessage.set_position:
				Go.set_position(message.data);
		}
	}

	override function update(self:DualArrowData, dt:Float):Void {
		// var pos = Camera.world_to_screen(Defold.hash("/camera"), Go.get_position("/Minnie/dual_arrow"));
		// var test:RenderMessageDrawLine = {
		//     start_point: Vmath.vector3(pos.x, pos.y, 0),
		//     end_point: Vmath.vector3(pos.x + self.top_pt.x, pos.y + self.top_pt.y, 0),
		//     color: Vmath.vector4(1, 1, 1, 1)
		// }
		// TODO Stopped here.
		// Defold.pprint(pos);
		// var l0:RenderMessageDrawLine = {
		//     start_point: Vmath.vector3(950, 760, 0),
		//     end_point: Vmath.vector3(1000, 760, 0),
		//     color: Vmath.vector4(0, 0, 0, 1)
		// }
		// var l1:RenderMessageDrawLine = {
		//     start_point: Vmath.vector3(950, 760, 0),
		//     end_point: Vmath.vector3(1000, 760, 0),
		//     color: Vmath.vector4(0, 0, 0, 1)
		// }
		// var l2:RenderMessageDrawLine = {
		//     start_point: Vmath.vector3(950, 760, 0),
		//     end_point: Vmath.vector3(1000, 760, 0),
		//     color: Vmath.vector4(0, 0, 0, 1)
		// }
		// var l3:RenderMessageDrawLine = {
		//     start_point: Vmath.vector3(950, 760, 0),
		//     end_point: Vmath.vector3(1000, 760, 0),
		//     color: Vmath.vector4(0, 0, 0, 1)
		// }
		// // TODO debug
		// Msg.post("@render:", RenderMessages.draw_line, l0);
		// Msg.post("@render:", RenderMessages.draw_line, l1);
		// Msg.post("@render:", RenderMessages.draw_line, l2);
		// Msg.post("@render:", RenderMessages.draw_line, l3);
	}

	override function final_(self:DualArrowData):Void {}

	override function on_reload(self:DualArrowData):Void {}
}
