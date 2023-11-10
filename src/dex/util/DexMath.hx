package dex.util;

class DexMath {
	public static inline var eps:Float = 1e-4;

	public static inline function maxInt(a:Int, b:Int):Int {
		return a > b ? a : b;
	}

	public static inline function minInt(a:Int, b:Int):Int {
		return a < b ? a : b;
	}
}
