package dex.tiled;

import dex.tiled.TiledMapLayer;


typedef TiledMapData =
{
    var layers: Array<TiledMapLayer>;

    /** The width of each tile in the map in pixels. **/
    var tiledwidth: Int;

    /** The height of each tile in the map in pixels. **/
    var tileheight: Int;

    /** The width of the map in number of tiles. **/
    var width: Int;

    /** The height of the map in number of tiles. **/
    var height: Int;
}

@:forward
abstract TiledMap(TiledMapData)
{
    @:op([ ])
    inline function getLayer(name: String): TiledMapLayer
    {
        var foundLayer: TiledMapLayer = null;

        for (layer in this.layers)
        {
            if (layer.name == name)
            {
                foundLayer = layer;
                break;
            }
        }

        return foundLayer;
    }
}
