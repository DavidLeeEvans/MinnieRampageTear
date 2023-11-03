package dex.components;

import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import dex.scripts.CameraController;
import dex.util.types.Vector2;

/**
 * Extension of the base `Input2D` class, which also uses the `Camera` statics to keep track of the mouse position
 * in world coordinates.
 */
class InputWithCamera2D extends Input2D
{
    /**
     * The world x-coordinate of the current mouse position.
     */
    public var mouseWorldX(get, never): Float;

    /**
     * The world y-coordinate of the current mouse position.
     */
    public var mouseWorldY(get, never): Float;

    /**
     * The mouse world position as a vector.
     */
    public var mouseWorld(default, null): Vector2;

    public function new(useScreenCoordinates: Bool = false)
    {
        super(useScreenCoordinates);

        mouseWorld = Vector2.zero;
    }

    override function update(dt: Float)
    {
        super.update(dt);

        // calculate the new screen position
        // @TODO: optimize this by doing it only when the camera was moved
        CameraController.screenToWorld(mouseX, mouseY, mouseWorld);
    }

    override function onInput(actionId: Hash, action: ScriptOnInputAction): Bool
    {
        // call the base implementation to update the inputs
        var hadInput: Bool = super.onInput(actionId, action);

        // calculate the new screen position
        // @TODO: optimize this by doing it only when the mouse was moved
        CameraController.screenToWorld(mouseX, mouseY, mouseWorld);

        return hadInput;
    }

    inline function get_mouseWorldX(): Float
    {
        return mouseWorld.x;
    }

    inline function get_mouseWorldY(): Float
    {
        return mouseWorld.y;
    }
}
