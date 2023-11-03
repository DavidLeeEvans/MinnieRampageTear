package dex.lib.discordrich;

typedef User =
{
    /** The userId of the player asking to join. **/
    var user_id: String;

    /** The username of the player asking to join. **/
    var username: String;

    /** The discriminator of the player asking to join. (The 4-digit number after #) **/
    var discriminator: String;

    /** The avatar hash of the player asking to join.. **/
    var ?avatar: String;
}
