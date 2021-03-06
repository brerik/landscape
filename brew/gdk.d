/*
 * Brew Library by erik wikforss
 */
module brew.gdk;
import brew.color;
import brew.vec;
import gdk.RGBA;
import gdk.Event;
import gtkc.gdktypes;

RGBA toRGBA(in Color4d c)                                   { return new RGBA(c.tupleof); }
RGBA toRGBA(in Color3d c)                                   { return new RGBA(c.tupleof, 1.0); }
RGBA toRGBA(in Color4f c)                                   { return new RGBA(c.tupleof); }
RGBA toRGBA(in Color3f c)                                   { return new RGBA(c.tupleof, 1.0); }

/**
 * Gets scroll deltas or Vec2d.nan if fail
 */
Vec2d getScrollDeltas(Event ev) {
    ScrollDirection sd;
    if (ev.getScrollDirection(sd)) {
        switch (sd) {
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
Vec2d getRootCoords(Event ev) {
    Vec2d c;
    return ev.getRootCoords(c.x, c.y) ? c : Vec2d.nan;
}

/**
 * Gets coords or Vec2d.nan if fail
 */
Vec2d getCoords(Event ev) {
    Vec2d c;
    return ev.getCoords(c.x, c.y) ? c : Vec2d.nan;
}

/**
 * Gets click count
 */
uint getClickCount(Event ev) {
    uint c;
    return ev.getClickCount(c) ? c : 0;
}

/**
 * Gets button
 */
uint getButton(Event ev) {
    uint b = 0u;
    return ev.getButton(b) ? b : 0;
}

/**
 * Gets modifier state or empty(0) if no state
 */
ModifierType getState(Event ev) {
    ModifierType m;
    return ev.getState(m) ? m : cast(ModifierType)0;
}



