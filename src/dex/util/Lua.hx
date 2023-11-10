package dex.util;

@:native("_G")
extern class Lua {
	static function assert(v:Dynamic, ?message:String):Void;

	static function error(message:String):Any;

	/**
	 * Performs a full garbage-collection cycle.
	 */
	static inline function collectGarbage():Void {
		untyped __lua__('collectgarbage("collect")');
	}

	/**
	 * Returns the total memory in use by Lua (in Kbytes).
	 */
	static inline function memoryUsage():Float {
		return untyped __lua__('collectgarbage("count")');
	}

	/**
	 * Stops the garbage collector.
	 */
	static inline function stopGarbageCollector():Void {
		untyped __lua__('collectgarbage("stop")');
	}

	/**
	 * Restarts the garbage collector.
	 */
	static inline function startGarbageCollector():Void {
		untyped __lua__('collectgarbage("restart")');
	}
}
