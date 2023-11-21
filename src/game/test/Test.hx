package game.test;

import defold.Sprite.SpriteMessages;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

private typedef TestData = {}

class Test extends Script<TestData> {
	override function init(self:AnimationsData) {}

	override function update(self:TestData, dt:Float):Void {}

	override function final_(self:TestData):Void {}

	override function on_reload(self:TestData):Void {}
}
