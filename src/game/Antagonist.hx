package game;

import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

enum abstract AntagonistEnumState(Int) {
	var Pleading = 0;
	var Attacking;
	var Running;
	var Hiding;
	var Assembling;
	var Dying;
	var Spawning;
	var Stunned;
	var Lost;
	var WMDLocate;
	var Flanking;
}

private typedef AntagonistData = {
	var _state:Int;
}

class Antagonist extends Script<AntagonistData> {
	override function init(self:AntagonistData) {}

	override function update(self:AntagonistData, dt:Float):Void {}

	override function on_message<T>(self:AntagonistData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:AntagonistData):Void {}

	override function on_reload(self:AntagonistData):Void {}
}
