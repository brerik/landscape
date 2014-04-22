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
module landscape.nodes.dir.dirnode;
import landscape.nodes.filenode;
import landscape.nodes.rectnode;
import landscape.fileutil;
import brew.color;
import brew.insets;
import brew.vec;
import brew.box;
import brew.dim;
import cairo.Context;

class DirSymbol : CutCornerRectNode
{
    enum
    {
        GREY = NodeColor(Color4d(0.2, 0.2, 0.2, 1.0), Color4d(0.8, 0.8, 0.8, 1.0)),
        BLUE = NodeColor(Color4d(0.0, 0.1, 0.5, 1.0), Color4d(0.6, 0.7, 1.0, 1.0)),
        RED = NodeColor(Color4d(0.5, 0.0, 0.1, 1.0), Color4d(1.0, 0.6, 0.7, 1.0)),
        GREEN = NodeColor(Color4d(0.0, 0.5, 0.1, 1.0), Color4d(0.6, 1.0, 0.7, 1.0)),
        YELLOW = NodeColor(Color4d(0.6, 0.5, 0.0, 1.0), Color4d(1.0, 1.0, 0.5, 1.0)),
        VIOLET = NodeColor(Color4d(0.5, 0.2, 0.6, 1.0), Color4d(0.7, 0.65, 1.0, 1.0)),
        WHITE = NodeColor(Color4d(0.5, 0.5, 0.5, 1.0), Color4d(1.0, 1.0, 1.0, 1.0)),
        OCEAN = NodeColor(Color4d(0.0, 0.5, 0.5, 1.0), Color4d(0.3, 0.8, 0.8, 1.0)),
        SELECTED_INSETS = Insets2d.ZERO,
        DEFAULT_INSETS = Insets2d.ONES,
        DEFAULT_BOUNDS = Box2d(0, 0,240, 24),
        SELECTED_LINE_WIDTH = 2.0,
        DEFAULT_LINE_WIDTH = 1.0,
        DEFAULT_CUT = Vec2d(4,4),
        BAR_HEIGHT = 21,
    }

    static {
        immutable COLORS = [GREY, BLUE, RED, GREEN, YELLOW, VIOLET, WHITE, OCEAN];
        ref const(NodeColor) nextColor()
        {
            static size_t next = 0;
            return COLORS[next++ % COLORS.length];
        }
    }

    this()
    {
        super();
        connect(&watchNamedBool);
        addOnMousePressedDlg(&onSelectedDlg);
        nodeColor = nextColor;
        updateRect();
    }

    final bool onSelectedDlg(in Vec2d point, uint clickCount)
    {
        selected = !selected;
//        if (clickCount == 2)
//        {
//            FileUtil.openFile(file);
//        }
//        else if (clickCount == 1)
//        {
//            writefln("Clicked %s"w, file.getPath);
//        }
        return true;
    }

    void watchNamedBool(string name, bool newValue, bool oldValuez)
    {
        if (name == "selected")
        {
            updateRect();
        }
    }

    final void updateRect()
    {
        cut = DEFAULT_CUT;
        lineWidth = selected ? SELECTED_LINE_WIDTH : DEFAULT_LINE_WIDTH;
        insets = selected ? SELECTED_INSETS : DEFAULT_INSETS;
    }

    Box2d tailBounds()
    {
        return bounds - SELECTED_INSETS;
    }

    override void doPaintNode(Context ct)
    {
        super.doPaintNode(ct);
        if (bounds.height > DEFAULT_BOUNDS.height)
        {
            auto r = rectToPaint(lineWidth);
            ct.setLineWidth(lineWidth);
            ct.setSourceRgb(fgColor.red, fgColor.green, fgColor.blue);
            ct.moveTo(r.left + DEFAULT_CUT.x, r.top + BAR_HEIGHT);
            ct.lineTo(r.right - DEFAULT_CUT.x, r.top + BAR_HEIGHT);
            ct.stroke();
        }
    }
}
