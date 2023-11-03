package dex.wrappers;

import defold.Go;
import defold.Msg;
import defold.Sound.SoundMessageSoundDone;
import defold.Sound.SoundPlayOptions;
import defold.types.Hash;
import defold.types.SoundPlayId;
import defold.types.Url;


typedef DfSound = defold.Sound;

@:build(dex.macro.PropertyBuilder.build())
class SoundProperties
{
    var gain: Float;
    var pan: Float;
    var speed: Float;
    var sound: Hash;
}

@:forward
abstract Sound(Addressable) to Addressable
{
    public static inline function get(path: String): Sound
    {
        return Msg.url(path);
    }

    public inline function play<T: {}>(?options: SoundPlayOptions, ?callback: (T, Hash, SoundMessageSoundDone, Url) -> Void): SoundPlayId
    {
        return
            if (callback != null)
            {
                DfSound.play(this, options, callback);
            }
            else if (options != null)
            {
                DfSound.play(this, options);
            }
            else
            {
                DfSound.play(this);
            }
    }

    public inline function pause()
    {
        DfSound.pause(this, true);
    }

    public inline function resume()
    {
        DfSound.pause(this, false);
    }

    public inline function stop()
    {
        DfSound.stop(this);
    }

    public inline function setPan(pan: Float)
    {
        DfSound.set_pan(this, pan);
    }

    public inline function getPan(): Float
    {
        return Go.get(this, SoundProperties.pan);
    }

    public inline function setGain(gain: Float)
    {
        DfSound.set_gain(this, gain);
    }

    public inline function getGain(): Float
    {
        return Go.get(this, SoundProperties.gain);
    }

    public inline function setSpeed(speed: Float)
    {
        DfSound.set_gain(this, speed);
    }

    public inline function getSpeed(): Float
    {
        return Go.get(this, SoundProperties.speed);
    }

    @:from
    static inline function fromUrl(url: Url): Sound
    {
        return cast url;
    }
}
