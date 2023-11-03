package dex.tiled.tileset;

import dex.tiled.tileset.TiledTilesetWangSet;


typedef TiledTilesetData =
{
    var columns: Int;
    var imageheight: Int;
    var imagewidth: Int;
    var name: String;
    var image: String;
    var spacing: Int;
    var tilecount: Int;
    var tiledversion: String;
    var tilewidth: Int;
    var tileheight: Int;
    var tiles: Array<TiledTilesetStochasticTile>;
    var type: String;
    var wangsets: Array<TiledTilesetWangSet>;
}

@:forward
abstract TiledTileset(TiledTilesetData) from TiledTilesetData
{
    public inline function getWangSetWithName(name: String): TiledTilesetWangSet
    {
        var wangset: TiledTilesetWangSet = null;

        for (ws in this.wangsets)
        {
            if (ws.name == name)
            {
                wangset = ws;
                break;
            }
        }

        return wangset;
    }
}
