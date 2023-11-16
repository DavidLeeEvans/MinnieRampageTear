package game;

import Defold.hash;
import defold.Factory;
import defold.Go;
import defold.Msg;
import defold.Render.RenderMessages;
import defold.Tilemap;
import defold.Vmath;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import game.atomic.Globals;
import lua.Math;

private typedef GameLogicData = {
	@property(-1) var level:Int;
	@property(-1) var climate:Int;
	var run_pause_game:Bool;
	var _minnie:Hash;
	var _loaded:Bool;
}

// private var test:CameraControllerProperties = {
//     center: Vmath.vector3(0, 0, 0),
//     follow: Defold.hash(""),
//     followLerpY: 1,
//     followLerpX: 0,
//     followOffsetY: 0,
//     followOffsetX: 0,
//     go: hash("")
// }
// var camera:CameraControllerProperties = {}
// class GameLogic extends CameraController<camera> {
class GameLogic extends Script<GameLogicData> {
	var code:Int;
	var fmessage:String;

	override function init(self:GameLogicData):Void {
		lua.Lua.assert(self.level != -1, "Level Not Set");
		lua.Lua.assert(self.climate != -1, "Climate Not Set");
		Msg.post(".", GoMessages.acquire_input_focus);
		self.run_pause_game = true;
		var fps = 30;
		self._loaded = false;
		var map_bounds:TilemapBounds;
		var game_level:Int;
		// Stopped Here
		Defold.pprint("--------------------------");
		Defold.pprint(Globals.level00[15][0]);
		map_bounds = Tilemap.get_bounds("/go#l");
		Defold.pprint('Mapx = ${map_bounds.w}');
		Defold.pprint('Mapy = ${map_bounds.h}');
		for (x in map_bounds.x...map_bounds.w + 1)
			for (y in map_bounds.y...map_bounds.h + 1) {
				game_level = Tilemap.get_tile("/go#l", "floor", x, y);
				Defold.pprint('game_level is $game_level');
				if (game_level != 0)
					create_level_function(x, y, 16, 16, Globals.level00, game_level);
			}
		// Now lets add the entities
		//        map_bounds = Tilemap.get_bounds("/go#tilemap");
		//        for (x in map_bounds.x...map_bounds.w)
		//            for (y in map_bounds.y...map_bounds.h) {
		//
		// game_level = Tilemap.get_tile("/go#tilemap", "entities", x, y);

		// Set camera to follow Horse
		// var follow:FollowOptions = {
		//     lerp: 10.61,
		//     offset: Vmath.vector3(0, 100, 0),
		//     horizontal: true,
		//     vertical: true,
		//     immediate: false
		// }
		// Camera.follow(hash('/camera'), self._minnie, follow);
		// self.level = SaveLoad.get_all_saved_data().game_level;
		// load_level(self);
	}

	override function update(self:GameLogicData, dt:Float):Void {
		if (self.run_pause_game) {
			Msg.post("@render:", RenderMessages.clear_color, {color: Vmath.vector4(95 / 256, 129 / 256, 161 / 256, 1)});
		} else {
			// Game has started
			Msg.post("@render:", RenderMessages.clear_color, {color: Vmath.vector4(256 / 256, 256 / 256, 256 / 256, 1)});
			// Msg.post("@render:", RenderMessages.clear_color, {color: Vmath.vector4(256 / 256, 0 / 256, 0 / 256, 1)});
		}
	}

	override function on_message<TMessage>(self:GameLogicData, message_id:Message<TMessage>, message:TMessage, sender:Url):Void {
		switch (message_id) {}
	}

	override function on_input(self:GameLogicData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("touch")) {
			// Defold.pprint(' the action_id is $action_id');
			// Defold.pprint(' the action is $action');
			// Defold.pprint('----------------------------');
			// Defold.pprint(Camera.screen_to_world(hash("/camera"), Vmath.vector3(action.screen_x, action.screen_y, 0)));
		}
		return false;
	}

	override function final_(self:GameLogicData):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}

	private function create_level_function(x:Int, y:Int, xwidth:Int, ywidth:Int, arr:Array<Array<Int>>, tile:Int):Void {
		Defold.pprint('x = $x y = $y tile $tile');
		lua.Lua.assert(x > 0 && x <= xwidth);
		lua.Lua.assert(y > 0 && y <= ywidth);
		final o = Factory.create('/go#ftile' + three_string_create(tile), Vmath.vector3(x * 64, y * 64, 0));
		// switch (arr[x - 1][ywidth - y]) {
		switch (arr[ywidth - y][x - 1]) {
			case 0:
				return;
			case 1:
				var r = Go.get_world_rotation(o);
				r = r * Vmath.quat_rotation_z(Math.rad(-90));
				Go.set_rotation(r, o);
			case 2:
				var r = Go.get_world_rotation(o);
				r = r * Vmath.quat_rotation_z(Math.rad(-180));
				Go.set_rotation(r, o);
			case 3:
				var r = Go.get_world_rotation(o);
				r = r * Vmath.quat_rotation_z(Math.rad(-270));
				Go.set_rotation(r, o);
		}
	}

	override function on_reload(self:GameLogicData):Void {}

	private function load_level(self:GameLogicData):Void {}

	private function three_string_create(v:Int):String {
		var r:String = '';
		if (v <= 9) {
			r = '00' + Std.string(v);
		} else if (v >= 10 && v <= 99) {
			r = '0' + Std.string(v);
		} else {
			r = Std.string(v);
		}
		return (r);
	}

	private function two_string_create(v:Int):String {
		var r:String = '';
		if (v <= 9) {
			r = '0' + Std.string(v);
		} else {
			r = Std.string(v);
		}
		return (r);
	}
}
