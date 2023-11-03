package dex.systems;

import defold.Sound.SoundPlayOptions;
import dex.util.DexError;
import dex.wrappers.Sound;


typedef SoundData =
{
    var sound: Sound;
    var maxPlaybacks: UInt;
    var currentPlaybacks: UInt;
}

/**
 * A global sound manager which can be configured to control a list of sounds associated with an integer id.
 */
class SoundManager
{
    static var maxConcurrentPlaybacks: UInt;
    static var currentPlaybacks: UInt;
    static var sounds: Map<UInt, SoundData>;

    /**
     * Initializes the sound manager.
     * This method should be called once at the beginning of a new scene.
     *
     * @param maxConcurrent the maximum concurrent sound playbacks among all configured sounds
     */
    public static function init(maxConcurrent: UInt = 100)
    {
        DexError.assert(maxConcurrent > 0);

        maxConcurrentPlaybacks = maxConcurrent;
        currentPlaybacks = 0;
        sounds = [ ];
    }

    /**
     * Adds a sound to the sound manager.
     *
     * @param soundId an integer id used to identify the sound
     * @param soundUrl the url path to the sound component
     * @param maxPlaybacks the maximum concurrent playbacks for this sound;
     *                     a value of `0` means no limit, so only the global limit will affect this sound
     */
    public static function add(soundId: UInt, soundUrl: String, maxPlaybacks: UInt = 0)
    {
        DexError.assert(!sounds.exists(soundId), 'duplicate sound id: $soundId');

        sounds.set(soundId,
            {
                sound: Sound.get(soundUrl),
                maxPlaybacks: maxPlaybacks,
                currentPlaybacks: 0
            });
    }

    /**
     * Configure multiple sounds at once using a dynamic array.
     *
     * Each element of the array given should be an array with 2 or 3 items: `id, url, max`
     *
     * See the `add()` documentation for details.
     *
     * `[ [0, '#sound1'], [1, '#sound2'], [2, '#sound3', 10] ]`
     */
    public static function addMultiple(soundData: Array<Array<Dynamic>>)
    {
        for (sound in soundData)
        {
            if (sound.length == 2)
            {
                add(sound[ 0 ], sound[ 1 ]);
            }
            else if (sound.length == 3)
            {
                add(sound[ 0 ], sound[ 1 ], sound[ 2 ]);
            }
            else
            {
                DexError.error();
            }
        }
    }

    /**
     * Plays a sound.
     *
     * @param soundId the sound id, as configured using `add()`
     * @return `true` if the sound was played, `false` if the sound was not played because the maximum concurrent sound playbacks is reached
     */
    public static function play(soundId: UInt, ?options: SoundPlayOptions): Bool
    {
        DexError.assert(sounds.exists(soundId), 'unknown sound id: $soundId');

        if (currentPlaybacks >= maxConcurrentPlaybacks)
        {
            // already at max global sound playbacks
            return false;
        }

        var sound: SoundData = sounds[ soundId ];
        if ((sound.maxPlaybacks != 0) && (sound.currentPlaybacks == sound.maxPlaybacks))
        {
            // already at max playbacks for this sound
            return false;
        }

        // play the sound
        sound.currentPlaybacks++;
        currentPlaybacks++;

        sound.sound.play(options, (_, _, _, _) ->
        {
            // decrement the counters when the sound is done
            sound.currentPlaybacks--;
            currentPlaybacks--;
        });

        return true;
    }

    /**
     * Checks if the sound with a given id is currently playing.
     *
     * @param soundId the sound id, as configured using `add()`
     * @return `true` if at least one playback of the sound is currently ongoing
     */
    public static function isPlaying(soundId: UInt): Bool
    {
        DexError.assert(sounds.exists(soundId), 'unknown sound id: $soundId');

        return sounds[ soundId ].currentPlaybacks > 0;
    }
}
