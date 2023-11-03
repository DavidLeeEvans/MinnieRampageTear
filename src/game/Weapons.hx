package game;
import defold.Go.GoMessages;
import defold.Msg;
import Defold.hash;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

/*
shield_curved              = 0
weapon_axe 		   = 1
weapon_chariot             = 2
weapon_nuclear_raygun	   = 3
weapon_trained_cats        = 4
shield_straight		   = 5
weapon_axe_large    	   = 6
weapon_dagger
weapon_pole
weapon_trained_ferrets
weapon_boomerang
weapon_flamethrower
weapon_spear
weapon_arrow
weapon_bow_arrow
weapon_hammer
weapon_staff
weapon_axe_blades
weapon_bow
weapon_longsword
weapon_sword
weapon_axe_double
weapon_canopener
weapon_machine_gun
weapon_throwing_stars
*/

private typedef WeaponsData = {
	@property(-1) var type:Int;
}

class Weapons extends Script<WeaponsData> {
	override function init(self:WeaponsData) {
			assert(self.type != -1, "!!!!!!! Cat type is not Set !!!!!!!!!!");

}

	override function update(self:WeaponsData, dt:Float):Void {}

	override function on_message<T>(self:WeaponsData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:WeaponsData):Void {}

	override function on_reload(self:WeaponsData):Void {}
}
