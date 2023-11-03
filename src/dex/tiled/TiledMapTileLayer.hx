package dex.tiled;

import defold.types.HashOrString;
import dex.tiled.TiledMapLayer.TiledMapLayerData;
import dex.util.DexError;
import dex.util.ds.Matrix2D;
import dex.wrappers.Tilemap;


@:forward(type, x, y, width, height, name, visible, opacity, data)
abstract TiledMapTileLayer(TiledMapLayerData)
{
    public inline function contains(x: Int, y: Int): Bool
    {
        return x >= this.x && x < this.x + this.width && y >= this.y && y < this.y + this.height;
    }

    public inline function get(x: Int, y: Int): UInt
    {
        return this.data[ y * this.width + x ];
    }

    public function toMatrix(): Matrix2D<UInt>
    {
        var matrix: Matrix2D<UInt> = new Matrix2D(this.width, this.height, 0);

        for (x in 0...this.width)
        {
            for (y in 0...this.height)
            {
                matrix[ x ][ y ] = get(x, y);
            }
        }

        return matrix;
    }

    public function setToTilemap(tilemap: Tilemap, layer: HashOrString)
    {
        for (x in 0...this.width)
        {
            for (y in 0...this.height)
            {
                var tile: Int = get(x, y);

                tilemap.set(layer, x + 1, y + 1, tile);
            }
        }
    }

    @:from
    static inline function fromLayer(layer: TiledMapLayer): TiledMapTileLayer
    {
        if (layer.type != TileLayer)
        {
            DexError.error('invalid cast to TiledMapTileLayer from ${layer.type}');
        }
        return cast layer;
    }
}
