package dex.topdown.components;

import defold.types.Hash;
import dex.systems.Time;
import dex.topdown.components.TargetFollower;
import dex.util.DexError;
import dex.util.types.Vector2;
import dex.util.types.Vector2Int;
import dex.wrappers.GameObject;

/**
 * This component is similar to `TargetFollower`, with the distinction that multiple targets can be followed at the same time.
 * The follower will try to always move towards the closest target among the ones that have been set.
 *
 * When `setTargets` is called, the first target in the list will get followed for the first few frames.
 *
 * After that, the paths to all targets will get checked at regular intervals, and if one of the targets
 * is found to be closer than the currently-followed target, it will be followed instead.
 *
 * @TODO: this is nonsense, it should be done by replacing A* with Dijkstra's algorithm which can pathfind to
 * multiple targets.
 */
class MultiTargetFollower extends TargetFollower
{
    var targets: Array<GameObject>;
    var tileDistanceToTarget: Int;

    var targetCheckFrameInterval: Int = 3;

    public function new(tileSize: Int, pathfinder: PathfinderCallback, updateInterval: Float = 0.5, obstacleGroups: Array<Hash> = null)
    {
        super(tileSize, pathfinder, updateInterval, obstacleGroups);
    }

    override function init()
    {
        super.init();

        targets = [ ];
        tileDistanceToTarget = 0;
    }

    /**
     * Set the new targets to follow.
     *
     * @param targets
     * @param rangeFromTarget
     */
    public function setTargets(targets: Array<GameObject>, rangeFromTarget: Float, ?maxPathfindRange: Float)
    {
        if (targets == null)
        {
            target = null;
        }
        else
        {
            target = targets[ 0 ];
        }

        this.targets = targets;
        this.rangeFromTarget = rangeFromTarget;
        this.maxPathfindRange = maxPathfindRange;
        tileDistanceToTarget = 0;
    }

    /**
     * Configure the time interval (in number of frames) between pathfinding checks
     * to identify the current closest targets.
     *
     * One target will be checked per this number of frames.
     * For example, with `targetCheckFrameInterval=2`, the targets will be checked in this sequence
     * of frames:
     *
     * > target0, _, target1, _, target3, _, ..., target0, _, target1, ...
     *
     *
     * @param targetCheckFrameInterval the number of frames between pathfinding checks
     */
    public function setTargetCheckFrameInterval(targetCheckFrameInterval: Int)
    {
        DexError.assert(targetCheckFrameInterval > 0);
        this.targetCheckFrameInterval = targetCheckFrameInterval;
    }

    override function update(dt: Float)
    {
        updateTarget();

        super.update(dt);
    }

    function updateTarget()
    {
        if (targets == null)
        {
            return;
        }

        var ownPosition: Vector2 = go.getPosition();
        var currentTile: Vector2Int = (ownPosition / tileSize).floor();

        var hyperPeriod: Int = targetCheckFrameInterval * targets.length;

        // calculate the distance to one target every 2 frames
        for (i in 0...targets.length)
        {
            if (!targets[ i ].exists())
            {
                continue;
            }

            if (Time.everyFrames(hyperPeriod, targetCheckFrameInterval * i))
            {
                var targetPosition: Vector2 = targets[ i ].getPosition();
                var targetTileX: Int = Math.floor(targetPosition.x / tileSize);
                var targetTileY: Int = Math.floor(targetPosition.y / tileSize);
                var path: Array<Vector2> = pathfinder(currentTile.x, currentTile.y, targetTileX, targetTileY, maxPathfindRange);

                // is this path shorter than the one we are currently following?
                if (tileDistanceToTarget == 0 || path.length < tileDistanceToTarget)
                {
                    target = targets[ i ];
                    tileDistanceToTarget = path.length;

                    // update the path
                    this.path = path;
                    updateNextTarget();
                }

                break;
            }
        }
    }
}
