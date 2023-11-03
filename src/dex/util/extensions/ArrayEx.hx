package dex.util.extensions;

class ArrayEx
{
    /**
     * Removes an element from an array at a specified index, and returns it.
     *
     * This modifies the array in place, and affects the order of the elements.
     *
     * @param arr the array to remove the element from
     * @param pos the index in the array at which to remove the item
     * @return T the item that was removed
     */
    public static function removeAt<T>(arr: Array<T>, pos: Int): T
    {
        // move the element to the last position
        var elemRemoved: T = arr[ pos ];
        arr[ pos ] = arr[ arr.length - 1 ];
        arr[ arr.length - 1 ] = elemRemoved;

        // and pop it
        return arr.pop();
    }

    /**
     * Returns the last element in the array.
     *
     * Shorthand to `arr[arr.length - 1]`.
     * Will lead to error if the array is empty.
     *
     * @param arr the array
     * @return the last element
     */
    public static inline function last<T>(arr: Array<T>): T
    {
        return arr[ arr.length - 1 ];
    }

    public static inline function contains<T>(arr: Array<T>, elem: T): Bool
    {
        return arr.indexOf(elem) > -1;
    }

    public static inline function exists<T>(arr: Array<T>, fn: T->Bool): Bool
    {
        var exists: Bool = false;
        for (elem in arr)
        {
            if (fn(elem))
            {
                exists = true;
                break;
            }
        }
        return exists;
    }
}
