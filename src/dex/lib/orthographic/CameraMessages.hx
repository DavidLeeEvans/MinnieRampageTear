package dex.lib.orthographic;

import dex.lib.orthographic.Camera.HashOrUrl;

import defold.types.Vector3;

@:build(defold.support.MessageBuilder.build())
class CameraMessages {
	/** Shake the camera. **/
	var shake:CameraMessageShake;

	/** Stop shaking the camera. **/
	var stop_shaking;

	/** Apply a recoil effect to the camera. The recoil will decay using linear interpolation. **/
	var recoil:CameraMessageRecoil;

	/** Message sent back to the sender of a `shake` message when the shake has completed. **/
	var shake_complete;

	/** Follow a game object. **/
	var follow:CameraMessageFollow;

	/** Stop following a game object. **/
	var unfollow;

	/** If following a game object this will add a deadzone around the camera position where the camera position will not update. If the target moves to the edge of the deadzone the camera will start to follow until the target returns within the bounds of the deadzone. **/
	var deadzone:CameraMessageDeadzone;

	/** Limits the camera position to within the specified rectangle. **/
	var bounds:CameraMessageBounds;

	/** Set the current zoom level of the camera. **/
	var zoom_to:CameraMessageZoomTo;

	/** Enable the camera. While the camera is enabled it will update its view and projection and send these to the render script. **/
	var enable;

	/** Disable the camera. **/
	var disable;

	/** Set which projection to use. **/
	var use_projection:CameraMessageUseProjection;
}

typedef CameraMessageShake = {
	/** Intensity of the shake, in percent of screen. Defaults to `0.05`. **/
	var ?intensity:Float;

	/** Duration of the shake, in seconds. Defaults to `0.5`. **/
	var ?duration:Float;

	/** Direction of the shake. Possible values: `both`, `horizontal`, `vertical`. Defaults to `both`. **/
	var ?direction:ShakeDirection;
}

typedef CameraMessageRecoil = {
	/** Offset to apply to the camera. Defaults to `0.05`. **/
	var ?offset:Vector3;

	/** Duration of the recoil, in seconds. Defaults to `0.5`. **/
	var ?duration:Float;
}

typedef CameraMessageFollow = {
	/** Game object to follow. **/
	var target:HashOrUrl;

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

typedef CameraMessageDeadzone = {
	/** Number of pixels to the left of the camera. **/
	var left:Float;

	/** Number of pixels above the camera.**/
	var top:Float;

	/** Number of pixels to the right of the camera. **/
	var right:Float;

	/** Number of pixels below the camera. **/
	var bottom:Float;
}

typedef CameraMessageBounds = CameraMessageDeadzone;

typedef CameraMessageZoomTo = {
	/** The new zoom level of the camera. **/
	var zoom:Float;
}

typedef CameraMessageUseProjection = {
	/** The projection to use. **/
	var projection:Projection;
}
