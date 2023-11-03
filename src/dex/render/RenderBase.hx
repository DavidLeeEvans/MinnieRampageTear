package dex.render;

import defold.Render.*;
import defold.Render;
import defold.Sys;
import defold.Vmath;
import defold.support.RenderScript;
import defold.types.Matrix4;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector4;
import dex.render.RenderUtil.*;


typedef RenderBaseProperies =
{
    var projectionFn: (near: Float, far: Float, zoom: Float) -> Matrix4;
    var projection: Matrix4;
    var near: Float;
    var far: Float;
    var zoom: Float;

    /** Window width at the last update. */
    var windowWidth: Int;

    /** Window height at the last update. */
    var windowHeight: Int;

    var tilePred: RenderPredicate;
    var particlePred: RenderPredicate;
    var guiPred: RenderPredicate;
    var textPred: RenderPredicate;
    var clearColor: Vector4;
    var view: Matrix4;
}

/**
 * Base render class for making render scripts.
 * When extending this class, by default the `.render_script` generated will do the same
 * things as the default Defold render script (as of 1.4.2).
 *
 * To add custom rendering functionality, some of the following methods should be overriden:
 * - `initialize()`
 * - `render()`
 * - `onWindowResized()`
 */
class RenderBase<T: RenderBaseProperies> extends RenderScript<T>
{
    var self: T;

    final function fixedProjection(near: Float, far: Float, zoom: Float = 1): Matrix4
    {
        var projectedWidth: Float = get_window_width() / (zoom);
        var projectedHeight: Float = get_window_height() / (zoom);
        var xOffset: Float = -(projectedWidth - get_width()) / 2;
        var yOffset: Float = -(projectedHeight - get_height()) / 2;
        return Vmath.matrix4_orthographic(xOffset, xOffset + projectedWidth, yOffset, yOffset + projectedHeight, near, far);
    }

    final function fixedFitProjection(near: Float, far: Float, ?z: Float): Matrix4
    {
        var width: Float = get_width();
        var height: Float = get_height();
        var window_width: Float = get_window_width();
        var window_height: Float = get_window_height();
        var zoom: Float = Math.min(window_width / width, window_height / height);
        return fixedProjection(near, far, zoom);
    }

    inline function stretchProjection(near: Float, far: Float, ?z: Float)
    {
        return Vmath.matrix4_orthographic(0, get_width(), 0, get_height(), near, far);
    }

    inline function getProjection(): Matrix4
    {
        return self.projectionFn(self.near, self.far, self.zoom);
    }

    inline function clear()
    {
        RenderUtil.clear(self.clearColor);
    }

    override final function init(self: T)
    {
        this.self = self;
        self.tilePred = predicate('tile');
        self.particlePred = predicate('particle');
        self.guiPred = predicate('gui');
        self.textPred = predicate('text');

        self.clearColor = Vmath.vector4(
            Sys.get_config_number('render.clear_color_red', 0.0),
            Sys.get_config_number('render.clear_color_green', 0.0),
            Sys.get_config_number('render.clear_color_blue', 0.0),
            Sys.get_config_number('render.clear_color_alpha', 0.0)
        );

        self.view = RenderConstants.identity;

        self.near = -1;
        self.far = 1;
        self.zoom = 1;
        self.projectionFn = stretchProjection;

        self.windowWidth = get_window_width();
        self.windowHeight = get_window_height();

        initialize();
    }

    override final function update(self: T, dt: Float)
    {
        var windowWidth: Int = get_window_width();
        var windowHeight: Int = get_window_height();
        if (windowWidth == 0 || windowHeight == 0)
        {
            return;
        }

        // check if the window was resized
        if (windowWidth != self.windowWidth || windowHeight != self.windowHeight)
        {
            self.windowWidth = windowWidth;
            self.windowHeight = windowHeight;
            onWindowResized();
        }

        // call the render method
        render();
    }

    override function on_message<TMessage>(self: T, message_id: Message<TMessage>, message: TMessage, sender: Url)
    {
        switch message_id
        {
            case RenderMessages.clear_color:
                {
                    self.clearColor = message.color;
                }

            case RenderMessages.set_view_projection:
                {
                    self.view = message.view;
                    self.projection = message.projection;
                }

            case RenderMessages.use_camera_projection:
                {
                    self.projectionFn = (_, _, _) -> self.projection == null ? Vmath.matrix4() : self.projection;
                }

            case RenderMessages.use_stretch_projection:
                {
                    self.near = message.near == null ? -1 : message.near;
                    self.far = message.far == null ? 1 : message.far;
                    self.projectionFn = stretchProjection;
                }

            case RenderMessages.use_fixed_projection:
                {
                    self.near = message.near == null ? -1 : message.near;
                    self.far = message.far == null ? 1 : message.far;
                    self.zoom = message.zoom == null ? 1 : message.zoom;
                    self.projectionFn = fixedProjection;
                }

            case RenderMessages.use_fixed_fit_projection:
                {
                    self.near = message.near == null ? -1 : message.near;
                    self.far = message.far == null ? 1 : message.far;
                    self.projectionFn = fixedFitProjection;
                }

            default:
        }
    }

    /**
     * This method is called after the base class has been initialized.
     * Override it to add own initializations.
     */
    function initialize()
    {
    }

    /**
     * The main render method.
     * By default this method renders the same as the default Defold render script (as of 1.4.2).
     *
     * Override this to implement custom rendering.
     */
    function render()
    {
        // clear screen buffers
        set_depth_mask(true);
        set_stencil_mask(0xFF);
        clear();

        // render world - sprites, tilemaps, particles
        var proj: Matrix4 = getProjection();
        var frustum: Matrix4 = proj * self.view;

        set_viewport(0, 0, self.windowWidth, self.windowHeight);
        set_view(self.view);
        set_projection(proj);

        RenderUtil.setBlendMode();

        draw(self.tilePred, {frustum: frustum});
        draw(self.particlePred, {frustum: frustum});
        draw_debug3d();

        // render gui
        drawGui();
    }

    /**
     * Draws the `guiPred` and `textPred` predicates on the screen.
     * By default this method is called at the end of `render()`.
     */
    function drawGui()
    {
        var viewGui: Matrix4 = RenderConstants.identity;
        var projGui: Matrix4 = Vmath.matrix4_orthographic(0, self.windowWidth, 0, self.windowHeight, -1, 1);
        var frumstumGui: Matrix4 = projGui * viewGui;

        set_view(viewGui);
        set_projection(projGui);

        enable_state(STATE_STENCIL_TEST);
        draw(self.guiPred, {frustum: frumstumGui});
        draw(self.textPred, {frustum: frumstumGui});
        disable_state(STATE_STENCIL_TEST);
    }

    /**
     * Override this method to add update things when the window is resized.
     * E.g re-create render targets.
     */
    function onWindowResized()
    {
    }
}
