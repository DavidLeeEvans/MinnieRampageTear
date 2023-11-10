package dex.lib.monarch;

import haxe.extern.EitherType;

import defold.types.Url;
import defold.types.Hash;
import defold.types.Message;
import defold.types.HashOrString;

/**
	### Monarch
	https://github.com/britzl/monarch

	Monarch is a screen manager for the Defold game engine.
**/
@:luaRequire("monarch")
extern class Monarch {
	/**
		Show a Monarch screen. Note that the screen must be registered before it can be shown. The `init()` function of the `screen.script` takes care of registration. This operation will be added to the queue if Monarch is busy.

		@param screen_id Id of the screen to show.
		@param options Options when showing the new screen.
		@param data Optional data to associate with the screen. Retrieve using `Monarch.data()`.
		@param callback Optional function to call when the new screen is visible.
	**/
	static function show(screen_id:HashOrString, ?options:ShowOptions, ?data:Dynamic, ?callback:() -> Void):Void;

	/**
		Hide a screen that has been shown using the `no_stack` option. If used on a screen that was shown without the `no_stack` option it will only hide it if the screen is on top of the stack and the behavior will be exactly like if `monarch.back()` had been called. This operation will be added to the queue if Monarch is busy.

		@param screen_id Id of the screen to hide.
		@param callback Optional function to call when the screen has been hidden.
		@return True if the process of hiding the screen was started successfully.
	**/
	static function hide(screen_id:HashOrString, ?callback:() -> Void):Bool;

	/**
		Go back to a previous Monarch screen. This operation will be added to the queue if Monarch is busy.

		@param data Optional data to associate with the screen you are going back to. Retrieve using `monarch.data()`.
		@param callback Optional function to call when the previous screen is visible.
	**/
	static function back(?data:Dynamic, ?callback:() -> Void):Void;

	/**
		Preload a Monarch screen. This will load but not enable the screen. This is useful for content heavy screens that you wish to be able to show without having to wait for it load. This operation will be added to the queue if Monarch is busy.

		@param screen_id Id of the screen to preload.
		@param callback Optional function to call when the screen is preloaded.
	**/
	static function preload(screen_id:HashOrString, ?callback:() -> Void):Void;

	/**
		Check if a Monarch screen is preloading (via monarch.preload() or the Preload screen setting).

		@param screen_id Id of the screen to check.
		@return True if the screen is preloading.
	**/
	static function is_preloading(screen_id:HashOrString):Bool;

	/**
		Invoke a callback when a screen has been preloaded.

		@param screen_id Id of the screen to check.
		@param callback Function to call when the screen has been preloaded.
	**/
	static function when_preloaded(screen_id:HashOrString, callback:() -> Void):Void;

	/**
		Unload a preloaded Monarch screen. A preloaded screen will automatically get unloaded when hidden, but this function can be useful if a screen has been preloaded and it needs to be unloaded again without actually hiding it. This operation will be added to the queue if Monarch is busy.

		@param screen_id Id of the screen to unload.
		@param callback Optional function to call when the screen is unloaded.
	**/
	static function unload(screen_id:HashOrString, ?callback:() -> Void):Void;

	/**
		Get the id of the screen at the top of the stack.

		@param offset Optional offset from the top of the stack, ie `-1` to get the previous screen.
		@return Id of the requested screen.
	**/
	static function top(?offset:Int):HashOrString;

	/**
		Get the id of the screen at the bottom of the stack.

		@param offset Optional offset from the bottom of the stack.
		@return Id of the requested screen.
	**/
	static function bottom(?offset:Int):HashOrString;

	/**
		Get the data associated with a screen (from a call to `monarch.show()` or `monarch.back()`).

		@param Id of the screen to get data for.
		@return Data associated with the screen.
	**/
	static function data(screen_id:HashOrString):Dynamic;

	/**
		Check if a Monarch screen exists.

		@param screen_id Id of the screen to get data for.
		@return True if the screen exists.
	**/
	static function screen_exists(screen_id:HashOrString):Bool;

	/**
		Check if Monarch is busy showing and/or hiding a screen.

		@return True if busy hiding and/or showing a screen.
	**/
	static function is_busy():Bool;

	/**
		Check if a Monarch screen is at the top of the view stack.

		@param screen_id Id of the screen to check.
		@return True if the screen is at the top of the stack.
	**/
	static function is_top(screen_id:HashOrString):Bool;

	/**
		Check if a Monarch screen is visible.

		@param screen_id Id of the screen to check.
		@return True if the screen is visible.
	**/
	static function is_visible(screen_id:HashOrString):Bool;

	/**
		Add a URL that will be notified of navigation events.

		@param URL to send navigation events to. Will use current URL if omitted.
	**/
	static function add_listener(?url:Url):Void;

	/**
		Remove a previously added listener.

		@param URL to remove. Will use current URL if omitted.
	**/
	static function remove_listener(?url:Url):Void;

	/**
		Post a message to a visible screen. If the screen is created through a collection proxy it must have specified a receiver url. If the screen is created through a collection factory the function will post the message to all game objects within the collection.

		@param screen_id Id of the screen to post message to.
		@param message Id of the message to send.
		@param message Optional message data to send.
		@return True if the message was sent, error message if unable to send message.
	**/
	static function post<T>(screen_id:HashOrString, message_id:Message<T>, ?message:T):EitherType<Bool, String>;

	/**
		Enable verbose logging of the internals of Monarch.
	**/
	static function debug():Void;
}

typedef ShowOptions = {
	/** If the clear flag is set Monarch will search the stack for the screen that is to be shown. If the screen already exists in the stack and the clear flag is set Monarch will remove all screens between the current top and the screen in question. **/
	var clear:Bool;

	/** If the reload flag is set Monarch will reload the collection proxy if it's already loaded (this can happen if the previous screen was a popup). **/
	var reload:Bool;

	/** If the no_stack flag is set Monarch will load the screen without adding it to the screen stack. **/
	var no_stack:Bool;
}
