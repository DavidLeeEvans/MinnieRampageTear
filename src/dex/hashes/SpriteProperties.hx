package dex.hashes;

import defold.types.AtlasResourceReference;
import defold.types.Hash;
import defold.types.Vector3;
import defold.types.Vector4;


@:build(dex.macro.PropertyBuilder.build())
class SpriteProperties
{
    var tint: Vector4;
    var tintR: Float = "tint.x";
    var tintG: Float = "tint.y";
    var tintB: Float = "tint.z";
    var tintA: Float = "tint.w";
    var cursor: Float;
    var image: AtlasResourceReference;
    var sizeX: Float = "size.x";
    var sizeY: Float = "size.y";
    var scale: Vector3;
    var scaleX: Float = "scale.x";
    var scaleY: Float = "scale.y";
    var animation: Hash;
    var texture0: Hash;
}
