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
module landscape.events.renderevent;
import landscape.events.event;
import brew.mat;
import brew.vec;
import cairo.Context;

class RenderEvent : Event
{
    enum Name : string
    {
        render = "render"
    }

    Context _context;
    Mat3x3d _transform;

    this(Context ct, in Mat3x3d trans)
    {
        super(Name.render);
        _context = ct;
        _transform = trans;
    }

    Context context()
    {
        return _context;
    }

    ref const(Mat3x3d) transform() const
    {
        return _transform;
    }

    Vec2d offset() const
    {
        return Vec2d(_transform.c2.x, _transform.c2.y);
    }

    Vec2d scale() const
    {
        return Vec2d(_transform.c0.x, _transform.c1.y);
    }

    Vec2d shear() const
    {
        return Vec2d(_transform.c1.x, _transform.c0.y);
    }
}

