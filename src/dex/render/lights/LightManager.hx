package dex.render.lights;

import defold.types.Vector3;
import defold.types.Vector4;
import linkedlist.LinkedList;
import dex.render.RenderUtil;


class LightManager
{
    static var lights: LinkedList<Light>;
    static var occluderPred: RenderPredicate;

    static var pred: RenderPredicate;

    public static function init()
    {
        lights = new LinkedList();

        occluderPred = RenderUtil.predicate('light_occluder');

        pred = RenderUtil.predicate('light_quad');
    }

    public static function addLight(position: Vector3, color: Vector4, angle: Vector4, falloff: Float, radius: Float): Light
    {
        var light: Light = new Light();
        light.position = position;
        light.color = color;
        light.angle = angle;
        light.falloff = falloff;
        light.setRadius(radius);

        lights.push(light);

        return light;
    }

    public static function removeLight(light: Light)
    {
        lights.remove(light);
    }

    public static function onWindowResized(displayWidth: Int, displayHeight: Int)
    {
        for (light in lights)
        {
            light.updateRenderTargets(displayWidth, displayHeight);
        }
    }

    public static function render(rt: RenderTarget, ambientLight: Vector4, view: Matrix4, projection: Matrix4)
    {
        rt.render(() -> RenderUtil.clear(ambientLight));

        for (light in lights)
        {
            if (light.sizeChanged)
            {
                light.updateRenderTargets(rt.getWidth(), rt.getHeight());
            }

            drawOccluder(light, view, projection);
            drawShadowMap(light);
            drawLight(rt, light, view, projection);
        }
    }

    static function drawOccluder(light: Light, view: Matrix4, projection: Matrix4)
    {
        light.rtOccluder.setSize(light.size, light.size);

        set_viewport(0, 0, light.size, light.size);

        set_projection(Vmath.matrix4_orthographic(0, light.size, 0, light.size, -5, 5));

        set_view(
            Vmath.matrix4_look_at(
                Vmath.vector3(-light.radius, -light.radius, 0) + light.position,
                Vmath.vector3(-light.radius, -light.radius, -1) + light.position,
                Vmath.vector3(0, 1, 0)
            )
        );

        light.rtOccluder.render(() ->
        {
            RenderUtil.clear(RenderConstants.transparent);

            RenderUtil.setBlendMode();

            draw(occluderPred);
        });
    }

    static function drawShadowMap(light: Light)
    {
        light.rtShadowmap.render(() ->
        {
            set_viewport(0, 0, light.size, 1);
            set_projection(Vmath.matrix4_orthographic(0, light.size, 0, 1, -1, 1));

            set_view(
                Vmath.matrix4_look_at(Vmath.vector3(-light.radius, -light.radius, 0), Vmath.vector3(-light.radius, -light.radius, -1), Vmath.vector3(0, 1, 0))
            );

            RenderUtil.clear(RenderConstants.transparent);

            enable_material('shadow_map');
            light.rtOccluder.enableTexture(0);

            var constants: RenderConstantBuffer = constant_buffer();
            constants.resolution = Vmath.vector4(0, light.size, 0, 0);
            constants.size = Vmath.vector4(light.size, light.size, 1, 0);
            draw(pred, {constants: constants});

            disable_texture(0);
            disable_material();
        });
    }

    static function drawLight(rt: RenderTarget, light: Light, view: Matrix4, projection: Matrix4)
    {
        rt.render(() ->
        {
            set_viewport(0, 0, get_window_width(), get_window_height());
            set_projection(projection);
            set_view(view);

            light.rtShadowmap.enableTexture(0);

            var constants: RenderConstantBuffer = constant_buffer();
            constants.light_pos = Vmath.vector4(light.position.x, light.position.y, light.position.z, 0);
            constants.size = Vmath.vector4(light.size, 0, 0, 0);
            constants.color = light.color;
            constants.falloff = Vmath.vector4(light.falloff, 0, 0, 0);
            constants.angle = Vmath.vector4(light.angle.x, light.angle.y, light.angle.z, light.angle.w);

            draw(pred, {constants: constants});

            disable_texture(0);
        });
    }
}
