package dex;

import defold.support.ScriptOnInputAction;

import defold.types.Hash;
import defold.types.Url;
import defold.types.Message;

class ScriptComponent {
	@:allow(dex.ScriptComponentList)
	var componentList:ScriptComponentList;

	public function new() {}

	public function init() {}

	public function update(dt:Float) {}

	public function onMessage<TMessage>(messageId:Message<TMessage>, message:TMessage, sender:Url) {}

	public function onBeforeInput() {}

	public function onInput(actionId:Hash, action:ScriptOnInputAction):Bool {
		return false;
	}
}
