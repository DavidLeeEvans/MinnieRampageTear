package game.antagonist;

import Defold.hash;
import defold.Go;
import defold.Msg;
import defold.Sprite.SpriteMessages;
import defold.extensions.spine.Spine;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

private typedef AntagonistAnimationsSpineData = {
	@property(-1) var type:Int;
}

class AntagonistAnimationsSpine extends Script<AntagonistAnimationsSpineData> {
	override function init(self:AntagonistAnimationsSpineData) {
		lua.Lua.assert(self.type != -1, "!!!!!!!!!!!!!!! AntagonistAnimationsSpine.hx type is not set!!!!!!!!!!!!!");
		final _left_wmd_id = Spine.get_go("#spine", hash("left-hand"));
		final _right_wmd_id = Spine.get_go("#spine", hash("right-hand"));
		final _body_id = Spine.get_go("#spine", hash("character"));

		//
		// final _left_wmd_obj = Factory.create("#fac_wmd", Go.get_world_position(_left_wmd_id));
		// final _right_wmd_obj = Factory.create("#fac_wmd", Go.get_world_position(_right_wmd_id));
		// final _body_obj = Factory.create("#fac_body");
		//
		Go.set_parent("/left-hand", _left_wmd_id, true);
		Go.set_parent("/right-hand", _right_wmd_id, true);
		Go.set_parent("/character", _body_id, true);
		switch (self.type) {
			case 0:
				// yellow
				Msg.post("/character#sprite", SpriteMessages.play_animation, {id: hash("yellow_character")});
				Msg.post("/right-hand#sprite", SpriteMessages.play_animation, {id: hash("yellow_hand")});
				Msg.post("/left-hand#sprite", SpriteMessages.play_animation, {id: hash("yellow_hand")});
			case 1:
				// purple
				Msg.post("/character#sprite", SpriteMessages.play_animation, {id: hash("yellow_character")});
				Msg.post("/right-hand#sprite", SpriteMessages.play_animation, {id: hash("yellow_hand")});
				Msg.post("/left-hand#sprite", SpriteMessages.play_animation, {id: hash("yellow_hand")});
			case 2:
				// green
				Msg.post("/character#sprite", SpriteMessages.play_animation, {id: hash("yellow_character")});
				Msg.post("/right-hand#sprite", SpriteMessages.play_animation, {id: hash("yellow_hand")});
				Msg.post("/left-hand#sprite", SpriteMessages.play_animation, {id: hash("yellow_hand")});
			case 3:
				// red
				Msg.post("/character#sprite", SpriteMessages.play_animation, {id: hash("yellow_character")});
				Msg.post("/right-hand#sprite", SpriteMessages.play_animation, {id: hash("yellow_hand")});
				Msg.post("/left-hand#sprite", SpriteMessages.play_animation, {id: hash("yellow_hand")});
		}
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
