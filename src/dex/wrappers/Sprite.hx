package dex.wrappers;

import defold.types.AtlasResourceReference;
import defold.types.Hash;
import defold.types.HashOrString;
import defold.types.HashOrStringOrUrl;

import defold.Go;
import defold.Msg;

import Defold.hash;

import defold.Sprite.SpriteMessages;

import defold.types.UrlOrString;

import defold.Vmath;

typedef DfSprite = defold.Sprite;

@:build(dex.util.HashBuilder.build())
class SpriteProperties {
	var tint;
	var tintR = "tint.x";
	var tintG = "tint.y";
	var tintB = "tint.z";
	var tintA = "tint.w";
	var cursor;
	var image;
	var sizeX = "size.x";
	var sizeY = "size.y";
}

@:forward
abstract Sprite(GameObject) {
	public function new(path:HashOrStringOrUrl = "#sprite") {
		this = new GameObject(path);
	}

	public inline function setTint(r:Float, g:Float, b:Float, a:Float) {
		DfSprite.set_constant(this, SpriteProperties.tint, Vmath.vector4(r, g, b, a));
	}

	public inline function setTintR(r:Float) {
		Go.set(this, SpriteProperties.tintR, r);
	}

	public inline function setTintG(g:Float) {
		Go.set(this, SpriteProperties.tintG, g);
	}

	public inline function setTintB(b:Float) {
		Go.set(this, SpriteProperties.tintB, b);
	}

	public inline function setTintA(a:Float) {
		Go.set(this, SpriteProperties.tintA, a);
	}

	public inline function playAnimation(animationId:HashOrString) {
		if (Std.isOfType(animationId, String)) {
			animationId = hash(animationId);
		}
		Msg.post(this, SpriteMessages.play_animation, {id: animationId});
	}

	public inline function setFlip(horizontal:Bool = false, vertical:Bool = false) {
		DfSprite.set_hflip(this, horizontal);
		DfSprite.set_vflip(this, vertical);
	}

	public inline function getWidth():Float {
		return Go.get(this, SpriteProperties.sizeX);
	}

	public inline function getHeight():Float {
		return Go.get(this, SpriteProperties.sizeY);
	}

	/**
		Gets the cursor of the sprite.

		@return Number between `0.0` and `1.0`, indicating the progress into the current animation.
	**/
	public inline function getCursor():Float {
		return Go.get(this, SpriteProperties.cursor);
	}

	public inline function setImage(atlasResource:AtlasResourceReference) {
		Go.set(this, SpriteProperties.image, atlasResource);
	}

	public static final self:Sprite = new Sprite("#sprite");
	public static final sprite:Sprite = new Sprite("#sprite");
}
