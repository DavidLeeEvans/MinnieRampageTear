package dex.gui;

import Defold.hash;

import defold.types.Hash;

import defold.support.ScriptOnInputAction;

import dex.wrappers.GuiNode;

class InteractiveGuiNode extends GuiNode {
	public var hoverScaleIncrease(default, null):Float;
	public var hovered(default, null):Bool;
	public var held(default, null):Bool;

	public var onHover(null, default):() -> Void;
	public var onHoverEnd(null, default):() -> Void;
	public var onPress(null, default):() -> Void;

	var touchAction:Hash;
	var disabled:Bool;

	public function new(?id:String, ?touchAction:Hash, hoverScaleIncrease:Float = 0.4) {
		super(id);

		if (touchAction == null) {
			touchAction = hash("touch");
		}

		this.touchAction = touchAction;
		this.hoverScaleIncrease = hoverScaleIncrease;

		hovered = false;
		held = false;
		disabled = false;
	}

	/**
	 * Performs the action check on the interractive node.
	 *
	 * @return `true` if input was captured by the node, `false` otherwise.
	 */
	public function onInput(action_id:Hash, action:ScriptOnInputAction):Bool {
		if (!isEnabled() || disabled)
			return false;

		var captured:Bool = false;

		var isInteraction:Bool = (action_id == touchAction) // Single touch.
			|| (action_id == null) // Mouse movement.
			|| (action.touch != null); // Multi-touch

		if (isInteraction && pick(action.x, action.y)) {
			if (!hovered) {
				incrementScale(hoverScaleIncrease);
				hovered = true;

				if (onHover != null)
					onHover();
			}

			if (action.pressed) {
				held = true;
				captured = true;
			} else if (held && action.released) {
				if (onPress != null)
					onPress();
				captured = true;
			}
		} else if (isInteraction) {
			cancelHover();
		}

		return captured;
	}

	public function enableInteraction() {
		disabled = false;
	}

	public function disableInteraction() {
		disabled = true;
		cancelHover();
	}

	function cancelHover() {
		if (hovered) {
			incrementScale(-hoverScaleIncrease);
			hovered = false;

			if (onHoverEnd != null)
				onHoverEnd();
		}

		if (held) {
			held = false;
		}
	}
}
