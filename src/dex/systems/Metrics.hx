package dex.systems;

import dex.util.Lua;
import lua.lib.luasocket.Socket;

/**
 * Utility system for tracking performance metrics.
 */
class Metrics
{
    /**
     * The multiplying factor for the exponential moving average used to compute metrics.
     * Must be in the range `[0.0, 1.0]`.
     */
    public static var movingAverageFactor: Float = 0.2;

    static var timestamp: Float;
    static var frameTime: Float;
    static var memoryUsage: Float;

    static var maxFrameTime: Float;
    static var maxMemoryUsage: Float;

    /**
     * Initialize the system.
     * Should be called once at the beginning of the application, or at the beginning of every new scene.
     */
    public static function init()
    {
        timestamp = getTime();
        frameTime = 0;
        memoryUsage = 0;

        resetPeakCounters();
    }

    /**
     * Resets the counters tracking the peak values reached.
     */
    public static inline function resetPeakCounters()
    {
        maxFrameTime = frameTime;
        maxMemoryUsage = memoryUsage;
    }

    /**
     * Update the system.
     * Should be called once on every application cycle.
     */
    public static function update()
    {
        /**
         * Compute FPS
         */
        var curTime: Float = getTime();

        var curFrameTime: Float = curTime - timestamp;
        timestamp = curTime;

        frameTime = movingAverageFactor * frameTime + (1 - movingAverageFactor) * curFrameTime;

        /**
         * Compute memory usage
         */
        var curMemoryUsage = Lua.memoryUsage();

        memoryUsage = movingAverageFactor * memoryUsage + (1 - movingAverageFactor) * curMemoryUsage;

        /**
         * Update peak counters
         */
        if (curFrameTime > maxFrameTime)
        {
            maxFrameTime = curFrameTime;
        }
        if (curMemoryUsage > maxMemoryUsage)
        {
            maxMemoryUsage = curMemoryUsage;
        }
    }

    /**
     * Returns the average Frames-per-Second (FPS) count.
     */
    public static inline function getFps(): Int
    {
        return Std.int(1 / frameTime);
    }

    /**
     * Returns the average frame time (in seconds).
     */
    public static inline function getFrameTime(): Float
    {
        return frameTime;
    }

    /**
     * Returns the peak Frames-per-Second (FPS) count.
     * Countinng since the last time `init()` or `resetPeakCounters()` was called.
     */
    public static inline function getMinFps(): Int
    {
        return Std.int(1 / maxFrameTime);
    }

    /**
     * Returns the peak frame time (in seconds).
     * Countinng since the last time `init()` or `resetPeakCounters()` was called.
     */
    public static inline function getPeakFrameTime(): Float
    {
        return maxFrameTime;
    }

    /**
     * Returns the average memory usage (in KB).
     */
    public static inline function getMemoryUsage(): Float
    {
        return memoryUsage;
    }

    /**
     * Returns the average memory usage in a human-readable string.
     */
    public static inline function getMemoryUsageFormatted(): String
    {
        return humanReadableBytes(memoryUsage);
    }

    /**
     * Returns the peak memory usage (in KB).
     * Countinng since the last time `init()` or `resetPeakCounters()` was called.
     */
    public static inline function getPeakMemoryUsage(): Float
    {
        return maxMemoryUsage;
    }

    /**
     * Returns the peak memory usage in a human-readable string.
     * Countinng since the last time `init()` or `resetPeakCounters()` was called.
     */
    public static inline function getPeakMemoryUsageFormatted(): String
    {
        return humanReadableBytes(maxMemoryUsage);
    }

    inline static function getTime(): Float
    {
        return Socket.gettime();
    }

    static function humanReadableBytes(kb: Float): String
    {
        // initialize value to bytes
        var value: Float = kb * 1000;

        var prefixIndex: Int = 0;
        while (Math.abs(value) >= 1000)
        {
            value /= 1000;
            prefixIndex++;
        }

        // round and get prefix to the unit
        var valueRounded: Float = Math.round(value * 100) / 100;
        var unitPrefix: String = prefixIndex > 0 ? byteSizePrefixes.charAt(prefixIndex - 1) : "";

        return '${valueRounded} ${unitPrefix}B';
    }

    static final byteSizePrefixes: String = "kMGTPE";
}
