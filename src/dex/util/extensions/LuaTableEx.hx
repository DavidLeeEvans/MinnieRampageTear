package dex.util.extensions;

import lua.TableTools;

import defold.types.Hash;

import lua.Table;

class LuaTableEx {
	public static function get(table:Table<Hash, Hash>, key:Hash):Hash {
		#if (haxe_ver >= 4.1)
		for (k => v in Table.toMap(table)) {
			if (k == key) {
				return v;
			}
		}
		return null;
		#else
		var value:Hash = null;

		Table.foreach(table, (k:Hash, v:Hash) -> {
			if (k == key) {
				value = v;
			}
		});

		return value;
		#end
	}

	public static function forEach<K, V>(table:Table<K, V>, callback:(K, V) -> Void) {
		#if (haxe_ver >= 4.1)
		for (k => v in Table.toMap(table)) {
			callback(k, v);
		}
		return null;
		#else
		Table.foreach(table, (k:K, v:V) -> {
			callback(k, v);
		});
		#end
	}
}
