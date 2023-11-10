package dex.wrappers;

import haxe.Exception;

import defold.types.HashOrString;
import defold.types.HashOrStringOrUrl;

import defold.Go;

import defold.Go.GoProperty;
import defold.Go.GoMessages;

import defold.Msg;

abstract Addressable(HashOrString) to HashOrStringOrUrl {
	public function new(path:HashOrStringOrUrl = ".") {
		this = path;
	}

	/**
		Gets a named property of the specified game object or component.

		@param id id of the property to retrieve
		@return the value of the specified property
	**/
	public inline function get(id:HashOrString):GoProperty {
		return Go.get(this, id);
	}

	/**
		Gets a named property of the specified game object or component.
		If the property does not exist or is `null`, this method returns `null`
		instead of throwing an exception.

		@param id id of the property to retrieve
		@return the value of the specified property
	**/
	public inline function tryGet(id:HashOrString):GoProperty {
		try {
			return Go.get(this, id);
		} catch (ex:Exception) {
			return null;
		}
	}

	/**
		Sets a named property of the specified game object or component.

		@param id id of the property to set
		@param value the value to set
	**/
	public inline function set(id:HashOrString, value:GoProperty) {
		Go.set(this, id, value);
	}

	public inline function enable() {
		Msg.post(this, GoMessages.enable);
	}

	public inline function disable() {
		Msg.post(this, GoMessages.disable);
	}
}
