package dex.lib.drawpixels;

import defold.Image.ImageType;
import defold.types.Buffer;
import dex.util.DexError;


enum abstract BufferInfoChannels(Int)
{
    var RGB = 3;
    var RGBA = 4;

    @:to
    inline function toImageType(): ImageType
    {
        return
            switch cast(this, BufferInfoChannels)
            {
                case RGB:
                    TYPE_RGB;
                case RGBA:
                    TYPE_RGBA;
                default:
                    DexError.error('invalid buffer info channels');
            }
    }
}

typedef BufferInfo =
{
    /** buffer */
    var buffer: Buffer;

    /** buffer width, same as your texture width */
    var width: Int;

    /** buffer height, same as your texture height */
    var height: Int;

    /** 3 for rgb, 4 for rgba */
    var channels: BufferInfoChannels;

    /** alpha value will be premultiplied into the RGB color values. Optional parameter. Default is `false`. */
    var ?premultiply_alpha: Bool;
}
