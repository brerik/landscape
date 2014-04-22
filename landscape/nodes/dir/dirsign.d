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
module landscape.nodes.dir.dirsign;
public import landscape.nodes.signnode;
import brew.insets;
import brew.dim;

class OpenSign : SignNode
{
    enum
    {
        OPEN = SignType.DOWN,
        CLOSE = SignType.UP,
        HIDDEN = SignType.NONE,
    }

    this()
    {
        connect(&signChanged);
        drawRing = false;
    }

    void signChanged(string name, int newSign, int oldSign)
    {
        if (name == PropName.sign)
        {
            switch (newSign)
            {
                case OPEN:
                    signColor.set(0,0,.25);
                    insets = Insets2d(5,5,5,5);
                    visible = true;
                    break;
                case CLOSE:
                    signColor.set(.25,0,0);
                    insets= Insets2d(5,5,5,5);
                    visible = true;
                    break;
                case HIDDEN:
                    signColor.set(0,0,0);
                    insets = Insets2d(5,5,5,5);
                    visible = false;
                    break;
                default:
                    signColor.set(0,0,0);
                    insets = Insets2d(5,5,5,5);
                    visible = true;
                    break;
            }
            setLayoutDirty();
            redraw();
        }
    }
}

class ExpandSign : SignNode
{
    enum {
        OPEN = SignType.RIGHT,
        CLOSE = SignType.LEFT,
        HIDDEN = SignType.NONE,
    }

    this()
    {
        connect(&signChanged);
        drawRing = false;
    }

    void signChanged(string name, int newSign, int oldSign)
    {
        if (name == PropName.sign)
        {
            switch (newSign)
            {
                case OPEN:
                    signColor.set(0,.25,0);
                    visible = true;
                    bounds.dim = Dim2d(20,20);
                    break;
                case CLOSE:
                    signColor.set(.25,0,0);
                    visible = true;
                    bounds.dim = Dim2d(20,20);
                    break;
                case HIDDEN:
                    signColor.set(0,0,0);
                    visible = false;
                    break;
                default:
                    signColor.set(0,0,0);
                    visible = true;
                    bounds.dim = Dim2d(20,20);
                    break;
            }
            setLayoutDirty();
            redraw();
        }
    }
}
