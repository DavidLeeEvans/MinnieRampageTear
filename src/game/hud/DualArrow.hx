package game.hud;

import defold.support.Script;
import defold.types.Hash;
import defold.types.Message;

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
	var set_angle:{data:Float};
	var on_off:{status:Bool};
	var set_position:{data:Float};
}

class DualArrow extends Script<DualArrowData> {
	override function init(self:DualArrowData) {}

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

	override function final_(self:DualArrowData):Void {}

	override function on_reload(self:DualArrowData):Void {}
}
