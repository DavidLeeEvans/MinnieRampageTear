package dex.render.lights;

import defold.types.Vector3;
import defold.types.Vector4;
import linkedlist.LinkedListItem;
import dex.render.RenderTarget;


class Light implements LinkedListItem
{
    public var position: Vector3;
    public var color: Vector4;
    public var angle: Vector4;
    public var falloff: Float;
    public var radius(default, null): Float;

    @:allow(dex.render.lights.LightManager) var size(default, null): Int;
    @:allow(dex.render.lights.LightManager) var sizeChanged(default, null): Bool;
    @:allow(dex.render.lights.LightManager) var rtShadowmap: RenderTarget;
    @:allow(dex.render.lights.LightManager) var rtOccluder: RenderTarget;

    public function new()
    {
    }

    public function setRadius(radius: Float)
    {
        if (this.radius == radius)
        {
            return;
        }
        this.radius = radius;
        size = Math.ceil(radius * 2);
        sizeChanged = true;
    }

    public function updateRenderTargets(displayWidth: Int, displayHeight: Int)
    {
        if (rtShadowmap != null)
        {
            rtShadowmap.delete();
        }
        if (rtOccluder != null)
        {
            rtOccluder.delete();
        }

        rtShadowmap = RenderUtil.createRenderTarget(size, 1);
        rtOccluder = RenderUtil.createRenderTarget(displayWidth, displayHeight);
        sizeChanged = false;
    }
}
