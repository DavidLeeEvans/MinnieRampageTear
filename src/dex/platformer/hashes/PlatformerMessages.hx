package dex.platformer.hashes;

import defold.types.Vector3;


@:build(defold.support.MessageBuilder.build())
class PlatformerMessages
{
    var walk: WalkMessage;
}

/**
    Message sent to a character, to make him move a certain distance.
**/
typedef WalkMessage =
{
    /** The distance to move along the x-axis. A positive value to move right or a negative value to move left. **/
    var distance: Float;

    /** Speed multiplier to apply to the configured speed during this movement. **/
    var speedFactor: Float;
}
