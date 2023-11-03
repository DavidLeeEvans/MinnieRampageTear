package dex.lib.defos.types;

import defold.types.Buffer;


typedef CursorData =
{
    /** Image resource. **/
    var image: Buffer;

    /** The X-position of an anchor point within the image that will overlap with the functional position of the mouse pointer (eg. the tip of the arrow).**/
    var hot_spot_x: Int;

    /** The Y-position of an anchor point within the image that will overlap with the functional position of the mouse pointer (eg. the tip of the arrow).**/
    var hot_spot_y: Int;
}
