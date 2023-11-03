package dex.render.lights;

import Defold.hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector4;
import dex.render.RenderBase;


typedef MainRenderProperties = RenderBaseProperies &
{
    var shadowClip: RenderPredicate;
    var predOccluder: RenderPredicate;

    var quadRender: RenderQuad;
    var quadMultiply: RenderQuad;
    var quadClip: RenderQuad;
    var rtTile: RenderTarget;
    var rtShadowClip: RenderTarget;
    var rtLights: RenderTarget;
    var rtOccluder: RenderTarget;
    var ambientLight: Vector4;
}

class LightsRender extends RenderBase<MainRenderProperties>
{
    override function initialize()
    {
        self.shadowClip = predicate('shadow_clip');
        self.predOccluder = predicate('light_occluder');
        self.quadRender = new RenderQuad(predicate('quad'), hash('quad'));
        self.quadMultiply = new RenderQuad(predicate('quad'), hash('multiply_quad'));
        self.quadClip = new RenderQuad(predicate('quad'), hash('shadow_clip_quad'));

        self.rtTile = createRenderTarget(self.windowWidth, self.windowHeight);
        self.rtShadowClip = createRenderTarget(self.windowWidth, self.windowHeight);
        self.rtLights = createRenderTarget(self.windowWidth, self.windowHeight);
        self.rtOccluder = createRenderTarget(self.windowWidth, self.windowHeight);

        self.ambientLight = RenderConstants.white;

        LightManager.init();
    }

    override function render()
    {
        // render world - sprites, tilemaps, particles
        var proj: Matrix4 = getProjection();
        var frustum: Matrix4 = proj * self.view;

        // clear screen buffers
        set_depth_mask(true);
        set_stencil_mask(0xFF);
        clear();

        set_viewport(0, 0, self.windowWidth, self.windowHeight);
        set_view(self.view);
        set_projection(proj);

        setBlendMode();

        self.rtTile.render(() ->
        {
            clear();

            set_view(self.view);
            set_projection(proj);

            RenderUtil.setBlendMode();

            draw(self.tilePred, {frustum: frustum});
            draw(self.particlePred, {frustum: frustum});
        });
        self.rtShadowClip.render(() ->
        {
            clear();

            set_view(self.view);
            set_projection(proj);

            RenderUtil.setBlendMode();

            draw(self.shadowClip, {frustum: frustum});
        });
        self.rtOccluder.render(() ->
        {
            RenderUtil.clear(RenderConstants.transparent);

            set_view(self.view);
            set_projection(proj);

            RenderUtil.setBlendMode();

            draw(self.predOccluder, {frustum: frustum});
            draw_debug3d();
        });

        LightManager.render(self.rtLights, self.ambientLight, self.view, proj);

        clear();
        self.quadRender.draw(self.rtOccluder);
        self.quadMultiply.drawTwo(self.rtTile, self.rtLights);
        self.quadClip.drawTwo(self.rtShadowClip, self.rtLights);


        drawGui();
    }

    override function onWindowResized()
    {
        self.rtTile.setSize(self.windowWidth, self.windowHeight);
        self.rtShadowClip.setSize(self.windowWidth, self.windowHeight);
        self.rtLights.setSize(self.windowWidth, self.windowHeight);
        self.rtOccluder.setSize(self.windowWidth, self.windowHeight);

        LightManager.onWindowResized(self.windowWidth, self.windowHeight);
    }

    override function on_message<TMessage>(self: MainRenderProperties, message_id: Message<TMessage>, message: TMessage, sender: Url)
    {
        super.on_message(self, message_id, message, sender);

        switch message_id
        {
            case LightsRenderMessages.set_ambient_light:
                {
                    self.ambientLight = message.ambientLight;
                }

            default:
        }
    }
}
