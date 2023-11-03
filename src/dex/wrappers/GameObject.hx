package dex.wrappers;

import defold.Go;
import defold.Msg;
import defold.types.Hash;
import defold.types.HashOrString;
import defold.types.Message;
import defold.types.Url;
import dex.hashes.GameObjectProperties;
import dex.util.DexMath;
import dex.util.types.Vector2;
import dex.wrappers.Addressable;

using dex.util.extensions.Vector3Ex;


@:forward
abstract GameObject(Addressable) to Addressable to Hash from Hash
{
    public static inline function get(path: String = '.'): GameObject
    {
        return Msg.url(path);
    }

    /**
     * Gets the id of the object calling the method.
     *
     * Just a shorthand to calling `Go.get_id()`.
     *
     * @return the id of the game object
     */
    public static inline function self(): GameObject
    {
        return Go.get_id();
    }

    public inline function setParent(?parentId: GameObject, ?keepWorldTransform: Bool)
    {
        Go.set_parent(this, parentId, keepWorldTransform);
    }

    public inline function getParent(): GameObject
    {
        return Go.get_parent(this);
    }

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

    public inline function setScale(scaleX: Float, scaleY: Float)
    {
        Go.set(this, GameObjectProperties.scaleX, scaleX);
        Go.set(this, GameObjectProperties.scaleY, scaleY);
    }

    public inline function setScaleX(x: Float)
    {
        Go.set(this, GameObjectProperties.scaleX, x);
    }

    public inline function setScaleY(y: Float)
    {
        Go.set(this, GameObjectProperties.scaleY, y);
    }

    public inline function getScale(): Vector2
    {
        return Go.get_scale(this);
    }

    public inline function getScaleX(): Float
    {
        return Go.get(this, GameObjectProperties.scaleX);
    }

    public inline function getScaleY(): Float
    {
        return Go.get(this, GameObjectProperties.scaleY);
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

    public inline function acquireInputFocus()
    {
        Msg.post(this, GoMessages.acquire_input_focus);
    }

    public inline function releaseInputFocus()
    {
        Msg.post(this, GoMessages.release_input_focus);
    }

    public inline function message<T>(messageId: Message<T>, ?message: T)
    {
        Msg.post(this, messageId, message);
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

    /**
     * Returns a `Url` to the object's component with the given component id.
     */
    public inline function getComponent<T: Addressable>(componentId: HashOrString): T
    {
        // @TODO: fix this!
        var component: T = null;

        try
        {
            // this should work if this GameObject is a Hash
            component = cast Msg.url(null, this, componentId);
        }
        catch (e: Any)
        {
            // ... otherwise it's a Url
            var ownUrl: Url = cast this;
            component = cast Msg.url(ownUrl.socket, ownUrl.path, componentId);
        }

        return component;
    }

    public inline function delete(recursive: Bool = false)
    {
        Go.delete(this, recursive);
    }

    /**
     * Checks if the game object is not `null` and exists.
     *
     * @return `true` if the object exists, `false` if it is `null` or it has been deleted
     */
    public inline function exists(): Bool
    {
        return this != null && Go.exists(this);
    }

    /**
     * Checks if the game object is either `null` or `none`.
     */
    public inline function isNull(): Bool
    {
        return (this == null) || (this == none);
    }

    public static final none: GameObject = cast Defold.hash('');

    @:from
    static inline function fromUrl(url: Url): GameObject
    {
        return cast url;
    }
}
