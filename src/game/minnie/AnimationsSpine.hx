package game.minnie;

import defold.Sprite.SpriteMessages;
import defold.support.Script;
import defold.types.Message;
import defold.types.Url;

private typedef AnimationsSpineData = {}


class AnimationsSpine extends Script<AnimationsSpineData> {
	override function init(self:AnimationsSpineData) {}

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
