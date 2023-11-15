package hud;

import defold.Factory;
import defold.Go;
import defold.Gui;
import defold.Msg;
import defold.Sound;
import defold.Vmath;
import defold.support.GuiScript;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef SackMenuData = {
	var panel:GuiNode;
	var exit:GuiNode;
	var on_off_screen:Bool;
	var wmdindex:Int;
	var string_wmd:Array<String>;
	var int_wmd:Array<Int>;
	var hcurrent_wmd:Hash;
}

@:build(defold.support.MessageBuilder.build()) class SackMenuMessage {
	var on_off_screen:{data:Bool};
	var on_off_screen_instant:{data:Bool};
	var toggle_on_off_screen;
	var item_select:{data:Int};
}

class SackMenu extends GuiScript<SackMenuData> {
	override function init(self:SackMenuData) {
		Msg.post(".", GoMessages.acquire_input_focus);
		Msg.post("#", SackMenuMessage.on_off_screen_instant, {data: false});
		//
		self.wmdindex = 0;
		self.string_wmd = [
			"shield_curved", "weapon_axe", "weapon_chariot", "weapon_nuclear_raygun", "weapon_trained_cats", "shield_straight", "weapon_axe_large",
			"weapon_dagger", "weapon_pole", "weapon_trained_ferrets", "weapon_boomerang", "weapon_flamethrower", "weapon_spear", "weapon_arrow",
			"weapon_bow_arrow", "weapon_hammer", "weapon_staff", "weapon_axe_blades", "weapon_bow", "weapon_longsword", "weapon_sword", "weapon_axe_double",
			"weapon_canopener", "weapon_machine_gun", "weapon_throwing_stars", "weapon_fist"
		];
		self.int_wmd = [for (i in 0...self.string_wmd.length) i];
		//
		self.panel = Gui.get_node("panel");
		self.exit = Gui.get_node("exit");
	}

	override function update(self:SackMenuData, dt:Float):Void {}

	override function on_input(self:SackMenuData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (Gui.pick_node(self.exit, action.x, action.y)) {
			Sound.play('/sounds#click');
			Msg.post("#", SackMenuMessage.on_off_screen, {data: false});
		} // TODO else if inventory cat
		return false;
	}

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
			case SackMenuMessage.on_off_screen_instant:
				if (message.data) {
					Gui.animate(self.panel, GuiAnimateProprty.PROP_POSITION, Vmath.vector3(330, 545, 0), GuiEasing.EASING_LINEAR, 0.0, 0,
						(self:SackMenuData, _) -> {
							self.on_off_screen = true;
						});
				} else {
					Gui.animate(self.panel, GuiAnimateProprty.PROP_POSITION, Vmath.vector3(990, 545, 0), GuiEasing.EASING_LINEAR, 0.0, 0,
						(self:SackMenuData, _) -> {
							self.on_off_screen = false;
						});
				}
			case SackMenuMessage.item_select:
				final _pos = Go.get_world_position("");
				final _rot = Go.get_world_rotation("");
				if (self.hcurrent_wmd != null)
					Go.delete(self.hcurrent_wmd);
				switch (message.data) {
					case 0:
					case 1:
					case 2:
					case 3:
					case 4:
					case 5:
					case 6:
					case 7:
					case 8:
					case 9:
					case 10:
					case 11:
					case 12:
					case 13:
					case 14:
					case 15:
					case 16:
					case 17:
					case 18:
					case 19:
					case 20:
					case 21:
					case 22:
					case 23:
					case 24:
					case 25:
				}
				self.hcurrent_wmd = Factory.create()

			case SackMenuMessage.toggle_on_off_screen:
				self.wmdindex++;
				if (self.wmdindex > self.int_wmd.length)
					self.wmdindex = 0;
				Defold.pprint(self.string_wmd[self.wmdindex]);
				Msg.post("#", SackMenuMessage.item_select, {data: self.wmdindex});
		}
	}

	override function final_(self:SackMenuData):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}

	override function on_reload(self:SackMenuData):Void {}
}
