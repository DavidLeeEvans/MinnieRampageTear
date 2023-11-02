package game;

import Defold.hash;
import defold.Factory;
import defold.Go.GoMessages;
import defold.Msg;
import defold.Render.RenderMessages;
import defold.Tilemap;
import defold.Vmath;
import defold.support.Script;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import dex.lib.orthographic.Camera;

private typedef GameLogicData = {
	var run_game:Bool;
	var level:Int;
	var _loaded:Bool;
}

class GameLogic extends Script<GameLogicData> {
	var code:Int;
	var fmessage:String;

	override function init(self:GameLogicData):Void {
		Msg.post(".", GoMessages.acquire_input_focus);
		var fps = 30;
		self._loaded = false;
		var map_bounds:TilemapBounds;
		var game_level:Int;
		map_bounds = Tilemap.get_bounds("/go#tilemap");
		for (x in map_bounds.x...map_bounds.w)
			for (y in map_bounds.y...map_bounds.h) {
				game_level = Tilemap.get_tile("/go#tilemap", "terrain", x, y);
				if (game_level != 0)
					create_level_function(x, y, game_level);
			}
		// Now lets add the entities
		map_bounds = Tilemap.get_bounds("/go#tilemap");
		for (x in map_bounds.x...map_bounds.w)
			for (y in map_bounds.y...map_bounds.h) {
				game_level = Tilemap.get_tile("/go#tilemap", "entities", x, y);
				if (game_level != 0)
					create_entity_function(x, y, game_level, self);
			}
		// Set camera to follow Horse
		var follow:FollowOptions = {
			lerp: 10.61,
			offset: Vmath.vector3(0, 100, 0),
			horizontal: true,
			vertical: true,
			immediate: false
		}
		Camera.follow(hash('/camera'), self._horse_hash, follow);

		self.level = SaveLoad.get_all_saved_data().game_level;
		load_level(self);
	}

	override function update(self:GameLogicData, dt:Float):Void {
		if (self.run_game) {
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
		if (action_id == hash("jump") || action_id == hash("touch")) {
			Defold.pprint(' the action_id is $action_id');
			Defold.pprint(' the action is $action');
		}
		return false;
	}

	override function final_(self:GameLogicData):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}

	private function create_level_function(x:Int, y:Int, tile:Int):Void {
		trace('x = $x y = $y tile $tile');
		Factory.create('/go#fac_' + string_create(tile), Vmath.vector3(x * 64, y * 64, 0));
	}

	override function on_reload(self:GameLogicData):Void {}

	private function load_level(self:GameLogicData):Void {}

	private function string_create(v:Int):String {
		var r:String = '';
		if (v <= 9) {
			r = '00' + Std.string(v);
		} else if (v >= 10 || v <= 99) {
			r = '0' + Std.string(v);
		} else {
			r = Std.string(v);
		}
		return (r);
	}
}
