package dex.platformer;

@:enum
abstract Animations(Int) from Int to Int {
	var Idle = 1 << 0;
	var Walk = 1 << 1;
	var Jump = 1 << 2;
	var Roll = 1 << 3;
	var Fall = 1 << 4;
	var Run = 1 << 5;
	var All = 0xFFFF;

	@:op(A + B)
	public inline function add(a:Animations):Animations {
		return cast(this, Int) | cast(a, Int);
	}

	@:op(A - B)
	public inline function clear(a:Animations):Animations {
		return cast(this, Int) & ~cast(a, Int);
	}

	@:op(A | B)
	public inline function bitwiseOr(a:Animations):Animations {
		return cast(this, Int) | cast(a, Int);
	}

	@:op(A & B)
	public inline function bitwiseAnd(a:Animations):Bool {
		return cast(this, Int) & cast(a, Int) > 0;
	}

	@:op(~A)
	public inline function bitwiseNot():Animations {
		return ~cast(this, Int);
	}
}
