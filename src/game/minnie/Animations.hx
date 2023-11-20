package game.minnie;

import defold.Sprite.SpriteMessages;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

private typedef AnimationsData = {}

@:build(defold.support.HashBuilder.build()) class AnimationsHash {
	var Attacking;
	var Walking;
	var Running;
	var Resting;
	var Jumping;
	var Ducking;
	var Throwing;
	var Grasp;
	var Stunned;
	var Teleporting;
	var Hurt;
	var Dying;
	var Reunion;
}

class Animations extends Script<AnimationsData> {
	override function init(self:AnimationsData) {}

	override function update(self:AnimationsData, dt:Float):Void {}

	override function on_message<T>(self:AnimationsData, message_id:Message<T>, message:T, sender:Url):Void {
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

	override function final_(self:AnimationsData):Void {}

	override function on_reload(self:AnimationsData):Void {}
}
