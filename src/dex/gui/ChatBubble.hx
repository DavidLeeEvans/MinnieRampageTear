package dex.gui;

import defold.Gui.GuiTextMetrics;
import defold.types.Hash;
import dex.wrappers.GameObject;
import dex.wrappers.GuiNode;


class ChatBubble
{
    public var onObject(default, null): GameObject;
    public var chatBubbleTree(default, null): Map<Hash, GuiNode>;
    public var onScrollComplete: () -> Void;

    var texts: Map<Hash, String>;
    var options: Array<ChatBubbleTextOptions>;
    var duration: Int;
    var textCompleted: Bool;

    public function new(chatBubbleTree: Map<Hash, GuiNode>, texts: Map<Hash, String>, onObject: GameObject, duration: Int, instant: Bool,
            options: Array<ChatBubbleTextOptions>)
    {
        this.chatBubbleTree = chatBubbleTree;
        this.texts = texts;
        this.onObject = onObject;
        this.duration = duration;
        this.options = options;
        textCompleted = false;

        for (key => text in texts)
        {
            if (instant || !isScrolled(key))
            {
                chatBubbleTree[ key ].setText(text);
            }
            else
            {
                chatBubbleTree[ key ].setText("");
            }
        }
    }

    /**
        @return `true` if the bubble should close.
    **/
    public function update(): Bool
    {
        var textUpdated: Bool = false;

        for (key => text in texts)
        {
            if (isScrolled(key))
            {
                var curText: String = chatBubbleTree[ key ].getText();
                var curLength: Int = curText.length;

                if (curLength == text.length)
                {
                    // Text already completed.
                    continue;
                }

                var newText: String = curText + text.charAt(curLength);

                chatBubbleTree[ key ].setText(newText);

                textUpdated = true;
            }
        }

        if (!textUpdated && !textCompleted)
        {
            // No text was updated this frame, this means that all texts were completed in the last one.
            if (onScrollComplete != null)
            {
                onScrollComplete();
            }

            textCompleted = true;
        }

        return duration != 0 && --duration <= 0;
    }

    public function getMinWidth(): Float
    {
        var minWidth: Float = 0;

        for (key => text in texts)
        {
            var node: GuiNode = chatBubbleTree[ key ];

            var marginLeft: Float = node.getPosition().x;

            var textMetrics: GuiTextMetrics = node.getTextMetricsForString(texts[ key ]);

            var totalWidth: Float = marginLeft + textMetrics.width + marginLeft;

            if (minWidth < totalWidth)
            {
                minWidth = totalWidth;
            }
        }

        return minWidth;
    }

    inline function isScrolled(key: Hash): Bool
    {
        var scrolled: Bool = false;
        for (text in options)
        {
            if (text.id == key)
            {
                scrolled = text.scroll;
                break;
            }
        }
        return scrolled;
    }
}
