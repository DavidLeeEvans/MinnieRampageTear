package dex.hashes.camera;

import dex.types.CameraRecoil;
import dex.types.CameraShake;
import dex.util.types.Vector2;


@:build(defold.support.MessageBuilder.build())
class CameraMessages
{
    var acquire_camera_focus: Void;
    var move_to: MoveToMessage;
    var zoom_to: ZoomToMessage;
    var recoil: RecoilPositionMessage;
    var recoil_zoom: RecoilZoomMessage;
    var shake: ShakePositionMessage;
    var shake_zoom: ShakeZoomMessage;
}

typedef MoveToMessage =
{
    var center: Vector2;
    var animDuration: Float;
}

typedef ZoomToMessage =
{
    var zoom: Float;
    var animDuration: Float;
}

typedef RecoilPositionMessage = RecoilMessage &
{
    var direction: Vector2;
}

typedef RecoilZoomMessage = RecoilMessage;

typedef RecoilMessage =
{
    /** The type of recoil animation to perform. */
    var recoilType: CameraRecoil;

    /**
     * The magnitude of the recoil, i.e the maximum amount that the camera might move on either axis.
     * For the `recoil` message, this is a number of pixels, and for the `recoil_zoom` message this is zoom percentage.
     */
    var magnitude: Float;

    /** The duration of the recoil in seconds. */
    var duration: Float;
}

typedef ShakePositionMessage = ShakeMessage &
{
    /** Whether to shake on the x-axis. */
    var axisX: Bool;

    /** Whether to shake on the y-axis. */
    var axisY: Bool;
}

typedef ShakeZoomMessage = ShakeMessage;

typedef ShakeMessage =
{
    /** The type of shake animation to perform. */
    var shakeType: CameraShake;

    /**
     * The magnitude of the shake, i.e the maximum amount that the camera might move on either axis.
     * For the `shake` message, this is a number of pixels, and for the `shake_zoom` message this is zoom percentage.
     */
    var magnitude: Float;

    /** The duration of the shake in seconds. */
    var duration: Float;
}
