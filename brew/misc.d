/*
 * Brew Miscellaneous Library by Brother erik wikforss
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
module brew.misc;
private import brew.math;

struct Interval(T)
{
    T min, max;

    pure static Interval!T opCall(T min, T max)
    {
        Interval!T interval = {min, max};
        return interval;
    }

    T length() const
    {
        return Math!T.abs(max - min);
    }

    T clamp(T value) const
    {
        return Math!T.clamp(value, min, max);
    }
    T clampAbove(T value) const
    {
        return Math!T.clampAbove(value, max);
    }
    T clampBelow(T value) const
    {
        return Math!T.clampBelow(value, min);
    }
}

enum CardinalDirection
{
    EAST,
    EAST_NORTH_EAST,
    NORTH_EAST,
    NORTH_NORTH_EAST,
    NORTH,
    NORTH_NORTH_WEST,
    NORTH_WEST,
    WEST_NORTH_WEST,
    WEST,
    WEST_SOUTH_WEST,
    SOUTH_WEST,
    SOUTH_SOUTH_WEST,
    SOUTH,
    SOUTH_SOUTH_EAST,
    SOUTH_EAST,
    EAST_SOUTH_EAST
}

enum Direction
{
    LEFT,
    UP,
    RIGHT,
    DOWN
}


