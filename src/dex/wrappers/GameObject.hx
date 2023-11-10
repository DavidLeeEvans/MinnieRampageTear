package dex.wrappers;

import dex.util.types.Vector2;

import haxe.Exception;

import dex.wrappers.Sprite.DfSprite;

import defold.types.Url;
import defold.types.HashOrString;
import defold.types.HashOrStringOrUrl;
import defold.types.Hash;
import defold.types.Quaternion;

import haxe.extern.EitherType;

import defold.types.Vector3;

import defold.Vmath;
import defold.Go;

import defold.Go.GoMessages;

import defold.Msg;

using dex.util.extensions.Vector3Ex;

@:build(dex.util.HashBuilder.build())
class GameObjectProperties {
	var positionX = "position.x";
	var positionY = "position.y";
	var positionZ = "position.z";
	var scaleX = "scale.x";
	var scaleY = "scale.y";
	var scaleZ = "scale.z";
}

@:forward
abstract GameObject(Addressable) to HashOrStringOrUrl {
	public function new(path:HashOrStringOrUrl = ".") {
		this = new Addressable(path);
	}

	public static inline function ownId():Hash {
		return Go.get_id();
	}

	public inline function getId():Hash {
		return Go.get_id(this);
	}

	public inline function setParent(?parentId:HashOrStringOrUrl, ?keepWorldTransform:Bool) {
		Go.set_parent(this, parentId, keepWorldTransform);
	}

	public inline function getParent():GameObject {
		return cast Go.get_parent(this);
	}

	public inline function getPosition():Vector3 {
		return Go.get_position(this);
	}

	public inline function getPositionX():Float {
		return Go.get(this, GameObjectProperties.positionX);
	}

	public inline function getPositionY():Float {
		return Go.get(this, GameObjectProperties.positionY);
	}

	public inline function getPositionZ():Float {
		return Go.get(this, GameObjectProperties.positionZ);
	}

	/**
	 * Returns the `(x, y)` coordinates of the object.
	 */
	public inline function getPosition2D():Vector2 {
		return new Vector2(getPositionX(), getPositionY());
	}

	public inline function getWorldPosition():Vector3 {
		return Go.get_world_position(this);
	}

	public inline function setPosition(pos:Vector3) {
		Go.set_position(pos, this);
	}

	public inline function setPosition2D(v:Vector2) {
		setPositionX(v.x);
		setPositionY(v.y);
	}

	/**
	 * Moves the object to the given `(x, y)` coordinates
	 * while maintaining its position on the `z`-axis.
	 */
	public inline function setPositionXY(x:Float, y:Float) {
		setPositionX(x);
		setPositionY(y);
	}

	public inline function setPositionXYZ(x:Float, y:Float, z:Float) {
		setPositionX(x);
		setPositionY(y);
		setPositionZ(z);
	}

	public inline function setPositionX(x:Float) {
		Go.set(this, GameObjectProperties.positionX, x);
	}

	public inline function setPositionY(y:Float) {
		Go.set(this, GameObjectProperties.positionY, y);
	}

	public inline function setPositionZ(z:Float) {
		Go.set(this, GameObjectProperties.positionZ, z);
	}

	public inline function setScale(scaleX:Float, scaleY:Float) {
		Go.set(this, GameObjectProperties.scaleX, scaleX);
		Go.set(this, GameObjectProperties.scaleY, scaleY);
	}

	public inline function setScaleX(x:Float) {
		Go.set(this, GameObjectProperties.scaleX, x);
	}

	public inline function setScaleY(y:Float) {
		Go.set(this, GameObjectProperties.scaleY, y);
	}

	public inline function getScale():Vector3 {
		return Go.get_scale(this);
	}

	public inline function getScaleX():Float {
		return Go.get(this, GameObjectProperties.scaleX);
	}

	public inline function getScaleY():Float {
		return Go.get(this, GameObjectProperties.scaleY);
	}

	public inline function move(direction:Vector3, distance:Float) {
		if (direction.getLengthSquared() > 0) {
			direction.normalize();

			setPosition(getPosition() + (direction * distance));
		}
	}

	public inline function moveXY(moveX:Float, moveY:Float) {
		setPositionX(getPositionX() + moveX);
		setPositionY(getPositionY() + moveY);
	}

	public inline function moveAngle(angle:Float, distance:Float) {
		moveXY(distance * Math.cos(angle), distance * Math.sin(angle));
	}

	public inline function acquireInputFocus() {
		Msg.post(this, GoMessages.acquire_input_focus);
	}

	public inline function releaseInputFocus() {
		Msg.post(this, GoMessages.release_input_focus);
	}

	/**
	 * Sets the rotation of the object to a given angle in radians.
	 */
	public inline function setRotation(angle:Float) {
		Go.set_rotation(Vmath.quat_rotation_z(angle), this);
	}

	public inline function animate<T>(property:HashOrString, to:GoAnimatedProperty, duration:Float, ?delay:Float = 0, ?easing:GoEasing = cast 0,
			?playback:GoPlayback = cast 1, ?onComplete:(T, Url, GoAnimatedProperty) -> Void) {
		Go.animate(this, property, playback, to, easing, duration, delay, onComplete);
	}

	public inline function cancelAnimations(property:HashOrString) {
		Go.cancel_animations(this, property);
	}

	/**
	 * Returns a `Url` to the object's component with the given component id.
	 */
	public inline function getUrl(componentId:HashOrString):Url {
		return Msg.url(null, this, componentId);
	}

	/**
	 * Returns a `Url` to the object's component with the given component id.
	 */
	public inline function getComponent(componentId:HashOrString):Addressable {
		return cast Msg.url(null, this, componentId);
	}

	public inline function delete(recursive:Bool = false) {
		Go.delete(this, recursive);
	}

	/**
	 * Checks if the game object exists.
	 * @return `true` if the object exists, `false` if it has been deleted
	 */
	public inline function exists():Bool {
		try {
			Go.get_parent(this);
			return true;
		} catch (ex:Exception) {
			return false;
		}
	}

	public static final self:GameObject = new GameObject(".");
	public static final go:GameObject = new GameObject(".");
}
