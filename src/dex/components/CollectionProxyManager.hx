package dex.components;

import defold.Collectionproxy.CollectionproxyMessages;
import defold.types.Message;
import defold.types.Url;
import dex.util.DexError;
import dex.util.StateMachine;
import dex.wrappers.CollectionProxy;


enum abstract CollectionProxyState(Int) to Int
{
    /**
     * This state only indicates that the collection proxy url given to `getState()`
     * is not managed by the manager.
     */
    var Unknown;

    /**
     * The collection proxy has not been loaded.
     */
    var Unloaded;

    /**
     * The collection proxy is currently being loaded.
     * Either `load` or `async_load` has been sent, but `proxy_loaded` hasn't been received yet.
     */
    var Loading;

    /**
     * The collection proxy has been loaded, but not enabled.
     */
    var Loaded;

    /**
     * The collection proxy is currently being unloaded.
     * The `unload` message has been sent, but `proxy_unloaded` hasn't been received yet.
     */
    var Unloading;

    /**
     * The collection proxy has been enabled.
     */
    var Enabled;
}

enum abstract CollectionProxyTransition(Int) to Int
{
    var Load;
    var LoadDone;
    var Unload;
    var UnloadDone;
    var Enable;
    var Disable;
}

/**
 * Component for automatically managing multiple collection proxies.
 *
 * Each proxy is tracked using a state machine: `Unloaded` ⇄ `Loaded` ⇄ `Enabled`
 */
class CollectionProxyManager extends ScriptComponent
{
    var collectionProxyStates: Map<CollectionProxy, CollectionProxyState>;
    var collectionProxyCallbacks: Map<CollectionProxy, CollectionProxy->Void>;
    var stateMachine: StateMachine<CollectionProxyState, CollectionProxyTransition>;

    public function new()
    {
        super();

        stateMachine = StateMachine.create([
            Unloaded => [ Load => Loading ],
            Loading => [ LoadDone => Loaded ],
            Loaded => [ Unload => Unloading, Enable => Enabled ],
            Unloading => [ UnloadDone => Unloaded ],
            Enabled => [ Disable => Loaded ]
        ]);
    }

    override function init()
    {
        collectionProxyStates = cast [ ];
        collectionProxyCallbacks = cast [ ];
    }

    override function onMessage<TMessage>(messageId: Message<TMessage>, message: TMessage, sender: Url)
    {
        switch messageId
        {
            case CollectionproxyMessages.proxy_loaded:
                {
                    var cp: CollectionProxy = sender;
                    DexError.assert(collectionProxyStates.exists(cp), 'got a collection proxy message for untracked proxy: $cp');

                    transition(cp, LoadDone);

                    if (collectionProxyCallbacks[ cp ] != null)
                    {
                        collectionProxyCallbacks[ cp ](cp);
                        collectionProxyCallbacks.set(cp, null);
                    }
                }

            case CollectionproxyMessages.proxy_unloaded:
                {
                    var cp: CollectionProxy = sender;
                    DexError.assert(collectionProxyStates.exists(cp), 'got a collection proxy message for untracked proxy: $cp');

                    transition(cp, UnloadDone);

                    if (collectionProxyCallbacks[ cp ] != null)
                    {
                        collectionProxyCallbacks[ cp ](cp);
                        collectionProxyCallbacks.set(cp, null);
                    }
                }

            default:
        }
    }

    /**
     * Load a collection proxy synchronously.
     *
     * The user should wait until the state of the collection proxy changes to `Loaded`, or until the callback is fired
     * before enabling it.
     *
     * @param collectionProxy the collection proxy url
     * @param callback a callback function that will be invoked when the collection proxy is loaded
     */
    public function load(collectionProxy: CollectionProxy, ?callback: CollectionProxy->Void)
    {
        if (!collectionProxyStates.exists(collectionProxy))
        {
            add(collectionProxy);
        }

        collectionProxy.load();
        transition(collectionProxy, Load);
        collectionProxyCallbacks.set(collectionProxy, callback);
    }

    /**
     * Load a collection proxy asynchronously.
     *
     * The user should wait until the state of the collection proxy changes to `Loaded`, or until the callback is fired
     * before enabling it.
     *
     * @param collectionProxy the collection proxy url
     * @param callback a callback function that will be invoked when the collection proxy is loaded
     */
    public function loadAsync(collectionProxy: CollectionProxy, ?callback: CollectionProxy->Void)
    {
        if (!collectionProxyStates.exists(collectionProxy))
        {
            add(collectionProxy);
        }

        collectionProxy.loadAsync();
        transition(collectionProxy, Load);
        collectionProxyCallbacks.set(collectionProxy, callback);
    }

    /**
     * Enable a collection proxy.
     *
     * This should also generate an `init` message on the collection proxy.
     *
     * @param collectionProxy the collection proxy url
     */
    public function enable(collectionProxy: CollectionProxy)
    {
        DexError.assert(collectionProxyStates.exists(collectionProxy));

        collectionProxy.enable();
        transition(collectionProxy, Enable);
    }

    /**
     * Disable a collection proxy.
     *
     * This should also generate `final` and `disable` messages on the collection proxy.
     *
     * @param collectionProxy the collection proxy url
     */
    public function disable(collectionProxy: CollectionProxy)
    {
        DexError.assert(collectionProxyStates.exists(collectionProxy));

        collectionProxy.final_();
        collectionProxy.disable();
        transition(collectionProxy, Disable);
    }

    /**
     * Unload a collection proxy.
     *
     * The user should wait until the state of the collection proxy changes to `Unloaded`, or until the callback is fired
     * before attempting to load it again.
     *
     * @param collectionProxy the collection proxy url
     * @param callback a callback function that will be invoked when the collection proxy is unloaded
     */
    public function unload(collectionProxy: CollectionProxy, ?callback: CollectionProxy->Void)
    {
        DexError.assert(collectionProxyStates.exists(collectionProxy));

        collectionProxy.unload();
        transition(collectionProxy, Unload);
        collectionProxyCallbacks.set(collectionProxy, callback);
    }

    /**
     * Sets the timestep of a collection proxy.
     *
     * @param collectionProxy the collection proxy url
     * @param factor the time factor
     */
    public function setTimestep(collectionProxy: CollectionProxy, factor: Float)
    {
        DexError.assert(collectionProxyStates.exists(collectionProxy));
        DexError.assert(factor >= 0);

        collectionProxy.setTimeStep(factor);
    }

    /**
     * Gets the current state of a collection proxy.
     *
     * Will return `Unknown` if the url given is not one of a collection
     * proxy that is managed by this manager.
     *
     * @param collectionProxy the collection proxy url
     * @return the collection proxy's state
     */
    public inline function getState(collectionProxy: CollectionProxy): CollectionProxyState
    {
        if (!collectionProxyStates.exists(collectionProxy))
        {
            return Unknown;
        }

        return collectionProxyStates[ collectionProxy ];
    }

    function add(collectionProxy: CollectionProxy)
    {
        collectionProxyStates.set(collectionProxy, Unloaded);
        collectionProxyCallbacks.set(collectionProxy, null);
    }

    function transition(cp: CollectionProxy, transition: CollectionProxyTransition)
    {
        collectionProxyStates[ cp ] = stateMachine.transition(collectionProxyStates[ cp ], transition);
    }
}
