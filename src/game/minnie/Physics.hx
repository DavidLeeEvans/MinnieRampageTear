package game.minnie;

import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

private typedef PhysicsData = {}

class Physics extends Script<PhysicsData> {
	override function update(self:PhysicsData, dt:Float):Void {}

	override function on_message<T>(self:PhysicsData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:PhysicsData):Void {}

	override function on_reload(self:PhysicsData):Void {}
}
