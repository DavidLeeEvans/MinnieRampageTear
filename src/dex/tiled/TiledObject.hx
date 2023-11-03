package dex.tiled;

import dex.tiled.TiledObjectProperty;


typedef TiledObjectData =
{
    var name: String;
    var x: Float;
    var y: Float;
    var width: Float;
    var height: Float;
    var visible: Bool;
    var rotation: Float;
    var properties: Array<TiledObjectProperty>;
}

@:forward
abstract TiledObject(TiledObjectData)
{
    public var class_(get, set): String;

    @:op([ ])
    inline function getProperty(name: String): TiledObjectProperty
    {
        var foundProperty: TiledObjectProperty = null;
        if (this.properties != null)
        {
            for (prop in this.properties)
            {
                if (prop.name == name)
                {
                    foundProperty = prop;
                    break;
                }
            }
        }

        return foundProperty;
    }

    inline function get_class_(): String
    {
        return Reflect.field(this, 'class');
    }

    inline function set_class_(value: String): String
    {
        Reflect.setField(this, 'class', value);
        return value;
    }
}
