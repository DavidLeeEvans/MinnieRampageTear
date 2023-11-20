package game.minnie;

import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

private typedef AnimationsData = {}

class Animations extends Script<AnimationsData> {
	override function init(self:AnimationsData) {}

	override function update(self:AnimationsData, dt:Float):Void {}

	override function on_message<T>(self:AnimationsData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:AnimationsData):Void {}

	override function on_reload(self:AnimationsData):Void {}
}
