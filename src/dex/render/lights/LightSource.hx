package dex.render.lights;

import defold.Vmath;
import defold.support.Script;
import defold.types.Vector4;
import dex.hashes.GameObjectProperties;
import dex.wrappers.GameObject;


typedef LightSourceProperties =
{
    @property(1, 1, 1, 1) var color: Vector4;
    @property(256) var radius: Float;
    @property(360) var arcAngle: Float;
    @property(1) var falloff: Float;
    @property(false) var fixed: Bool;

    var light: Light;
    var go: GameObject;
}

/**
    x and y = upper semi-cirlce
    x = upper start (0 to 180)
    y = upper to (x to 180)

           +90
         y  |  x
          \ | /
           \|/
    +180 ---+--- 0


    z and w = lower semi-circle
    z = lower start (0 to -180)
    w = lower to (z to -180)

    -180 ---+--- 0
           /|\
          / | \
         w  |  z
           -90
**/
class LightSource extends Script<LightSourceProperties>
{
    override function init(self: LightSourceProperties)
    {
        self.go = GameObject.self();
        self.light = LightManager.addLight(self.go.getWorldPosition(), self.color, updateAngle(self), self.falloff, self.radius);
    }

    override function update(self: LightSourceProperties, dt: Float)
    {
        if (!self.fixed)
        {
            self.light.position = self.go.getWorldPosition();
            self.light.color = self.color;
            self.light.angle = updateAngle(self);
            self.light.falloff = self.falloff;
            self.light.setRadius(self.radius);
        }
    }

    override function final_(self: LightSourceProperties)
    {
        LightManager.removeLight(self.light);
    }

    static function updateAngle(self: LightSourceProperties): Vector4
    {
        var x: Float = 0;
        var y: Float = 0;
        var z: Float = 0;
        var w: Float = 0;
        var rotation = self.go.get(GameObjectProperties.eulerZ) % 360;
        var from: Float = rotation - (self.arcAngle / 2);
        var to: Float = rotation + (self.arcAngle / 2);
        if (from < 0)
        {
            z = 0;
            w = from;
            x = 0;
            y = to;
        }
        else if (from <= 180)
        {
            x = from;
            if (to > 180)
            {
                y = 180;
                w = -180;
                z = to - 360;
            }
            else
            {
                y = to;
                w = 0;
                z = 0;
            }
        }
        else if (from > 180)
        {
            w = from - 360;
            if (to > 360)
            {
                z = 0;
                x = 0;
                y = to - 360;
            }
            else
            {
                z = to - 360;
                x = 0;
                y = 0;
            }
        }

        return Vmath.vector4(lua.Math.rad(x), lua.Math.rad(y), lua.Math.rad(z), lua.Math.rad(w));
    }
}
