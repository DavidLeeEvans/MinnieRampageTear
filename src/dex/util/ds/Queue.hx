package dex.util.ds;

/**
 * Simple abstract over an array, that only forwards the queue-related methods.
 */
@:forward(length)
abstract Queue<T>(Array<T>) from Array<T>
{
    public var isEmpty(get, never): Bool;

    inline function get_isEmpty(): Bool
    {
        return this.length == 0;
    }

    /**
     * Adds an element to the end of the queue.
     *
     * @param item
     * @return Int
     */
    public inline function enqueue(item: T): Int
    {
        return this.push(item);
    }

    /**
     * Removes the first element of `this` Array and returns it.
     *
     * If `this` is the empty Array `[]`, `null` is returned and the length remains 0.
     *
     * @return the item
     */
    public inline function dequeue(): T
    {
        return this.shift();
    }
}
