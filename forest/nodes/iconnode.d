/*
 * Forest File Finder by erik wikforss
 */
module forest.nodes.iconnode;
import forest.nodes.node;
import brew.box;
import brew.vec;
import brew.dim;
import brew.insets;
import gio.FileIcon;
import gdk.Pixbuf;
import gdk.Cairo;
import cairo.Context;
import std.stdio;


class IconNode : Node
{
    enum {
        DEFAULT_ICON_SIZE = Dim2d(100,100),
    }

    enum PropName {
        iconSize = "iconSize"
    }

    private Dim2d _iconSize;

    this() {
        super();
        _iconSize = DEFAULT_ICON_SIZE;
        alignment = Vec2d.halves;
    }

    override void drawNode(Context ct) {
        auto r = insetBounds;
        ct.setSourceRgb(.5,1,.5);
        ct.rectangle(r.x + (r.width - iconSize.width) * alignment.x, r.y + (r.height - iconSize.height) * alignment.y, iconSize.width, iconSize.height);
        ct.fill();
    }

    ref const(Dim2d) iconSize() const {
        return _iconSize;
    }

    void iconSize(in Dim2d newSize) {
        if (newSize != _iconSize) {
            auto oldSize = _iconSize;
            _iconSize = newSize;
            emit(PropName.iconSize, newSize, oldSize);
        }
    }
}
