package dex.gui;

import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import dex.gui.ChatBubbleMessages.CreateChatBubbleMessage;
import dex.util.types.Vector2;
import dex.wrappers.GameObject;
import dex.wrappers.GuiNode;


class ChatBubbles extends ScriptComponent
{
    public var characterInterval: Float = 0.05;
    public var maxCharactersPerLine: Int = 20;

    var templateId: Hash;
    var options: Array<ChatBubbleTextOptions>;

    var templateNode: GuiNode;
    var bubbles: Array<ChatBubble>;
    var updateTimer: Float;

    public function new(templateId: Hash, options: Array<ChatBubbleTextOptions>)
    {
        super();

        this.templateId = templateId;
        this.options = options;
    }

    override function init()
    {
        super.init();

        templateNode = new GuiNode(templateId);
        templateNode.disable();

        bubbles = new Array<ChatBubble>();
        updateTimer = 0;
    }

    override function update(dt: Float)
    {
        super.update(dt);

        updateTimer += dt;
        if (updateTimer >= characterInterval)
        {
            for (bubble in bubbles.copy())
            {
                var shouldClose: Bool = bubble.update();

                if (shouldClose)
                {
                    bubble.chatBubbleTree[ templateId ].delete();
                    bubbles.remove(bubble);
                }
            }
            updateTimer = 0;
        }
    }

    override function onMessage<TMessage>(messageId: Message<TMessage>, message: TMessage, sender: Url)
    {
        super.onMessage(messageId, message, sender);

        switch messageId
        {
            case ChatBubbleMessages.chat_bubble_create:
                {
                    var createMsg: CreateChatBubbleMessage = cast message;

                    create(createMsg.position, createMsg.texts, cast sender);
                }
        }
    }

    public function getBubbleOnObject(object: Hash): GuiNode
    {
        for (bubble in bubbles)
        {
            if (bubble.onObject == object)
            {
                return bubble.chatBubbleTree[ templateId ];
            }
        }
        return null;
    }

    public function closeBubbleOnObject(object: Hash)
    {
        var bubbleToClose: ChatBubble = null;

        for (bubble in bubbles)
        {
            if (bubble.onObject == object)
            {
                bubbleToClose = bubble;
                break;
            }
        }

        if (bubbleToClose != null)
        {
            bubbles.remove(bubbleToClose);
            bubbleToClose.chatBubbleTree[ templateId ].delete();
        }
    }

    public function create(position: Vector2, texts: Map<Hash, String>, onObject: GameObject, duration: Float = 0, instant: Bool = false): ChatBubble
    {
        closeBubbleOnObject(onObject);

        // clone template node
        var chatBubbleTree: Map<Hash, GuiNode> = templateNode.cloneTree();
        var chatBubbleNode: GuiNode = chatBubbleTree[ templateId ];

        // add line-breaks where necessary
        for (key => text in texts)
        {
            texts[ key ] = transformBubbleText(text);

            var lines: Int = texts[ key ].split("\n").length;

            if (lines > 1)
            {
                var addedHeight: Int = addedHeightPerExtraLine(key);

                chatBubbleNode.addSize(0, addedHeight * (lines - 1));
            }
        }

        // create and add new bubble to the list
        var bubble: ChatBubble = new ChatBubble(chatBubbleTree, texts, onObject, Math.ceil(duration / characterInterval), instant, options);
        bubbles.push(bubble);

        // Update the bubble's width.
        var minWidth: Float = bubble.getMinWidth();
        if (chatBubbleNode.getSize().x < minWidth)
        {
            chatBubbleNode.setSize(minWidth, chatBubbleNode.getSize().y);
        }

        // set the position and enable
        chatBubbleNode.setPosition(position);
        chatBubbleNode.enable();

        return bubble;
    }

    function transformBubbleText(text: String): String
    {
        var words: Array<String> = text.split(" ");
        var newText: StringBuf = new StringBuf();

        var curLineLength: Int = 0;

        for (word in words)
        {
            if (curLineLength == 0 || curLineLength + word.length < maxCharactersPerLine)
            {
                // Append word to current line.
                if (newText.length > 0)
                {
                    newText.add(" ");
                }

                curLineLength += word.length;
            }
            else
            {
                // Start a new line.
                newText.add("\n");
                curLineLength = word.length;
            }

            newText.add(word);
        }

        return newText.toString();
    }

    inline function addedHeightPerExtraLine(key: Hash): Int
    {
        var addedHeight: Int = 0;
        for (text in options)
        {
            if (text.id == key)
            {
                addedHeight = text.addedHeightPerExtraLine;
                break;
            }
        }
        return addedHeight;
    }
}
