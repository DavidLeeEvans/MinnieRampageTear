package dex.wrappers;

import defold.Go;
import defold.types.Hash;
import dex.hashes.GameObjectProperties;
import dex.util.DexMath;
import dex.util.types.Vector2;
import dex.wrappers.Addressable;


@:forward
abstract Positionable(Addressable) to Addressable to Hash
{
    public inline function getPosition(): Vector2
    {
        return Go.get_position(this);
    }

    public inline function getPositionX(): Float
    {
        return Go.get(this, GameObjectProperties.positionX);
    }

    public inline function getPositionY(): Float
    {
        return Go.get(this, GameObjectProperties.positionY);
    }

    public inline function getPositionZ(): Float
    {
        return Go.get(this, GameObjectProperties.positionZ);
    }

    public inline function getWorldPosition(): Vector2
    {
        return Go.get_world_position(this);
    }

    public inline function setPosition(pos: Vector2)
    {
        Go.set_position(pos, this);
    }

    /**
     * Moves the object to the given `(x, y)` coordinates
     * while maintaining its position on the `z`-axis.
     */
    public inline function setPositionXY(x: Float, y: Float)
    {
        setPositionX(x);
        setPositionY(y);
    }

    public inline function setPositionXYZ(x: Float, y: Float, z: Float)
    {
        setPositionX(x);
        setPositionY(y);
        setPositionZ(z);
    }

    public inline function setPositionX(x: Float)
    {
        Go.set(this, GameObjectProperties.positionX, x);
    }

    public inline function setPositionY(y: Float)
    {
        Go.set(this, GameObjectProperties.positionY, y);
    }

    public inline function setPositionZ(z: Float)
    {
        Go.set(this, GameObjectProperties.positionZ, z);
    }

    public inline function move(direction: Vector2, distance: Float)
    {
        setPosition(getPosition() + (direction * distance));
    }

    public inline function moveXY(moveX: Float, moveY: Float)
    {
        setPositionX(getPositionX() + moveX);
        setPositionY(getPositionY() + moveY);
    }

    public inline function moveAngle(angle: Float, distance: Float)
    {
        moveXY(distance * Math.cos(angle), distance * Math.sin(angle));
    }

    /**
     * Sets the rotation of the object to a given angle in radians.
     */
    public inline function setRotation(angle: Float)
    {
        Go.set(this, GameObjectProperties.eulerZ, angle * DexMath.radToDeg);
    }

    /**
     * Get the rotation of the object in radians,
     */
    public inline function getRotation(): Float
    {
        return Go.get(this, GameObjectProperties.eulerZ) * DexMath.degToRad;
    }
}
