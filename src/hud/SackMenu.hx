package hud;

import defold.support.GuiScript;
import defold.types.Message;
import defold.types.Url;

private typedef SackMenuData = {}

@:build(defold.support.MessageBuilder.build()) class SackMenuMessage {
	var on_off_screen:{data:Bool};
	var item_select:{data:Int};
}

class SackMenu extends GuiScript<SackMenuData> {
	override function init(self:SackMenuData) {}

	override function update(self:SackMenuData, dt:Float):Void {}

	override function on_message<T>(self:SackMenuData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			// TODO
		}
	}

	override function final_(self:SackMenuData):Void {}

	override function on_reload(self:SackMenuData):Void {}
}
