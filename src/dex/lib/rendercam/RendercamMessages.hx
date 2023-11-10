package dex.lib.rendercam;

import defold.types.Message;
import defold.types.Vector3;

typedef RendercamMessageWindowUpdate = Window;

class RendercamMessages {
	/** Message sent to all listeners added through `Rendercam.add_window_listener` when the window is updated. **/
	static var window_update(default, never) = new Message<RendercamMessageWindowUpdate>("window_update");
}
