/*
 * Landscape Filesystem Browser
 * Copyright (C) 2013-2014 erik wikforss
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
module landscape.nodes.iconnode;
import landscape.nodes.node;
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
        iconSize = "iconSize",
    }
    private {
        Dim2d _iconSize;
    }

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
