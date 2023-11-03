package dex.util.rng.wfc;

import dex.util.ds.Matrix2D;
import dex.util.ds.TileFlipTable;
import dex.util.ds.TileRotationTable;
import dex.util.rng.wfc.PatternTransform;


typedef PatternData =
{
    /**
     * The ID of the pattern, which represents the position of the pattern
     * in the input tilemap.
     */
    var id: UInt;

    /**
     * The x-position of the (0, 0) corner of the pattern in the input tilemap.
     */
    var x: Int;

    /**
     * The y-position of the (0, 0) corner of the pattern in the input tilemap.
     */
    var y: Int;

    var transform: PatternTransform;
}

@:forward
abstract Pattern(PatternData) from PatternData
{
    public inline function new(id: UInt, patternsPerRow: Int, stride: UInt)
    {
        this =
        {
            id: id,
            x: (id % patternsPerRow) * stride,
            y: (Std.int(id / patternsPerRow)) * stride,
            transform: None,
        };
    }

    public inline function transformed(transform: PatternTransform): Pattern
    {
        return {
            id: this.id,
            x: this.x,
            y: this.y,
            transform: transform,
        };
    }

    /**
     * Get the tile value that corresponds to the given pattern coordinates in the input tilemap.
     *
     * @param input the input tilemap
     * @param kernel the kernel size for patterns
     * @param x the x-position inside the pattern in the range `[0, kernel)`
     * @param y the y-position inside the pattern in the range `[0, kernel)`
     * @param tileRotationTable optional tile rotation table, when tile values change if they are rotated
     * @param tileFlipTable optional tile rotation table, when tile values change if they are flipped
     */
    public inline function get(input: Matrix2D<UInt>, kernel: UInt, x: Int, y: Int, ?tileRotationTable: TileRotationTable, ?tileFlipTable: TileFlipTable): UInt
    {
        DexError.assert(x >= 0);
        DexError.assert(x < kernel);
        DexError.assert(y >= 0);
        DexError.assert(y < kernel);

        switch this.transform
        {
            case None:

            case FlipHorizontal:
                x = kernel - x - 1;

            case FlipVertical:
                y = kernel - y - 1;

            case FlipHorizontalAndVertical:
                x = kernel - x - 1;
                y = kernel - y - 1;

            case Rotate(_) if (kernel != 2 && kernel != 3):
                DexError.error('rotations are currently supported only for K=2 and K=3');

            case Rotate(rot):
                switch rot
                {
                    case Clockwise:
                        var tmp: Int = x;
                        x = kernel - y - 1;
                        y = tmp;

                    case Semicircle:
                        x = kernel - x - 1;
                        y = kernel - y - 1;

                    case CounterClockwise:
                        var tmp: Int = y;
                        y = kernel - x - 1;
                        x = tmp;

                    default:
                        DexError.error('invalid rotation');
                }

            default:
                DexError.error('not implemented');
        }

        DexError.assert(this.x + x >= 0);
        DexError.assert(this.x + x < input.width);
        DexError.assert(this.y + y >= 0);
        DexError.assert(this.y + y < input.height);

        var tileValue: UInt = input[ this.x + x ][ this.y + y ];

        switch this.transform
        {
            case FlipHorizontal if (tileFlipTable != null):
                tileValue = tileFlipTable.getHorizontal(tileValue);

            case FlipVertical if (tileFlipTable != null):
                tileValue = tileFlipTable.getVertical(tileValue);

            case FlipHorizontalAndVertical if (tileFlipTable != null):
                tileValue = tileFlipTable.getHorizontalAndVertical(tileValue);

            case Rotate(rot) if (tileRotationTable != null):
                // tiles need to be changed if rotated
                switch rot
                {
                    case Clockwise:
                        tileValue = tileRotationTable.getClockwise(tileValue);

                    case Semicircle:
                        tileValue = tileRotationTable.getSemicircle(tileValue);

                    case CounterClockwise:
                        tileValue = tileRotationTable.getCounterClockwise(tileValue);

                    default:
                }

            default:
        }

        return tileValue;
    }
}
