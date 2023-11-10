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

typedef DfCollectionFactory = defold.Collectionfactory;

@:forward
abstract CollectionFactory(Addressable) {
	public function new(path:HashOrStringOrUrl) {
		this = new Addressable(path);
	}

	public inline function createAt(x:Float, y:Float, z:Float = 0):Table<Hash, Hash> {
		return create(Vmath.vector3(x, y, z));
	}

	public inline function create(?position:Vector3, ?rotation:Quaternion, ?properties:Map<Hash, Dynamic>,
			?scale:EitherType<Float, Vector3>):Table<Hash, Hash> {
		for (key in properties.keys()) {
			properties.set(key, Table.fromDynamic(properties[key]));
		}

		return DfCollectionFactory.create(this, position, rotation, Table.fromMap(properties), scale);
	}
}
