package dex.wrappers;

import Math.floor;
import defold.Go;
import defold.Tilemap.TilemapBounds;
import defold.Vmath;
import defold.types.HashOrString;
import defold.types.HashOrStringOrUrl;
import dex.util.DexError;
import dex.util.ds.Matrix2D;
import dex.util.types.Vector2;
import dex.util.types.Vector2Int;


typedef DfTilemap = defold.Tilemap;

enum abstract TileAnimationPlayback(Int)
{
    /** Advance the animation forward one frame on each iteration. **/
    var Forward = 0;

    /** Advance the animation backward one frame on each iteration. **/
    var Backward = 1;

    /** Advance the animation to another random frame on each iteration. **/
    var Random = 2;
}

class Tilemap
{
    public var path: HashOrStringOrUrl;
    public var tileWidth(default, null): Int;
    public var tileHeight(default, null): Int;

    var bounds: TilemapBounds;

    /**
     * Initialize a new reference to a tilemap.
     *
     * @param path The path of the tilemap.
     * @param tileWidth The map's tile width in pixels.
     * @param tileHeight The map's tile height in pixels.
     */
    public function new(path: HashOrStringOrUrl, tileWidth: Int, tileHeight: Int)
    {
        this.path = path;
        this.tileWidth = tileWidth;
        this.tileHeight = tileHeight;
    }

    /**
     * Gets the position of the game object containing the tilemap.
     *
     * @return The object's position.
     */
    public inline function getPosition(): Vector2
    {
        return Go.get_world_position(Go.get_id());
    }

    /**
     * Gets the actual position of a specific tile, relative to the tilemap object.
     *
     * @param x The x-coordinate of the tile in the map grid.
     * @param y The y-coordinate of the tile in the map grid.
     * @param center Whether or not to return the position of the tile's center, instead of its bottom-left corner.
     * @return The position of the tile's center or bottom-left corner, depending on the `center` parameter.
     *         Or `null` if the specified `x` and `y` are outside of the tilemap's bounds.
     */
    public inline function tileToPosition(x: Int, y: Int, center: Bool = true): Vector2
    {
        if (!inBounds(x, y))
        {
            return null;
        }

        var pos: Vector2 = Vmath.vector3();

        if (center)
        {
            pos.x += (x - 0.5) * tileWidth;
            pos.y += (y - 0.5) * tileHeight;
        }
        else
        {
            pos.x += (x - 1) * tileWidth;
            pos.y += (x - 1) * tileHeight;
        }

        return pos;
    }

    /**
     * Converts the given position to the corresponding tile on the tilemap.
     *
     * **Note:** This is a simple coordinate conversion, and does not check if the returned
     * coordinates are inside the tilemap's bounds.
     *
     * @param pos The world position, relative to the tilemap object.
     * @return A `{ x, y }` structure containing the coordinates of the tile on the tilemap grid.
     */
    public inline function positionToTile(pos: Vector2): Vector2Int
    {
        return positionXYToTile(pos.x, pos.y);
    }

    /**
     * Converts the given position to the corresponding tile on the tilemap.
     *
     * **Note:** This is a simple coordinate conversion, and does not check if the returned
     * coordinates are inside the tilemap's bounds.
     *
     * @param x The world position x-coordinate, relative to the tilemap object.
     * @param y The world position y-coordinate, relative to the tilemap object.
     * @return A `{ x, y }` structure containing the coordinates of the tile on the tilemap grid.
     */
    public inline function positionXYToTile(x: Float, y: Float): Vector2Int
    {
        loadBounds();
        return new Vector2Int(bounds.x + floor(x / tileWidth), bounds.y + floor(y / tileHeight));
    }

    /**
     * Gets the tilemap's width.
     *
     * @return The width of the tilemap in tiles.
     */
    public inline function getWidth(): Int
    {
        loadBounds();
        return bounds.w;
    }

    /**
     * Gets the tilemap's height.
     *
     * @return The height of the tilemap in tiles.
     */
    public inline function getHeight(): Int
    {
        loadBounds();
        return bounds.h;
    }

    /**
     * Gets the tile at the given position.
     *
     * @param layer The name of the layer on which to get the tile from.
     * @param x The x-coordinate of the tile.
     * @param y The y-coordinate of the tile.
     * @return The tile number.
     */
    public inline function get(layer: HashOrString, x: Int, y: Int): Int
    {
        return DfTilemap.get_tile(path, layer, x, y);
    }

    /**
     * Sets a tile at the given position.
     *
     * @param layer The name of the layer on which to set the tile.
     * @param x The x-coordinate of the tile.
     * @param y The y-coordinate of the tile.
     * @param tile The tile number.
     * @param hFlip Set to `true` to flip the tile horizontally.
     * @param vFlip Set to `true` to flip the tile vertically.
     * @return Self for chaining.
     */
    public inline function set(layer: HashOrString, x: Int, y: Int, tile: Int, ?hFlip: Bool, ?vFlip: Bool): Tilemap
    {
        DfTilemap.set_tile(path, layer, x, y, tile, hFlip, vFlip);
        return this;
    }

    /**
     * Sets multiple tiles at once. The given `tile` will be set to all combinations of coordinates
     * in the given `x` and `y` arrays.
     *
     * @param layer The name of the layer on which to set the tile.
     * @param x The x-coordinates of tiles to set.
     * @param y The y-coordinates of tiles to set.
     * @param tile The tile number.
     * @param hFlip Set to `true` to flip the tile horizontally.
     * @param vFlip Set to `true` to flip the tile vertically.
     * @return Self for chaining.
     */
    public inline function setMultiple(layer: HashOrString, x: Array<Int>, y: Array<Int>, tile: Int, ?hFlip: Bool, ?vFlip: Bool): Tilemap
    {
        for (i in x)
        {
            for (j in y)
            {
                set(layer, i, j, tile, hFlip, vFlip);
            }
        }
        return this;
    }

    /**
     * Checks if the given `x` and `y` coordinates are within the bounds of the tilemap.
     *
     * @param x The x-coordinate.
     * @param y The y-coordinate
     * @return `true` if the given coordinates are within the bounds.
     */
    public inline function inBounds(x: Float, y: Float): Bool
    {
        loadBounds();

        return x >= bounds.x && x < bounds.x + bounds.w && y >= bounds.y && y < bounds.y + bounds.h;
    }

    /**
     * Iterates over all tile coordinates in the tilemap's bounds, calling the given `callback` for each one.
     *
     * @param layer The name of the layer on which to iterate.
     * @param callback The callback function to be called for each pair of `x` and `y` coordinates.
     */
    public inline function forEach(callback: (x: Int, y: Int) -> Void)
    {
        loadBounds();

        for (x in bounds.x...(bounds.x + bounds.w))
        {
            for (y in bounds.y...(bounds.y + bounds.h))
            {
                callback(x, y);
            }
        }
    }

    /**
     * Iterates over all tiles in the tilemap, calling the given `callback` for each one.
     *
     * @param layer The name of the layer on which to iterate.
     * @param callback The callback function to be called for each tile.
     */
    public inline function forEachTile(layer: HashOrString, callback: (x: Int, y: Int, tile: Int) -> Void)
    {
        loadBounds();

        for (x in bounds.x...(bounds.x + bounds.w))
        {
            for (y in bounds.y...(bounds.y + bounds.h))
            {
                callback(x, y, get(layer, x, y));
            }
        }
    }

    /**
     * Animates all tiles on a given layer.
     *
     * All tiles on the layer, whose tile number exists in the given `frames` array, will be changed to the next frame in the array cyclically.
     *
     * @param layer The layer to run the animation iteration on.
     * @param frames A set of tile animation frames.
     * @param playback The animation playback method.
     * @param hFlipChance A chance `[0.0, 1.0]` to flip a tile horizontally.
     * @param vFlipChance A chance `[0.0, 1.0]` to flip a tile vertically.
     * @return Self for chaining.
     */
    public inline function animateTiles(layer: HashOrString, frames: Array<Int>, playback: TileAnimationPlayback = Forward, ?hFlipChance: Float = 0,
            ?vFlipChance: Float = 0)
    {
        forEachTile(layer, (x: Int, y: Int, tile: Int) ->
        {
            var animationIndex: Int = frames.indexOf(tile);

            if (animationIndex > -1)
            {
                switch playback
                {
                    case Forward:
                        animationIndex = (animationIndex + 1) % frames.length;

                    case Backward if (animationIndex > 0):
                        animationIndex = animationIndex - 1;

                    case Backward:
                        animationIndex = frames.length - 1;

                    case Random if (frames.length > 1):
                        var orig: Int = animationIndex;
                        animationIndex = Math.floor(Math.random() * (frames.length - 1));
                        if (animationIndex >= orig)
                        {
                            // indices equal or greater than the original are "resampled" to the range of values above it
                            animationIndex++;
                        }

                    case _:
                        DexError.error('invalid tile animation playback: $playback');
                }

                set(layer, x, y, frames[ animationIndex ], Math.random() < hFlipChance, Math.random() < vFlipChance);
            }
        });

        return this;
    }

    /**
     * Checks if the specified tile position on the given layer is empty.
     * (i.e tile number `0`)
     *
     * @param layer The name of the layer to check.
     * @param x The x-coordinates of tiles to check.
     * @param y The y-coordinates of tiles to check.
     * @return `true` if the tile at the given coordinates is empty.
     */
    public inline function isEmpty(layer: HashOrString, x: Int, y: Int): Bool
    {
        return get(layer, x, y) == 0;
    }

    /**
     * Creates and returns an one-dimensional array with one element for each tile in the tilemap.
     *
     * Each element will be `0` if the respective tile is empty, or `1` if it is non-empty.
     *
     * The map grid will be packed into this array row-by-row, meaning that the first element will
     * be for tile 1x1, the second element for tile 2x1 and so on.
     *
     * @param layer The name of the layer to get the mask from.
     * @param tile A specific tile to consider on the layer. If this parameter is provided,
     * a mask of only the specified tile on the layer will be created.
     * @param bit The number to use for existing tiles in the mask. Set to override the default `1`.
     * @return The mask.
     */
    public function getLayerMask(layer: HashOrString, ?tiles: Array<Int>, bit: Int = 1): Array<Int>
    {
        loadBounds();

        var mask: Array<Int> = new Array<Int>();

        for (y in bounds.y...(bounds.y + bounds.h))
        {
            for (x in bounds.x...(bounds.x + bounds.w))
            {
                var tile: Int = get(layer, x, y);

                if (tile != 0 && (tiles == null || tiles.indexOf(tile) > -1))
                {
                    mask.push(bit);
                }
                else
                {
                    mask.push(0);
                }
            }
        }

        return mask;
    }

    /**
     * Similar to `getLayerMask()`, but combining multiple layers to produce a single mask array.
     *
     * Each element in the mask is `0` if the respective tile is empty on all given layers, or
     * has the value of `bits[i]` if the layer `layers[i]` is non-empty. In case multiple layers
     * are non-empty on a given tile, the larger `bits[i]` value will be set.
     *
     * If `bits[]` is not provided, tiles from all layers will default to `1`.
     *
     * @param layers The list of layers to create the mask from.
     * @param tiles A specific list of tiles to consider on each layer. If this parameter is provided,
     * a mask of only the specified tiles on each layer will be created.
     * @param bits A list of bits, where `bits[i]` is the value to set for non-empty tiles on the layer `layers[i]`.
     * @return The mask.
     */
    public function getMultiLayerMask(layers: Array<HashOrStringOrUrl>, ?tiles: Array<Int>, ?bits: Array<Int>): Array<Int>
    {
        DexError.assert(layers.length == bits.length, 'different number of layers and bits passed to getMultiLayerMask()');

        loadBounds();

        var mask: Array<Int> = new Array<Int>();

        for (y in bounds.y...(bounds.y + bounds.h))
        {
            for (x in bounds.x...(bounds.x + bounds.w))
            {
                var val: Int = 0;

                for (l in 0...layers.length)
                {
                    var tile: Int = get(layers[ l ], x, y);
                    var layerBit: Int = bits == null ? 1 : bits[ l ];

                    if (tile != null && layerBit > val && (tiles == null || tiles.indexOf(tile) > -1))
                    {
                        val = layerBit;
                    }
                }

                mask.push(val);
            }
        }

        return mask;
    }

    /**
     * Set a region of the tilemap according to a given matrix of tiles.
     *
     * The bottom-left corner of where the matrix will be set on the tilemap is determined
     * by the input arguments `offsetX` and `offsetY`.
     *
     * @param layer the layer where to set the tiles
     * @param matrix the tiles to set as a 2D matrix
     * @param offsetX the x-position in the tilemap where the matrix should be set
     * @param offsetY the y-position in the tilemap where the matrix should be set
     */
    public function setMatrix(layer: HashOrString, matrix: Matrix2D<UInt>, offsetX: Int = 1, offsetY: Int = 1)
    {
        // ensure that the offsets given are valid
        DexError.assert(offsetX >= 1);
        DexError.assert(offsetY >= 1);

        // ensure that the given matrix can fit at the given position of the tilemap
        DexError.assert(matrix.width + offsetX - 1 <= getWidth());
        DexError.assert(matrix.height + offsetY - 1 <= getHeight());

        for (x in 0...matrix.width)
        {
            for (y in 0...matrix.height)
            {
                set(layer, x + offsetX, y + offsetY, matrix[ x ][ y ]);
            }
        }
    }

    /**
     * Sets the visible property on a given layer.
     *
     * @param layer The layer to set the property on.
     * @param visible Whether the layer should be visible or not.
     */
    public inline function setVisible(layer: HashOrString, visible: Bool)
    {
        DfTilemap.set_visible(path, layer, visible);
    }

    inline function loadBounds()
    {
        if (bounds == null)
            bounds = DfTilemap.get_bounds(path);
    }
}
