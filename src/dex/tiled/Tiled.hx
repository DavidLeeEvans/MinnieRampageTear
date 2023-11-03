package dex.tiled;

import haxe.Json;
import dex.tiled.infinite.InfiniteTiledMap;
import dex.tiled.tileset.TiledTileset;
import dex.util.DexError;


class Tiled
{
    /**
     * Parses a regular Tiled map.
     *
     * This parser also mirrors the map along with y-axis, since Tiled measures from the top left, while
     * Defold measures from the bottom left.
     *
     * @param tmxJson the JSON string of the TMX map file
     * @return the tiled map data
     */
    public static function parse(tmxJson: String): TiledMap
    {
        var map: TiledMap = Json.parse(tmxJson);

        for (layer in map.layers)
        {
            layer.y = -layer.y;

            switch layer.type
            {
                case TileLayer:
                    {
                        var tileLayer: TiledMapTileLayer = layer;
                        var data: Array<Int> = tileLayer.data;
                        DexError.assert(data != null);

                        for (row in 0...Std.int(tileLayer.height / 2))
                        {
                            for (col in 0...tileLayer.width)
                            {
                                var x: Int = col;
                                var y0: Int = row;
                                var y1: Int = tileLayer.height - row - 1;

                                var tmp: Int = data[ x + y0 * tileLayer.width ];
                                data[ x + y0 * tileLayer.width ] = data[ x + y1 * tileLayer.width ];
                                data[ x + y1 * tileLayer.width ] = tmp;
                            }
                        }
                    }

                case ObjectLayer:
                    {
                        var objLayer: TiledMapObjectLayer = layer;
                        var mapHeight: Float = map.height * map.tileheight;
                        DexError.assert(objLayer.objects != null);

                        for (object in objLayer.objects)
                        {
                            object.y = mapHeight - object.y;
                        }
                    }

                case _:
                    DexError.error('invalid layer type: ${layer.type}');
            }
        }

        return map;
    }

    /**
     * Parses an infinite Tiled map.
     *
     * This parser also mirrors the map along with y-axis, since Tiled measures from the top left, while
     * Defold measures from the bottom left.
     *
     * @param tmxJson the JSON string of the TMX map file
     * @return the tiled map data
     */
    public static function parseInfinite(tmxJson: String): InfiniteTiledMap
    {
        var map: InfiniteTiledMap = Json.parse(tmxJson);

        for (layer in map.layers)
        {
            for (chunk in layer.chunks)
            {
                chunk.y = -chunk.y;

                var data: Array<Int> = chunk.data;

                for (row in 0...Std.int(chunk.height / 2))
                {
                    for (col in 0...chunk.width)
                    {
                        var i1: Int = Std.int(col + row * chunk.height);
                        var i2: Int = Std.int(col + (chunk.height - row - 1) * chunk.height);

                        var tmp: Int = data[ i1 ];
                        data[ i1 ] = data[ i2 ];
                        data[ i2 ] = tmp;
                    }
                }
            }
        }

        return map;
    }

    public static function parseTileset(tsxJson: String): TiledTileset
    {
        return Json.parse(tsxJson);
    }
}
