package dex;

import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import dex.util.DexError;
import dex.util.types.OneOfTwo;


abstract ScriptComponentList(Array<ScriptComponent>)
{
    public function new(?components: Array<ScriptComponent>)
    {
        this = cast fromArray(components != null ? components : [ ]);
    }

    @:from
    static function fromArray(components: Array<ScriptComponent>): ScriptComponentList
    {
        var list: ScriptComponentList = cast [ ];

        for (component in components)
        {
            list.add(component);
        }

        return list;
    }

    @:op([ ])
    inline function getByIndex(i: Int): ScriptComponent
    {
        return this[ i ];
    }

    @:op([ ])
    inline function setByIndex(i: Int, component: OneOfTwo<Class<ScriptComponent>, ScriptComponent>): ScriptComponent
    {
        var componentInstance: ScriptComponent;

        if (Std.isOfType(component, ScriptComponent))
        {
            componentInstance = cast(component, ScriptComponent);
        }
        else
        {
            componentInstance = Type.createInstance(component, [ ]);
        }

        while (i >= this.length)
        {
            this.push(null);
        }

        this[ i ] = componentInstance;

        return this[ i ];
    }

    @:op([ ])
    inline function getByType<@:const T: ScriptComponent>(componentType: Class<T>): T
    {
        var foundComponent: T = null;
        for (component in this)
        {
            if (Std.isOfType(component, componentType))
            {
                foundComponent = cast component;
                break;
            }
        }
        return cast foundComponent;
    }

    public inline function require<@:const T: ScriptComponent>(componentType: Class<T>): T
    {
        var foundComponent: T = null;
        for (component in this)
        {
            if (Std.isOfType(component, componentType))
            {
                foundComponent = cast component;
                break;
            }
        }
        DexError.assert(foundComponent != null, 'missing required component: $componentType');
        return cast foundComponent;
    }

    public inline function has<@:const T: ScriptComponent>(componentType: Class<T>): Bool
    {
        var foundComponent: Bool = false;
        for (component in this)
        {
            if (Std.isOfType(component, componentType))
            {
                foundComponent = true;
                break;
            }
        }
        return foundComponent;
    }

    public inline function add(component: OneOfTwo<Class<ScriptComponent>, ScriptComponent>, unshift: Bool = false): ScriptComponent
    {
        if (this == null)
        {
            this = [ ];
        }

        var componentInstance: ScriptComponent;

        if (Std.isOfType(component, ScriptComponent))
        {
            componentInstance = cast(component, ScriptComponent);
        }
        else
        {
            componentInstance = Type.createInstance(component, [ ]);
        }

        if (unshift)
        {
            this.unshift(componentInstance);
        }
        else
        {
            this.push(componentInstance);
        }

        if (componentInstance.componentList != null)
        {
            DexError.error('component already in another list');
        }

        componentInstance.componentList = cast this;
        componentInstance.onAddedToList();

        return componentInstance;
    }

    public inline function init()
    {
        if (this == null)
        {
            this = [ ];
        }

        for (component in this)
        {
            component.init();
        }
    }

    public inline function update(dt: Float)
    {
        for (component in this)
        {
            component.update(dt);
        }
    }

    public inline function fixedUpdate(dt: Float)
    {
        for (component in this)
        {
            component.fixedUpdate(dt);
        }
    }

    public inline function onMessage<TMessage>(messageId: Message<TMessage>, message: TMessage, sender: Url)
    {
        for (component in this)
        {
            component.onMessage(messageId, message, sender);
        }
    }

    public inline function onInput(actionId: Hash, action: ScriptOnInputAction): Bool
    {
        for (component in this)
        {
            component.onBeforeInput();
        }

        var ret: Bool = false;
        for (component in this)
        {
            ret = ret || component.onInput(actionId, action);
        }
        return ret;
    }
}
