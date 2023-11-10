package dex.systems;

/**
 * Static time-tracking system, offering certain convenient features statically throughout the entire project.
 */
class Time {
	/**
	 * A number which gets incremented at the beginning of every update() cycle.
	 * This value should not be used as a number, it is only meant to be stored and
	 * compared by sections which should not be executed more than once per cycle.
	 */
	public static var cycle:Int = 0;

	static var lastElapsed:Float = 0;

	static var totalElapsed:Float = 0;

	/**
	 * Initializes the time system.
	 * Should be called once, when a scene is initialized.
	 */
	public static function init() {
		cycle = 0;
		lastElapsed = 0;
		totalElapsed = 0;
	}

	/**
	 * Update the time system. Should be called once every update cycle.
	 *
	 * @param dt the time (in seconds) that elapsed since the last cycle
	 */
	public static inline function update(dt:Float) {
		cycle++;
		lastElapsed = dt;
		totalElapsed += dt;
	}

	/**
	 * A function for generating a periodic signal, in the form of a condition that is `true`
	 * every time `interval` has elapsed, and `false` all the other times.
	 *
	 * ```haxe
	 * if (Time.every(2.0))
	 *     trace("2 seconds have passed");
	 * ```
	 *
	 * By default, all calls with the same `interval` parameter will trigger on the same cycle.
	 *
	 * An optional `phase` can be specified, to trigger multiple checks out-of-phase.
	 * For example: multiple events each need to occur once every `10` seconds, but not on the same frame.
	 * Using a random `phase` for each one will cause them to trigger on different cycles.
	 *
	 * @param interval the interval in seconds
	 * @param phase offset phase in seconds
	 * @return `true` once every `interval`, otherwise `false`
	 */
	public static inline function every(interval:Float, phase:Float = 0):Bool {
		var totalElapsedPhased:Float = totalElapsed + phase;
		return Math.ffloor(totalElapsedPhased / interval) == (totalElapsedPhased / interval)
			|| Math.floor((totalElapsedPhased - lastElapsed) / interval) != Math.floor(totalElapsedPhased / interval);
	}

	/**
	 * A function for generating a periodic signal, in the form of a condition that is `true`
	 * every time a given number of `cycles` has elapsed, and `false` all the other times.
	 *
	 * By default, all calls with the same `cycles` parameter will trigger on the same cycle.
	 *
	 * An optional `phase` can be specified, to trigger multiple checks out-of-phase.
	 * For example: multiple events each need to occur once every `10` frames, but not on the same frame.
	 * Using a random `phase` for each one will cause them to trigger on different cycles.
	 *
	 * **WARNING:** this function may not work correctly if `update()` is called more than once per cycle,
	 * or if `everyCycles()` is not called on every cycle.
	 *
	 * @param cycles the interval in cycles
	 * @param phase offset phase in cycle numbers
	 * @return `true` once every `cycles`, otherwise `false`
	 */
	public static inline function everyCycles(cycles:Int, phase:Int = 0):Bool {
		return (cycle + phase) % cycles == 0;
	}
}
