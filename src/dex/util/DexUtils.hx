package dex.util;

import defold.Gui;
import defold.Msg;
import defold.Physics;
import defold.Render.RenderMessages;
import defold.Sys;
import defold.Window;
import defold.types.Hash;
import defold.types.Vector4;
import defold.types.util.LuaArray;
import dex.systems.Time;
import dex.util.types.Vector2;
import lua.Table;


class DexUtils
{
    static var system: System = Unknown;

    /**
     * Returns the system the game is running on.
     */
    public static inline function getSystem(): System
    {
        if (system == Unknown)
        {
            var systemName: String = Sys.get_sys_info().system_name;

            system = switch systemName
                {
                    case 'Darwin':
                        Darwin;
                    case 'Linux':
                        Linux;
                    case 'Windows':
                        Windows;
                    case 'HTML5':
                        Html5;
                    case 'Android':
                        Android;
                    case 'iPhone OS':
                        IPhone;
                    default:
                        DexError.error('Unknown system: $systemName');
                };
        }

        return system;
    }

    /**
     * Checks if the game is running on a mobile device.
     */
    public static function isMobileDevice(): Bool
    {
        return
            switch getSystem()
            {
                case Android | IPhone:
                    true;

                case Html5:
                    defold.Html5.run('(typeof window.orientation !== "undefined") || (navigator.userAgent.indexOf("IEMobile") !== -1)') == "true";

                default:
                    false;
            }
    }

    /**
     * Returns `true` if this is a debug build.
     */
    public static inline function isDebug(): Bool
    {
        return Sys.get_engine_info().is_debug;
    }

    /**
     * Run once to disable the right-click context menu event for `HTML5` platforms.
     */
    public static inline function ensureHtml5ContextMenuDisabled()
    {
        if (getSystem() == Html5)
        {
            defold.Html5.run("canvas.oncontextmenu=function(e){e.preventDefault(); return false;}");
        }
    }

    /**
     * Returns the ratio of the window width to the Gui width.
     */
    public static inline function getGuiAdjustFactorWidth(): Float
    {
        return Window.get_size().width / Gui.get_width();
    }

    /**
     * Returns the ratio of the window height to the Gui height.
     */
    public static inline function getGuiAdjustFactorHeight(): Float
    {
        return Window.get_size().height / Gui.get_height();
    }

    /**
     * Returns the display width configured in `game.project`.
     */
    public static inline function getDisplayWidth(): Float
    {
        return Sys.get_config_int("display.width", 0);
    }

    /**
     * Returns the display height configured in `game.project`.
     */
    public static inline function getDisplayHeight(): Float
    {
        return Sys.get_config_int("display.height", 0);
    }

    /**
     * Returns the current width of the window.
     */
    public static inline function getWindowWidth(): Float
    {
        return Window.get_size().width;
    }

    /**
     * Returns the current height of the window.
     */
    public static inline function getWindowHeight(): Float
    {
        return Window.get_size().height;
    }

    /**
     * Draws a debug line on screen.
     *
     * @param from the starting point of the line
     * @param to the ending point of the line
     * @param color the color of the line
     */
    public static inline function drawLine(from: Vector2, to: Vector2, color: Vector4)
    {
        Msg.post("@render:", RenderMessages.draw_line,
            {
                start_point: from,
                end_point: to,
                color: color
            });
    }

    /**
     * Prints a given message to the console, prepended by the current application cycle number.
     *
     * Note that this requires the `Time` system to be enable and updated.
     */
    public static inline function log(msg: Dynamic)
    {
        Sys.println('[${Time.frame}] $msg');
    }

    /**
     * Checks if it is possible to raycast to a specific point.
     * In other words, if the point is visible from a position taking into account collision
     * obstacle groups.
     *
     * @param from the point to raycast from
     * @param to the point to raycast to
     * @param obstacleGroups the list of obstacle collision groups
     * @return `true` if there are no obstacles between `from` and `to`
     */
    public static inline function canRaycastTo(from: Vector2, to: Vector2, obstacleGroups: LuaArray<Hash>): Bool
    {
        var raycast: LuaArray<PhysicsMessageRayCastResponse> = Physics.raycast(from, to, obstacleGroups, {all: false});
        return raycast == null;
    }
}

enum System
{
    Unknown;
    Darwin;
    Linux;
    Windows;
    Html5;
    Android;
    IPhone;
}
