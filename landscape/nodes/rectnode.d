/*
 * Landscape Filesystem Browser
 * Copyright (C) 2013-2014 Erik Wigforss
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
module landscape.nodes.rectnode;
import std.string, std.stdio;
import landscape.nodes.node;
import brew.dim;
import brew.box;
import brew.vec;
import brew.color;
import brew.math;
import cairo.Context;

class RectNode : Node
{
    double _lineWidth = 1;
    bool isDraw = true;
    bool isFill = true;

    this()
    {
        super();
    }

    final void lineWidth(double newLineWidth)
    {
        if (newLineWidth != _lineWidth)
        {
            auto oldLineWidth = _lineWidth;
            _lineWidth = newLineWidth;
            emit("lineWidth", newLineWidth, oldLineWidth);
            redraw();
        }
    }

    final double lineWidth() const
    {
        return _lineWidth;
    }

    override void doPaintNode(Context ct)
    {
        if (isFill)
        {
            ct.rectangle(bounds.x+insets.left, bounds.y+insets.top, bounds.width-insets.width, bounds.height-insets.height);
            ct.setSourceRgb(bgColor.red, bgColor.green, bgColor.blue);
            ct.fill();
        }
        if (isDraw)
        {
            ct.setLineWidth(lineWidth);
            ct.setSourceRgb(fgColor.red, fgColor.green, fgColor.blue);
            ct.rectangle(bounds.x+insets.left, bounds.y+insets.top, bounds.width-insets.width, bounds.height-insets.height);
            ct.stroke();
        }
    }
}

class CutCornerRectNode : RectNode
{
    Vec2d topLeft = Vec2d(4,4);
    Vec2d topRight = Vec2d(4,4);
    Vec2d bottomLeft = Vec2d(4,4);
    Vec2d bottomRight = Vec2d(4,4);

    void cut(in Vec2d c)
    {
        topLeft = topRight = bottomLeft = bottomRight = c;
    }

    final Box2d rectToPaint(double aLineWidth) const
    {
        Box2d r = insettedBounds;
        r.x = r.floorX + lineWidth / 2.0;
        r.y = r.floorY + lineWidth / 2.0;
        r.width = r.ceilWidth - lineWidth;
        r.height = r.ceilHeight - lineWidth;
        return r;
    }

    override void doPaintNode(Context ct)
    {
        if (isFill)
        {
            doOutline(ct);
            ct.setSourceRgb(bgColor.red, bgColor.green, bgColor.blue);
            ct.fill();
        }
        if (isDraw && lineWidth > 0)
        {
            ct.setLineWidth(lineWidth);
            ct.setSourceRgb(fgColor.red, fgColor.green, fgColor.blue);
            doOutline(ct);
            ct.stroke();
        }
    }

    final void doOutline(Context ct)
    {
        auto r = rectToPaint(lineWidth);
        ct.moveTo(r.left, r.top + topLeft.y);
        ct.lineTo(r.left + topLeft.x, r.top);
        ct.lineTo(r.right-topRight.x, r.top);
        ct.lineTo(r.right, r.top + topRight.y);
        ct.lineTo(r.right, r.bottom - bottomRight.y);
        ct.lineTo(r.right-bottomRight.x, r.bottom);
        ct.lineTo(r.left + bottomLeft.x, r.bottom);
        ct.lineTo(r.left, r.bottom - bottomLeft.y);
        ct.lineTo(r.left, r.bottom - bottomLeft.y);
        ct.lineTo(r.left, r.top + topLeft.y);
    }
}
