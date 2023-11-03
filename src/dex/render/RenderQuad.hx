package dex.render;

import defold.Render.*;
import defold.Render;
import defold.types.Hash;
import dex.render.RenderTarget;


typedef RenderQuadData =
{
    var pred: RenderPredicate;
    var material: Hash;
}

/**
 * Wrapper for methods that render a specific quad predicate using a specific material.
 *
 * Specifically methods used for mixing render targets.
 */
abstract RenderQuad(RenderQuadData)
{
    /**
     * Create a new render quad.
     *
     * @param pred the predicate of the quad that should be drawn
     * @param material the material that should be used; note that this needs to have been added to the `.render` configuration
     */
    public function new(pred: RenderPredicate, material: Hash)
    {
        this =
        {
            pred: pred,
            material: material
        };
    }

    public function draw(rt: RenderTarget)
    {
        prepare();

        enable_material(this.material);

        rt.enableTexture(0, BUFFER_COLOR_BIT);
        Render.draw(this.pred);
        disable_texture(0);

        disable_material();
    }

    /**
     * Draw two render targets on the quad using the configured material.
     *
     * This method:
     * - Sets the view to identity.
     * - Sets the projection to identity.
     * - Clears to black.
     * - Draws both render targets on the quad predicate.
     *
     * @param rt0 the first render target
     * @param rt1 the second render target
     */
    public function drawTwo(rt0: RenderTarget, rt1: RenderTarget)
    {
        prepare();

        enable_material(this.material);

        rt0.enableTexture(0, BUFFER_COLOR_BIT);
        rt1.enableTexture(1, BUFFER_COLOR_BIT);
        Render.draw(this.pred);
        disable_texture(0);
        disable_texture(1);

        disable_material();
    }

    public function drawThree(rt0: RenderTarget, rt1: RenderTarget, rt2: RenderTarget)
    {
        prepare();

        enable_material(this.material);

        rt0.enableTexture(0, BUFFER_COLOR_BIT);
        rt1.enableTexture(1, BUFFER_COLOR_BIT);
        rt2.enableTexture(2, BUFFER_COLOR_BIT);
        Render.draw(this.pred);
        disable_texture(0);
        disable_texture(1);
        disable_texture(2);

        disable_material();
    }

    static inline function prepare()
    {
        set_view(RenderConstants.identity);
        set_projection(RenderConstants.identity);

        RenderUtil.setBlendMode();
    }
}
