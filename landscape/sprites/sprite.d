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
module landscape.sprites.sprite;
import landscape.events.renderevent;
import landscape.events.mouseevent;
import landscape.events.updateevent;
import landscape.events.event;
import brew.box;
import brew.vec;
import brew.dim;
import cairo.Context;
import std.signals;

class Sprite
{
    Box2d _bounds;
    double _lineWidth = 1.0;
    bool _outlined = true;
    bool _filled = true;

    mixin Signal!(MouseEvent);
    mixin Signal!(RenderEvent);
    mixin Signal!(UpdateEvent);

    final void pos(in Vec2d p)
    {
        _bounds.pos = p;
    }

    final Vec2d pos() const
    {
        return _bounds.pos;
    }

    final void dim(in Dim2d d)
    {
        _bounds.dim = d;
    }

    final Dim2d dim() const
    {
        return _bounds.dim;
    }

    final void bounds(Box2d b)
    {
        _bounds = b;
    }

    final Box2d bounds() const
    {
        return _bounds;
    }

    final bool outlined() const
    {
        return _outlined;
    }

    final void outlined(bool b)
    {
        _outlined = b;
    }

    final bool filled() const
    {
        return _filled;
    }

    final void filled(bool b)
    {
        _filled = b;
    }
}
