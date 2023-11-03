package dex.lib.discordrich;

/**
    ### DiscordRich
    https://github.com/subsoap/discordrich

    Rich Presence for Defold games on Discord.
    https://discordapp.com/developers/docs/rich-presence/how-to
**/
@:native("discordrich")
extern class DiscordRich
{
    /**
        Initializes Discord RPC.

        @param application_id Your client_id/application_id.
        @param handlers A set of callback functions you registered for each Discord event.
        @param auto_register Whether or not to register an application protocol for your game on the player's computer. Necessary to launch games from Discord. Default `true`.
        @param optional_steam_id Your game's Steam application id, if your game is distributed on Steam. Used for launching your game through Steam if `auto_register` is `true`.
    **/
    static function initialize(application_id: String, ?handlers: Handlers, ?auto_register: Bool, ?optional_steam_id: String): Void;

    /**
        Shuts down the Discord RPC connection. There's no need to call this manually. It will get called automatically, if needed, when the game exits.
    **/
    static function shutdown(): Void;

    /**
        Sets your Discord presence.

        Discord has a rate limit for updating the user's presence to **once ever 15 seconds**.

        @param presence The new presence information.
    **/
    static function update_presence(presence: Presence): Void;

    /**
        Clears your Discord presence.
    **/
    static function clear_presence(): Void;

    /**
        Respond to a join request issued by the user identified by `user_id`.

        @param user_id The ID of the user who clicked "Ask to Join" on the current user's profile.
        @param answer The response to give to the join request.
    **/
    static function respond(user_id: String, answer: JoinAnswer): Void;

    /**
        Change the `handlers` callbacks with different ones.

        @param handlers A set of callback functions you registered for each Discord event.
    **/
    static function update_handlers(handlers: Handlers): Void;

    /**
        Register the game's application protocol manually (`auto_register` does this automatically for you).

        @param application_id Your client_id/application_id.
    **/
    static function register(application_id: String, command: String): Void;

    /**
        Register the game's application protocol manually to launch the game through Steam. (`auto_register` does this automatically for you).

        @param application_id Your client_id/application_id.
        @param steam_id Your game's Steam application id, if your game is distributed on Steam.
    **/
    static function register_steam(application_id: String, steam_id: String): Void;
}
