package dex.render;

import defold.Vmath;
import defold.types.Matrix4;
import defold.types.Vector4;


class RenderConstants
{
    /** The white color. */
    public static final white: Vector4 = Vmath.vector4(1, 1, 1, 1);

    /** The black color. */
    public static final black: Vector4 = Vmath.vector4(0, 0, 0, 1);

    /** The transparent color. */
    public static final transparent: Vector4 = Vmath.vector4(0, 0, 0, 0);

    /** The identity matrix. */
    public static final identity: Matrix4 = Vmath.matrix4();
}
