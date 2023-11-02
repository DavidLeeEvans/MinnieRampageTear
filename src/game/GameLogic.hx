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
import dle.Delayer;
import lua.Table;

private typedef GameLogicData = {
	var delayer:Delayer;
	var run_game:Bool;
	var level:Int;
	//
	var _loaded:Bool;
}

class GameLogic extends Script<GameLogicData> {
	var code:Int;
	var fmessage:String;

	override function init(self:GameLogicData):Void {
		Msg.post(".", GoMessages.acquire_input_focus);
		// Start Of Load Level

		// End Of Load Level
		var fps = 30;
		self.delayer = new Delayer(fps);
		self._loaded = false;
		ads_runner(self);
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

		BroadCast.register("GAME_START", function(self:GameLogicData, message_id, sender):Void {
			trace("GAME_START CALLED");
			self.run_game = true;
		});

		BroadCast.register("GAME_PAUSE", function(self:GameLogicData, message_id, sender):Void {
			trace("GAME_PAUSE CALLED");
			self.run_game = false;
		});

		// TODO y6k testing
		var g:GestureSetting = {
			action_id: hash("touch"),
			double_tap_interval: 0.5,
			long_press_time: 0.5,
			swipe_threshold: 100,
			tap_threshold: 20,
			multi_touch: false,
		}
		self.run_game = false;
		self.level = SaveLoad.get_all_saved_data().game_level;
		load_level(self);
	}

	override function update(self:GameLogicData, dt:Float):Void {
		if (self.run_game) {
			Msg.post("@render:", RenderMessages.clear_color, {color: Vmath.vector4(95 / 256, 129 / 256, 161 / 256, 1)});
		} else {
			// Game has started
			self.delayer.update(1.0);
			Msg.post("@render:", RenderMessages.clear_color, {color: Vmath.vector4(256 / 256, 256 / 256, 256 / 256, 1)});
			// Msg.post("@render:", RenderMessages.clear_color, {color: Vmath.vector4(256 / 256, 0 / 256, 0 / 256, 1)});
		}
	}

	override function on_message<TMessage>(self:GameLogicData, message_id:Message<TMessage>, message:TMessage, sender:Url):Void {
		switch (message_id) {
			case AdmobMsg.have_is_banner_loaded:
				Defold.pprint('have_banner_called_back MSG actionable ${message.name}');
				self._loaded = message.name;
			case GestureMessage.on_gesture:
				Defold.pprint("GameLogic on_gesture");
				// Defold.pprint(message);
				Defold.pprint(message);
		}

		// var my_message:AnyTable = Table.create();
		// // var u:Url = null;
		if (BroadCast.on_message(hash("GAME_START"), Table.create(), null))
			trace("GAME_START Handled");
		if (BroadCast.on_message(hash("GAME_PAUSED"), Table.create(), null))
			trace("GAME_PAUSED Handled");
		// More Assembly required??
	}

	override function on_input(self:GameLogicData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("jump") || action_id == hash("touch")) {
			Defold.pprint(' the action_id is $action_id');
			Defold.pprint(' the action is $action');
		}
		// if (r.tap != null)
		// 	if (r.tap == true)
		// 		Defold.pprint("Tap");
		// if (action_id == hash("jump") || action_id == hash("touch")) {
		// 	if (action.pressed) {
		// 		// left empty
		// 	}
		// }
		return false;
	}

	override function final_(self:GameLogicData):Void {
		Msg.post(".", GoMessages.release_input_focus);
		BroadCast.unregister("GAME_START");
		BroadCast.unregister("GAME_PAUSE");
		self.delayer.cancelEverything();
	}

	private function create_level_function(x:Int, y:Int, tile:Int):Void {
		// trace('x = $x y = $y tile $tile');
		Factory.create('/go#fac_' + string_create(tile), Vmath.vector3(x * 64, y * 64, 0));
	}

	private function create_entity_function(x:Int, y:Int, tile:Int, self:GameLogicData):Void {
		// trace('entity x = $x y = $y tile $tile');
		switch (tile) {
			case 50: // Cat
				// TODO set random type
				Factory.create('/go#factory_cat', Vmath.vector3(x * 64, y * 64, 0), null, Table.create({type: 1, current_state: 1}));
			case 51: // Helper
				Factory.create('/go#factory_helper', Vmath.vector3(x * 64, y * 64, 0));
			case 52: // Horse
				self._horse_hash = Factory.create('/go#factory_horse', Vmath.vector3(x * 64, y * 64, 0));
		}
	}

	override function on_reload(self:GameLogicData):Void {}

	private function load_level(self:GameLogicData):Void {}

	function string_create(v:Int):String {
		var r:String = '';
		if (v <= 9) {
			r = '0' + Std.string(v);
		} else {
			r = Std.string(v);
		}
		return (r);
	}
}
