package dex.util.ds;

typedef PriorityItem =
{
    var priority: Int;
}

/**
 * Priority queue which keeps elements in increasing order of priority.
 */
@:forward(length)
abstract PriorityQueue<T: PriorityItem>(Array<T>)
{
    public function new()
    {
        this = [ ];
    }

    /**
     * Adds a new element to the priority queue.
     *
     * This is an `O(logn)` operation.
     *
     * @param item the item to add
     */
    public function add(item: T)
    {
        var size: Int = this.length;

        this.push(item);

        if (size > 0)
        {
            var heapifyFrom: Int = Std.int(size / 2);

            for (i in 0...heapifyFrom)
            {
                heapify(heapifyFrom - i - 1);
            }
        }
    }

    /**
     * Removes and returns the item with the smallest `priority` currently in the list.
     *
     * This is an `O(logn)` operation.
     *
     * @return the item
     */
    public inline function getNext(): T
    {
        return removeAt(0);
    }

    /**
     * Returns the item with the smallest `priority` currently in the list,
     * but without removing it.
     *
     * This is an `O(1)` operation.
     *
     * @return the item
     */
    public inline function peekNext(): T
    {
        return this[ 0 ];
    }

    /**
     * Remove a specific element from the priority queue.
     *
     * This is an `O(logn)` operation.
     *
     * @param item the item to remove
     * @return `true` if the element existed in the list, otherwise `false`
     */
    public inline function remove(item: T): Bool
    {
        var i: Int = this.indexOf(item);
        var removed: Bool = false;

        if (i > -1)
        {
            removeAt(i);
            removed = true;
        }

        return removed;
    }

    function removeAt(i: Int): T
    {
        var size: Int = this.length;

        // replace the first item with the last, then pop the last
        var temp: T = this[ i ];
        this[ i ] = this[ size - 1 ];
        this[ size - 1 ] = temp;

        var nextItem: T = this.pop();

        // heapify the array
        var heapifyTo: Int = Std.int(size / 2);
        for (j in 0...heapifyTo)
        {
            heapify(heapifyTo - j - 1);
        }

        return nextItem;
    }

    function heapify(i: Int)
    {
        var size: Int = this.length;
        // find the smallest among root, left child and right child
        var smallest: Int = i;
        var l: Int = 2 * i + 1;
        var r: Int = 2 * i + 2;
        if (l < size && this[ l ].priority < this[ smallest ].priority)
        {
            smallest = l;
        }
        if (r < size && this[ r ].priority < this[ smallest ].priority)
        {
            smallest = r;
        }

        // wwap and continue heapifying if root is not smallest
        if (smallest != i)
        {
            var temp: T = this[ smallest ];
            this[ smallest ] = this[ i ];
            this[ i ] = temp;

            heapify(smallest);
        }
    }

    @:op([ ])
    inline function getIndex(i: Int): T
    {
        return this[ i ];
    }
}
