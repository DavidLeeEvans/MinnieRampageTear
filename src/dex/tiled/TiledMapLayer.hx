package dex.tiled;

import dex.tiled.TiledObject;


typedef TiledMapLayerData =
{
    var type: TiledLayerType;
    var x: UInt;
    var y: UInt;
    var height: UInt;
    var width: UInt;
    var name: String;
    var visible: Bool;
    var opacity: Float;
    var data: Array<UInt>;
    var objects: Array<TiledObject>;
}

@:forward(type, x, y, name, visible, opacity)
abstract TiledMapLayer(TiledMapLayerData)
{
}
