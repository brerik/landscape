/*
 * Brew Miscellaneous Library for GDK Extensions
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
module brew.gdk;
import brew.color;
import brew.vec;
import gdk.RGBA;
import gdk.Event;

RGBA toRGBA(in Color4d c)
{
    return new RGBA(c.red, c.green, c.blue, c.alpha);
}

RGBA toRGBA(in Color3d c)
{
    return new RGBA(c.red, c.green, c.blue, 1.0);
}

RGBA toRGBA(in Color4f c)
{
    return new RGBA(c.red, c.green, c.blue, c.alpha);
}

RGBA toRGBA(in Color3f c)
{
    return new RGBA(c.red, c.green, c.blue, 1.0);
}

/**
 * Gets scroll deltas or Vec2d.nan if fail
 */
Vec2d getScrollDeltas(Event ev)
{
    ScrollDirection sd;
    if (ev.getScrollDirection(sd))
    {
        switch (sd)
        {
            case ScrollDirection.UP:
                return Vec2d(0,-1);
            case ScrollDirection.DOWN:
                return Vec2d(0,1);
            case ScrollDirection.LEFT:
                return Vec2d(-1,0);
            case ScrollDirection.RIGHT:
                return Vec2d(1,0);
            case ScrollDirection.SMOOTH:
                Vec2d d;
                if (ev.getScrollDeltas(d.x, d.y))
                    return d;
                return Vec2d.zero;
            default:
                return Vec2d.zero;
        }
    }
    return Vec2d.nan;
}

/**
 * Gets root coords or Vec2d.nan if fail
 */
Vec2d getRootCoords(Event ev)
{
    Vec2d c;
    if (ev.getRootCoords(c.x, c.y))
        return c;
    else
        return Vec2d.nan;
}

/**
 * Gets coords or Vec2d.nan if fail
 */
Vec2d getCoords(Event ev)
{
    Vec2d c;
    if (ev.getCoords(c.x, c.y))
        return c;
    else
        return Vec2d.nan;
}

/**
 * Gets click count
 */
uint getClickCount(Event ev)
{
    uint c;
    if (ev.getClickCount(c))
        return c;
    else
        return 0;
}
