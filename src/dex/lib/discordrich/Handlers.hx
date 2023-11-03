package dex.lib.discordrich;

typedef Handlers =
{
    /**
        Called when the game successfully connects to the Discord client.

        @param user A table describing the currently logged in user.
    **/
    var ?ready: (user: User) -> Void;

    /**
        Called when the game disconnects from the Discord client.

        @param errcode Error code of the reason for the disconnect.
        @param message Message explaining the reason for the disconnect.
    **/
    var ?disconnected: (errcode: Int, message: String) -> Void;

    /**
        Called when the Discord RPC API raises an error.

        @param errcode Error code of the reason for the disconnect.
        @param message Message explaining the reason for the disconnect.
    **/
    var ?errored: (errcode: Int, message: String) -> Void;

    /**
        Called when the game launches as a result of the user clicking "Join" on another player's invitation.

        @param join_secret The string provided to `DiscordRich.update_presence()` by the inviting player's game.
    **/
    var ?join_game: (join_secret: String) -> Void;

    /**
        Called when the game launches as a result of the user clicking "Spectate" on another player's invitation.

        @param spectate_secret The string provided to `DiscordRich.update_presence()` by the inviting player's game.
    **/
    var ?spectate_gane: (spectage_secret: String) -> Void;

    /**
        Called when another user clicks "Ask to Join" on the current user's profile.
        This is when your game should ask the user if he wants to accept the request and then call `DiscordRich.respond()` with the user's answer.
    **/
    var ?join_request: (user: User) -> Void;
}
