package dex.util.types;

import defold.Vmath;

import defold.types.Vector3;

typedef Vector2Data = {
	var x:Float;
	var y:Float;
}

@:forward
abstract Vector2(Vector2Data) {
	public static var zero(get, never):Vector2;

	public inline function new(x:Float, y:Float) {
		this = {x: x, y: y};
	}

	public inline function round():Vector2Int {
		return new Vector2Int(Math.round(this.x), Math.round(this.y));
	}

	public inline function ceil():Vector2Int {
		return new Vector2Int(Math.ceil(this.x), Math.ceil(this.y));
	}

	public inline function floor():Vector2Int {
		return new Vector2Int(Math.floor(this.x), Math.floor(this.y));
	}

	public inline function length():Float {
		return Math.sqrt(lengthSquared());
	}

	public inline function lengthSquared():Float {
		return this.x * this.x + this.y * this.y;
	}

	public inline function toVector3():Vector3 {
		return Vmath.vector3(this.x, this.y, 0);
	}

	@:to
	public inline function toString():String {
		return '${this.x}, ${this.y}';
	}

	static function get_zero():Vector2 {
		return new Vector2(0, 0);
	}

	@:op(a + b)
	static inline function add(a:Vector2, b:Vector2):Vector2 {
		return new Vector2(a.x + b.x, a.y + b.y);
	}

	@:op(a + b)
	static inline function addScalar(a:Vector2, b:Float):Vector2 {
		return new Vector2(a.x + b, a.y + b);
	}

	@:op(a - b)
	static inline function sub(a:Vector2, b:Vector2):Vector2 {
		return new Vector2(a.x - b.x, a.y - b.y);
	}

	@:op(a - b)
	static inline function subScalaer(a:Vector2, b:Float):Vector2 {
		return new Vector2(a.x - b, a.y - b);
	}

	@:op(-b)
	static inline function neg(a:Vector2):Vector2 {
		return new Vector2(-a.x, -a.y);
	}

	@:op(a * b) @:commutative
	static inline function mulScalar(a:Vector2, b:Float):Vector2 {
		return new Vector2(a.x * b, a.y * b);
	}

	@:op(a / b)
	static inline function divScalar(a:Vector2, b:Float):Vector2 {
		return new Vector2(a.x / b, a.y / b);
	}

	@:op(a * b)
	static inline function mul(a:Vector2, b:Vector2):Vector2 {
		return new Vector2(a.x * b.x, a.y * b.y);
	}
}
