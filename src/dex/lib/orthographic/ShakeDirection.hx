package dex.lib.orthographic;

import Defold.hash;

import defold.types.Hash;

@:enum
abstract ShakeDirection(Hash) {
	public var Both(get, never):Hash;

	inline function get_Both():Hash {
		return hash("both");
	}

	public var Horizontal(get, never):Hash;

	inline function get_Horizontal():Hash {
		return hash("horizontal");
	}

	public var Vertical(get, never):Hash;

	inline function get_Vertical():Hash {
		return hash("vertical");
	}
}
