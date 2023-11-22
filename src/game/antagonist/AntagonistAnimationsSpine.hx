package game.antagonist;

import Defold.hash;
import defold.Factory;
import defold.Go;
import defold.extensions.spine.Spine;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

private typedef AntagonistAnimationsSpineData = {}

class AntagonistAnimationsSpine extends Script<AntagonistAnimationsSpineData> {
	override function init(self:AntagonistAnimationsSpineData) {
		// Spine.get_go("foo#myspinecomponent", "boneid")

		final _left_wmd_id = Spine.get_go("#spine", hash("left-wmd"));
		final _right_wmd_id = Spine.get_go("#spine", hash("right-wmd"));
		final _body_id = Spine.get_go("#spine", hash("body"));
		//
		final _left_wmd_obj = Factory.create("#fac_wmd");
		final _right_wmd_obj = Factory.create("#fac_wmd");
		final _body_obj = Factory.create("#fac_body");
		//
		Go.set_parent(_left_wmd_obj, _left_wmd_id);
		Go.set_parent(_right_wmd_obj, _right_wmd_id);
		Go.set_parent(_body_obj, _body_id);
		//
	}

	override function update(self:AntagonistAnimationsSpineData, dt:Float):Void {}

	override function on_message<T>(self:AntagonistAnimationsSpineData, message_id:Message<T>, message:T, sender:Url):Void {
		/*
			switch (message_id) {

				case SpriteMessages.animation_done:
					if (message.id == AnimationsHash.Attacking) {
						// Attacking
					} else if (message.id == AnimationsHash.Walking) {
						// TODO Walking
					} else if (message.id == AnimationsHash.Running) {
						// TODO Running
					} else if (message.id == AnimationsHash.Resting) {
						// TODO Resting
					} else if (message.id == AnimationsHash.Jumping) {
						// TODO Jumping
					} else if (message.id == AnimationsHash.Ducking) {
						// TODO Ducking
					} else if (message.id == AnimationsHash.Throwing) {
						// TODO Throwing
					} else if (message.id == AnimationsHash.Grasp) {
						// TODO Grasp
					} else if (message.id == AnimationsHash.Stunned) {
						// TODO Stunned
					} else if (message.id == AnimationsHash.Teleporting) {
						// TODO Teleporting
					} else if (message.id == AnimationsHash.Hurt) {
						// TODO Hurt
					} else if (message.id == AnimationsHash.Dying) {
						// TODO Dying
					} else if (message.id == AnimationsHash.Reunion) {
						// TODO Reunion
					}
			}
		 */
	}

	override function final_(self:AntagonistAnimationsSpineData):Void {}

	override function on_reload(self:AntagonistAnimationsSpineData):Void {}
}