package dex.systems;

import defold.Go;
import defold.Msg;
import defold.types.Hash;
import defold.types.Message;
import dex.util.DexError;
import dex.wrappers.GameObject;

/**
 * This is a simple system that allows all objects to subscribe to certain message types,
 * and then other objects to send messages that reach all subscribers.
 */
class Postman
{
    static var subscriptions: Map<Hash, Array<GameObject>>;

    public static function init()
    {
        subscriptions = [ ];
    }

    public static function update()
    {
        /**
         * Once per N frames, remove all subscribers that have been deleted.
         * We end up with deleted subscribers in-between these checks,
         * but that's fine because the send() method checks again if objects exist.
         */
        if (Time.everyFrames(60))
        {
            for (msg in subscriptions.keys())
            {
                subscriptions[ msg ] = subscriptions[ msg ].filter(o -> o.exists());
            }
        }
    }

    /**
     * Send a message to the postman.
     *
     * @param messageId the message id
     * @param message the message
     */
    public static inline function send<TMessage>(messageId: Message<TMessage>, ?message: TMessage)
    {
        var messageIdHash: Hash = cast messageId;
        if (!subscriptions.exists(messageIdHash))
        {
            // no subscribers for this message
            return;
        }

        for (subscriber in subscriptions[ messageIdHash ])
        {
            if (subscriber.exists())
            {
                // forward message
                Msg.post(subscriber, messageId, message);
            }
        }
    }

    /**
     * Subscribe an object to receive messages with a specific id.
     *
     * All messages received by the postman matching the given id will be sent also to the given gameobject.
     *
     * @param messageId the message id
     * @param recipient the object id; if left `null` if id of the calling object will be used
     */
    public static function subscribe<TMessage>(messageId: Message<TMessage>, ?recipient: GameObject)
    {
        if (recipient == null)
        {
            recipient = Go.get_id();
        }

        var messageId: Hash = cast messageId;
        if (!subscriptions.exists(messageId))
        {
            subscriptions.set(messageId, [ ]);
        }

        var removed: Bool = subscriptions[ messageId ].remove(recipient);
        DexError.assert(!removed, 'Postman.subscribe: gameobject $recipient tried to subscribe to message $messageId more than once');

        subscriptions[ messageId ].push(recipient);
    }

    /**
     * Unsubscribe an object from receiving messages with a given id.
     *
     * @param messageId the message id
     * @param recipient the object id; if left `null` if id of the calling object will be used
     */
    public static function unsubscribe<TMessage>(messageId: Message<TMessage>, ?recipient: GameObject)
    {
        if (recipient == null)
        {
            recipient = Go.get_id();
        }

        var messageId: Hash = cast messageId;

        DexError.assert(subscriptions.exists(messageId), 'Postman.unsubscribe: no subscriptions for message $messageId exist');

        var removed: Bool = subscriptions[ messageId ].remove(recipient);

        DexError.assert(removed, 'Postman.unsubscribe: gameobject $recipient is not subscribed to message $messageId');
    }

    /**
     * Unsubscribe a gameobject from all messages it may have subscribed to.
     *
     * @param recipient the object id; if left `null` if id of the calling object will be used
     */
    public static function unsubscribeFromAll(?recipient: GameObject)
    {
        if (recipient == null)
        {
            recipient = Go.get_id();
        }

        for (_ => subscribers in subscriptions)
        {
            subscribers.remove(recipient);
        }
    }

    /**
     * Unsubscribe all subscribers from a message.
     *
     * @param messageId the message id
     */
    public static function unsubscribeAll<TMessage>(messageId: Message<TMessage>)
    {
        var messageId: Hash = cast messageId;
        subscriptions.set(messageId, [ ]);
    }
}
