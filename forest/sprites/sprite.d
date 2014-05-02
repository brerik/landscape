/*
 * Forest File Finder by erik wikforss
 */
module forest.sprites.sprite;
import forest.events.renderevent;
import forest.events.mouseevent;
import forest.events.updateevent;
import forest.events.event;
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
