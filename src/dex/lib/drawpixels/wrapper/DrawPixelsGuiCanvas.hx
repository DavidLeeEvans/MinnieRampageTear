package dex.lib.drawpixels.wrapper;

import Defold.hash;
import defold.Buffer;
import defold.Gui;
import defold.types.BufferData;
import defold.types.Hash;
import dex.lib.drawpixels.BufferInfo.BufferInfoChannels;
import dex.util.DexError;
import dex.wrappers.GuiNode;


class DrawPixelsGuiCanvas extends DrawPixelsCanvas
{
    static final rgba: Hash = hash("rgba");

    static var txtrId: Int = 0;

    var node: GuiNode;

    public function new(node: GuiNode, width: Int, height: Int, channels: BufferInfoChannels = RGBA)
    {
        this.node = node;

        var textureName: Hash = hash('txtr${txtrId++}');
        super(textureName, width, height, channels);

        var data: BufferData = Buffer.get_bytes(buf.buffer, rgba);
        var res: GuiNewTextureResult = Gui.new_texture(textureName, width, height, channels, data);
        DexError.assert(res.success, 'unable to create gui texture; error code: ${res.code}');

        node.setTexture(resource);
        node.setSize(width, height);
    }

    override public function draw()
    {
        var data: BufferData = Buffer.get_bytes(buf.buffer, rgba);
        var success: Bool = Gui.set_texture_data(resource, buf.width, buf.height, buf.channels, data);
        DexError.assert(success, 'error setting texture data');

        node.setTexture(resource);
    }
}
