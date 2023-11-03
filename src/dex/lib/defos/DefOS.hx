package dex.lib.defos;

import haxe.extern.EitherType;
import dex.lib.defos.types.*;

/**
    ### DefOS
    https://github.com/subsoap/defos

    Extra native OS functions for games written using the Defold game engine
    Currently supports macOS, Windows, Linux and HTML5.
**/
@:native("defos")
extern class DefOS
{
    /** The system path separator. `\\` on Windows, `/` everywhere else. **/
    static var PATH_SEP(default, never): String;

    static var CURSOR_ARROW(default, never): Cursor;

    static var CURSOR_HAND(default, never): Cursor;

    static var CURSOR_CROSSHAIR(default, never): Cursor;

    static var CURSOR_IBEAM(default, never): Cursor;

    /**
        Disable the title bar's maximize button.

        - Not supported on **HTML5**.
    **/
    static function disable_maximize_button(): Void;

    /**
        Disable the title bar's minimuze button.

        - Not supported on **HTML5**.
    **/
    static function disable_minimize_button(): Void;

    /**
        Disable window resizing.

        - Not supported on **HTML5**.
    **/
    static function disable_window_resize(): Void;

    /**
        Sets the window's title.

        - Not supported on **HTML5**.
    **/
    static function set_window_title(title: String): Void;

    /**
        Sets the window to maximized.
    **/
    static function set_maximized(maximized: Bool): Void;

    /**
        Toggles the window's maximize status.
    **/
    static function toggle_maximized(): Void;

    /**
        Returns `true` if the window is maximized.
    **/
    static function is_maximized(): Bool;

    /**
        Sets the window to full-screen.

        - On  **HTML5** this only works from `DefOS.on_click`.
    **/
    static function set_fullscreen(fullscreen: Bool): Void;

    /**
        Sets the window's full-screen status.

        - On  **HTML5** this only works from `DefOS.on_click`.
    **/
    static function toggle_fullscreen(): Void;

    /**
        Returns `true` if the window is on full-screen.
    **/
    static function is_fullscreen(): Bool;

    /**
        Sets the window to always be on top.

        - Not supported on **HTML5**.
    **/
    static function set_always_on_top(alwaysOnTop: Bool): Void;

    /**
        Toggles the window always being on top.

        - Not supported on **HTML5**.
    **/
    static function toggle_always_on_top(): Void;

    /**
        Returns `true` if the window is set to always be on top
    **/
    static function is_always_on_top(): Bool;

    /**
        Minimizes the window.

        - Not supported on **HTML5**.
    **/
    static function minimize(): Void;

    /**
        Activates (focuses) the window.

        - Not supported on **HTML5**.
    **/
    static function activate(): Void;

    /**
        Gets the window's size and position in screen coordinates. The window area includes the title bar, so the actual contained game view area might be smaller than the given metrics.

        Screen coordinates start at `(0, 0)` in the top-left corner of the main display. X axis goes right. Y axis goes down.
    **/
    static function get_window_size(): WindowSize;

    /**
        Sets the window's size and position in screen coordinates. The window area includes the title bar, so the actual contained game view area might be smaller than the given metrics.

        Passing `null` for x and y will center the window in the middle of the display.

        Screen coordinates start at `(0, 0)` in the top-left corner of the main display. X axis goes right. Y axis goes down.
    **/
    static function set_window_size(x: Null<Float>, y: Null<Float>, w: Float, h: Float): Void;

    /**
        Gets the game view size and position in screen coordinates. This adjusts the window so that its containing game view is at the desired size and position. The window will be larger than the given metrics because it includes the title bar.
    **/
    static function get_view_size(): ViewSize;

    /**
        Sets the game view size and position in screen coordinates. This adjusts the window so that its containing game view is at the desired size and position. The window will be larger than the given metrics because it includes the title bar.

        Passing `null` for x and y will center the window in the middle of the display.
    **/
    static function set_view_size(x: Float, y: Float, w: Float, h: Float): Void;

    /**
        Returns a list of available displays.

        - Not supported on **HTML5**.
        - The first element is the main display.
    **/
    static function get_displays(): Array<Display>;

    /**
        Gets the ID of the game's current display
    **/
    static function get_current_display_id(): DisplayId;

    /**
        Returns a list with all the resolution modes a display supports.
    **/
    static function get_display_modes(displayId: DisplayId): Array<DisplayMode>;

    /**
        Shows the mouse cursor.
    **/
    static function set_cursor_visible(visible: Bool): Void;

    /**
        Returns `true` if the mouse cursor is visible.
    **/
    static function is_cursor_visible(): Bool;

    /**
        Returns `true` if the mouse cursor is inside the view area.
    **/
    static function is_mouse_in_view(): Bool;

    /**
        Registers a callback to be invoked whenever the mouse enters the view area.
    **/
    static function on_mouse_enter(callback: () -> Void): Void;

    /**
        Registers a callback to be invoked whenever the mouse exits the view area.
    **/
    static function on_mouse_leave(callback: () -> Void): Void;

    /**
        Returns the position of the cursor in screen coordinates.
    **/
    static function get_cursor_pos(): Position;

    /**
        Returns the position of the cursor in view coordinates.
    **/
    static function get_cursor_pos_view(): Position;

    /**
        Sets the position of the cursor to the specified screen coordinates.

        - Not supported on **HTML5**.
    **/
    static function set_cursor_pos(x: Int, y: Int): Void;

    /**
        Sets the position of the cursor to the specified view coordinates.

        - Not supported on **HTML5**.
    **/
    static function set_cursor_pos_view(x: Int, y: Int): Void;

    /**
        Sets the cursor to be clipped to the current game view area.

        - Not supported on **Linux** or **HTML5**.
    **/
    static function set_cursor_clipped(clipped: Bool): Void;

    /**
        Returns `true` if the cursor is set to be clipped to the current game view area.

        - Not supported on **Linux** or **HTML5**.
    **/
    static function is_cursor_clipped(): Bool;

    /**
        Locks the cursor's movements.

        - On  **HTML5** this only works from `DefOS.on_click`.
        - Not supported on **Linux**.
    **/
    static function set_cursor_locked(locked: Bool): Void;

    /**
        Returns `true` if the cursor is locked.

        - Not supported on **Linux**.
    **/
    static function is_cursor_locked(): Bool;

    /**
        Registers a callback to be invoked on **HTML5** when the user presses ESC and the browser disables locking

        - Not supported on **Linux**.
    **/
    static function on_cursor_lock_disabled(callback: () -> Void): Void;

    /**
        Loads a custom hardware cursor.

        Given `cursor_data` must be:

        - On **HTML5**, a URL to an image (data URLs work as well).
        - On **Windows**, a path to an `.ani` or `.cur` file on the file system.
        - On **Linux**, a path to an X11 cursor file on the file system.
        - On **maxOS**, a `CursorData` structure.

    **/
    static function load_cursor(cursor_data: EitherType<String, CursorData>): Cursor;

    /**
        Sets a custom hardware cursor.

        Can be:

        - `null`: Resets the cursor to the default. Equivalent to `DefOS.reset_cursor()`.
        - `DefOS.CURSOR_ARROW`
        - `DefOS.CURSOR_HAND`
        - `DefOS.CURSOR_CROSSHAIR`
        - `DefOS.CURSOR_IBEAM`
        - A `Cursor` value obtained with `DefOS.load_cursor()`.
        - A `CursorData` value that will be used to create a single-use cursor.
    **/
    static function set_cursor(cursor: EitherType<Cursor, CursorData>): Void;

    /**
        Resets the cursor to the default.
    **/
    static function reset_cursor(): Void;

    /**
        Shows or hides the console window on Windows.
        Only works when not running from the Editor.
    **/
    static function set_console_visible(visible: Bool): Void;

    /**
        Returns `true` if the console is currently being shown.
        Only works when not running from the Editor.
    **/
    static function is_console_visible(): Bool;

    /**
        On **HTML5** only, get a synchronous event when the user clicks in the canvas.
        This is necessary because some HTML5 functions only work when called synchronously from an event handler.

        - `DefOS.toggle_fullscreen()`
        - `DefOS.set_cursor_locked(true)`
    **/
    static function on_click(callback: () -> Void): Void;

    /**
        Gets the absolute path to the game's containing directory.

        - On macOS this will be the path to the .app bundle.
        - On HTML5 this will be the page URL up until the last `/`.
    **/
    static function get_bundle_root(): String;

    /**
        Changes the game window's icon at runtime.

        - On **Windows**, this function accepts `.ico` files.
        - On **macOS** this accepts any image file supported by NSImage.
        - On **Linux** this function is not supported yet.
    **/
    static function set_window_icon(pathToIconFile: String): Void;

    /**
        Returns a table of command line arguments used to run the app.

        - On **HTML5**, returns an array with a single string: the query string part of the URL (eg. `[ "?param1=foo&param2=bar ]`).
    **/
    static function get_arguments(): Array<String>;
}
