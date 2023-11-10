package dex.util.extensions;

class ArrayEx {
	/**
	 * Removes an element from an array at a specified index, and returns it.
	 *
	 * This modifies the array in place.
	 *
	 * @param arr the array to remove the element from
	 * @param pos the index in the array at which to remove the item
	 * @return T the item that was removed
	 */
	public static function removeAt<T>(arr:Array<T>, pos:Int):T {
		var elemRemoved:T = arr[pos];

		for (i in pos...arr.length - 1) {
			arr[i] = arr[i + 1];
		}

		arr.pop();

		return elemRemoved;
	}
}
