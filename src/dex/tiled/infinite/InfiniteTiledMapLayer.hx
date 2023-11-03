package dex.tiled.infinite;

typedef InfiniteTiledMapLayer =
{
    var startx: Int;
    var starty: Int;
    var height: Int;
    var width: Int;
    var name: String;
    var chunks: Array<InfiniteTiledMapLayerChunk>;
}
