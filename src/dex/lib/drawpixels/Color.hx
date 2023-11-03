package dex.lib.drawpixels;

@:multiReturn
extern class Color
{
    /** red channel of the color 0..255 */
    var red: Int;

    /** green channel of the color 0..255 */
    var green: Int;

    /** blue channel of the color 0..255 */
    var blue: Int;

    /** alpha channel 0..255. Optional parameter for rgba textures */
    var alpha: Int;
}
