package dex.wrappers;

import defold.Timer;

/**
 * Wrapper for the defold native `Timer` functions.
 */
abstract Timeout(TimerHandle) from TimerHandle
{
    /**
     * Create a new timeout that will execute once in the future.
     */
    public static inline function once(delay: Float, callback: () -> Void): Timeout
    {
        return Timer.delay(delay, false, (_, _, _) -> callback());
    }

    /**
     * Create a new timeout that will execute repeatedly in the future.
     */
    public static inline function repeat(delay: Float, callback: () -> Void): Timeout
    {
        return Timer.delay(delay, true, (_, _, _) -> callback());
    }

    /**
     * Create a new placeholder `Timeout` handle.
     *
     * This can be used for initialization, for a timeout that is controlled using `restart()`.
     */
    public static inline function none(): Timeout
    {
        return Timer.INVALID_TIMER_HANDLE;
    }

    /**
     * Cancels this timeout if it is already running, and starts a new one with the given delay.
     *
     * If this `Timeout` was created using the `repeat()` method, then it will be restarted as
     * repeating as well.
     */
    public inline function restart(delay: Float, callback: () -> Void)
    {
        var repeat: Bool = false;
        if (cancel())
        {
            // it was already running
            repeat = isRepeating();
        }
        this = Timer.delay(delay, repeat, (_, _, _) -> callback());
    }

    public inline function trigger(): Bool
    {
        return Timer.trigger(this);
    }

    public inline function cancel(): Bool
    {
        return Timer.cancel(this);
    }

    public inline function getInfo(): TimerInfo
    {
        return Timer.get_info(this);
    }

    public inline function getDelay(): Float
    {
        return getInfo().delay;
    }

    public inline function getTimeRemaining(): Float
    {
        return getInfo().time_remaining;
    }

    public inline function isRepeating(): Bool
    {
        return getInfo().repeat;
    }
}
