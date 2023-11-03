package dex.gui;

import defold.Go.GoEasing;
import defold.types.Property;
import dex.hashes.GameObjectProperties;
import dex.util.DexError;
import dex.wrappers.GameObject;
import dex.wrappers.Sprite;
import dex.wrappers.Timeout;


class SpriteProgressBar
{
    public var animationDuration: Float = 0.3;

    final backSprite: GameObject;
    final fillSprite: GameObject;
    final horizontal: Bool;
    final fullLength: Float;

    final propScale: Property<Float>;
    final propPosition: Property<Float>;

    var autoHideTimeout: Timeout;

    public function new(backSprite: String, ?fillSprite: String, horizontal: Bool = true)
    {
        this.backSprite = GameObject.get(backSprite);
        this.fillSprite = fillSprite != null ? GameObject.get(fillSprite) : null;
        this.horizontal = horizontal;

        var backSprite: Sprite = this.backSprite.getComponent('sprite');
        if (horizontal)
        {
            fullLength = backSprite.getHeightScaled();
            propScale = GameObjectProperties.scaleX;
            propPosition = GameObjectProperties.positionX;
        }
        else
        {
            fullLength = backSprite.getWidthScaled();
            propScale = GameObjectProperties.scaleY;
            propPosition = GameObjectProperties.positionY;
        }

        autoHideTimeout = Timeout.none();
    }

    public inline function show()
    {
        backSprite.enable();
        if (fillSprite != null)
        {
            fillSprite.enable();
        }
    }

    public inline function hide()
    {
        backSprite.disable();
        if (fillSprite != null)
        {
            fillSprite.disable();
        }
    }

    public function setFill(fill: Float)
    {
        DexError.assert(fill >= 0.0 && fill <= 1.0, 'got non-percentage fill: $fill');

        var fillOffset: Float = -(fullLength / 2) * (1 - fill);

        set(backSprite, propScale, fill);
        if (fillSprite == null)
        {
            // fill sprite not specified, use only the back sprite
            set(backSprite, propPosition, fillOffset);
        }
        else
        {
            // fill sprite also specified
            set(fillSprite, propScale, fill);
            set(fillSprite, propPosition, fillOffset);
        }
    }

    /**
     * Sets the fill percentage of the healthbar.
     */
    public function animateFill(fill: Float, autoHide: Bool = false)
    {
        DexError.assert(fill >= 0.0 && fill <= 1.0, 'got non-percentage fill: $fill');

        var fillOffset: Float = -(fullLength / 2) * (1 - fill);

        animate(backSprite, propScale, fill);
        if (fillSprite == null)
        {
            // fill sprite not specified, use only the back sprite
            animate(backSprite, propPosition, fillOffset);
        }
        else
        {
            // fill sprite also specified
            animate(fillSprite, propScale, fill);
            animate(fillSprite, propPosition, fillOffset);
        }

        if (autoHide)
        {
            autoHideTimeout.restart(animationDuration, hide);
        }
        else
        {
            autoHideTimeout.cancel();
        }
    }

    inline function animate(sprite: GameObject, property: Property<Float>, to: Float)
    {
        sprite.animate(property, to, animationDuration, GoEasing.EASING_INOUTQUAD);
    }

    inline function set(sprite: GameObject, property: Property<Float>, to: Float)
    {
        sprite.cancelAnimations(property);
        sprite.set(property, to);
    }
}
