package dex.lib.drawpixels;

/**
 * Defold engine native extension for drawing pixels and simple geometry into texture buffer.
 * The size of the image you manipulate with DrawPixels must match that of the atlas, not the sprite image.
 * Otherwise you need to know where the sprite is the atlas and update that region of the atlas.
 *
 * In order to draw this into a sprite, you need a separate atlas with power of two texture, then use `Resource.set_texture()`.
 *
 * ```lua
 * resource.set_texture(go.get("#sprite", "texture0"), self.header, self.buffer_info.buffer)
 * ```
 *
 * In order to render this in gui, we just need to create a box and create a new texture.
 * We can use `Gui.new_texture`. Then you need to set this texture to the box using `Gui.set_texture`.
 *
 * ```lua
 * local data = buffer.get_bytes(self.buffer_info.buffer, hash("rgba"))
 * gui.new_texture("name", width, height, image.TYPE_RGBA, data)
 * gui.set_texture(gui.get_node("box"), "name")
 * gui.set_size(gui.get_node("box"), vmath.vector3(width, height, 0))
 * ```
 *
 * https://github.com/AGulev/drawpixels
 */
@:native("drawpixels")
extern class DrawPixels
{
    /**
     * Method for drawing a circle.
     *
     * @param bufferInfo buffer information
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
    static function circle(bufferInfo: BufferInfo, posX: Float, posY: Float, diameter: Float, red: Int, green: Int, blue: Int, ?alpha: Int,
        ?antialiasing: Bool, ?width: Float): Void;

    /**
     * Method for drawing a filled circle.
     *
     * @param bufferInfo buffer information
     * @param posX x position center of the circle
     * @param posY y position center of the circle
     * @param diameter diameter of the circle
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     * @param antialiasing adds anti-aliasing. Only for 4 channels. Optional parameter.
     */
    @:native("filled_circle")
    static function filledCircle(bufferInfo: BufferInfo, posX: Float, posY: Float, diameter: Float, red: Int, green: Int, blue: Int, ?alpha: Int,
        ?antialiasing: Bool): Void;

    /**
     * Method for drawing a rectangle.
     *
     * @param bufferInfo buffer information
     * @param posX x position center of the rectangle
     * @param posY y position center of the rectangle
     * @param rectWidth rectangle width
     * @param rectHeight rectangle height
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     */
    static function rect(bufferInfo: BufferInfo, posX: Float, posY: Float, rectWidth: Float, rectHeight: Float, red: Int, green: Int, blue: Int,
        ?alpha: Int): Void;

    /**
     * Method for drawing a filledrectangle.
     *
     * @param bufferInfo buffer information
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
    @:native("filled_rect")
    static function filledRect(bufferInfo: BufferInfo, posX: Float, posY: Float, rectWidth: Float, rectHeight: Float, red: Int, green: Int, blue: Int,
        ?alpha: Int, ?angle: Float): Void;

    /**
     * Fill buffer with the color.
     *
     * @param bufferInfo buffer information
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     */
    static function fill(bufferInfo: BufferInfo, red: Int, green: Int, blue: Int, ?alpha: Int): Void;

    /**
     * Draw a line between two points.
     *
     * @param bufferInfo buffer information
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
    static function line(bufferInfo: BufferInfo, x0: Float, y0: Float, x1: Float, y1: Float, red: Int, green: Int, blue: Int, ?alpha: Int,
        ?antialiasing: Bool, ?width: Float): Void;

    /**
     * Draw a gradient line between two points.
     *
     * @param bufferInfo buffer information
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
    @:native("gradient_line")
    static function gradientLine(bufferInfo: BufferInfo, x0: Float, y0: Float, x1: Float, y1: Float, red1: Int, green1: Int, blue1: Int, red2: Int,
        green2: Int, blue2: Int, ?alpha: Int, antialiasing: Bool, ?width: Float): Void;

    /**
     * Draw an arc between two corners.
     * If from < to the arc is drawn counterclockwise.
     * If from > to the arc is drawn clockwise. Only for 4 channels
     *
     * @param bufferInfo buffer information
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
    static function arc(bufferInfo: BufferInfo, x: Float, y: Float, radius: Float, from: Float, to: Float, red: Int, green: Int, blue: Int, alpha: Int): Void;

    /**
     * Draw a filled arc between two corners.
     * If from < to the arc is drawn counterclockwise.
     * If from > to the arc is drawn clockwise. Only for 4 channels
     *
     * @param bufferInfo buffer information
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
    @:native("filled_arc")
    static function filledArc(bufferInfo: BufferInfo, x: Float, y: Float, radius: Float, from: Float, to: Float, red: Int, green: Int, blue: Int,
        alpha: Int): Void;

    /**
     * Draw a filled arc between two corners.
     * If from < to the arc is drawn counterclockwise.
     * If from > to the arc is drawn clockwise. Only for 4 channels
     *
     * @param bufferInfo buffer information
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
    @:native("gradient_arc")
    static function gradientArc(bufferInfo: BufferInfo, x: Float, y: Float, radius: Float, from: Float, to: Float, red1: Int, green1: Int, blue1: Int,
        red2: Int, green2: Int, blue2: Int, alpha: Int): Void;

    /**
     * Draw a pixel.
     *
     * @param bufferInfo buffer information
     * @param x x position of pixel
     * @param y y position of pixel
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255. Optional parameter for rgba textures
     */
    static function pixel(bufferInfo: BufferInfo, x: Float, y: Float, red: Int, green: Int, blue: Int, ?alpha: Int): Void;

    /**
     * Read color from a position in the buffer.
     *
     * @param bufferInfo buffer information
     * @param x x position to get color from
     * @param y y position to get color from
     * @return the color
     */
    static function color(bufferInfo: BufferInfo, x: Float, y: Float): Color;

    /**
     * Draw a bezier line between two points and one control point.
     *
     * @param bufferInfo buffer information
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
    static function bezier(bufferInfo: BufferInfo, x0: Float, y0: Float, xc: Float, yc: Float, x1: Float, y1: Float, red: Int, green: Int, blue: Int,
        ?alpha: Int): Void;

    /**
     * Indicates the start of border preservation.
     *
     * You can fill in a specific area. To do this, you need to identify the borders with `startFill` method and call the `fillArea` method to fill the area.
     * Borders work with: lines, gradient lines, circles, filled circles with anti-aliasing, pixels, arcs.
     * **NOT WORK WITH FILLED ARCS AND GRADIENT ARCS.**
     * The arcs themselves use this method, so the fill may not be predictable.
     * Do not create arcs until you are done with the fill. Be sure to call the `endFill` method when you stop working with the fill.
     */
    @:native("start_fill")
    static function startFill(): Void;

    /**
     * Indicates the stop of border preservation.
     */
    @:native("end_fill")
    static function endFill(): Void;

    /**
     * Fills an area at specified boundaries. Only for 4 channels.
     *
     * @param bufferInfo buffer information
     * @param x x position of the start point
     * @param y y position of the start point
     * @param red red channel of the color 0..255
     * @param green green channel of the color 0..255
     * @param blue blue channel of the color 0..255
     * @param alpha alpha channel 0..255
     */
    @:native("fill_area")
    static function fillArea(bufferInfo: BufferInfo, x: Float, y: Float, red: Int, green: Int, blue: Int, alpha: Int): Void;
}
