package dex.render;

import lua.Table;
import defold.Render;


abstract RenderTarget(defold.Render.RenderTarget) from defold.Render.RenderTarget to defold.Render.RenderTarget
{
    public static var none(get, never): RenderTarget;

    /**
     * Shorthand to enabling the default render target.
     */
    public static inline function reset()
    {
        Render.set_render_target(none);
    }

    public inline function enable(?options: SetRenderTargetOptions)
    {
        if (options == null)
        {
            Render.set_render_target(this,
                {
                    transient: Table.fromArray([ BUFFER_DEPTH_BIT ])
                });
        }
        else
        {
            Render.set_render_target(this, options);
        }
    }

    public inline function disable()
    {
        Render.set_render_target(none);
    }

    public inline function setSize(width: Int, height: Int)
    {
        Render.set_render_target_size(this, width, height);
    }

    public inline function getWidth(bufferType: RenderBufferType = BUFFER_COLOR_BIT): Int
    {
        return Render.get_render_target_width(this, bufferType);
    }

    public inline function getHeight(bufferType: RenderBufferType = BUFFER_COLOR_BIT): Int
    {
        return Render.get_render_target_height(this, bufferType);
    }

    public inline function enableTexture(unit: Int, bufferType: RenderBufferType = BUFFER_COLOR_BIT)
    {
        Render.enable_texture(unit, this, bufferType);
    }

    public inline function delete()
    {
        Render.delete_render_target(this);
    }

    /**
     * Calls the given render function on this render target.
     *
     * Shorthand to enabling the render target, calling `fn()`, and disabling it again.
     *
     * @param fn the render function with its draw operations
     */
    public inline function render(fn: () -> Void)
    {
        enable();
        fn();
        disable();
    }

    static inline function get_none(): RenderTarget
    {
        return Render.RENDER_TARGET_DEFAULT;
    }
}
