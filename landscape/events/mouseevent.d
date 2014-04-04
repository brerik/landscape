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
module landscape.events.mouseevent;
import landscape.events.event;
import brew.vec;

class MouseEvent : Event
{
    enum Name : string
    {
        pressed = "pressed",
        released = "released",
        motion = "motion",
        wheel = "wheel"
    }

    Vec2d _point;
    uint _button;
    uint _clickCount;
    uint _time;
    Vec2d _scrollDelta;

    public static MouseEvent pressed(in Vec2d point, uint button, uint clickCount, uint time)
    {
        auto e = new MouseEvent(Name.pressed);
        e._point = point;
        e._button = button;
        e._clickCount = clickCount;
        e._time = time;
        e._scrollDelta = Vec2d.zero;
        return e;
    }

    public static MouseEvent released(in Vec2d point, uint button, uint clickCount, uint time)
    {
        auto e = new MouseEvent(Name.released);
        e._point = point;
        e._button = button;
        e._clickCount = clickCount;
        e._time = time;
        e._scrollDelta = Vec2d.zero;
        return e;
    }

    public static MouseEvent motion(in Vec2d point, uint button, uint clickCount, uint time)
    {
        auto e = new MouseEvent(Name.motion);
        e._point = point;
        e._button = button;
        e._clickCount = clickCount;
        e._time = time;
        e._scrollDelta = Vec2d.zero;
        return e;
    }

    public static MouseEvent wheel(in Vec2d point, uint button, uint clickCount, uint time, in Vec2d scrollDelta)
    {
        auto e = new MouseEvent(Name.wheel);
        e._point = point;
        e._button = button;
        e._clickCount = clickCount;
        e._time = time;
        e._scrollDelta = scrollDelta;
        return e;
    }

    this(Name n)
    {
        super(n);
    }

    final Vec2d point() const
    {
        return _point;
    }

    final double pointX() const
    {
        return _point.x;
    }

    final double pointY() const
    {
        return _point.y;
    }

    final uint button() const
    {
        return _button;
    }

    final uint time() const
    {
        return _time;
    }

    final Vec2d scrollDelta() const
    {
        return _scrollDelta;
    }

    final double scrollDeltaX() const
    {
        return _scrollDelta.x;
    }

    final double scrollDeltaY() const
    {
        return scrollDelta.y;
    }

    final bool isPressed() const
    {
        return name == Name.pressed;
    }

    final bool isReleased() const
    {
        return name == Name.released;
    }

    final bool isMotion() const
    {
        return name == Name.motion;
    }

    final bool isWheel() const
    {
        return name == Name.wheel;
    }
}
