package game.minnie;

import Defold.hash;
import defold.Factory;
import defold.Go;
import defold.Sprite.SpriteMessages;
import defold.extensions.spine.Spine;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

private typedef AnimationsSpineData = {}

class AnimationsSpine extends Script<AnimationsSpineData> {
	override function init(self:AnimationsSpineData) {
		// Spine.get_go("foo#myspinecomponent", "boneid")

		final _left_id = Spine.get_go("/MinnieSpine/go#MinnieSpine", hash("black_left_arm"));
		final _right_id = Spine.get_go("/MinnieSpine/go#MinnieSpine", hash("black_right_arm"));
		final _body_id = Spine.get_go("/MinnieSpine/go#MinnieSpine", hash("black_character"));
		final _left_obj = Factory.create("fac_black_left_arm");
		final _right_obj = Factory.create("fac_black_right_arm");
		final _body_obj = Factory.create("fac_black_character");
		Go.set_parent(_left_obj, _left_id);
		Go.set_parent(_right_obj, _right_id);
		Go.set_parent(_body_obj, _body_id);
		//
		Go.set_parent(_left_id, ".");
		Go.set_parent(_right_id, ".");
		Go.set_parent(_body_id, ".");
	}

	override function update(self:AnimationsSpineData, dt:Float):Void {}

	override function on_message<T>(self:AnimationsSpineData, message_id:Message<T>, message:T, sender:Url):Void {
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
	}

	override function final_(self:AnimationsSpineData):Void {}

	override function on_reload(self:AnimationsSpineData):Void {}
}
