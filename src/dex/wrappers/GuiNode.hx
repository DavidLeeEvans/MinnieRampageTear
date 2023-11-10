package dex.wrappers;

import dex.util.DexUtils;

import defold.Go.GoAnimatedProperty;

import defold.types.Vector4;

import haxe.extern.EitherType;

import defold.support.ScriptOnInputAction;

import defold.types.Hash;
import defold.types.HashOrString;

import defold.Vmath;

import defold.types.Vector3;

import defold.Gui;

import dex.gui.InteractiveGuiNode;

using lua.Table;

typedef DfGuiNode = defold.Gui.GuiNode;

class GuiNode {
	var node:DfGuiNode;
	var parent:GuiNode;

	public function new(?id:HashOrString) {
		if (id != null) {
			node = Gui.get_node(id);
		}
	}

	public inline function getId():Hash {
		return Gui.get_id(node);
	}

	public inline function getPosition():Vector3 {
		return Gui.get_position(node);
	}

	public inline function getScreenPosition():Vector3 {
		return Gui.get_screen_position(node);
	}

	public inline function setPositionVec(v:Vector3) {
		Gui.set_position(node, v);
	}

	public inline function setPosition(x:Float, y:Float) {
		var pos:Vector3 = getPosition();
		Gui.set_position(node, Vmath.vector3(x, y, pos.z));
	}

	public inline function setPositionX(x:Float) {
		var pos:Vector3 = getPosition();
		Gui.set_position(node, Vmath.vector3(x, pos.y, pos.z));
	}

	public inline function setPositionY(y:Float) {
		var pos:Vector3 = getPosition();
		Gui.set_position(node, Vmath.vector3(pos.x, y, pos.z));
	}

	public inline function getSize():Vector3 {
		return Gui.get_size(node);
	}

	public inline function getWidth():Float {
		return Gui.get_size(node).x;
	}

	public inline function getHeight():Float {
		return Gui.get_size(node).y;
	}

	public inline function getScreenWidth():Float {
		var factor:Float = switch Gui.get_adjust_mode(node) {
			case ADJUST_ZOOM: Math.max(DexUtils.getGuiAdjustFactorWidth(), DexUtils.getGuiAdjustFactorHeight());

			case ADJUST_STRETCH: DexUtils.getGuiAdjustFactorWidth();

			case ADJUST_FIT: Math.min(DexUtils.getGuiAdjustFactorWidth(), DexUtils.getGuiAdjustFactorHeight());
		}

		return factor * getWidth();
	}

	public inline function getScreenHeight():Float {
		var factor:Float = switch Gui.get_adjust_mode(node) {
			case ADJUST_ZOOM: Math.max(DexUtils.getGuiAdjustFactorWidth(), DexUtils.getGuiAdjustFactorHeight());

			case ADJUST_STRETCH: DexUtils.getGuiAdjustFactorHeight();

			case ADJUST_FIT: Math.min(DexUtils.getGuiAdjustFactorWidth(), DexUtils.getGuiAdjustFactorHeight());
		}

		return factor * getHeight();
	}

	public inline function setSize(x:Float, y:Float) {
		Gui.set_size(node, Vmath.vector3(x, y, 0));
	}

	public inline function addSize(x:Float, y:Float) {
		var size:Vector3 = getSize();
		size.x += x;
		size.y += y;
		Gui.set_size(node, size);
	}

	public inline function move(dx:Float, dy:Float) {
		var pos:Vector3 = getPosition();
		Gui.set_position(node, Vmath.vector3(pos.x + dx, pos.y + dy, pos.z));
	}

	public inline function enable() {
		Gui.set_enabled(node, true);
	}

	public inline function disable() {
		Gui.set_enabled(node, false);
	}

	public inline function isEnabled():Bool {
		return Gui.is_enabled(node);
	}

	public inline function toggle():Bool {
		if (isEnabled()) {
			disable();
			return false;
		} else {
			enable();
			return true;
		}
	}

	public inline function pick(x:Float, y:Float):Bool {
		return Gui.pick_node(node, x, y);
	}

	public inline function delete() {
		return Gui.delete_node(node);
	}

	public inline function clone():GuiNode {
		var clone = switch Std.isOfType(this, InteractiveGuiNode) {
			case true: new InteractiveGuiNode(cast(this, InteractiveGuiNode).hoverScaleIncrease);
			case false: new GuiNode(null);
		}

		clone.node = Gui.clone(node);
		return clone;
	}

	public inline function cloneTree():Map<Hash, GuiNode> {
		var nodes:Map<Hash, GuiNode> = new Map<Hash, GuiNode>();

		var cloneTable:Table<Hash, DfGuiNode> = Gui.clone_tree(node);

		#if (haxe_ver >= 4.1)
		for (id => clonedNode in Table.toMap(cloneTable)) {
			var clone = new GuiNode(null);

			if (id == Gui.get_id(node) && Std.isOfType(this, InteractiveGuiNode)) {
				clone = new InteractiveGuiNode(cast(this, InteractiveGuiNode).hoverScaleIncrease);
			}

			clone.node = clonedNode;
			nodes.set(id, clone);
		}
		#else
		Table.foreach(cloneTable, (id:Hash, clonedNode:DfGuiNode) -> {
			var clone = new GuiNode(null);

			if (id == Gui.get_id(node) && Std.isOfType(this, InteractiveGuiNode)) {
				clone = new InteractiveGuiNode(cast(this, InteractiveGuiNode).hoverScaleIncrease);
			}

			clone.node = clonedNode;
			nodes.set(id, clone);
		});
		#end

		return nodes;
	}

	public inline function setTexture(textureId:HashOrString) {
		Gui.set_texture(node, textureId);
	}

	public inline function playFlipbook(animationId:HashOrString) {
		Gui.play_flipbook(node, animationId);
	}

	public inline function setParent(parent:GuiNode, ?keepSceneTransform:Bool) {
		Gui.set_parent(node, parent != null ? parent.node : null, keepSceneTransform);
	}

	public inline function getParent():GuiNode {
		if (parent == null) {
			parent = new GuiNode(null);
			parent.node = Gui.get_parent(node);
		}
		return parent;
	}

	public inline function setText(text:Any) {
		Gui.set_text(node, Std.string(text));
	}

	public inline function getText():String {
		return Gui.get_text(node);
	}

	public inline function getFillAngle():Float {
		return Gui.get_fill_angle(node);
	}

	public inline function setFillAngle(angle:Float) {
		Gui.set_fill_angle(node, Math.max(Math.min(angle, 360), 0));
	}

	public inline function incrementFillAngle(incr:Float) {
		setFillAngle(getFillAngle() + incr);
	}

	public inline function incrementScale(incr:Float) {
		var scale:Vector3 = Gui.get_scale(node);
		scale.x += incr;
		scale.y += incr;
		Gui.set_scale(node, scale);
	}

	public inline function setScale(x:Float, y:Float) {
		var scale:Vector3 = Gui.get_scale(node);
		scale.x = x;
		scale.y = y;
		Gui.set_scale(node, scale);
	}

	public inline function getScale():Vector3 {
		return Gui.get_scale(node);
	}

	public inline function setColor(r:Float, g:Float, b:Float, a:Float = 1) {
		Gui.set_color(node, Vmath.vector4(r, g, b, a));
	}

	public inline function setAlpha(alpha:Float) {
		Gui.set_alpha(node, alpha);
	}

	public inline function getAlpha():Float {
		return Gui.get_alpha(node);
	}

	public inline function animate<T>(property:String, to:GoAnimatedProperty, easing:GuiEasing, duration:Float, delay:Float = 0, ?callback:T->DfGuiNode->Void,
			?playback:GuiPlayback) {
		Gui.animate(node, property, to, easing, duration, delay, callback, playback);
	}

	public inline function cancelAnimation(property:String) {
		Gui.cancel_animation(node, property);
	}

	public inline function getTextMetrics():GuiTextMetrics {
		return Gui.get_text_metrics_from_node(node);
	}

	public inline function getTextMetricsForString(str:String):GuiTextMetrics {
		return Gui.get_text_metrics(Gui.get_font(node), str);
	}
}
