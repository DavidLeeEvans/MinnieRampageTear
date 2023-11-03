package dex.lib.discordrich;

typedef Presence =
{
    /**
        What the player is currently doing.

        e.g. `Competitive - Captain's Mode`, `In Queue`, `Unranked PvP`

        (Max 128 bytes)
    **/
    var details: String;

    /**
        The user's current party status.

        e.g. `Looking to Play`, `Playing Solo`, `In a Group`

        (Max 128 bytes)
    **/
    var ?state: String;

    /**
        Epoch seconds for game start - including will show time as "elapsed".
    **/
    var ?startTimestamp: Int;

    /**
        Epoch seconds for game end - including will show time as "remaining".
    **/
    var ?endTimestamp: Int;

    /**
        Name of the uploaded image for the large profile artwork.

        (Max 32 bytes)
    **/
    var ?largeImageKey: String;

    /**
        Tooltip for the largeImageKey.

        (Max 128 bytes)
    **/
    var ?largeImageText: String;

    /**
        Name of the uploaded image for the small profile artwork.

        (Max 32 bytes)
    **/
    var ?smallImageKey: String;

    /**
        Tooltip for the smallImageKey.

        (Max 128 bytes)
    **/
    var ?smallImageText: String;

    /**
        Id of the player's party, lobby, or group.

        (Max 128 bytes)
    **/
    var ?partyId: String;

    /**
        Current size of the player's party, lobby, or group.
    **/
    var ?partySize: Int;

    /**
        Maximum size of the player's party, lobby, or group.
    **/
    var ?partyMax: Int;

    /**
        Unique hashed string for a player's match.

        (for future use)

        (Max 128 bytes)
    **/
    var ?matchSecret: String;

    /**
        Unique hashed string for Spectate button.

        (Max 128 bytes)
    **/
    var ?joinSecret: String;

    /**
        Unique hashed string for chat invitations and Ask to Join.

        (Max 128 bytes)
    **/
    var ?spectateSecret: String;

    /**
        Integer representing a boolean for if the player is in an instance (an in-progress match)

        (for future use)
    **/
    var ?instance: Int;
}
