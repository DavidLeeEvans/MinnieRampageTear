package dex.scripts;

import defold.Msg;
import defold.Render.RenderMessages;
import defold.Vmath;
import defold.support.Script;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;
import dex.hashes.camera.CameraMessages;
import dex.hashes.camera.CameraProperties;
import dex.types.CameraRecoil;
import dex.types.CameraShake;
import dex.util.DexError;
import dex.util.DexUtils;
import dex.util.Easing;
import dex.util.types.Vector2;
import dex.wrappers.Addressable;
import dex.wrappers.GameObject;


typedef CameraControllerProperties =
{
    @property() var center: Vector3;
    @property(1.0) var zoom: Float;

    @property() var follow: Hash;
    @property(0) var followOffsetX: Float;
    @property(0) var followOffsetY: Float;
    @property(1) var followLerpX: Float;
    @property(1) var followLerpY: Float;
    // shake properties for animating
    // they should not be touched through the editor
    @property(0) var zoomShake: Float;
    @property() var positionShake: Vector3;
    var go: GameObject;
}

class CameraController<T: CameraControllerProperties> extends Script<T>
{
    public static var cameraInFocus(default, null): GameObject = GameObject.none;
    static var cameraInFocusZoom: Float = 1;

    override function init(self: T)
    {
        self.go = GameObject.self();
        self.center = self.go.getPosition();
        self.zoomShake = 1.0;
        self.positionShake = Vector2.zero;

        Msg.post(self.go, CameraMessages.acquire_camera_focus);
    }

    override function update(self: T, dt: Float)
    {
        /**
         * Update zoom for the camera in focus.
         */
        if (cameraInFocus == self.go)
        {
            Msg.post("@render:", RenderMessages.use_fixed_projection, {near: -1, far: 1, zoom: self.zoom * self.zoomShake});
            cameraInFocusZoom = self.zoom;
        }

        /**
         * Update object following.
         */
        if (!(self.follow: GameObject).isNull())
        {
            var follow: GameObject = self.follow;
            DexError.assert(follow.exists(), 'camera set to follow non-existent object with id: $follow');
            DexError.assert(self.followLerpX >= 0.0 && self.followLerpX <= 1.0);
            DexError.assert(self.followLerpY >= 0.0 && self.followLerpY <= 1.0);

            var targetPosition: Vector3 = follow.getWorldPosition();
            self.center.x = Vmath.lerp(self.followLerpX, self.center.x, targetPosition.x);
            self.center.y = Vmath.lerp(self.followLerpY, self.center.y, targetPosition.y);
        }

        /**
         * Set camera object position.
         */
        var displayWidth: Float = DexUtils.getDisplayWidth();

        var displayHeight: Float = DexUtils.getDisplayHeight();

        var cameraPosX: Float = self.center.x - (displayWidth / 2) + self.followOffsetX + self.positionShake.x;
        var cameraPosY: Float = self.center.y - (displayHeight / 2) + self.followOffsetY + self.positionShake.y;

        self.go.setPositionXY(cameraPosX, cameraPosY);
    }

    /**
     * Converts the given screen coordinates to world coordinates, taking
     * into account the camera's position and zoom.
     *
     * @param screenX the x-coordinate on the screen
     * @param screenY the y-coordinate on the screen
     * @param v optional pre-allocated vector, if provided it will be updated in-place with the return value
     * @return the updated instance `v`, or a new vector instance if the given `v` is `null`
     */
    public static function screenToWorld(screenX: Float, screenY: Float, ?v: Vector2): Vector2
    {
        var displayWidth: Float = DexUtils.getDisplayWidth();
        var displayHeight: Float = DexUtils.getDisplayHeight();
        var screenFromCenterX: Float = screenX - (displayWidth / 2);
        var screenFromCenterY: Float = screenY - (displayHeight / 2);

        var cameraPos: Vector2 = cameraInFocus.getPosition();

        var cameraCenterX: Float = cameraPos.x + (displayWidth / 2);
        var cameraCenterY: Float = cameraPos.y + (displayHeight / 2);

        if (v == null)
        {
            v = new Vector2();
        }
        v.x = (screenFromCenterX / cameraInFocusZoom) + cameraCenterX;
        v.y = (screenFromCenterY / cameraInFocusZoom) + cameraCenterY;

        return v;
    }

    /**
     * Converts the given world coordinates to screen coordinates, taking
     * into account the camera's position and zoom.
     *
     * @param world the world position
     * @param v optional pre-allocated vector, if provided it will be updated in-place with the return value
     * @return the updated instance `v`, or a new vector instance if the given `v` is `null`
     */
    public static function worldToScreen(world: Vector2, ?v: Vector2): Vector2
    {
        if (v == null)
        {
            v = new Vector2();
        }

        v.x = worldToScreenX(world.x);
        v.y = worldToScreenY(world.y);

        return v;
    }

    /**
     * Converts the given world x-coordinate to screen x-coordinate, taking
     * into account the camera's position and zoom.
     *
     * @param worldX the world x-coordinate
     * @return the screen x-coordinate
     */
    public static inline function worldToScreenX(worldX: Float): Float
    {
        var cameraPosX: Float = cameraInFocus.getPositionX();

        var displayWidth: Float = DexUtils.getDisplayWidth();
        var cameraCenterX: Float = cameraPosX + (displayWidth / 2);
        var screenFromCenterX: Float = (worldX - cameraCenterX) * cameraInFocusZoom;

        return screenFromCenterX + (displayWidth / 2);
    }

    /**
     * Converts the given world y-coordinate to screen y-coordinate, taking
     * into account the camera's position and zoom.
     *
     * @param worldX the world y-coordinate
     * @return the screen y-coordinate
     */
    public static inline function worldToScreenY(worldY: Float): Float
    {
        var cameraPosY: Float = cameraInFocus.getPositionY();
        var displayHeight: Float = DexUtils.getDisplayHeight();
        var cameraCenterY: Float = cameraPosY + (displayHeight / 2);

        var screenFromCenterY: Float = (worldY - cameraCenterY) * cameraInFocusZoom;

        return screenFromCenterY + (displayHeight / 2);
    }

    /**
     * Checks if the given screen coordinates are inside the current display bounds.
     *
     * @param screenPos the screen coordinates
     * @return `true` if the coordinates are inside the bounds otherwise `false`
     */
    public static inline function isInBounds(screenPos: Vector2): Bool
    {
        return isInBoundsX(screenPos.x) && isInBoundsY(screenPos.y);
    }

    /**
     * Checks if the given screen x-coordinate is inside the current display bounds.
     *
     * @param screenX the screen x-coordinate
     * @return `true` if the coordinate is between `0` and the display with
     */
    public static inline function isInBoundsX(screenX: Float): Bool
    {
        return screenX >= 0 && screenX <= DexUtils.getDisplayWidth();
    }

    /**
     * Checks if the given screen y-coordinate is inside the current display bounds.
     *
     * @param screenX the screen y-coordinate
     * @return `true` if the coordinate is between `0` and the display height
     */
    public static inline function isInBoundsY(screenY: Float): Bool
    {
        return screenY >= 0 && screenY <= DexUtils.getDisplayHeight();
    }

    /**
     * Get the world x-coordinate of the camera's center focus point.
     */
    public static inline function getCenterX(): Float
    {
        return cameraInFocus.get(CameraProperties.centerX);
    }

    /**
     * Get the world y-coordinate of the camera's center focus point.
     */
    public static inline function getCenterY(): Float
    {
        return cameraInFocus.get(CameraProperties.centerY);
    }

    override function on_message<TMessage>(self: T, message_id: Message<TMessage>, message: TMessage, sender: Url)
    {
        var camScript: Addressable = Addressable.url();

        switch message_id
        {
            case CameraMessages.acquire_camera_focus:
                {
                    cameraInFocus = self.go;
                    cameraInFocusZoom = self.zoom;
                    Msg.post("#camera", CameraMessages.acquire_camera_focus); // necessary or not?
                    Msg.post("@render:", RenderMessages.use_fixed_projection, {near: -1, far: 1, zoom: self.zoom});
                }

            case CameraMessages.move_to:
                {
                    camScript.animate(CameraProperties.center, message.center, message.animDuration);
                }

            case CameraMessages.zoom_to:
                {
                    camScript.animate(CameraProperties.zoom, message.zoom, message.animDuration);
                }

            case CameraMessages.recoil:
                {
                    var recoilToPos: Vector2 = message.direction.normalize() * message.magnitude;
                    var easing: Easing = getRecoilEasing(message.recoilType, message.duration);
                    camScript.animate(CameraProperties.positionShake, recoilToPos, message.duration, 0, easing);
                }

            case CameraMessages.recoil_zoom:
                {
                    var easing: Easing = getRecoilEasing(message.recoilType, message.duration);
                    camScript.animate(CameraProperties.zoomShake, 1.0 + message.magnitude, message.duration, 0, easing);
                }

            case CameraMessages.shake:
                {
                    DexError.assert(message.axisX || message.axisY, 'got shake message, with no shake axes specified');

                    if (message.axisX)
                    {
                        var easing: Easing = getShakeEasing(message.shakeType, message.duration);
                        camScript.animate(CameraProperties.positionShakeX, message.magnitude, message.duration, 0, easing);
                    }
                    if (message.axisY)
                    {
                        var easing: Easing = getShakeEasing(message.shakeType, message.duration);
                        camScript.animate(CameraProperties.positionShakeY, message.magnitude, message.duration, 0, easing);
                    }
                }

            case CameraMessages.shake_zoom:
                {
                    var easing: Easing = getShakeEasing(message.shakeType, message.duration);
                    camScript.animate(CameraProperties.zoomShake, 1.0 + message.magnitude, message.duration, 0, easing);
                }
        }
    }

    static function getShakeEasing(shake: CameraShake, duration: Float): Easing
    {
        return
            switch shake
            {
                case Sine:
                    Easing.sin(1 + Math.round(2 * duration));
                case SineDiminishing:
                    Easing.sinDiminishing(1 + Math.round(2 * duration));
                case Random:
                    Easing.random(Math.round(10 * duration));
                case RandomDiminishing:
                    Easing.randomDiminishing(Math.round(10 * duration));
                case RandomPerlin:
                    Easing.randomPerlin(Math.round(10 * duration));
                case Square:
                    Easing.square(false, 1 + Math.round(2 * duration));
                case SquareDiminishing:
                    Easing.squareDiminishing(false, 1 + Math.round(2 * duration));

                default:
                    DexError.error('not implemented');
            }
    }

    static function getRecoilEasing(recoil: CameraRecoil, duration: Float): Easing
    {
        return
            switch recoil
            {
                case SineDiminishing:
                    Easing.sinDiminishing(1 + Math.round(2 * duration));
                case Square:
                    Easing.square(true, 1 + Math.round(2 * duration));
                case SquareDiminishing:
                    Easing.squareDiminishing(true, 1 + Math.round(2 * duration));
                case OutIn:
                    Easing.outIn(3 + Math.round(10 * duration));

                default:
                    DexError.error('not implemented');
            }
    }
}
