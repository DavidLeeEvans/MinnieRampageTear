package dex.components;

import dex.util.types.Vector2;
import dex.util.types.Vector2Int;
import dex.util.extensions.Vector3Ex;

import defold.Vmath;

import defold.types.Vector3;

import defold.support.ScriptOnInputAction;

import defold.types.Hash;

class Input2D extends ScriptComponent {
	/**
	 * X-axis move input.
	 * `-1` left, `+1` right
	 */
	public var x(get, never):Int;

	/**
	 * Y-axis move input.
	 * `-1` down, `+1` up
	 */
	public var y(get, never):Int;

	/**
	 * Move input as a 2D vector.
	 */
	public var vector(default, null):Vector2Int;

	/**
	 * Is `true` if there was move input during the last call to `onInput()`.
	 */
	public var hadMoveInput(default, null):Bool;

	/**
	 * The x-coordinate of the current mouse position.
	 */
	public var mouseX(get, never):Float;

	/**
	 * The y-coordinate of the current mouse position.
	 */
	public var mouseY(get, never):Float;

	/**
	 * The mouse position as a vector.
	 */
	public var mouse(default, null):Vector2;

	/**
	 * The mouse movement along the x-axis during the last frame.
	 */
	public var mouseDeltaX(get, never):Float;

	/**
	 * The mouse movement along the y-axis during the last frame.
	 */
	public var mouseDeltaY(get, never):Float;

	/**
	 * The mouse movement during the last frame as a vector.
	 */
	public var mouseDelta(default, null):Vector2;

	/**
	 * The length of the mouse movement during the last frame.
	 */
	public var mouseDeltaLength(get, never):Float;

	public var inputUp:Hash = Defold.hash("up");
	public var inputDown:Hash = Defold.hash("down");
	public var inputLeft:Hash = Defold.hash("left");
	public var inputRight:Hash = Defold.hash("right");

	var useScreenCoordinates:Bool;

	var prevMouseX:Float;
	var prevMouseY:Float;
	var changed:Bool;

	public function new(useScreenCoordinates:Bool = false) {
		super();

		this.useScreenCoordinates = useScreenCoordinates;

		reset();
	}

	public function reset() {
		vector = Vector2Int.zero;
		hadMoveInput = false;
		mouse = Vector2.zero;
		mouseDelta = Vector2.zero;
		prevMouseX = 0;
		prevMouseY = 0;
		changed = false;
	}

	override function onBeforeInput() {
		hadMoveInput = false;
	}

	public override function onInput(actionId:Hash, action:ScriptOnInputAction):Bool {
		if (actionId == inputUp) {
			if (action.pressed || vector.y == 0) {
				vector.y = 1;
				changed = true;
			} else if (action.released) {
				vector.y = 0;
				changed = true;
			}
			hadMoveInput = true;
		} else if (actionId == inputDown) {
			if (action.pressed || vector.y == 0) {
				vector.y = -1;
				changed = true;
			} else if (action.released) {
				vector.y = 0;
				changed = true;
			}
			hadMoveInput = true;
		} else if (actionId == inputLeft) {
			if (action.pressed || vector.x == 0) {
				vector.x = -1;
				changed = true;
			} else if (action.released) {
				vector.x = 0;
				changed = true;
			}
			hadMoveInput = true;
		} else if (actionId == inputRight) {
			if (action.pressed || vector.x == 0) {
				vector.x = 1;
				changed = true;
			} else if (action.released) {
				vector.x = 0;
				changed = true;
			}
			hadMoveInput = true;
		} else if (actionId == null) {
			prevMouseX = mouse.x;
			prevMouseY = mouse.y;

			if (useScreenCoordinates) {
				mouse.x = action.screen_x;
				mouse.y = action.screen_y;
			} else {
				mouse.x = action.x;
				mouse.y = action.y;
			}
		}

		mouseDelta.x = mouse.x - prevMouseX;
		mouseDelta.y = mouse.y - prevMouseY;

		return hadMoveInput;
	}

	/**
		Checks if the current input is different to when `wasChanged()` was last called.

		This does not include mouse movement.
	**/
	public inline function wasChanged():Bool {
		if (changed) {
			changed = false;
			return true;
		}
		{
			return false;
		}
	}

	inline function get_x():Int {
		return vector.x;
	}

	inline function get_y():Int {
		return vector.y;
	}

	inline function get_mouseX():Float {
		return mouse.x;
	}

	inline function get_mouseY():Float {
		return mouse.y;
	}

	inline function get_mouseDeltaX():Float {
		return mouseDelta.x;
	}

	inline function get_mouseDeltaY():Float {
		return mouseDelta.y;
	}

	inline function get_mouseDeltaLength():Float {
		return mouseDelta.length();
	}
}
