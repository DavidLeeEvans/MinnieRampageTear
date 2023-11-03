package dex.lib.websocket;

/**
    ### defold-websocket
    https://github.com/britzl/defold-websocket

    This project aims to provide a cross platform asynchronous implementation of the WebSockets protocol for Defold projects.
    Defold-WebSocket is based on the `lua-websocket` project with additional code to handle WebSocket connections for HTML5 builds.
    The additional code is required since Emscripten (which is used for Defold HTML5 builds) will automatically upgrade normal TCP sockets connections to WebSocket connections.
    Emscripten will also take care of encoding and decoding the WebSocket frames.
    The WebSocket implementation in this project will bypass the handshake and frame encode/decode of lua-websocket when running in HTML5 builds.

    As of now it is required to manually add the following line to the top of main.lua:
    local client_async = require "websocket.client_async"
**/
extern class WebSocket
{
    /** Creates a new WebSocket client with the given configuration. **/
    public static inline function create(?config: WebSocketClientConfig): WebSocket
    {
        // Hack so that the compiler doesn't throw away the config parameter
        if (config != null)
        {
            config.connect_timeout = config.connect_timeout;
        }

        if (defold.Sys.get_sys_info().system_name != "HTML5")
        {
            untyped __lua__('local client_async = require "websocket.client_async"');
            return untyped __lua__('client_async(config)');
        }
        return untyped __lua__('client_async(config)');
    }

    /**
        Connect to a WebSocket server.

        @param ws_url The URL of the server.
        @param ws_protocol The connection protocol. Default: `ws`.
        @ssl_params Parameters for `wss` connection.
    **/
    function connect(ws_url: String, ?ws_protocol: String, ?ssl_params: WebSocketSslParameters): Void;

    /**
        Closes the WebSocket connection.
    **/
    function close(): Void;

    /**
        Sends data to the server.

        @param data The data to send.
    **/
    function send(data: Dynamic): Void;

    /**
        Updates the WebSocket client, should be called on every frame.
    **/
    function step(): Void;

    /**
        Register a callback to be invoked when a connection is established.

        @param fn `function (ok: Bool, err: String)`
    **/
    function on_connected(fn: (ok: Bool, err: String) -> Void): Void;

    /**
        Register a callback to be invoked when a the client is disconnected.
    **/
    function on_disconnected(fn: () -> Void): Void;

    /**
        Register a callback to be invoked when a message is received.

        @param fn `function (message: String)`
    **/
    function on_message(fn: (message: Dynamic) -> Void): Void;
}

typedef WebSocketClientConfig =
{
    /** Optional timeout (in seconds) when connecting. **/
    var connect_timeout: Float;
}

typedef WebSocketSslParameters =
{
    var mode: String;
    var protocol: String;
    var verify: String;
    var options: String;
}
