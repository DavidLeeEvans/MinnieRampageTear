package dex.wrappers;

import defold.types.HashOrStringOrUrl;

import defold.Msg;
import defold.Vmath;

import lua.Table;

import haxe.extern.EitherType;

import defold.types.Hash;

import defold.Go.GoProperty;

import defold.types.Quaternion;
import defold.types.Vector3;

typedef DfFactory = defold.Factory;

@:forward
abstract Factory(Addressable) {
	public function new(path:HashOrStringOrUrl) {
		this = new Addressable(path);
	}

	public inline function createAt(x:Float, y:Float, z:Float = 0):GameObject {
		return create(Vmath.vector3(x, y, z));
	}

	/**
		Make a factory create a new game object.

		The URL identifies which factory should create the game object.
		If the game object is created inside of the frame (e.g. from an update callback), the game object will be created instantly,
		but none of its component will be updated in the same frame.

		Properties defined in scripts in the created game object can be overridden through the properties-parameter below.

		Calling `Factory.create` on a factory that is marked as dynamic without having loaded resources
		using `Factory.load` will synchronously load and create resources which may affect application performance.

		@param position the position of the new game object, the position of the game object calling `Factory.create()` is used by default, or if the value is `nil`
		@param rotation the rotation of the new game object, the rotation of the game object calling `Factory.create()` is used by default, or if the value is `nil`.
		@param properties the properties defined in a script attached to the new game object.
		@param scale the scale of the new game object (must be greater than 0), the scale of the game object containing the factory is used by default, or if the value is `nil`
		@return the global id of the spawned game object
	**/
	public inline function create(?position:Vector3, ?rotation:Quaternion, ?properties:Dynamic, ?scale:EitherType<Float, Vector3>):GameObject {
		var propsTable:Table<Hash, GoProperty> = null;

		if (properties != null) {
			propsTable = Table.fromDynamic(properties);
		}

		var objId:Hash = DfFactory.create(this, position, rotation, propsTable, scale);
		return new GameObject(objId);
	}
}
