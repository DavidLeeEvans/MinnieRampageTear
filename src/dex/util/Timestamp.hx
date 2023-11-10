package dex.util;

/**
 * Abstract type representing a UNIX timestamp in seconds.
 */
abstract Timestamp(Float) to Float {
	public static var Zero(get, never):Timestamp;
	public static var Now(get, never):Timestamp;

	public inline function new() {
		reset();
	}

	/**
	 * Resets the timestamp to the current UNIX time.
	 */
	public inline function reset() {
		this = untyped __lua__("socket.gettime()");
	}

	/**
	 * Returns the elapsed time since the timestamp in seconds.
	 */
	public inline function elapsed():Float {
		return (untyped __lua__("socket.gettime()")) - this;
	}

	/**
	 * Returns `true` if more time has elapsed since this timestamp than the given timeout (in seconds).
	 * A timeout value less than or equal to `0` is considered infinite and will always return false.
	 */
	public inline function isTimedOut(timeout:Float):Bool {
		return timeout > 0 && elapsed() > timeout;
	}

	static inline function get_Zero():Timestamp {
		return cast(0.0, Timestamp);
	}

	static inline function get_Now():Timestamp {
		return new Timestamp();
	}
}
