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
module landscape.nodes.circlenode;
import std.string;
import landscape.nodes.node;
import brew.dim, brew.box, brew.vec, brew.color, brew.math;
import cairo.Context;

class CircleNode : Node
{
    double lineWidth = 2.0;
    bool isDraw = true;
    bool isFill = true;

    this()
    {
        super();
    }

    override void doPaintNode(Context ct)
    {
        if (isFill)
        {
            pathCircle(ct);
            ct.setSourceRgb(bgColor.red, bgColor.green, bgColor.blue);
            ct.fill();
        }
        if (isDraw)
        {
            ct.setLineWidth(lineWidth);
            ct.setSourceRgb(fgColor.red, fgColor.green, fgColor.blue);
            pathCircle(ct);
            ct.stroke();
        }
    }

    final void pathCircle(Context ct)
    {
        ct.moveTo(bounds.maxX, bounds.centerY);
        ct.arc(bounds.centerX, bounds.centerY, bounds.halfWidth, 0, 2 * Mathd.pi);
//        const M_1_4 = 1.0 / 5.0;
//        const M_3_4 = 4.0 / 5.0;
//        ct.moveTo(bounds.minX, bounds.centerY);
//        ct.curveTo(bounds.minX, bounds.alignedY(M_1_4), bounds.alignedX(M_1_4), bounds.minY, bounds.centerX, bounds.minY);
//        ct.curveTo(bounds.alignedX(M_3_4), bounds.minY, bounds.maxX, bounds.alignedY(M_1_4), bounds.maxX, bounds.centerY);
//        ct.curveTo(bounds.maxX, bounds.alignedY(M_3_4), bounds.alignedX(M_3_4), bounds.maxY, bounds.centerX, bounds.maxY);
//        ct.curveTo(bounds.alignedX(M_1_4), bounds.maxY, bounds.minX, bounds.alignedY(M_3_4), bounds.minX, bounds.centerY);
//        ct.closePath();

    }
}

