/*
 * Forest File Finder by erik wikforss
 */
module forest.events.mouseevent;
import forest.events.event;
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
