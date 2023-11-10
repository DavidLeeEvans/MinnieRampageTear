package dex.topdown.components;

import lua.Table;

import defold.Physics;

import defold.types.Vector3;
import defold.types.Hash;

import dex.wrappers.GameObject.go;

using dex.util.extensions.Vector3Ex;

class PathWalker extends ScriptComponent {
	static inline var TARGET_DISTANCE_THRESHOLD:Float = 2;

	var tileSize:Int;
	var collisionGroups:Array<Hash>;

	var path:Array<Vector3>;
	var nextTarget:Vector3;

	public function new(tileSize:Int, collisionGroups:Array<Hash> = null) {
		super();

		this.tileSize = tileSize;
		this.collisionGroups = collisionGroups;
	}

	public inline function setPath(path:Array<Vector3>) {
		this.path = path;

		updateNextTarget();
	}

	public inline function getPathLength():Int {
		return path.length;
	}

	public inline function getPathEnd():Vector3 {
		return path[path.length - 1];
	}

	override function init() {
		path = new Array<Vector3>();
		nextTarget = null;
	}

	override function update(dt:Float) {
		if (nextTarget != null) {
			if (distanceToNextTarget() < TARGET_DISTANCE_THRESHOLD) {
				// Reached current target, move on to next point.
				updateNextTarget();
			} else {
				// Update mover to move to the next point.
				var direction:Vector3 = nextTarget - go.getPosition();

				componentList[TopdownMover].setDirection(direction.x, direction.y);
			}
		} else {
			componentList[TopdownMover].setDirection(0, 0);
		}
	}

	/**
		Updates the `nextTarget` to the next point in the path that can be raycast to.
	**/
	inline function updateNextTarget() {
		var ownPosition:Vector3 = go.getPosition();

		nextTarget = null;

		// Determine the next point that can be raycasted to.
		while (path.length > 0) {
			// Pop the next point of the path.
			var point:Vector3 = path[0];
			var raycast:PhysicsMessageRayCastResponse = null;

			if (collisionGroups != null) {
				raycast = Physics.raycast(ownPosition, point, Table.fromArray(collisionGroups));
			}

			if (raycast == null) {
				// Can raycast to point, pop off list and check next.
				path.splice(0, 1);
				nextTarget = point;
			} else {
				// Cannot raycast to this point, keep the last one.
				break;
			}
		}
	}

	inline function distanceToNextTarget():Float {
		return (nextTarget - go.getPosition()).getLength();
	}
}
