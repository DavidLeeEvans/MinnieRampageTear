package dex.systems;

import dex.systems.time.Watchdog;
import dex.systems.time.WatchdogPool;
import linkedlist.LinkedList;

/**
 * Static time-tracking system, offering certain convenient features statically throughout the entire project.
 */
class Time {
	/**
	 * A number which gets incremented at the beginning of every update() cycle.
	 * This value should not be used as a number, it is only meant to be stored and
	 * compared by sections which should not be executed more than once per cycle.
	 */
	public static var frame(default, null):UInt = 0;

	/**
	 * Timestamp representing the total number of seconds since `Time.init()` was called.
	 */
	public static var timestamp(default, null):Float = 0;

	static var lastElapsed:Float = 0;
	static var watchdogs:LinkedList<Watchdog>;

	/**
	 * Initializes the time system.
	 * Should be called once, when a scene is initialized.
	 */
	public static function init() {
		frame = 0;
		lastElapsed = 0;
		timestamp = 0;
		watchdogs = new LinkedList();
	}

	/**
	 * Update the time system. Should be called once every update cycle.
	 *
	 * @param dt the time (in seconds) that elapsed since the last cycle
	 */
	public static inline function update(dt:Float) {
		frame++;
		lastElapsed = dt;
		timestamp += dt;

		for (wd in watchdogs) {
			if (wd.stopped || wd.update(dt)) {
				// watchdog done
				watchdogs.remove(wd);

				WatchdogPool.putWatchdog(wd);
			}
		}
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
		var totalElapsedPhased:Float = timestamp + phase;
		return Math.ffloor(totalElapsedPhased / interval) == (totalElapsedPhased / interval)
			|| Math.floor((totalElapsedPhased - lastElapsed) / interval) != Math.floor(totalElapsedPhased / interval);
	}

	/**
	 * A function for generating a periodic signal, in the form of a condition that is `true`
	 * every time a given number of `frames` has elapsed, and `false` all the other times.
	 *
	 * By default, all calls with the same `frames` parameter will trigger on the same cycle.
	 *
	 * An optional `phase` can be specified, to trigger multiple checks out-of-phase.
	 * For example: multiple events each need to occur once every `10` frames, but not on the same frame.
	 * Using a random `phase` for each one will cause them to trigger on different cycles.
	 *
	 * **WARNING:** this function may not work correctly if `update()` is called more than once per cycle,
	 * or if `everyFrames()` is not called on every cycle.
	 *
	 * @param frames the interval in cycles
	 * @param phase offset phase in cycle numbers
	 * @return `true` once every `cycles`, otherwise `false`
	 */
	public static inline function everyFrames(frames:Int, phase:Int = 0):Bool {
		return (frame + phase) % frames == 0;
	}

	/**
	 * A watchdog is a callback which gets invoked after a specified delay, unless it is reset or stopped.
	 *
	 * The returned object should not be kept by the user after the watchdog is stopped.
	 *
	 * @param time the time after which the watchdog callback will trigger
	 * @param repeat whether the watchdog is repeating
	 * @param callback the function to call if the watchdog time expires
	 * @return the watchdog object
	 */
	public static inline function watchdog(time:Float, repeat:Bool, callback:() -> Void):Watchdog {
		var wd:Watchdog = WatchdogPool.getWatchdog(time, repeat, callback);
		watchdogs.push(wd);
		return wd;
	}

	/**
	 * Gets how many frames have elapsed since the given frame number,
	 * with some care not to overflow the result.
	 *
	 * @param frame the frame number
	 * @return the number of frames that elapsed since `frame`
	 */
	public static inline function framesElapsedSince(frame:UInt):UInt {
		return if (Time.frame > frame) {
			Time.frame - frame;
		} else {
			frame - Time.frame;
		}
	}
}
