package dex.lib.monarch;

import defold.types.Hash;
import defold.types.Message;


class MonarchMessages
{
    /** Message sent to listeners added using `Monarch.add_listener()` when a screen has started to transition in. **/
    static var screen_transition_in_started(default, never) = new Message<MonarchMessageTransitionIn>("monarch_screen_transition_in_started");

    /** Message sent to listeners added using `Monarch.add_listener()` when a screen has finished to transition in. **/
    static var monarch_screen_transition_in_finished(default, never) = new Message<MonarchMessageTransitionIn>("monarch_screen_transition_in_finished");

    /** Message sent to listeners added using `Monarch.add_listener()` when a screen has started to transition out. **/
    static var monarch_screen_transition_out_started(default, never) = new Message<MonarchMessageTransitionOut>("monarch_screen_transition_out_started");

    /** Message sent to listeners added using `Monarch.add_listener()` when a screen has finished to transition out. **/
    static var monarch_screen_transition_out_finished(default, never) = new Message<MonarchMessageTransitionOut>("monarch_screen_transition_out_finished");

    /** Message sent to listeners added using `Monarch.add_listener()` when a screen transition failed. **/
    static var monarch_screen_transition_failed(default, never) = new Message<MonarchMessageTransitionFailed>("monarch_screen_transition_failed");
}

typedef MonarchMessageTransitionIn =
{
    /** Id of the screen. **/
    var screen: Hash;

    /** Id of the previous screen (if any). **/
    var previous_screen: Hash;
}

typedef MonarchMessageTransitionOut =
{
    /** Id of the screen. **/
    var screen: Hash;

    /** Id of the next screen (if any). **/
    var next_screen: Hash;
}

typedef MonarchMessageTransitionFailed =
{
    /** Id of the screen. **/
    var screen: Hash;
}
