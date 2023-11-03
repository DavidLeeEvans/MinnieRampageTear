package dex.wrappers;

import defold.Collectionproxy.CollectionproxyMessages;
import defold.Msg;
import defold.types.HashOrString;
import defold.types.Url;


enum abstract SetTimeStepMode(Int) to Int
{
    var Continuous = 0;
    var Discrete = 1;
}

abstract CollectionProxy(Url) from Url
{
    public inline function new(socket: HashOrString, path: HashOrString, fragment: HashOrString)
    {
        this = Msg.url(socket, path, fragment);
    }

    public inline function load()
    {
        Msg.post(this, CollectionproxyMessages.load);
    }

    public inline function loadAsync()
    {
        Msg.post(this, CollectionproxyMessages.async_load);
    }

    public inline function init()
    {
        Msg.post(this, CollectionproxyMessages.init);
    }

    public inline function enable()
    {
        Msg.post(this, CollectionproxyMessages.enable);
    }

    public inline function disable()
    {
        Msg.post(this, CollectionproxyMessages.disable);
    }

    public inline function final_()
    {
        Msg.post(this, CollectionproxyMessages.final_);
    }

    public inline function unload()
    {
        Msg.post(this, CollectionproxyMessages.unload);
    }

    public inline function setTimeStep(factor: Float, mode: SetTimeStepMode = Continuous)
    {
        Msg.post(this, CollectionproxyMessages.set_time_step, {factor: factor, mode: mode});
    }
}
