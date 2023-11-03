package dex.wrappers;

import defold.Go;
import defold.Msg;
import defold.types.Hash;
import defold.types.Property;
import defold.types.Url;


abstract Addressable(Hash) from Hash to Hash
{
    /**
     * Gets the url of the calling script component.
     *
     * Shorthand to calling `Msg.url()`.
     *
     * @return the url
     */
    public static inline function url(): Addressable
    {
        return cast Msg.url();
    }

    /**
     * Gets a named property of the specified game object or component.
     *
     * @param id id of the property to retrieve
     * @return the value of the specified property
     */
    public inline function get<T>(id: Property<T>): T
    {
        return Go.get(this, id);
    }

    public inline function animate<TProp, TSelf>(property: Property<TProp>, to: TProp, duration: Float, delay: Float = 0, easing: GoEasing = EASING_LINEAR,
            playback: GoPlayback = PLAYBACK_ONCE_FORWARD, ?onComplete: (TSelf, Url, Property<TProp>) -> Void)
    {
        Go.animate(this, property, playback, to, easing, duration, delay, onComplete);
    }

    public inline function cancelAnimations<T>(property: Property<T>)
    {
        Go.cancel_animations(this, cast property);
    }

    /**
     * Sets a named property of the specified game object or component.
     *
     * @param id id of the property to set
     * @param value the value to set
     */
    public inline function set<T>(id: Property<T>, value: T)
    {
        Go.set(this, id, value);
    }

    public inline function enable()
    {
        Msg.post(this, GoMessages.enable);
    }

    public inline function disable()
    {
        Msg.post(this, GoMessages.disable);
    }

    @:to
    inline function toUrl(): Url
    {
        return cast this;
    }

    @:from
    static inline function fromUrl(url: Url): Addressable
    {
        return cast url;
    }
}
