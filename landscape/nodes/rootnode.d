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
module landscape.nodes.rootnode;
import landscape.nodes.node;
import landscape.nodes.rectnode;
import brew.vec;
import brew.color;
import brew.insets;

class RootNode : CutCornerRectNode
{
    enum NODE_COLOR : NodeColor {
        ROOT = NodeColor(Color4d(0.1, 0.1, 0.1, 1.0), Color4d(0.9, 0.9, 0.9, 1.0))
    }

    this()
    {
        cut = Vec2d.fill(8.0);
        nodeColor = NODE_COLOR.ROOT;
        lineWidth = 2.0;
    }

    override void updateLayout()
    {
        double next = 0;
        double m = 0;
        foreach(Node c; visibleChildren)
        {
            c.updateTotalBounds();
            c.offset.y = next - c.totalBounds.top + m;
            m = 50;
            next = next + c.totalBounds.height;
        }
        updateBounds();
        updateTotalBounds();
    }

    override void updateBounds()
    {
        bounds = computeTotalBounds() + Insets2d(160,160,100,100);
    }
}
