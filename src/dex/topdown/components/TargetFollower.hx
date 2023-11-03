package dex.topdown.components;

import defold.types.Hash;
import dex.util.DexError;
import dex.util.DexUtils;
import dex.util.Timer;
import dex.util.types.Vector2;
import dex.util.types.Vector2Int;
import dex.wrappers.GameObject;

using lua.Table;
using dex.util.extensions.ArrayEx;

/**
 * A function which takes the coordinates of a `from` tile and a `to` tile,
 * and returns the shortest path between the two as an array of world positions.
 */
typedef PathfinderCallback = (fromX: Int, fromY: Int, toX: Int, toY: Int, maxCost: Null<Float>) -> Array<Vector2>;

/**
 * A component for non-player characters, which should continuously pathfind and move towards another gameobject.
 * This component will:
 * - Take a target at any time using `setTarget(GameObject)`.
 * - Keep the shortest path to the target and follow it every frame using `TopdownMover`.
 * - Every frame monitor the position of the target, and if it moved to a new tile it will get a new path to follow.
 * - Stop moving when a configured distance and visibility from the target is reached.
 */
class TargetFollower extends PathWalker
{
    var pathfinder: PathfinderCallback;
    var updateInterval: Float;

    var updateTimer: Timer;

    var target: GameObject;
    var rangeFromTarget: Float;
    var maxPathfindRange: Null<Float>;

    var targetTile: Vector2Int;
    var targetInRange: Bool;

    /** Callback to be invoked when the followed target enters the configured range. */
    public var onTargetEnterRange(null, default): (target: GameObject) -> Void;

    /** Callback to be invoked when the followed target exits the configured range. */
    public var onTargetExitRange(null, default): (target: GameObject) -> Void;

    /**
     * Initialize a target follower component.
     *
     * @param tileSize the tile-size of the tilemap
     * @param pathfinder the callback to use to obtain new paths to the target when necessary;
     *                   in case it returns `null`, it will be called again after a few frames
     * @param updateInterval the time (in seconds) between updates
     * @param obstacleGroups list of obstacle collision groups;
     *                       if **not** specified, the follower will walk the exact tile-based path, even when a straight-line to the target exists,
     *                       and also the `rangeFromTarget` will be treated as absolute world distance even through walls
     */
    public function new(tileSize: Int, pathfinder: PathfinderCallback, updateInterval: Float = 0.5, obstacleGroups: Array<Hash> = null)
    {
        super(tileSize, obstacleGroups);

        this.pathfinder = pathfinder;
        this.updateInterval = updateInterval;
        updateTimer = Timer.expired;

        target = GameObject.none;
        targetTile = Vector2Int.zero;
        targetInRange = false;
    }

    override function init()
    {
        super.init();

        target = GameObject.none;
        targetTile = Vector2Int.zero;
    }

    override function setPath(path: Array<Vector2>)
    {
        DexError.error('TargetFollower should only be commanded using setTarget()');
    }

    /**
     * Update the target.
     *
     * @param target the target id
     * @param rangeFromTarget the distance from the target at which the mover should stop
     * @param maxPathfindRange if specified, the pathfinder will exit early if this distance is exceeded
     */
    public function setTarget(target: GameObject, rangeFromTarget: Float, ?maxPathfindRange: Float)
    {
        DexError.assertWarn(target.exists(), 'setting non-existent target');

        this.target = target;
        this.rangeFromTarget = rangeFromTarget;
        this.maxPathfindRange = maxPathfindRange;

        // set the timer to trigger at the next update
        updateTimer = Timer.primed;
    }

    override function update(dt: Float)
    {
        if (target == null || !target.exists())
        {
            // nothing to do
            return;
        }

        var ownPosition: Vector2 = go.getWorldPosition();
        var targetPosition: Vector2 = target.getWorldPosition();

        // check if the target has been reached
        if (isTargetReached(ownPosition, targetPosition))
        {
            onTargetIsInRange(true);
            super.setPath(null);
            return;
        }

        if (updateTimer.tick(dt))
        {
            onTargetIsInRange(false);

            updatePath(ownPosition, targetPosition);
            updateTimer.start(updateInterval);
        }

        super.update(dt);
    }

    function updatePath(ownPosition: Vector2, targetPosition: Vector2)
    {
        if (!target.exists())
        {
            super.setPath(null);
            return;
        }

        // still following the target
        var targetTileX: Int = Math.floor(targetPosition.x / tileSize);
        var targetTileY: Int = Math.floor(targetPosition.y / tileSize);

        if ((targetTileX == targetTile.x) && (targetTileY == targetTile.y))
        {
            // the target didn't move since the last frame
            if (path != null)
            {
                // do nothing, keep following the current path
                return;
            }
        }

        // the target moved to a different tile
        targetTile.x = targetTileX;
        targetTile.y = targetTileY;

        // calculate a new path
        var newPath: Array<Vector2> = null;
        if (obstacleGroups != null && DexUtils.canRaycastTo(ownPosition, targetPosition, obstacleGroups))
        {
            // can go directly to the target
            // path straight to there
            newPath = [ targetPosition ];
        }
        else
        {
            // cannot raycast to the target, use the pathfinder
            var currentTile: Vector2Int = (ownPosition / tileSize).floor();
            newPath = pathfinder(currentTile.x, currentTile.y, targetTile.x, targetTile.y, maxPathfindRange);

            if (newPath != null)
            {
                // the last point should be the exact position of the target
                newPath.last().x = targetPosition.x;
                newPath.last().y = targetPosition.y;
            }
        }

        super.setPath(newPath);
    }

    inline function isTargetReached(ownPosition: Vector2, targetPosition: Vector2): Bool
    {
        var reached: Bool = false;

        var distance: Float = (targetPosition - ownPosition).length();
        if (distance <= rangeFromTarget)
        {
            // target reached (in theory)
            if (obstacleGroups == null)
            {
                // no obstacle colliders configured, absolute distance is good enough
                reached = true;
            }
            else
            {
                // if obstacle colliders are configured, then absolute distance shouldn't be used
                // because we don't want to "reach" the target through a wall
                // check by raycasting to the target instead
                if (DexUtils.canRaycastTo(ownPosition, targetPosition, obstacleGroups))
                {
                    // can raycast to the target
                    reached = true;
                }
            }
        }

        return reached;
    }

    /**
     * Simple wrapper for the callback API of the class.
     * This method has no impact on the class' behavior.
     */
    function onTargetIsInRange(inRange: Bool)
    {
        if (inRange)
        {
            if (!targetInRange)
            {
                // the target was reached just now
                if (onTargetEnterRange != null)
                    onTargetEnterRange(target);
            }
        }
        else
        {
            if (targetInRange)
            {
                // the target just now went out of range
                if (onTargetExitRange != null)
                    onTargetExitRange(target);
            }
        }

        targetInRange = inRange;
    }
}
