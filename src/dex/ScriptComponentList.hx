package dex;

import defold.support.ScriptOnInputAction;

import defold.types.Hash;
import defold.types.Url;
import defold.types.Message;

import dex.util.types.OneOfTwo;

abstract ScriptComponentList(Array<ScriptComponent>) from Array<ScriptComponent> {
	public inline function new(?components:Array<ScriptComponent>) {
		this = components != null ? components : new Array<ScriptComponent>();
	}

	@:op([])
	inline function getByIndex(i:Int):ScriptComponent {
		return this[i];
	}

	@:op([])
	inline function setByIndex(i:Int, component:OneOfTwo<Class<ScriptComponent>, ScriptComponent>):ScriptComponent {
		var componentInstance:ScriptComponent;

		if (Std.isOfType(component, ScriptComponent)) {
			componentInstance = cast(component, ScriptComponent);
		} else {
			componentInstance = Type.createInstance(component, []);
		}

		while (i >= this.length) {
			this.push(null);
		}

		this[i] = componentInstance;

		return this[i];
	}

	@:generic @:op([])
	inline function getByType<@:const T:ScriptComponent>(componentType:Class<T>):T {
		var foundComponent:T = null;
		for (component in this) {
			if (Std.isOfType(component, componentType)) {
				foundComponent = cast component;
				break;
			}
		}
		return cast foundComponent;
	}

	public function add(component:OneOfTwo<Class<ScriptComponent>, ScriptComponent>):ScriptComponent {
		var componentInstance:ScriptComponent;

		if (Std.isOfType(component, ScriptComponent)) {
			componentInstance = cast(component, ScriptComponent);
		} else {
			componentInstance = Type.createInstance(component, []);
		}

		this.push(componentInstance);

		componentInstance.componentList = this;

		return componentInstance;
	}

	public inline function init() {
		for (component in this) {
			component.init();
		}
	}

	public inline function update(dt:Float) {
		for (component in this) {
			component.update(dt);
		}
	}

	public inline function onMessage<TMessage>(messageId:Message<TMessage>, message:TMessage, sender:Url) {
		for (component in this) {
			component.onMessage(messageId, message, sender);
		}
	}

	public inline function onInput(actionId:Hash, action:ScriptOnInputAction):Bool {
		for (component in this) {
			component.onBeforeInput();
		}

		var ret:Bool = false;
		for (component in this) {
			ret = ret || component.onInput(actionId, action);
		}
		return ret;
	}
}
