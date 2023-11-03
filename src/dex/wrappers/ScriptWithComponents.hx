package dex.wrappers;

import defold.types.Message;
import defold.types.Url;
import defold.types.Hash;
import defold.support.ScriptOnInputAction;
import dex.ScriptComponentList;
import defold.support.Script;


typedef ScriptWithComponentsProperties =
{
    var components: ScriptComponentList;
}

class ScriptWithComponents<T: ScriptWithComponentsProperties> extends Script<T>
{
    override function init(self: T)
    {
        self.components.init();
    }

    override function update(self: T, dt: Float)
    {
        self.components.update(dt);
    }

    override function on_input(self: T, action_id: Hash, action: ScriptOnInputAction): Bool
    {
        return self.components.onInput(action_id, action);
    }

    override function on_message<TMessage>(self: T, message_id: Message<TMessage>, message: TMessage, sender: Url)
    {
        self.components.onMessage(message_id, message, sender);
    }
}
