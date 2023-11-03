package dex.util.types;

import defold.types.AtlasResourceReference;
import defold.types.Hash;
import defold.types.HashOrStringOrUrl;
import dex.wrappers.Sprite;


abstract SpriteSet(Array<Sprite>)
{
    public function new(paths: Array<String>)
    {
        this = [ ];
        for (path in paths)
        {
            this.push(Sprite.get(path));
        }
    }

    public inline function playAnimation(animationId: Hash)
    {
        for (sprite in this)
        {
            sprite.playAnimation(animationId);
        }
    }

    public inline function setFlip(horizontal: Bool = false, vertical: Bool = false)
    {
        for (sprite in this)
        {
            sprite.setFlip(horizontal, vertical);
        }
    }

    public inline function setImage(atlasResource: AtlasResourceReference)
    {
        for (sprite in this)
        {
            sprite.setImage(atlasResource);
        }
    }

    public inline function enable()
    {
        for (sprite in this)
        {
            sprite.enable();
        }
    }

    public inline function disable()
    {
        for (sprite in this)
        {
            sprite.disable();
        }
    }

    @:op([ ])
    inline function get(idx: Int): Sprite
    {
        return this[ idx ];
    }

    @:from
    static inline function fromSprite(sprite: Sprite): SpriteSet
    {
        return cast [ sprite ];
    }

    @:from
    static inline function fromPath(path: HashOrStringOrUrl): SpriteSet
    {
        return cast [ Sprite.get(path) ];
    }

    @:from
    static inline function fromPaths(paths: Array<HashOrStringOrUrl>): SpriteSet
    {
        return new SpriteSet(paths);
    }
}
