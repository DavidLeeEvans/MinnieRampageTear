package dex.util.types;

import defold.types.AtlasResourceReference;
import defold.types.HashOrString;
import defold.types.HashOrStringOrUrl;

import dex.wrappers.Sprite;

abstract SpriteSet(Array<Sprite>) {
	public function new(paths:Array<HashOrStringOrUrl>) {
		this = [];
		for (path in paths) {
			this.push(new Sprite(path));
		}
	}

	public inline function playAnimation(animationId:HashOrString) {
		for (sprite in this) {
			sprite.playAnimation(animationId);
		}
	}

	public inline function setFlip(horizontal:Bool = false, vertical:Bool = false) {
		for (sprite in this) {
			sprite.setFlip(horizontal, vertical);
		}
	}

	public inline function setImage(atlasResource:AtlasResourceReference) {
		for (sprite in this) {
			sprite.setImage(atlasResource);
		}
	}

	public inline function enable() {
		for (sprite in this) {
			sprite.enable();
		}
	}

	public inline function disable() {
		for (sprite in this) {
			sprite.disable();
		}
	}

	@:op([])
	inline function get(idx:Int):Sprite {
		return this[idx];
	}

	@:from
	static inline function fromSprite(sprite:Sprite):SpriteSet {
		return cast [sprite];
	}

	@:from
	static inline function fromPath(path:HashOrStringOrUrl):SpriteSet {
		return cast [new Sprite(path)];
	}

	@:to
	inline function toSprite():Sprite {
		return this[0];
	}
}
