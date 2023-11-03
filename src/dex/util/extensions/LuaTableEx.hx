package dex.util.extensions;

import defold.types.Hash;
import lua.Table;


class LuaTableEx
{
    public static function get(table: Table<Hash, Hash>, key: Hash): Hash
    {
        for (k => v in Table.toMap(table))
        {
            if (k == key)
            {
                return v;
            }
        }
        return null;
    }

    public static function forEach<K, V>(table: Table<K, V>, callback: (K, V) -> Void)
    {
        for (k => v in Table.toMap(table))
        {
            callback(k, v);
        }
        return null;
    }
}
