package dex.hashes.camera;

import defold.types.Vector3;


@:build(dex.macro.PropertyBuilder.build())
class CameraProperties
{
    var center: Vector3;
    var centerX: Float = 'center.x';
    var centerY: Float = 'center.y';
    var zoom: Float;
    var zoomShake: Float;
    var positionShake: Vector3;
    var positionShakeX: Float = 'positionShake.x';
    var positionShakeY: Float = 'positionShake.y';
}
