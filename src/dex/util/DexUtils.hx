package dex.util;

import defold.Gui;
import defold.Window;
import defold.Sys;

class DexUtils {
	static var system:System = Unknown;

	/**
	 * Returns the system the game is running on.
	 */
	public static inline function getSystem():System {
		if (system == Unknown) {
			system = switch Sys.get_sys_info().system_name {
				case 'Darwin': Darwin;
				case 'Linux': Linux;
				case 'Windows': Windows;
				case 'HTML5': Html5;
				case 'Android': Android;
				case 'iPhone OS': IPhone;
				default: throw 'Unknown system?';
			};
		}

		return system;
	}

	/**
	 * Checks if the game is running on a mobile device.
	 */
	public static function isMobileDevice():Bool {
		return switch getSystem() {
			case Android | IPhone: true;

			case Html5: defold.Html5.run('(typeof window.orientation !== "undefined") || (navigator.userAgent.indexOf("IEMobile") !== -1)') == "true";

			default: false;
		}
	}

	public static inline function isDebug():Bool {
		return Sys.get_engine_info().is_debug;
	}

	/**
	 * Run once to disable the right-click context menu event for `HTML5` platforms.
	 */
	public static inline function ensureHtml5ContextMenuDisabled() {
		if (getSystem() == Html5) {
			defold.Html5.run("canvas.oncontextmenu=function(e){e.preventDefault(); return false;}");
		}
	}

	/**
	 * Returns the ratio of the window width to the Gui width.
	 */
	public static inline function getGuiAdjustFactorWidth():Float {
		return Window.get_size().width / Gui.get_width();
	}

	/**
	 * Returns the ratio of the window height to the Gui height.
	 */
	public static inline function getGuiAdjustFactorHeight():Float {
		return Window.get_size().height / Gui.get_height();
	}

	/**
	 * Returns the display width configured in `game.project`.
	 */
	public static inline function getDisplayWidth():Float {
		return Std.parseFloat(Sys.get_config("display.width"));
	}

	/**
	 * Returns the display height configured in `game.project`.
	 */
	public static inline function getDisplayHeight():Float {
		return Std.parseFloat(Sys.get_config("display.height"));
	}

	/**
	 * Returns the current width of the window.
	 */
	public static inline function getWindowWidth():Float {
		return Window.get_size().width;
	}

	/**
	 * Returns the current height of the window.
	 */
	public static inline function getWindowHeight():Float {
		return Window.get_size().height;
	}
}

enum System {
	Unknown;
	Darwin;
	Linux;
	Windows;
	Html5;
	Android;
	IPhone;
}
