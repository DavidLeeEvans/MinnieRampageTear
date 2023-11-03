package dex.tiled.tileset;

import dex.map.TileBitmask;


typedef TiledTilesetWangTileData =
{
    var tileid: UInt;
    var wangid: Array<Int>;
}

abstract TiledTilesetWangTile(TiledTilesetWangTileData) from TiledTilesetWangTileData
{
    public inline function getTileId(): UInt
    {
        // for some reason tilesets start counting tiles at 0
        // while the rest of Tiled starts at 1...
        return this.tileid + 1;
    }

    public inline function getBitmask(): TileBitmask
    {
        var bitmask: TileBitmask = TileBitmask.empty;

        bitmask.set(-1, -1, this.wangid[ 5 ] == 1);
        bitmask.set(0, -1, this.wangid[ 4 ] == 1);
        bitmask.set(1, -1, this.wangid[ 3 ] == 1);

        bitmask.set(-1, 0, this.wangid[ 6 ] == 1);
        bitmask.set(1, 0, this.wangid[ 2 ] == 1);

        bitmask.set(-1, 1, this.wangid[ 7 ] == 1);
        bitmask.set(0, 1, this.wangid[ 0 ] == 1);
        bitmask.set(1, 1, this.wangid[ 1 ] == 1);

        bitmask.set(0, 0, true);

        return bitmask;
    }
}
