package dex.topdown.components;

import dex.util.Timestamp;
import dex.util.DexMath;
import dex.util.types.Vector2;
import dex.util.types.Vector2Int;

import dex.wrappers.GameObject.go;

import defold.Vmath;

import defold.types.Vector3;

import dex.util.KinematicSeparator;

import defold.types.Message;
import defold.types.Url;

using dex.util.extensions.Vector3Ex;

class TopdownMover extends ScriptComponent {
	public var riseTime:Float = 0;
	public var fallTime:Float = 0;

	var inputDirection:Vector2;
	var speed:Float;

	var velocity:Vector2;

	public inline function setVelocity(velocityX:Float, velocityY:Float) {
		inputDirection.x = velocityX;
		inputDirection.y = velocityY;
		speed = inputDirection.length();
	}

	public inline function setDirection(dirX:Float, dirY:Float) {
		inputDirection.x = dirX;
		inputDirection.y = dirY;
	}

	public inline function setSpeed(speed:Float) {
		this.speed = speed;
	}

	override function init() {
		inputDirection = Vector2.zero;
		speed = 0;
		velocity = Vector2.zero;
	}

	override function update(dt:Float) {
		var kp:Float = 3;
		var weightX:Float = 0;
		if (velocity.x * inputDirection.x >= 0) {
			if (Math.abs(velocity.x) > Math.abs(inputDirection.x)) {
				weightX = kp * dt / riseTime;
			} else {
				weightX = kp * dt / fallTime;
			}
		} else {
			weightX = kp * dt / riseTime;
		}

		var weightY:Float = 0;
		if (velocity.y * inputDirection.y >= 0) {
			if (Math.abs(velocity.y) > Math.abs(inputDirection.y)) {
				weightY = kp * dt / riseTime;
			} else {
				weightY = kp * dt / fallTime;
			}
		} else {
			weightY = kp * dt / riseTime;
		}

		velocity.x = (1 - weightX) * velocity.x + weightX * inputDirection.x;
		velocity.y = (1 - weightY) * velocity.y + weightY * inputDirection.y;

		go.moveXY(velocity.x * speed * dt, velocity.y * speed * dt);
	}

	override function onMessage<TMessage>(messageId:Message<TMessage>, message:TMessage, sender:Url) {
		KinematicSeparator.separate(messageId, message);
	}
}
