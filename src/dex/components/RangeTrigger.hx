package dex.components;

import dex.wrappers.GameObject;

import defold.Msg;

import defold.Physics.PhysicsMessageTriggerResponse;
import defold.Physics.PhysicsMessages;

import defold.types.Message;
import defold.types.Url;
import defold.types.Hash;

private class GameObjectIterator {
	var objects:Array<GameObject>;
	var i:Int;

	public inline function new(objects:Array<GameObject>) {
		this.objects = objects;
		i = 0;
	}

	public inline function hasNext():Bool {
		while (i < objects.length && !objects[i].exists()) {
			objects.splice(i, 1);
		}

		return i < objects.length;
	}

	public inline function next():GameObject {
		return objects[i++];
	}
}

/**
	Component to be attached to an object with a trigger collider.

	This component keeps track of all other objects of the given groups that are
	currently overlapping with the collider.
**/
class RangeTrigger extends ScriptComponent {
	public var objectsInRange(default, null):Array<GameObject>;
	public var onEnter:(object:GameObject) -> Void;
	public var onExit:(object:GameObject) -> Void;

	var ownGroup:Hash;
	var targetGroups:Array<Hash>;

	public function new(ownGroup:Hash, targetGroups:Array<Hash>) {
		super();

		objectsInRange = new Array<GameObject>();
		this.ownGroup = ownGroup;
		this.targetGroups = targetGroups;
	}

	public override function onMessage<TMessage>(messageId:Message<TMessage>, message:TMessage, sender:Url) {
		switch messageId {
			case PhysicsMessages.trigger_response:
				{
					var triggerMsg:PhysicsMessageTriggerResponse = cast message;

					if (triggerMsg.own_group == ownGroup && targetGroups.indexOf(triggerMsg.other_group) > -1) {
						if (triggerMsg.enter) {
							objectsInRange.push(cast triggerMsg.other_id);

							if (onEnter != null) {
								onEnter(cast triggerMsg.other_id);
							}
						} else {
							objectsInRange.remove(cast triggerMsg.other_id);

							if (onExit != null) {
								onExit(cast triggerMsg.other_id);
							}
						}
					}
				}
		}
	}

	/**
	 * Sends the given message to all objects currently in the trigger range.
	 */
	public inline function broadcast<TMessage>(messageId:Message<TMessage>, message:TMessage = null) {
		for (object in objectsInRange) {
			Msg.post(object, messageId, message);
		}
	}

	/**
	 * Returns a safe iterator, that cleans the list from deleted objects while iterating through it.
	 */
	public inline function iterator():Iterator<GameObject> {
		return new GameObjectIterator(objectsInRange);
	}
}
