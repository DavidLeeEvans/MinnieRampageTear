package dex.util;

/**
 * Utility abstract over a float timer, used to work with
 * an event which may occur once after some time in the future.
 */
abstract Timer(Float) from Float
{
    /**
     * Get a timer that has already expired.
     *
     * The timer's `isRunning()` will return `false`, and `hasElapsed()` will return `true`.
     */
    public static var expired(get, never): Timer;

    /**
     * Get a timer that is primed to expire on the next `tick()`.
     *
     * The timer's `isRunning()` will return `true`, and `hasElapsed()` will return `false`.
     */
    public static var primed(get, never): Timer;

    /**
     * Starts the timer with the given time.
     *
     * @param time the time (in seconds) until the timer expires
     */
    public inline function start(time: Float)
    {
        this = time;
    }

    /**
     * This method shall be used in the update loop to update the timer.
     *
     * If the timer has already elapsed (i.e the value is `<= 0`),
     * this method has no effect.
     *
     * This will only return `true`, on the same frame that the timer elapses.
     *
     * @param dt the delta-time of the current frame
     * @return `true` if the timer should trigger on this frame, otherwise `false`
     */
    public inline function tick(dt: Float): Bool
    {
        if (this > 0)
        {
            this -= dt;

            if (this <= 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }

    /**
     * Checks if the timer has elapsed.
     *
     * Note that this also applies to timers that haven't been started at all.
     *
     * @return `true` if the timer has elapsed
     */
    public inline function hasElapsed(): Bool
    {
        return this <= 0;
    }

    /**
     * Checks if the timer is currently running.
     *
     * @return `true` if the timer is running
     */
    public inline function isRunning(): Bool
    {
        return this > 0;
    }

    @:to
    inline function toBool(): Bool
    {
        return isRunning();
    }

    static inline function get_primed(): Timer
    {
        return 1e-8;
    }

    static inline function get_expired(): Timer
    {
        return -1;
    }
}
