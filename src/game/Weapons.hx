package game;

import defold.Msg;
import defold.support.Script;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import lua.Lua;

/*
	shield_curved              = 0
	weapon_axe 		   		   = 1
	weapon_chariot             = 2
	weapon_nuclear_raygun	   = 3
	weapon_trained_cats        = 4
	shield_straight		   	   = 5
	weapon_axe_large    	   = 6
	weapon_dagger              = 7 
	weapon_pole		   		   = 8 // Next
	weapon_trained_ferrets	   = 9
	weapon_boomerang	  	   = 10
	weapon_flamethrower        = 11
	weapon_spear 		   = 12
	weapon_arrow		   = 13
	weapon_bow_arrow	   = 14
	weapon_hammer		   = 15
	weapon_staff		   = 16
	weapon_axe_blades	   = 17
	weapon_bow		   	   = 18
	weapon_longsword	   = 19
	weapon_sword		   = 20
	weapon_axe_double	   = 21
	weapon_canopener	   = 22
	weapon_machine_gun	   = 23
	weapon_throwing_stars  = 24
 */
private typedef WeaponsData = {
	@property(-1) var type:Int;
}

class Weapons extends Script<WeaponsData> {
	override function init(self:WeaponsData) {
		Lua.assert(self.type != -1, "!!!!!!! Cat type is not Set !!!!!!!!!!");
	}

	override function update(self:WeaponsData, dt:Float):Void {}

	override function on_message<T>(self:WeaponsData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:WeaponsData):Void {}

	override function on_reload(self:WeaponsData):Void {}
}