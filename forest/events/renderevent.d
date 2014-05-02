/*
 * Forest File Finder by erik wikforss
 */
module forest.events.renderevent;
import forest.events.event;
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

