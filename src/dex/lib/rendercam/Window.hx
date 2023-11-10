package dex.lib.rendercam;

import defold.types.Vector3;

typedef Window = {
	/** The same as `Rendercam.window`. The new size of the window. **/
	var window:Vector3;

	/** The same as `Rendercam.viewport`. **/
	var viewport:Viewport;

	/** The aspect ratio of the camera. **/
	var aspect:Float;

	/** The field of view of the camera in radians. Should be `-1` for orthographic cameras. **/
	var fov:Float;
}
