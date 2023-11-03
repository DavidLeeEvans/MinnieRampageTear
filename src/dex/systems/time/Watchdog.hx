package dex.systems.time;

import pool.Poolable;
import linkedlist.LinkedListItem;

/**
 * A watchdog is a countdown timer which triggers unless it is reset.
 */
class Watchdog implements Poolable implements LinkedListItem
{
    public var time(default, null): Float;
    public var timeRemaining(default, null): Float;
    public var repeat(default, null): Bool;
    public var stopped(default, null): Bool;

    var callback: () -> Void;

    @:allow(pool.Pool)
    function new(time: Float, repeat: Bool, callback: () -> Void)
    {
        this.time = time;
        this.repeat = repeat;
        this.callback = callback;

        timeRemaining = time;
        stopped = false;
    }

    /**
     * Reset the watchdog's timer to the initial value.
     */
    public inline function reset()
    {
        timeRemaining = time;
    }

    /**
     * Stop the watchdog.
     */
    public inline function stop()
    {
        stopped = true;
    }

    @:allow(dex.systems.Time)
    inline function update(dt: Float): Bool
    {
        var done: Bool = false;
        timeRemaining -= dt;

        if (timeRemaining <= 0)
        {
            callback();

            if (repeat)
            {
                timeRemaining = time;
            }
            else
            {
                done = true;
            }
        }

        return done;
    }
}
