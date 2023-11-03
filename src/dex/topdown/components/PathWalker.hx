package dex.topdown.components;

import defold.types.Hash;
import dex.util.DexError;
import dex.util.DexUtils;
import dex.util.types.Vector2;
import dex.wrappers.GameObject;

using lua.Table;


class PathWalker extends ScriptComponent
{
    static inline var TargetDistanceThreshold: Float = 4;

    final go: GameObject;
    final tileSize: Int;
    final obstacleGroups: Table<Int, Hash>;

    var path: Array<Vector2>;
    var nextTarget: Vector2;

    var mover: TopdownMover;

    public function new(tileSize: Int, obstacleGroups: Array<Hash> = null)
    {
        super();

        go = GameObject.self();
        this.tileSize = tileSize;
        if (obstacleGroups != null)
        {
            this.obstacleGroups = Table.fromArray(obstacleGroups);
        }
    }

    /**
     * Update the path of the mover.
     *
     * By calling this method, the previous path will be discarded and the new
     * path will start being walked.
     *
     * @param path the path as an array of world positions, or `null` to stop the mover
     */
    public function setPath(path: Array<Vector2>)
    {
        this.path = path;
        nextTarget = null;
        mover.setDirection(0, 0);

        updateNextTarget();
    }

    override function init()
    {
        path = null;
        nextTarget = null;
        mover = componentList.require(TopdownMover);
    }

    override function update(dt: Float)
    {
        if (nextTarget != null)
        {
            if (distanceToNextTarget() < TargetDistanceThreshold)
            {
                // Reached current target, move on to next point.
                updateNextTarget();
            }
            else
            {
                // Update mover to move to the next point.
                var direction: Vector2 = (nextTarget - go.getWorldPosition()).normalize();

                mover.setDirection(direction.x, direction.y);
            }
        }
        else
        {
            mover.setDirection(0, 0);
        }
    }

    /**
        Updates the `nextTarget` to the next point in the path that can be raycast to.
    **/
    function updateNextTarget()
    {
        if (path == null || path.length == 0)
        {
            nextTarget = null;
            return;
        }

        DexError.assert(nextTarget != path[ 0 ]);

        nextTarget = path.shift();

        if (obstacleGroups != null)
        {
            // determine the next point that can be raycast to
            var ownPosition: Vector2 = go.getWorldPosition();
            while (path.length > 0)
            {
                if (DexUtils.canRaycastTo(ownPosition, path[ 0 ], obstacleGroups))
                {
                    // can raycast to point, pop off list and check next
                    nextTarget = path.shift();
                }
                else
                {
                    // cannot raycast to this point, keep the last one
                    break;
                }
            }
        }
    }

    inline function distanceToNextTarget(): Float
    {
        return (nextTarget - go.getWorldPosition()).length();
    }
}
