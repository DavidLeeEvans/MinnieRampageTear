package dex.util.types;

typedef Vector2IntData = {
	var x:Int;
	var y:Int;
}

@:forward
abstract Vector2Int(Vector2IntData) {
	public static var zero(get, never):Vector2Int;

	public inline function new(x:Int, y:Int) {
		this = {x: x, y: y};
	}

	public inline function length():Float {
		return Math.sqrt(lengthSquared());
	}

	public inline function lengthSquared():Float {
		return this.x * this.x + this.y * this.y;
	}

	@:to
	public inline function toString():String {
		return '${this.x}, ${this.y}';
	}

	@:to
	function toFloat():Vector2 {
		return new Vector2(this.x, this.y);
	}

	static function get_zero():Vector2Int {
		return new Vector2Int(0, 0);
	}

	@:op(a + b)
	static inline function add(a:Vector2Int, b:Vector2Int):Vector2Int {
		return new Vector2Int(a.x + b.x, a.y + b.y);
	}

	@:op(a + b) @:commutative
	static inline function addFloat(a:Vector2Int, b:Vector2):Vector2 {
		return new Vector2(a.x + b.x, a.y + b.y);
	}

	@:op(a + b) @:commutative
	static inline function addScalar(a:Vector2Int, b:Int):Vector2Int {
		return new Vector2Int(a.x + b, a.y + b);
	}

	@:op(a + b) @:commutative
	static inline function addScalarFloat(a:Vector2Int, b:Float):Vector2 {
		return new Vector2(a.x + b, a.y + b);
	}

	@:op(a - b)
	static inline function sub(a:Vector2Int, b:Vector2Int):Vector2Int {
		return new Vector2Int(a.x - b.x, a.y - b.y);
	}

	@:op(a - b)
	static inline function subFloat(a:Vector2Int, b:Vector2):Vector2 {
		return new Vector2(a.x - b.x, a.y - b.y);
	}

	@:op(a - b)
	static inline function subFloat2(a:Vector2, b:Vector2Int):Vector2 {
		return new Vector2(a.x - b.x, a.y - b.y);
	}

	@:op(a - b)
	static inline function subScalar(a:Vector2Int, b:Int):Vector2Int {
		return new Vector2Int(a.x - b, a.y - b);
	}

	@:op(a - b)
	static inline function subScalarFloat(a:Vector2Int, b:Float):Vector2 {
		return new Vector2(a.x - b, a.y - b);
	}

	@:op(a - b)
	static inline function subScalar2(a:Int, b:Vector2Int):Vector2Int {
		return new Vector2Int(a - b.x, a - b.y);
	}

	@:op(a - b)
	static inline function subScalarFloat2(a:Float, b:Vector2Int):Vector2 {
		return new Vector2(a - b.x, a - b.y);
	}

	@:op(-b)
	static inline function neg(a:Vector2Int):Vector2Int {
		return new Vector2Int(-a.x, -a.y);
	}

	@:op(a * b) @:commutative
	static inline function mulScalar(a:Vector2Int, b:Int):Vector2Int {
		return new Vector2Int(a.x * b, a.y * b);
	}

	@:op(a * b) @:commutative
	static inline function mulScalarFloat(a:Vector2Int, b:Float):Vector2 {
		return new Vector2(a.x * b, a.y * b);
	}

	@:op(a / b)
	static inline function divScalar(a:Vector2Int, b:Int):Vector2Int {
		return new Vector2Int(Std.int(a.x / b), Std.int(a.y / b));
	}

	@:op(a / b)
	static inline function divScalarFloat(a:Vector2Int, b:Float):Vector2 {
		return new Vector2(a.x / b, a.y / b);
	}

	@:op(a * b)
	static inline function mul(a:Vector2Int, b:Vector2Int):Vector2Int {
		return new Vector2Int(a.x * b.x, a.y * b.y);
	}
}
