/*
 * Landscape Filesystem Browser
 * Copyright (C) 2013-2014 Erik Wikforss
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
    enum PropName : string
    {
        lineWidth = "lineWidth"
    }
    double _lineWidth = 1;
    bool isDraw = true;
    bool isFill = true;

    this()
    {
        super();
    }

    /**
     * Sets line width property and emits changed signal if changed
     * @param newLineWidth
     */
    public final void lineWidth(double newLineWidth)
    {
        if (newLineWidth != _lineWidth)
        {
            auto oldLineWidth = _lineWidth;
            _lineWidth = newLineWidth;
            emit(PropName.lineWidth, newLineWidth, oldLineWidth);
            redraw();
        }
    }

    /**
     * Gets line width property
     * @return line width
     */
    public final double lineWidth() const
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
    enum PropName : string
    {
        topLeftCut = "topLeftCut",
        topRightCut = "topRightCut",
        bottomLeftCut = "bottomLeftCut",
        bottomRightCut = "bottomRightCut"
    }

    private Vec2d _topLeftCut = Vec2d(4,4);
    private Vec2d _topRightCut = Vec2d(4,4);
    private Vec2d _bottomLeftCut = Vec2d(4,4);
    private Vec2d _bottomRightCut = Vec2d(4,4);

    public final void cut(in Vec2d c)
    {
        topLeftCut = c;
        topRightCut = c;
        bottomLeftCut = c;
        bottomRightCut = c;
    }

    public final void topLeftCut(in Vec2d newVal)
    {
        if (newVal != _topLeftCut)
        {
            auto oldVal = _topLeftCut;
            _topLeftCut = newVal;
            emit(PropName.topLeftCut, newVal, oldVal);
        }
    }
    public final ref const(Vec2d) topLeftCut() const
    {
        return _topLeftCut;
    }

    public final void topRightCut(in Vec2d newVal)
    {
        if (newVal != _topRightCut)
        {
            auto oldVal = _topRightCut;
            _topRightCut = newVal;
            emit(PropName.topRightCut, newVal, oldVal);
        }
    }
    public final ref const(Vec2d) topRightCut() const
    {
        return _topRightCut;
    }

    public final void bottomLeftCut(in Vec2d newVal)
    {
        if (newVal != _bottomLeftCut)
        {
            auto oldVal = _bottomLeftCut;
            _bottomLeftCut = newVal;
            emit(PropName.bottomLeftCut, newVal, oldVal);
        }
    }
    public final ref const(Vec2d) bottomLeftCut() const
    {
        return _bottomLeftCut;
    }

    public final void bottomRightCut(in Vec2d newVal)
    {
        if (newVal != _bottomRightCut)
        {
            auto oldVal = _bottomRightCut;
            _bottomRightCut = newVal;
            emit(PropName.bottomRightCut, newVal, oldVal);
        }
    }
    public final ref const(Vec2d) bottomRightCut() const
    {
        return _bottomRightCut;
    }

    final Box2d rectToPaint(double aLineWidth) const
    {
        Box2d r = insetBounds;
        r.x = r.floorX + aLineWidth / 2.0;
        r.y = r.floorY + aLineWidth / 2.0;
        r.width = r.ceilWidth - aLineWidth;
        r.height = r.ceilHeight - aLineWidth;
        return r;
    }

    override void doPaintNode(Context ct)
    {
        void doOutline()
        {
            auto r = rectToPaint(lineWidth);
            ct.moveTo(r.left, r.top + topLeftCut.y);
            ct.lineTo(r.left + topLeftCut.x, r.top);
            ct.lineTo(r.right - topRightCut.x, r.top);
            ct.lineTo(r.right, r.top + topRightCut.y);
            ct.lineTo(r.right, r.bottom - bottomRightCut.y);
            ct.lineTo(r.right - bottomRightCut.x, r.bottom);
            ct.lineTo(r.left + bottomLeftCut.x, r.bottom);
            ct.lineTo(r.left, r.bottom - bottomLeftCut.y);
            ct.lineTo(r.left, r.bottom - bottomLeftCut.y);
            ct.lineTo(r.left, r.top + topLeftCut.y);
        }
        if (isFill)
        {
            doOutline();
            ct.setSourceRgb(bgColor.red, bgColor.green, bgColor.blue);
            ct.fill();
        }
        if (isDraw && lineWidth > 0)
        {
            ct.setLineWidth(lineWidth);
            ct.setSourceRgb(fgColor.red, fgColor.green, fgColor.blue);
            doOutline();
            ct.stroke();
        }
    }

}
