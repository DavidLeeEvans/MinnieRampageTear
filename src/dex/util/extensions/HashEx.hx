package dex.util.extensions;

import defold.types.Hash;
import Defold.hash;

/**
    Static extensions for Hash.
**/
class HashEx
{
    static final nullHash = hash("");

    /**
     * Returns `true` if the hash `h` is either `null`, or equal to `hash("")`.
     */
    public static inline function isNull(h: Hash)
    {
        return h == null || h == nullHash;
    }

    /**
     * Returns `true` if the hash `h` is neither `null`, nor equal to `hash("")`.
     */
    public static inline function notNull(h: Hash)
    {
        return !isNull(h);
    }
}
