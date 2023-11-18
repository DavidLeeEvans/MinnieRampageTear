package hud;

import Defold.hash;
import defold.Factory;
// import defold.Go;
import defold.Gui;
import defold.Msg;
import defold.Sound;
import defold.Vmath;
import defold.support.GuiScript;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Quaternion;
import defold.types.Url;
import defold.types.Vector3;
import game.Minnie.MinnieMessage;
import game.Weapons.WeaponsMessages;

private typedef GuiSackMenuData = {
	var panel:GuiNode;
	var exit:GuiNode;
	var on_off_screen:Bool;
	var wmdindex:Int;
	var string_wmd:Array<String>;
	var int_wmd:Array<Int>;
	var hcurrent_wmd:Hash;
	//
	var _mpos:Vector3;
	var _mrot:Quaternion;
}

@:build(defold.support.MessageBuilder.build()) class GuiSackMenuMessage {
	var on_off_screen:{data:Bool};
	var on_off_screen_instant:{data:Bool};
	var toggle_on_off_screen;
	var item_select_rotate;
	var item_select:{data:Int};
}

class GuiSackMenu extends GuiScript<GuiSackMenuData> {
	override function init(self:GuiSackMenuData) {
		Msg.post("#", GuiSackMenuMessage.on_off_screen_instant, {data: false});
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

	override function update(self:GuiSackMenuData, dt:Float):Void {}

	override function on_input(self:GuiSackMenuData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("touch") && action.pressed)
			if (Gui.pick_node(self.exit, action.x, action.y)) {
				Sound.play('/sounds#click');
				Msg.post("#", GuiSackMenuMessage.on_off_screen, {data: false});
			} // TODO else if inventory cat
		return false;
	}

	override function on_message<T>(self:GuiSackMenuData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			//
			//
			// MENU Disaster Control
			//
			//
			case GuiSackMenuMessage.on_off_screen:
				if (message.data) {
					Gui.animate(self.panel, GuiAnimateProprty.PROP_POSITION, Vmath.vector3(330, 545, 0), GuiEasing.EASING_LINEAR, 1.0, 0,
						(self:GuiSackMenuData, _) -> {
							self.on_off_screen = true;
						});
				} else {
					Gui.animate(self.panel, GuiAnimateProprty.PROP_POSITION, Vmath.vector3(990, 545, 0), GuiEasing.EASING_LINEAR, 1.0, 0,
						(self:GuiSackMenuData, _) -> {
							self.on_off_screen = false;
						});
				}
			case GuiSackMenuMessage.on_off_screen_instant:
				if (message.data) {
					Gui.animate(self.panel, GuiAnimateProprty.PROP_POSITION, Vmath.vector3(330, 545, 0), GuiEasing.EASING_LINEAR, 0.0, 0,
						(self:GuiSackMenuData, _) -> {
							self.on_off_screen = true;
						});
				} else {
					Gui.animate(self.panel, GuiAnimateProprty.PROP_POSITION, Vmath.vector3(990, 545, 0), GuiEasing.EASING_LINEAR, 0.0, 0,
						(self:GuiSackMenuData, _) -> {
							self.on_off_screen = false;
						});
				}
			//
			//
			// WMD Weapon Selections
			//
			//
			case GuiSackMenuMessage.item_select_rotate:
				self.wmdindex++;
				if (self.wmdindex > self.int_wmd.length)
					self.wmdindex = 0;
				Defold.pprint(self.string_wmd[self.wmdindex]);
				Msg.post("/Minnie/entity#Minnie", MinnieMessage.send_pos);
				Msg.post("/Minnie/entity#Minnie", MinnieMessage.send_rot);
				if (self.hcurrent_wmd != null)
					Msg.post(self.hcurrent_wmd, WeaponsMessages.delete_weapon);
				switch (self.wmdindex) {
					case 0:
						self.hcurrent_wmd = Factory.create("/go#shield_curved", self._mpos, self._mrot);
					case 1:
						self.hcurrent_wmd = Factory.create("/go#weapon_axe", self._mpos, self._mrot);
					case 2:
						self.hcurrent_wmd = Factory.create("/go#weapon_chariot", self._mpos, self._mrot);
					case 3:
						self.hcurrent_wmd = Factory.create("/go#weapon_nuclear_raygun", self._mpos, self._mrot);
					case 4:
						self.hcurrent_wmd = Factory.create("/go#weapon_trained_cats_ferrets", self._mpos, self._mrot);
					case 5:
						self.hcurrent_wmd = Factory.create("/go#shield_straight", self._mpos, self._mrot);
					case 6:
						self.hcurrent_wmd = Factory.create("/go#weapon_axe_large", self._mpos, self._mrot);
					case 7:
						self.hcurrent_wmd = Factory.create("/go#weapon_dagger", self._mpos, self._mrot);
					case 8:
						self.hcurrent_wmd = Factory.create("/go#weapon_pole", self._mpos, self._mrot);
					case 9:
						self.hcurrent_wmd = Factory.create("/go#weapon_trained_cats_ferrets", self._mpos, self._mrot);
					case 10:
						self.hcurrent_wmd = Factory.create("/go#weapon_boomerang", self._mpos, self._mrot);
					case 11:
						self.hcurrent_wmd = Factory.create("/go#weapon_flamethrower", self._mpos, self._mrot);
					case 12:
						self.hcurrent_wmd = Factory.create("/go#weapon_spear", self._mpos, self._mrot);
					case 13:
						self.hcurrent_wmd = Factory.create("/go#weapon_arrow", self._mpos, self._mrot);
					case 14:
						self.hcurrent_wmd = Factory.create("/go#weapon_bow_arrow", self._mpos, self._mrot);
					case 15:
						self.hcurrent_wmd = Factory.create("/go#weapon_hammer", self._mpos, self._mrot);
					case 16:
						self.hcurrent_wmd = Factory.create("/go#weapon_staff", self._mpos, self._mrot);
					case 17:
						self.hcurrent_wmd = Factory.create("/go#weapon_axe_blades", self._mpos, self._mrot);
					case 18:
						self.hcurrent_wmd = Factory.create("/go#weapon_bow", self._mpos, self._mrot);
					case 19:
						self.hcurrent_wmd = Factory.create("/go#weapon_longsword", self._mpos, self._mrot);
					case 20:
						self.hcurrent_wmd = Factory.create("/go#weapon_sword", self._mpos, self._mrot);
					case 21:
						self.hcurrent_wmd = Factory.create("/go#weapon_axe_double", self._mpos, self._mrot);
					case 22:
						self.hcurrent_wmd = Factory.create("/go#weapon_canopener", self._mpos, self._mrot);
					case 23:
						self.hcurrent_wmd = Factory.create("/go#weapon_machine_gun", self._mpos, self._mrot);
					case 24:
						self.hcurrent_wmd = Factory.create("/go#weapon_throwing_stars", self._mpos, self._mrot);
					case 25:
						self.hcurrent_wmd = Factory.create("/go#weapon_fist", self._mpos, self._mrot);
				}
				Msg.post("/Minnie/entity#Minnie", MinnieMessage.set_wmd, {data: self.hcurrent_wmd});
			case GuiSackMenuMessage.item_select:
			case GuiSackMenuMessage.toggle_on_off_screen:
			case MinnieMessage.receive_pos:
				self._mpos = message.pos;
			case MinnieMessage.receive_rot:
				self._mrot = message.rot;
		}
	}

	override function final_(self:GuiSackMenuData):Void {}

	override function on_reload(self:GuiSackMenuData):Void {}
}
