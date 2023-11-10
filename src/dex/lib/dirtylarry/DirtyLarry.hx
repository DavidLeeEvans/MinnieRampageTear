package dex.lib.dirtylarry;

import defold.Gui.GuiKeyboardType;

import defold.support.ScriptOnInputAction;

import defold.types.Hash;

/**
	### dirtylarry
	https://github.com/andsve/dirtylarry

	A quick and dirty GUI library for Defold.
**/
@:luaRequire("dirtylarry/dirtylarry")
extern class DirtyLarry {
	static function input(node:String, action_id:Hash, action:ScriptOnInputAction, type:GuiKeyboardType, empty_text:String):Void;

	static function button(node:String, action_id:Hash, action:ScriptOnInputAction, cb:() -> Void):Void;

	static function checkbox(node:String, action_id:Hash, action:ScriptOnInputAction, value:Bool):Bool;

	static function radio(node:String, action_id:Hash, action:ScriptOnInputAction, id:String, value:String):String;
}
