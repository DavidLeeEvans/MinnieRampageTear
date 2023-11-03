package dex.hashes;

import defold.types.Quaternion;
import defold.types.Vector3;


@:build(dex.macro.PropertyBuilder.build())
class GameObjectProperties
{
    var position: Vector3;
    var positionX: Float = "position.x";
    var positionY: Float = "position.y";
    var positionZ: Float = "position.z";
    var scale: Vector3;
    var scaleX: Float = "scale.x";
    var scaleY: Float = "scale.y";
    var scaleZ: Float = "scale.z";
    var euler: Vector3;
    var eulerX: Float = "euler.x";
    var eulerY: Float = "euler.y";
    var eulerZ: Float = "euler.z";
    var rotation: Quaternion;
    var rotationX: Float = "rotation.x";
    var rotationY: Float = "rotation.y";
    var rotationZ: Float = "rotation.z";
    var rotationW: Float = "rotation.w";
}
