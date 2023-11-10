package dex.util.extensions;

import defold.Vmath;

import defold.types.Vector3;

/**
	Static extensions for Vector3 representing only 2D positions.
**/
class Vector3Ex {
	/**
		Returns the string (x, y) representation of the vector.
	**/
	public static inline function toString(v:Vector3) {
		return '(${v.x}, ${v.y})';
	}

	/**
		Returns the squared length of the vector's `x` and `y` components.
	**/
	public static inline function getLengthSquared(v:Vector3):Float {
		return (v.x * v.x) + (v.y * v.y);
	}

	/**
		Returns the length of the vector's `x` and `y` components.
	**/
	public static inline function getLength(v:Vector3):Float {
		return Math.sqrt(getLengthSquared(v));
	}

	/**
		Returns a new vector, which is the given vector normalized on the `x` and `y` components,
		with the `z` components left unchanged.
	**/
	public static inline function normalized(v:Vector3):Vector3 {
		var length:Float = getLength(v);
		if (length == 0) {
			return Vmath.vector3();
		} else {
			return Vmath.vector3(v.x / length, v.y / length, v.z);
		}
	}

	/**
		Normalizes and returns the given vector, on the `x` and `y` components,
		with the `z` components left unchanged.
	**/
	public static inline function normalize(v:Vector3):Vector3 {
		var length:Float = getLength(v);

		if (length != 0) {
			v.x = v.x / length;
			v.y = v.y / length;
		}

		return v;
	}

	/**
		Returns the vector's angle in radians.
	**/
	public static inline function getAngle(v:Vector3):Float {
		return Math.atan2(v.y, v.x);
	}

	public static inline function equals(v0:Vector3, v:Vector3, epsilon:Float = 1e-2):Bool {
		return Math.abs(v0.x - v.x) < epsilon && Math.abs(v0.y - v.y) < epsilon;
	}
}
