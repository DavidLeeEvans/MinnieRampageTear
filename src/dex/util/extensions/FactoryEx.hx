package dex.util.extensions;

import defold.Vmath;
import dex.hashes.GameObjectProperties;
import dex.util.types.Vector2;
import dex.wrappers.Factory;
import dex.wrappers.GameObject;


class FactoryEx
{
    /**
     * Fires a projectile efficiently.
     *
     * It is moved to its destination using `Go.animate()`, and is automatically deleted at the end of its movement.
     *
     * @param factory the factory for creating the projectiles
     * @param from origin world position
     * @param to target world position; the projectile will be deleted upon reaching it
     * @param speed the speed of the projectile in pixels/sec
     * @param rotate `true` if to apply the same rotation to the projectile object as the angle of its trajectory
     * @return the projectile that was created
     */
    public static inline function shootProjectile(factory: Factory, from: Vector2, to: Vector2, speed: Float, rotate: Bool = true): GameObject
    {
        // create the projectile with the correct rotation
        var rotation: Float = rotate ? (to - from).angle() : 0.0;
        var projectile: GameObject = factory.create(from, Vmath.quat_rotation_z(rotation));

        // animate the object to its final position
        var range: Float = from.distanceTo(to);
        var moveDuration: Float = range / speed;
        projectile.animate(GameObjectProperties.position, to, moveDuration, 0, EASING_LINEAR, PLAYBACK_ONCE_FORWARD, (_, _, _) ->
        {
            // ... and queue its deletion at the end of the animation
            projectile.delete();
        });

        return projectile;
    }

    /**
     * Fires a projectile efficiently.
     *
     * It is moved to its destination using `Go.animate()`, and is automatically deleted at the end of its movement.
     *
     * @param factory the factory for creating the projectiles
     * @param from origin world position
     * @param direction the direction angle in radians
     * @param speed the speed of the projectile in pixels/sec
     * @param range the distance in pixels that the projectile should travel before being deleted
     * @param rotate `true` if to apply the same rotation to the projectile object as the angle of its trajectory
     * @return the projectile that was created
     */
    public static inline function shootProjectileTowards(factory: Factory, from: Vector2, direction: Float, speed: Float, range: Float,
            rotate: Bool = true): GameObject
    {
        // create the projectile with the correct rotation
        var rotation: Float = rotate ? direction : 0.0;
        var projectile: GameObject = factory.create(from, Vmath.quat_rotation_z(rotation));

        var to: Vector2 = new Vector2(from.x + range * Math.cos(direction), from.y + range * Math.sin(direction));

        // animate the object to its final position
        var moveDuration: Float = range / speed;
        projectile.animate(GameObjectProperties.position, to, moveDuration, 0, EASING_LINEAR, PLAYBACK_ONCE_FORWARD, (_, _, _) ->
        {
            // ... and queue its deletion at the end of the animation
            projectile.delete();
        });

        return projectile;
    }
}
