package dex.wrappers;

import defold.Msg;
import defold.Particlefx.ParticleFxStopOptions;
import defold.Particlefx.ParticlefxEmitterState;
import defold.types.Hash;
import defold.types.HashOrString;
import defold.types.Url;
import defold.types.Vector4;
import dex.wrappers.Addressable;


typedef DfParticleFx = defold.Particlefx;

abstract ParticleFx(Addressable) to Addressable
{
    public static inline function get(path: String): ParticleFx
    {
        return Msg.url(path);
    }

    /**
     * Start playing a particle FX.
     *
     * Particle FX started this way need to be manually stopped through `stop()`.
     * Which particle FX to play is identified by the URL.
     *
     * @param url the particle fx that should start playing
     * @param emitter_state_cb optional callback that will be called when an emitter attached to this particlefx changes state.
     * The callback receives the hash of the path to the particlefx, the hash of the id of the emitter, and the new state of the emitter.
     */
    public inline function play<T>(?callback: (self: T, id: ParticleFx, emitter: Hash, state: ParticlefxEmitterState) -> Void)
    {
        DfParticleFx.play(this, cast callback);
    }

    public inline function stop(options: ParticleFxStopOptions)
    {
        DfParticleFx.stop(this, options);
    }

    public inline function setConstant(emitter: HashOrString, constant: HashOrString, value: Vector4)
    {
        DfParticleFx.set_constant(this, emitter, constant, value);
    }

    public inline function resetConstant(emitter: HashOrString, constant: HashOrString)
    {
        DfParticleFx.reset_constant(this, emitter, constant);
    }

    @:from
    static inline function fromUrl(url: Url): ParticleFx
    {
        return cast url;
    }
}
