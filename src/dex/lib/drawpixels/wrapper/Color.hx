package dex.lib.drawpixels.wrapper;

enum Color
{
    None;

    Red;
    Green;
    Blue;
    White;
    Black;

    /**
     * RGB color with red, green, blue channels (0...255)
     */
    Rgb(r: Int, g: Int, b: Int);

    /**
     * RGB color with red, green, blue, and alpha channels (0...255)
     */
    Rgba(r: Int, g: Int, b: Int, ?a: Int);
}
