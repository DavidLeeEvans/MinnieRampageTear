package dex.gui;

import defold.types.HashOrString;

import dex.wrappers.GuiNode;

/**
 * Abstract wrapper of a base `GuiNode`, that is initialized as disabled,
 * and only exposes the clone functions.
 */
@:forward(clone, cloneTree)
abstract GuiNodeTemplate(GuiNode) {
	public function new(?id:HashOrString) {
		this = new GuiNode(id);
		this.disable();
	}
}
