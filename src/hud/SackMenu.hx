package hud;

import defold.Go.GoMessages;
import defold.Gui;
import defold.Msg;
import defold.Vmath;
import defold.support.GuiScript;
import defold.types.Message;
import defold.types.Url;

private typedef SackMenuData = {
	var panel:GuiNode;
	var exit:GuiNode;
	var on_off_screen:Bool;
}

@:build(defold.support.MessageBuilder.build()) class SackMenuMessage {
	var on_off_screen:{data:Bool};
	var item_select:{data:Int};
}

class SackMenu extends GuiScript<SackMenuData> {
	override function init(self:SackMenuData) {
		Msg.post(".", GoMessages.acquire_input_focus);
		Msg.post("#", SackMenuMessage.on_off_screen, {data: false});
		self.panel = Gui.get_node("");
		self.exit = Gui.get_node("");
	}

	override function update(self:SackMenuData, dt:Float):Void {}

	override function on_message<T>(self:SackMenuData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case SackMenuMessage.on_off_screen:
				if (message.data) {
					Gui.animate(self.panel, GuiAnimateProprty.PROP_POSITION, Vmath.vector3(330, 545, 0), GuiEasing.EASING_LINEAR, 1.0, 0,
						(self:SackMenuData, _) -> {
							self.on_off_screen = true;
						});
				} else {
					Gui.animate(self.panel, GuiAnimateProprty.PROP_POSITION, Vmath.vector3(990, 545, 0), GuiEasing.EASING_LINEAR, 1.0, 0,
						(self:SackMenuData, _) -> {
							self.on_off_screen = false;
						});
				}
			case SackMenuMessage.item_select:
		}
	}

	override function final_(self:SackMenuData):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}

	override function on_reload(self:SackMenuData):Void {}
}