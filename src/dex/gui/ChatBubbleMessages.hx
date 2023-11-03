package dex.gui;

import defold.types.Hash;
import defold.types.Vector3;


@:build(defold.support.MessageBuilder.build())
class ChatBubbleMessages
{
    var chat_bubble_create: CreateChatBubbleMessage;

    var chat_bubble_update: CreateChatBubbleUpdateMessage;
}

typedef CreateChatBubbleMessage =
{
    var position: Vector3;

    var texts: Map<Hash, String>;
}

typedef CreateChatBubbleUpdateMessage =
{
    var position: Vector3;

    var object: Hash;
}
