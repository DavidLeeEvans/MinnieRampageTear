package dex.lib.drawpixels.wrapper;

import lua.Table;
import defold.Buffer;
import defold.Resource.ResourceTextureInfo;
import defold.Resource;
import defold.types.HashOrString;
import dex.lib.drawpixels.BufferInfo.BufferInfoChannels;
import dex.wrappers.GuiNode;


typedef ColorChannels =
{
    var r: Int;
    var g: Int;
    var b: Int;
    var ?a: Int;
}

/**
 * Convenience wrapper for the DrawPixels asset.
 */
class DrawPixelsCanvas
{
    var buf: BufferInfo;
    var resource: HashOrString;
    var textureInfo: ResourceSetTextureInfo;

    // temp variables to hold color channels
    var c: ColorChannels;
    var c2: ColorChannels;

    public function new(resource: HashOrString, width: Int, height: Int, channels: BufferInfoChannels = RGBA)
    {
        this.resource = resource;
        var bufDecl: Table<Int, BufferStreamDeclaration> = untyped __lua__(
            '{{
            name = hash("rgba"),
            type = buffer.VALUE_TYPE_UINT8,
            count = channels
        }}'
        );
        buf =
        {
            buffer: Buffer.create(width * height, bufDecl),
            width: width,
            height: height,
            channels: channels
        };
        textureInfo =
        {
            width: width,
            height: height,
            format: channels == RGB ? TEXTURE_FORMAT_RGB : TEXTURE_FORMAT_RGBA,
            type: TEXTURE_TYPE_2D
        };

        c =
        {
            r: 0,
            g: 0,
            b: 0,
            a: null
        };
        c2 =
        {
            r: 0,
            g: 0,
            b: 0,
            a: null
        };

        fill(None);
    }

    /**
     * Draws the prepared texture buffer onto the underlying texture.
     */
    public function draw()
    {
        Resource.set_texture(resource, textureInfo, buf.buffer);
    }

    /**
     * Method for drawing a circle.
     *
     * @param posX x position center of the circle
     * @param posY y position center of the circle
     * @param diameter diameter of the circle
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     * @param antialiasing adds anti-aliasing. Only for 4 channels. Optional parameter.
     * @param width indicates the circle width. Only for circle with anti-aliasing. Optional parameter.
     */
    public inline function circle(posX: Float, posY: Float, diameter: Float, color: Color, ?antialiasing: Bool, ?width: Float): Void
    {
        toChannels(color);
        DrawPixels.circle(buf, posX, posY, diameter, c.r, c.g, c.b, c.a, antialiasing, width);
    }

    /**
     * Method for drawing a filled circle.
     *
     * @param posX x position center of the circle
     * @param posY y position center of the circle
     * @param diameter diameter of the circle
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     * @param antialiasing adds anti-aliasing. Only for 4 channels. Optional parameter.
     */
    public inline function filledCircle(posX: Float, posY: Float, diameter: Float, color: Color, ?antialiasing: Bool): Void
    {
        toChannels(color);
        DrawPixels.filledCircle(buf, posX, posY, diameter, c.r, c.g, c.b, c.a, antialiasing);
    }

    /**
     * Method for drawing a rectangle.
     *
     * @param posX x position center of the rectangle
     * @param posY y position center of the rectangle
     * @param rectWidth rectangle width
     * @param rectHeight rectangle height
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     */
    public inline function rect(posX: Float, posY: Float, rectWidth: Float, rectHeight: Float, color: Color): Void
    {
        toChannels(color);
        DrawPixels.rect(buf, posX, posY, rectWidth, rectHeight, c.r, c.g, c.b, c.a);
    }

    /**
     * Method for drawing a filledrectangle.
     *
     * @param posX x position center of the rectangle
     * @param posY y position center of the rectangle
     * @param rectWidth rectangle width
     * @param rectHeight rectangle height
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     * @param angle rotation angle in degrees. Optional.
     */
    public inline function filledRect(posX: Float, posY: Float, rectWidth: Float, rectHeight: Float, color: Color, ?angle: Float): Void
    {
        toChannels(color);
        DrawPixels.filledRect(buf, posX, posY, rectWidth, rectHeight, c.r, c.g, c.b, c.a, angle);
    }

    /**
     * Fill buffer with the color.
     *
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     */
    public inline function fill(color: Color): Void
    {
        toChannels(color);
        DrawPixels.fill(buf, c.r, c.g, c.b, c.a);
    }

    /**
     * Draw a line between two points.
     *
     * @param x0 x position of one end of the line
     * @param y0 y position of one end of the line
     * @param x1 x position of the other end of the line
     * @param y1 y position of the other end of the line
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     * @param antialiasing adds anti-aliasing. Only for 4 channels. Optional parameter.
     * @param width indicates the line width. Only for line with anti-aliasing. Optional parameter.
     */
    public inline function line(x0: Float, y0: Float, x1: Float, y1: Float, color: Color, ?antialiasing: Bool, ?width: Float): Void
    {
        toChannels(color);
        DrawPixels.line(buf, x0, y0, x1, y1, c.r, c.g, c.b, c.a, antialiasing, width);
    }

    /**
     * Draw a gradient line between two points.
     *
     * @param x0 x position of one end of the line
     * @param y0 y position of one end of the line
     * @param x1 x position of the other end of the line
     * @param y1 y position of the other end of the line
     * @param red1 first red channel of the color 0..255
     * @param green1 first green channel of the color 0..255
     * @param blue1 first blue channel of the color 0..255
     * @param red2 second red channel of the color 0..255
     * @param green2 second green channel of the color 0..255
     * @param blue2 second blue channel of the color 0..255
     * @param alpha alpha channel 0..255
     * @param antialiasing adds anti-aliasing. Only for 4 channels. Optional parameter.
     * @param width indicates the line width. Only for line with anti-aliasing. Optional parameter.
     */
    public inline function gradientLine(x0: Float, y0: Float, x1: Float, y1: Float, color1: Color, color2, antialiasing: Bool, ?width: Float): Void
    {
        toChannels(color2);
        c2.r = c.r;
        c2.g = c.g;
        c2.b = c.b;
        c2.a = c.a;
        toChannels(color1);
        DrawPixels.gradientLine(buf, x0, y0, x1, y1, c.r, c.g, c.b, c2.r, c2.g, c2.b, c.a, antialiasing, width);
    }

    /**
     * Draw an arc between two corners.
     * If from < to the arc is drawn counterclockwise.
     * If from > to the arc is drawn clockwise. Only for 4 channels
     *
     * @param x x position center of the circle
     * @param y y position center of the circle
     * @param radius radius of the circle
     * @param from first arc angle in radians. May be negative
     * @param to second arc angle in radians. May be negative
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255
     */
    public inline function arc(x: Float, y: Float, radius: Float, from: Float, to: Float, color: Color): Void
    {
        toChannels(color);
        DrawPixels.arc(buf, x, y, radius, from, to, c.r, c.g, c.b, c.a);
    }

    /**
     * Draw a filled arc between two corners.
     * If from < to the arc is drawn counterclockwise.
     * If from > to the arc is drawn clockwise. Only for 4 channels
     *
     * @param x x position center of the circle
     * @param y y position center of the circle
     * @param radius radius of the circle
     * @param from first arc angle in radians. May be negative
     * @param to second arc angle in radians. May be negative
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255
     */
    public inline function filledArc(x: Float, y: Float, radius: Float, from: Float, to: Float, color: Color): Void
    {
        toChannels(color);
        DrawPixels.filledArc(buf, x, y, radius, from, to, c.r, c.g, c.b, c.a);
    }

    /**
     * Draw a filled arc between two corners.
     * If from < to the arc is drawn counterclockwise.
     * If from > to the arc is drawn clockwise. Only for 4 channels
     *
     * @param x x position center of the circle
     * @param y y position center of the circle
     * @param radius radius of the circle
     * @param from first arc angle in radians. May be negative
     * @param to second arc angle in radians. May be negative
     * @param red1 first red channel of the color 0..255
     * @param green1 first green channel of the color 0..255
     * @param blue1 first blue channel of the color 0..255
     * @param red2 second red channel of the color 0..255
     * @param green2 second green channel of the color 0..255
     * @param blue2 second blue channel of the color 0..255
     * @param alpha alpha channel 0..255
     */
    public inline function gradientArc(x: Float, y: Float, radius: Float, from: Float, to: Float, color1: Color, color2: Color): Void
    {
        toChannels(color2);
        c2.r = c.r;
        c2.g = c.g;
        c2.b = c.b;
        c2.a = c.a;
        toChannels(color1);
        DrawPixels.gradientArc(buf, x, y, radius, from, to, c.r, c.g, c.b, c2.r, c2.g, c2.b, c.a);
    }

    /**
     * Draw a pixel.
     *
     * @param x x position of pixel
     * @param y y position of pixel
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     */
    public inline function pixel(x: Float, y: Float, color: Color): Void
    {
        toChannels(color);
        DrawPixels.pixel(buf, x, y, c.r, c.g, c.b, c.a);
    }

    /**
     * Read color from a position in the buffer.
     *
     * @param x x position to get color from
     * @param y y position to get color from
     * @return the color
     */
    public inline function color(x: Float, y: Float): Color
    {
        var c = DrawPixels.color(buf, x, y);
        return
            switch buf.channels
            {
                case RGB:
                    Rgb(c.red, c.green, c.blue);
                case RGBA:
                    Rgba(c.red, c.green, c.blue, c.alpha);
            }
    }

    /**
     * Draw a bezier line between two points and one control point.
     *
     * @param x0 x position of the first point
     * @param y0 y position of the first point
     * @param xc x position of the control point
     * @param yc y position of the control point
     * @param x1 x position of the second point
     * @param y1 y position of the second point
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     */
    public inline function bezier(x0: Float, y0: Float, xc: Float, yc: Float, x1: Float, y1: Float, color: Color): Void
    {
        toChannels(color);
        DrawPixels.bezier(buf, x0, y0, xc, yc, x1, y1, c.r, c.g, c.b, c.a);
    }

    /**
     * Draw a thick bezier line between two points and one control point.
     *
     * @param x0 x position of the first point
     * @param y0 y position of the first point
     * @param xc x position of the control point
     * @param yc y position of the control point
     * @param x1 x position of the second point
     * @param y1 y position of the second point
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     * @param width indicates the line width.
     */
    public function filledBezier(x0: Float, y0: Float, xc: Float, yc: Float, x1: Float, y1: Float, color: Color, width: Float, ?antialiasing: Bool): Void
    {
        var t: Float = 0;
        while (t <= 1)
        {
            var x: Float = (1 - t) * (1 - t) * x0 + 2 * (1 - t) * t * xc + t * t * x1;
            var y: Float = (1 - t) * (1 - t) * y0 + 2 * (1 - t) * t * yc + t * t * y1;

            filledCircle(Std.int(x), Std.int(y), width, color, antialiasing);

            t += 0.005;
        }
    }

    /**
     * Indicates the start of border preservation.
     *
     * You can fill in a specific area. To do this, you need to identify the borders with `startFill` method and call the `fillArea` method to fill the area.
     * Borders work with: lines, gradient lines, circles, filled circles with anti-aliasing, pixels, arcs.
     * **NOT WORK WITH FILLED ARCS AND GRADIENT ARCS.**
     * The arcs themselves use this method, so the fill may not be predictable.
     * Do not create arcs until you are done with the fill. Be sure to call the `endFill` method when you stop working with the fill.
     */
    public inline function startFill(): Void
    {
        DrawPixels.startFill();
    }

    /**
     * Indicates the stop of border preservation.
     */
    public inline function endFill(): Void
    {
        DrawPixels.endFill();
    }

    /**
     * Fills an area at specified boundaries. Only for 4 channels.
     *
     * @param x x position of the start point
     * @param y y position of the start point
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255
     */
    public inline function fillArea(x: Float, y: Float, color: Color): Void
    {
        DrawPixels.fillArea(buf, x, y, c.r, c.g, c.b, c.a);
    }

    inline function toChannels(color: Color)
    {
        switch color
        {
            case None:
                {
                    c.r = 0;
                    c.g = 0;
                    c.b = 0;
                    c.a = 0;
                };
            case Red:
                {
                    c.r = 255;
                    c.g = 0;
                    c.b = 0;
                    c.a = 255;
                };
            case Green:
                {
                    c.r = 0;
                    c.g = 255;
                    c.b = 0;
                    c.a = 255;
                };
            case Blue:
                {
                    c.r = 0;
                    c.g = 0;
                    c.b = 255;
                    c.a = 255;
                };
            case White:
                {
                    c.r = 255;
                    c.g = 255;
                    c.b = 255;
                    c.a = 255;
                };
            case Black:
                {
                    c.r = 0;
                    c.g = 0;
                    c.b = 0;
                    c.a = 255;
                };
            case Rgb(r, g, b):
                {
                    c.r = r;
                    c.g = g;
                    c.b = b;
                    c.a = null;
                };
            case Rgba(r, g, b, a):
                {
                    c.r = r;
                    c.g = g;
                    c.b = b;
                    c.a = a;
                };
        };
    }
}
