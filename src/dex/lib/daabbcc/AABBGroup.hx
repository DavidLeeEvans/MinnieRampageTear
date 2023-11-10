package dex.lib.daabbcc;

import lua.Table;

extern class AABBGroup {
	/**
	 * Insert AABB into the group.
	 * @return aabb id
	 */
	inline function insert(x:Float, y:Float, w:Float, h:Float):AABBObject {
		return AABB.insert(this, x, y, w, h);
	}

	/**
	 * Updates the AABB position and size when you change it is position or size.
	 */
	inline function update(aabb:AABBObject, x:Float, y:Float, w:Float, h:Float):Void {
		AABB.update(this, aabb, x, y, w, h);
	}

	/**
	 * Query the possible overlaps using ID.
	 * @return result table with ids.
	 */
	inline function queryId(aabb:AABBObject):Array<AABBObject> {
		return Table.toArray(AABB.queryId(this, aabb));
	}

	/**
	 * Query the possible overlaps using AABB.
	 * @return result table with ids.
	 */
	@:native("query_id")
	inline function query(x:Float, y:Float, w:Float, h:Float):Array<AABBObject> {
		return Table.toArray(AABB.query(this, x, y, w, h));
	}

	/**
	 * Query the possible overlaps using raycast.
	 * @return result table with ids.
	 */
	inline function raycast(startX:Float, startY:Float, endX:Float, endY:Float):Array<AABBObject> {
		return Table.toArray(AABB.raycast(this, startX, startY, endX, endY));
	}

	/**
	 * Removes the AABB from group.
	 */
	inline function remove(aabb:AABBObject):Void {
		AABB.remove(this, aabb);
	}
}
