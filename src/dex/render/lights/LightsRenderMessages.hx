package dex.render.lights;

import defold.types.Vector4;


@:build(defold.support.MessageBuilder.build())
class LightsRenderMessages
{
    var set_ambient_light: SetAmbientLightMessage;
}

typedef SetAmbientLightMessage =
{
    var ambientLight: Vector4;
}
