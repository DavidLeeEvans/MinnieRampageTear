package dex.lib.rendercam;

import defold.types.Hash;
import defold.types.Vector3;
import defold.types.UrlOrString;

/**
	### Rendercam
	https://github.com/rgrams/rendercam

	A universal render script & camera package for all the common camera types: perspective or orthographic, fixed aspect ratio or unfixed aspect ratio, plus four options for how the view changes for different resolutions and window sizes, and more. Also does screen-to-world and world-to-screen transforms for any camera type; camera switching, zooming, panning, shaking, recoil, and lerped following.
**/
@:luaRequire("rendercam.rendercam")
extern class Rendercam {
	/** The camera's window. **/
	static var window(default, never):Window;

	/** The camera's viewport. **/
	static var viewport(default, never):Viewport;

	/**
		Activate a different camera. If you have multiple cameras, use this to switch between them, otherwise you don't need it. Cameras with "Active" checked will activate themselves on init.

		@param cam_id ID of the camera game object.
	**/
	static function activate_camera(cam_id:Hash):Void;

	/**
		Zoom the camera. If the camera is orthographic, this adds `z * rendercam.ortho_zoom_mult` to the camera's ortho scale. If the camera is perspective, this moves the camera forward by `z`. You can set `Rendercam.ortho_zoom_mult` to adjust the ortho zoom speed, or use `Rendercam.get_ortho_scale` and `Rendercam.set_ortho_scale` for full control.

		@param z Amount to zoom.
		@param cam_id ID of the camera game object. Uses the current camera by default.
	**/
	static function zoom(z:Float, ?cam_id:Hash):Void;

	/**
		Gets the current ortho scale of the camera. (doesn't work for perspective cameras obviously).

		@param cam_id ID of the camera game object. Uses the current camera by default.
	**/
	static function get_ortho_scale(?cam_id:Hash):Float;

	/**
		Sets the current ortho scale of the camera. (doesn't work for perspective cameras obviously).

		@param cam_id ID of the camera game object. Uses the current camera by default.
	**/
	static function set_ortho_scale(s:Float, ?cam_id:Hash):Void;

	/**
		Moves the camera in its local X/Y plane.

		@param dx Distance to move the camera along its local X axis.
		@param dy Distance to move the camera along its local Y axis.
		@param cam_id ID of the camera game object. Uses the current camera by default.
	**/
	static function pan(dx:Float, dy:Float, ?cam_id:Hash):Void;

	/**
		Shakes the camera in its local X/Y plane. The intensity of the shake will fall off linearly over its duration.

		@param dist Radius of the shake.
		@param dur Duration of the shake in seconds.
		@param cam_id ID of the camera game object. Uses the current camera by default.
	**/
	static function shake(dist:Float, dur:Float, ?cam_id:Hash):Void;

	/**
		Recoils the camera by the supplied vector, local to the camera's rotation. The recoil will fall off quadratically (t^2) over its duration.

		@param vec Initial vector to offset the camera by, local to the camera's rotation.
		@param dur Duration of the recoil in seconds.
		@param cam_id ID of the camera game object. Uses the current camera by default.
	**/
	static function recoil(vec:Vector3, dur:Float, ?cam_id:Hash):Void;

	/**
		Cancels all current shakes and recoils for this camera.

		@param cam_id ID of the camera game object. Uses the current camera by default.
	**/
	static function stop_shaking(?cam_id:Hash):Void;

	/**
		Makes the camera follow a game object. Lerps by default (see `Rendercam.follow_lerp_func`). If you want the camera to rigidly follow a game object it is better to just make the camera a child of that object. Set `Rendercam.follow_lerp_speed` to adjust the global camera follow speed (default: 3). You can tell a camera to follow multiple game objects, in which case it will move toward the average of their positions. Note that the camera follow function only affects the camera's X and Y coordinates, so it only makes sense for 2D-oriented games.

		@param ID of the game object to follow.
		@param allowMultiFollow If true, will add target_id to the list of objects to follow instead of replacing all previous targets.
		@param cam_id ID of the camera game object. Uses the current camera by default.
	**/
	static function follow(target_id:Hash, ?allowMultiFollow:Bool, ?cam_id:Hash):Void;

	/**
		Makes the camera stop following a game object. If the camera was following multiple objects, this will remove target_id from the list, otherwise it will stop the camera from following anything.

		@param ID of the game object to unfollow.
		@param cam_id ID of the camera game object. Uses the current camera by default.
	**/
	static function unfollow(target_id:Hash, ?cam_id:Hash):Void;

	/**
		This is the default follow lerp function used by all cameras. Feel free to overwrite it if you need different behavior. If you need more complex control or different behavior for each camera, you should ignore Rendercam's follow feature and move your cameras directly, as you would any other game object.

		@param curPos The camera's current position, local to its parent.
		@param targetPos The average position of all follow targets---the exact position of the target if there is only one.
		@param dt Delta time for this frame.
	**/
	static var follow_lerp_func:(curPos:Vector3, targetPos:Vector3, dt:Float) -> Void;

	/**

	**/
	static var follow_lerp_speed:Float;

	/**
		Register a URL to be sent a message when the window is updated.

		@param url The URL. Note: If using a string, this must be an absolute URL including the socket.
	**/
	static function add_window_listener(url:UrlOrString):Void;

	/**
		Remove a URL from the list of window update listeners. If you added a listener, make sure you remove it before the script is destroyed.

		@param url The URL. This must be the same address and type that you passed to 'add_window_listener'. If you added a string, you must remove a string.
	**/
	static function remove_window_listener(url:UrlOrString):Void;

	/**
		Transforms `x` and `y` from screen coordinates to viewport coordinates. This only does something when you are using a fixed aspect ratio camera. Otherwise the viewport and the window are the same size. Called internally by `Rendercam.screen_to_world_ray` and `Rendercam.screen_to_world_2d`.

		@param x Screen X.
		@param y Screen Y.
		@param delta If `x` and `y` are for a delta (change in) screen position, rather than an absolute screen position.
	**/
	static function screen_to_viewport(x:Float, y:Float, ?delta:Bool):Vector2;

	/**
		Transforms x and y from screen coordinates to world coordinates at a certain Z position—either a specified worldz or by default the current camera's "2d World Z". This function returns a position on a plane perpendicular to the camera angle, so it's only accurate for 2D-oriented cameras (facing along the Z axis). It works for 2D-oriented perspective cameras, but will have some small imprecision based on the size of the view depth (farZ - nearZ). For 3D cameras, use rendercam.screen_to_world_plane or rendercam.screen_to_world_ray. Set the [raw] parameter to true to return raw x, y, and z values instead of a vector. This provides a minor performance improvement since returning a vector creates more garbage for the garbage collector.

		@param x Screen X.
		@param y Screen Y.
		@param delta If `x` and `y` are for a delta (change in) screen position, rather than an absolute screen position.
		@param worldz World Z position to find the X and Y coordinates at. Defaults to the current camera's "2d World Z" setting.
		@return The world position.
	**/
	static function screen_to_world_2d(x:Float, y:Float, ?delta:Bool, ?worldz:Float):Vector3;

	/**
		Takes `x` and `y` screen coordinates and returns two points describing the start and end of a ray from the camera's near plane to its far plane, through that point on the screen. You can use these points to cast a ray to check for collisions "underneath" the mouse cursor, or any other screen point. Set the [raw] parameter to true to return raw x, y, and z values instead of vectors. This provides a minor performance improvement since returning vectors creates more garbage for the garbage collector.

		@param x Screen X.
		@param y Screen Y.
		@return The ray start and end points on the camera plane, in world coordinates.
	**/
	static function screen_to_world_ray(x:Float, y:Float):Ray;

	/**
		Gets the screen-to-world ray and intersects it with a world-space plane. The equivalent of `Rendercam.screen_to_world_2d` for 3D cameras. Note: this will return `null` if the camera angle is exactly parallel to the plane (perpendicular to the normal).

		@param x Screen X.
		@param y Screen Y.
		@param planeNormal Normal vector of the plane.
		@param pointOnPlane A point on the plane.
	**/
	static function screen_to_world_plane(x:Float, y:Float, planeNormal:Vector3, pointOnPlane:Vector3):Vector3;

	/**
		Transforms `x` and `y` from screen coordinates to GUI coordinates. If the window size has changed and your GUI has "Adjust Reference" set to "Per Node", GUI coordinates will no longer match screen coordinates, and they will be different for each adjust mode.

		@param x Screen X.
		@param y Screen Y.
		@param adjust GUI adjust mode to use for calculation.
		@param isSize Optional argument. If the coordinates to be transformed are a node size rather than a position. False by default.
		@return The GUI position.
	**/
	static function screen_to_gui(x:Float, y:Float, adjust:GuiAdjustMode, isSize:Bool):Vector2;

	/**
		Transforms screen coordinates to coordinates that will work accurately with `Gui.pick_node`. If the window size has changed, the coordinate system used by `Gui.pick_node` will not match the screen coordinate system. If you are only picking nodes underneath a touch or the mouse cursor, you don't need this function, just use `action.x` and `action.y` in your `on_input` function. You will need this function to use `Gui.pick_node` with an arbitrary point on the screen (if the window has been changed from it's initial setting). The adjust mode of the GUI node does not matter.

		@param x Screen X.
		@param y Screen Y.
	**/
	static function screen_to_gui_pick(x:Float, y:Float):Vector2;

	/**
		Transforms the supplied world position into screen (viewport) coordinates. Can take an optional `adjust` parameter to calculate an accurate screen coordinate for a gui node with any adjust mode: Fit, Zoom, or Stretch. Set the [raw] parameter to true to return raw x, y, and z values instead of a vector. This provides a minor performance improvement since returning a vector creates more garbage for the garbage collector.

		@param pos World position.
		@param adjust GUI adjust mode to use for calculation.
		@return The screen position.
	**/
	static function world_to_screen(pos:Vector3, ?adjust:GuiAdjustMode):Vector3;
}

@:multiReturn extern class Vector2 {
	var x:Float;
	var y:Float;
}

@:multiReturn extern class Ray {
	var start:Vector3;
	var end:Vector3;
}
