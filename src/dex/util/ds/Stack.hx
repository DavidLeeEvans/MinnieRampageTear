package dex.util.ds;

/**
 * Simple abstract over an array, that only forwards the stack-related methods.
 */
@:forward(length, push, pop)
abstract Stack<T>(Array<T>) from Array<T>
{
    public var isEmpty(get, never): Bool;

    inline function get_isEmpty(): Bool
    {
        return this.length == 0;
    }
}
