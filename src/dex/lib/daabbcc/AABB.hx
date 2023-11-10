package dex.lib.daabbcc;

import lua.Table;

/**
 * ### DAABBCC
 * https://github.com/selimanac/DAABBCC
 *
 * A Dynamic AABB Tree is a binary search algorithm for fast overlap testing.
 * Dynamic AABB trees are good for general purpose use, and can handle moving objects very well.
 * The data structure provides an efficient way of detecting potential overlap between objects.
 * DAABBCC does not contain narrow-phase collision detection.
 */
@:native("aabb")
extern class AABB {
	/**
	 * New group for AABBs. Currently groups has limited to 20.
	 * @return group id
	 */
	@:native("new_group")
	static function newGroup():AABBGroup;

	/**
	 * Insert AABB into the group.
	 * @return aabb id
	 */
	static function insert(group:AABBGroup, x:Float, y:Float, w:Float, h:Float):AABBObject;

	/**
	 * Updates the AABB position and size when you change it is position or size.
	 */
	static function update(group:AABBGroup, aabb:AABBObject, x:Float, y:Float, w:Float, h:Float):Void;

	/**
	 * Query the possible overlaps using ID.
	 * @return result table with ids.
	 */
	@:native("query_id")
	static function queryId(group:AABBGroup, aabb:AABBObject):Table<Int, AABBObject>;

	/**
	 * Query the possible overlaps using AABB.
	 * @return result table with ids.
	 */
	static function query(group:AABBGroup, x:Float, y:Float, w:Float, h:Float):Table<Int, AABBObject>;

	/**
	 * Query the possible overlaps using raycast.
	 * @return result table with ids.
	 */
	static function raycast(group:AABBGroup, startX:Float, startY:Float, endX:Float, endY:Float):Table<Int, AABBObject>;

	/**
	 * Removes the group and cleans all AABBs.
	 */
	@:native("removeGroup")
	static function removeGroup(group:AABBGroup):Void;

	/**
	 * Removes the AABB from group.
	 */
	static function remove(group:AABBGroup, aabb:AABBObject):Void;
}
