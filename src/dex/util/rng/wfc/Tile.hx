package dex.util.rng.wfc;

import defold.types.HashOrString;
import dex.util.ds.TileRotationTable;
import dex.util.rng.wfc.PatternTransform;
import dex.wrappers.Tilemap;


typedef TileData =
{
    /**
     * The tile id of the tile, **without** the transform applied.
     */
    var value: UInt;

    /**
     * The transform applied to the tile.
     */
    var transform: PatternTransform;
}

@:forward
abstract Tile(TileData) from TileData
{
    public inline function new(value: UInt, transform: PatternTransform = None)
    {
        this =
        {
            value: value,
            transform: transform
        };
    }

    /**
     * Get the value of this tile after its transform has been applied to it.
     *
     * @param tileRotationTable the tile rotation table, in case the tile has been rotated
     * @return the transformed value
     */
    public function getTransformedValue(?tileRotationTable: TileRotationTable): UInt
    {
        var tileValue: UInt = this.value;

        switch this.transform
        {
            case Rotate(rot) if (tileRotationTable != null):
                switch rot
                {
                    case Clockwise:
                        tileValue = tileRotationTable.getClockwise(tileValue);

                    case Semicircle:
                        tileValue = tileRotationTable.getSemicircle(tileValue);

                    case CounterClockwise:
                        tileValue = tileRotationTable.getCounterClockwise(tileValue);

                    default:
                        DexError.error();
                }

            default:
        }
        return tileValue;
    }

    /**
     * Set this tile on a tilemap.
     *
     * The position follows the Defold convention, where the bottom-right corner is tile `(1, 1)`.
     *
     * @param tilemap the tilemap
     * @param layer the layer on the tilemap to set the tile on
     * @param x the x-position in the tilemap to set the tile
     * @param y the y-position in the tilemap to set the tile
     * @param tileRotationTable if rotational transforms are possible, then a tile rotation table should be provided
     */
    public function setOnTilemap(tilemap: Tilemap, layer: HashOrString, x: Int, y: Int, ?tileRotationTable: TileRotationTable)
    {
        var tileValue: UInt = this.value;
        var hFlip: Bool = false;
        var vFlip: Bool = false;
        switch this.transform
        {
            case None:

            case FlipHorizontal:
                hFlip = true;

            case FlipVertical:
                vFlip = true;

            case FlipHorizontalAndVertical:
                hFlip = true;
                vFlip = true;

            case Rotate(rot):
                switch rot
                {
                    case Clockwise:
                        tileValue = tileRotationTable.getClockwise(tileValue);

                    case Semicircle:
                        tileValue = tileRotationTable.getSemicircle(tileValue);

                    case CounterClockwise:
                        tileValue = tileRotationTable.getCounterClockwise(tileValue);

                    default:
                        DexError.error();
                }

            default:
                DexError.error();
        }
        tilemap.set(layer, x, y, tileValue, hFlip, vFlip);
    }

    @:from
    static inline function fromValue(value: UInt): Tile
    {
        return new Tile(value);
    }
}
