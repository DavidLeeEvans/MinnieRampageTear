package dex.components;

import dex.hashes.GameObjectProperties;
import dex.scripts.CameraController;
import dex.util.DexUtils;
import dex.wrappers.GameObject;

/**
 * Component that will dynamically adjust the object's z-position according to its y-position,
 * so that objects higher on the display appear behind those that are lower.
 */
class DynamicDepth extends ScriptComponent
{
    final go: GameObject;
    final centerZ: Float;
    final halfRangeZ: Float;

    public function new(minZ: Float, maxZ: Float)
    {
        super();

        go = GameObject.self();
        centerZ = (maxZ + minZ) / 2;
        halfRangeZ = (maxZ - minZ) / 2;
    }

    override function init()
    {
    }

    override function update(dt: Float)
    {
        var posY: Float = go.getPositionY();
        var screenY: Float = CameraController.worldToScreenY(posY);
        var displayHeight: Float = DexUtils.getDisplayHeight();

        if (screenY < 0 || screenY > displayHeight)
        {
            // object not on the screen
            return;
        }

        var screenFromCenterY: Float = screenY - (displayHeight / 2);
        var screenFromCenterPercentY: Float = screenFromCenterY / (displayHeight / 2);

        var newZ: Float = centerZ - (screenFromCenterPercentY * halfRangeZ);

        go.set(GameObjectProperties.positionZ, newZ);
    }
}
