package dex.lib.orthographic;

import haxe.extern.EitherType;

import defold.types.Vector3;
import defold.types.Matrix4;
import defold.types.Hash;
import defold.types.Url;

typedef HashOrUrl = EitherType<Hash, Url>;

/**
	### defold-orthographic
	https://github.com/britzl/defold-orthographic

	Orthographic camera API for the Defold game engine. The API makes it super easy to convert screen to world coordinates, smoothly follow a game object and create a screen shake effect. This project is inspired by the camera component of the Phaser engine.
**/
@:luaRequire("orthographic.camera")
extern class Camera {
	/**
		Shake the camera.

		@param camera_id
		@param intensity Intensity of the shake, in percent of screen. Defaults to `0.05`.
		@param duration Duration of the shake, in seconds. Defaults to `0.5`.
		@param direction Direction of the shake. Possible values: `both`, `horizontal`, `vertical`. Defaults to `both`.
		@param cb Function to call when the shake has finished.
	**/
	static function shake(camera_id:HashOrUrl, ?intensity:Float, ?duration:Float, ?direction:ShakeDirection, ?cb:() -> Void):Void;

	/**
		Stop shaking the camera.

		@param camera_id
	**/
	static function stop_shaking(camera_id:HashOrUrl):Void;

	/**
		Apply a recoil effect to the camera. The recoil will decay using linear interpolation.

		@param camera_id
		@param offset Offset to apply to the camera. Defaults to `0.05`.
		@param duration Duration of the recoil, in seconds. Defaults to `0.5`.
	**/
	static function recoil(camera_id:HashOrUrl, offset:Vector3, ?duration:Float):Void;

	/**
		Get the current zoom level of the camera.

		@param camera_id
		@return The current zoom of the camera.
	**/
	static function get_zoom(camera_id:HashOrUrl):Float;

	/**
		Set the current zoom level of the camera.

		@param camera_id
		@param zoom The new zoom level of the camera.
	**/
	static function set_zoom(camera_id:HashOrUrl, zoom:Float):Void;

	/**
		Follow a game object.

		@param camera_id
		@param target Game object to follow.
		@param options Follow options. (See `FollowOptions`)
	**/
	static function follow(camera_id:HashOrUrl, target:HashOrUrl, ?options:FollowOptions):Void;

	/**
		Stop following a game object.

		@param camera_id
	**/
	static function unfollow(camera_id:HashOrUrl):Void;

	/**
		If following a game object this will add a deadzone around the camera position where the camera position will not update. If the target moves to the edge of the deadzone the camera will start to follow until the target returns within the bounds of the deadzone.

		@param camera_id
		@param left Number of pixels to the left of the camera.
		@param top Number of pixels above the camera.
		@param right Number of pixels to the right of the camera.
		@param bottom Number of pixels below the camera.
	**/
	static function deadzone(camera_id:HashOrUrl, left:Float, top:Float, right:Float, bottom:Float):Void;

	/**
		Limits the camera position to within the specified rectangle.

		@param camera_id
		@param left Left edge of camera bounds.
		@param top Top edge of camera bounds.
		@param right Right edge of camera bounds.
		@param bottom Bottom edge of camera bounds.
	**/
	static function bounds(camera_id:HashOrUrl, left:Float, top:Float, right:Float, bottom:Float):Void;

	/**
		Translate screen coordinates to world coordinates, based on the view and projection of the camera.

		@param camera_id
		@param screen Screen coordinates to convert.
		@return World coordinates.
	**/
	static function screen_to_world(camera_id:HashOrUrl, screen:Vector3):Vector3;

	/**
		Translate world coordinates to screen coordinates, based on the view and projection of the camera, optionally taking into account an adjust mode. This is useful when manually culling game objects and you need to determine if a world coordinate will be visible or not. It can also be used to position gui nodes on top of game objects.

		@param camera_id
		@param world World coordinates to convert.
		@param adjust_mode One of `ADJUST_FIT`, `ADJUST_ZOOM` and `ADJUST_STRETCH`, or nil to not take into account the adjust mode.
		@return Screen coordinates.
	**/
	static function world_to_screen(camera_id:HashOrUrl, world:Vector3, ?adjust_mode:GuiAdjustMode2):Vector3;

	/**
		Translate screen coordinates to world coordinates using the specified view and projection.

		@param view
		@param projection
		@param screen Screen coordinates to convert.
		@return Note: Same v3 object as passed in as argument.
	**/
	static function unproject(view:Matrix4, projection:Matrix4, screen:Vector3):Vector3;

	/**
		Translate world coordinates to screen coordinates using the specified view and projection.

		@param view
		@param projection
		@param screen Screen coordinates to convert.
		@return Note: Same v3 object as passed in as argument.
	**/
	static function project(view:Matrix4, projection:Matrix4, screen:Vector3):Vector3;

	/**
		Add a custom projector that can be used by cameras in your project (see configuration above).

		@param projector_id Id of the projector. Used as a value in the projection field of the camera script.
		@param projector_fn The function to call when a projection matrix is needed for the camera. The function will receive the id, near_z and far_z values of the camera.
	**/
	static function add_projector(projector_id:Hash, projector_fn:(Hash, Float, Float) -> Void):Void;

	/**
		Set a specific projector for a camera. This must be either one of the predefined projectors (see above) or a custom projector added using camera.add_projector().

		@param camera_id Id of the camera to set projector for.
		@param projector_id Id of the projector.
	**/
	static function use_projector(camera_id:HashOrUrl, projector_id:Hash):Void;

	/**
		Set the current window size so that it is available to projectors via `Camera.get_window_size()`. Set this via your render script.

		@param width Current window width.
		@param height Current window height.
	**/
	static function set_window_size(width:Float, height:Float):Void;

	/**
		Set window scaling factor (basically retina or no retina screen). There is no built-in way to detect if Defold is running on a retina or non retina screen. This information combined with the High DPI setting in game.project can be used to ensure that the zoom behaves the same way regardless of screen type and High DPI setting. You can use an extension such as DefOS to get the window scaling factor.

		@param scaling_factor  Current window scaling factor.
	**/
	static function set_window_scaling_factor(scaling_factor:Float):Void;

	/**
		Get the current window size, as it was provided by `Camera.set_window_size()`. The default values will be the ones specified in game.project.`

		@return The window size.
	**/
	static function get_window_size():Size;

	/**
		Get the display size, as specified in game.project.

		@return The display size.
	**/
	static function get_display_size():Size;
}

typedef FollowOptions = {
	/** Lerp from current position to target position with lerp as `t`. **/
	var ?lerp:Float;

	/** Camera offset from target position. **/
	var ?offset:Vector3;

	/** True if following the target along the horizontal axis. **/
	var ?horizontal:Bool;

	/** True if following the target along the vertical axis. **/
	var ?vertical:Bool;

	/** True if the camera should be immediately positioned on the target even when lerping. **/
	var ?immediate:Bool;
}

@:multiReturn extern class Size {
	var width:Float;
	var height:Float;
}

@:enum
abstract GuiAdjustMode2(Int) {
	var Fit = 0;
	var Zoom = 1;
	var Stretch = 2;
}
