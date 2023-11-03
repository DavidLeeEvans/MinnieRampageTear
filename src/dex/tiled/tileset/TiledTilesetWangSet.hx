package dex.tiled.tileset;

import dex.map.TileBitmask;


typedef TiledTilesetWangSetData =
{
    var name: String;
    var type: WangSetType;
    var wangtiles: Array<TiledTilesetWangTile>;
}

@:forward
abstract TiledTilesetWangSet(TiledTilesetWangSetData) from TiledTilesetWangSetData
{
    public function getTileBitmasks(): Map<UInt, TileBitmask>
    {
        var bitmasks: Map<UInt, TileBitmask> = [ ];

        for (wangTile in this.wangtiles)
        {
            bitmasks.set(wangTile.getTileId(), wangTile.getBitmask());
        }

        return bitmasks;
    }
}
