package dex.tiled;

import dex.tiled.TiledMapLayer.TiledMapLayerData;
import dex.util.DexError;


@:forward(type, x, y, name, visible, opacity, objects)
abstract TiledMapObjectLayer(TiledMapLayerData)
{
    public inline function getObjectsByClass(cls: String): Array<TiledObject>
    {
        return this.objects.filter(o -> o.class_ == cls);
    }

    public inline function getObjectsByName(name: String): Array<TiledObject>
    {
        return this.objects.filter(o -> o.name == name);
    }

    @:from
    static inline function fromLayer(layer: TiledMapLayer): TiledMapObjectLayer
    {
        if (layer.type != ObjectLayer)
        {
            DexError.error('invalid cast to TiledMapObjectLayer from ${layer.type}');
        }
        return cast layer;
    }
}
