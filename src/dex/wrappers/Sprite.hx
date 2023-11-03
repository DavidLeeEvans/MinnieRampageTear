package dex.wrappers;

import defold.Go;
import defold.Msg;
import defold.Sprite.SpriteMessageAnimationDone;
import defold.Sprite.SpritePlayFlipbookProperties;
import defold.Vmath;
import defold.types.AtlasResourceReference;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import dex.hashes.SpriteProperties;
import dex.util.types.Vector2;
import dex.wrappers.Addressable;


typedef DfSprite = defold.Sprite;

@:build(defold.support.HashBuilder.build())
class SpriteConstants
{
}

@:forward
abstract Sprite(Addressable) to Addressable
{
    public static inline function get(path: String = '#sprite'): Sprite
    {
        return Msg.url(path);
    }

    public inline function setTint(r: Float, g: Float, b: Float, a: Float)
    {
        DfSprite.set_constant(this, cast SpriteProperties.tint, Vmath.vector4(r, g, b, a));
    }

    public inline function setTintR(r: Float)
    {
        this.set(SpriteProperties.tintR, r);
    }

    public inline function setTintG(g: Float)
    {
        this.set(SpriteProperties.tintG, g);
    }

    public inline function setTintB(b: Float)
    {
        this.set(SpriteProperties.tintB, b);
    }

    public inline function setTintA(a: Float)
    {
        this.set(SpriteProperties.tintA, a);
    }

    public inline function playAnimation<T>(animationId: Hash,
            ?callback: (self: T, message_id: Message<SpriteMessageAnimationDone>, message: SpriteMessageAnimationDone, sender: Url) -> Void,
            ?properties: SpritePlayFlipbookProperties)
    {
        if (properties == null)
        {
            DfSprite.play_flipbook(this, animationId, callback);
        }
        else
        {
            DfSprite.play_flipbook(this, animationId, callback, properties);
        }
    }

    public inline function getAnimation(): Hash
    {
        return Go.get(this, SpriteProperties.animation);
    }

    public inline function setFlip(horizontal: Bool = false, vertical: Bool = false)
    {
        DfSprite.set_hflip(this, horizontal);
        DfSprite.set_vflip(this, vertical);
    }

    public inline function setHorizontalFlip(flip: Bool)
    {
        DfSprite.set_hflip(this, flip);
    }

    public inline function setVerticalFlip(flip: Bool)
    {
        DfSprite.set_vflip(this, flip);
    }

    public inline function getWidth(): Float
    {
        return Go.get(this, SpriteProperties.sizeX);
    }

    public inline function getHeight(): Float
    {
        return Go.get(this, SpriteProperties.sizeY);
    }

    public inline function setScale(scaleX: Float, scaleY: Float)
    {
        Go.set(this, SpriteProperties.scaleX, scaleX);
        Go.set(this, SpriteProperties.scaleY, scaleY);
    }

    public inline function setScaleX(x: Float)
    {
        Go.set(this, SpriteProperties.scaleX, x);
    }

    public inline function setScaleY(y: Float)
    {
        Go.set(this, SpriteProperties.scaleY, y);
    }

    public inline function getScale(): Vector2
    {
        return Go.get(this, SpriteProperties.scale);
    }

    public inline function getScaleX(): Float
    {
        return Go.get(this, SpriteProperties.scaleX);
    }

    public inline function getScaleY(): Float
    {
        return Go.get(this, SpriteProperties.scaleY);
    }

    public inline function getWidthScaled(): Float
    {
        return getWidth() * getScaleX();
    }

    public inline function getHeightScaled(): Float
    {
        return getHeight() * getScaleY();
    }

    /**
     * Gets the cursor of the sprite.
     *
     * @return number between `0.0` and `1.0`, indicating the progress into the current animation.
     */
    public inline function getCursor(): Float
    {
        return Go.get(this, SpriteProperties.cursor);
    }

    public inline function setImage(atlasResource: AtlasResourceReference)
    {
        Go.set(this, SpriteProperties.image, atlasResource);
    }

    @:from
    static inline function fromUrl(url: Url): Sprite
    {
        return cast url;
    }
}
