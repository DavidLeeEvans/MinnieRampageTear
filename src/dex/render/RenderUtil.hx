package dex.render;

import haxe.Rest;
import lua.Table;
import defold.Render.*;
import defold.Render;
import defold.types.HashOrString;
import defold.types.Vector4;
import dex.render.RenderTarget;


class RenderUtil
{
    public static function createRenderTarget(width: Int, height: Int): dex.render.RenderTarget
    {
        @:keep var w = width;
        @:keep var h = height;

        untyped __lua__(
            '
            local colorParams = {
                format = render.FORMAT_RGBA,
                width = w,
                height = h,
                min_filter = render.FILTER_LINEAR,
                mag_filter = render.FILTER_LINEAR,
                u_wrap = render.WRAP_CLAMP_TO_EDGE,
                v_wrap = render.WRAP_CLAMP_TO_EDGE
            }
            local depthParams = {
                format = render.FORMAT_DEPTH,
                width = w,
                height = h,
                min_filter = render.FILTER_LINEAR,
                mag_filter = render.FILTER_LINEAR,
                u_wrap = render.WRAP_CLAMP_TO_EDGE,
                v_wrap = render.WRAP_CLAMP_TO_EDGE
            }'
        );

        return untyped __lua__('render.render_target({[render.BUFFER_COLOR_BIT] = colorParams, [render.BUFFER_DEPTH_BIT] = depthParams })');
    }

    public static inline function predicate(tags: Rest<HashOrString>): RenderPredicate
    {
        return Render.predicate(Table.fromArray(tags));
    }

    public static inline function clear(color: Vector4)
    {
        Render.clear(Table.fromMap([ RenderBufferType.BUFFER_COLOR_BIT => color ]));
    }

    /**
     * Function to be called before drawing game objects.
     *
     * - Disables the depth mask.
     * - Disables states `DEPTH_TEST`, `STENCIL_TEST`, and `CULL_FACE`.
     * - Enables state `BLEND`.
     * - Sets blend func to `SRC_ALPHA`.
     */
    public static inline function setBlendMode()
    {
        set_depth_mask(false);
        disable_state(STATE_DEPTH_TEST);
        disable_state(STATE_STENCIL_TEST);
        disable_state(STATE_CULL_FACE);
        enable_state(STATE_BLEND);
        set_blend_func(BLEND_SRC_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA);
    }
}
