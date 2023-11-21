package game.test;

import Defold.hash;
import defold.Factory;
import defold.Go;
import defold.extensions.spine.Spine;
import defold.support.Script;

private typedef TestData = {}

class Test extends Script<TestData> {
	override function init(self:TestData) {
		final _left_wing_id = Spine.get_go("#spinemodel", hash("left-wing"));
		final _right_wing_id = Spine.get_go("#spinemodel", hash("right-wing"));
		final _token_id = Spine.get_go("#spinemodel", hash("token"));
		//
		final _left_wing = Factory.create("#fac_black_left_arm");
		final _right_wing = Factory.create("#fac_black_right_arm");
		final _token = Factory.create("#fac_black_character");
		//
		Go.set_parent(_left_wing, _left_wing_id, true);
		Go.set_parent(_right_wing, _right_wing_id, true);
		Go.set_parent(_token, _token_id, true);
		//
	}

	override function update(self:TestData, dt:Float):Void {}

	override function final_(self:TestData):Void {}

	override function on_reload(self:TestData):Void {}
}
