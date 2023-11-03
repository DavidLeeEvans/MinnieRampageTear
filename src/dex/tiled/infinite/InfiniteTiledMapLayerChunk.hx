package dex.tiled.infinite;

typedef InfiniteTiledMapLayerChunkData =
{
    var data: Array<Int>;
    var x: Int;
    var y: Int;
    var width: Int;
    var height: Int;
}

@:forward(data, x, y, width, height)
abstract InfiniteTiledMapLayerChunk(InfiniteTiledMapLayerChunkData)
{
    public inline function contains(x: Int, y: Int): Bool
    {
        return x >= this.x && x < this.x + this.width && y >= this.y && y < this.y + this.height;
    }

    @:arrayAccess
    public inline function get(x: Int, y: Int): Int
    {
        return this.data[ y * this.height + x ];
    }
}
