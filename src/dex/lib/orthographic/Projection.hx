package dex.lib.orthographic;

import Defold.hash;

import defold.types.Hash;

@:enum
abstract Projection(Hash) {
	/**
		The default projection uses the same orthographic projection matrix as in the default render script (ie aspect ratio isn't maintained and content is stretched).
	**/
	public var Default(get, never):Hash;

	inline function get_Default():Hash {
		return hash("DEFAULT");
	}

	/**
		A fixed aspect ratio projection that automatically zooms in/out to fit the original viewport contents regardless of window size.
	**/
	public var FixedAuto(get, never):Hash;

	inline function get_FixedAuto():Hash {
		return hash("FIXED_AUTO");
	}

	/**
		A fixed aspect ratio projection with zoom.
	**/
	public var FixedZoom(get, never):Hash;

	inline function get_FixedZoom():Hash {
		return hash("FIXED_ZOOM");
	}
}
