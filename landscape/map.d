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
module landscape.map;
private import landscape.nodes.node;
private import landscape.nodes.dirgroup;
private import brew.insets;
private import brew.box;
private import brew.vec;
private import brew.dim;
private import brew.misc;
private import brew.math;
private import brew.color;
private import glogg.gdk;
private import gtk.MainWindow;
private import gtk.AboutDialog;
private import gtk.Label;
private import gtk.Button;
private import gtk.Box;
private import gtk.Main;
private import gtk.Widget;
private import gtk.Layout;
private import gtk.Scrollbar;
private import gtk.Adjustment;
private import gtk.ScrolledWindow;
private import gtk.DrawingArea;
private import gdk.DragContext;
private import gdk.Event;
private import gio.FileEnumerator;
private import gio.File;
private import gtkc.pangotypes;
private import gtkc.gtktypes;
private import gtkc.giotypes;
private import cairo.Context;
private import cairo.FontOption;
private import pango.PgContext;
private import std.stdio;

struct FsUtil
{
    static Vec2d getScrollDeltas(Event ev)
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
        return Vec2d.zero;
    }
}

class Map : DrawingArea
{
    alias gio.File.File GFile;
    static immutable SCALE_BOUNDS = Interval!double(0.2, 2.0);
    static immutable SCALE_GRANULARITY = 0.1;
    static immutable INSETS = Insets2d(400,400,400,400);
    Adjustment hAdj, vAdj;
    private Vec2d oldMouseCoords = Vec2d.zero;
    double mScale = 1.0;
    bool pressed;
    Box2d bounds;
    Root root;
    bool layoutDirty;
    bool boundsDirty;
    Color4d bgColor;
    Vec2d offset = Vec2d.zero;
    this()
    {
        super();
        bounds = Box2d.zero;
        bgColor = Color4d(.9,.9,.9);
        overrideBackgroundColor(StateFlags.NORMAL, GloggGtk.toRGBA(bgColor));
        addOnButtonPress(&onMouseButtonPress);
        addOnButtonRelease(&onMouseButtonRelease);
        addOnMotionNotify(&onMouseMotion);
        addOnScroll(&onMouseScroll);
        addOnDraw(&onMyDraw);
        root = new Root();
        addRoot(buildDir("/home/erik"));
//        addRoot(buildDir("C:\\D\\projects"));
//        addRoot(buildDir("C:\\"));
//        addRoot(buildDir("G:\\"));
        cleanUp();
    }

    final bool onMyDraw(Context ct, Widget wgt)
    {
        cleanUp();
        ct.translate(Mathd.floor(offset.x), Mathd.floor(offset.y));
        if (scale != 1.0)
            ct.scale(scale, scale);
        doPaint(ct);

        ct.newPath();
        import core.memory;
        GC.collect();
        return false;
    }

    final DirGroup buildDir(string path)
    {
        DirGroup n = new DirGroup(new GFile(path));
        n.importAllChildren(2);
        return n;
    }

    final bool onMouseButtonPress(Event ev, Widget wt)
    {
        ev.getRootCoords(oldMouseCoords.x, oldMouseCoords.y);

        pressed = true;
        uint clickCount;
        Vec2d coords;
        ev.getCoords(coords.x, coords.y);
        ev.getClickCount(clickCount);
        root.dispatchMouseButtonPressed((coords-offset)/scale, clickCount);
//        writefln("onMouseButtonPress coords(%f,%f)", coords.x, coords.y);

        return true;
    }

    final bool onMouseButtonRelease(Event ev, Widget wt)
    {
        //writefln("onMouseButtonRelease");
        pressed = false;
        Vec2d coords;
        uint clickCount;
        ev.getCoords(coords.x, coords.y);
        ev.getClickCount(clickCount);
        root.dispatchMouseButtonReleased((coords-offset)/scale, clickCount);
        return true;
    }

    final bool onMouseMotion(Event ev, Widget wt)
    {
        //writefln("onMouseMotion");
        Vec2d newMouseCoords;
        if (pressed && 0 != ev.getRootCoords(newMouseCoords.x, newMouseCoords.y))
        {
            offset += newMouseCoords - oldMouseCoords;
            oldMouseCoords = newMouseCoords;
            queueDraw();
        }
        else
        {
            Vec2d coords;
            ev.getCoords(coords.x, coords.y);
            root.dispatchMouseMotion((coords-offset)/scale);
        }
        return true;
    }

    final bool onMouseScroll(Event ev, Widget w)
    {
        ModifierType mod;
        int res = ev.getState(mod);
        if (res && mod & ModifierType.CONTROL_MASK)
        {
            Vec2d d = FsUtil.getScrollDeltas(ev);
            scale = scale * (1 + (0.1 * d.y));
            queueDraw();
            return true;
        }
        return false;
    }

    final double scale() const
    {
        return mScale;
    }

    final void scale(double aScale)
    {
        double newScale = SCALE_BOUNDS.clamp(Mathd.round(aScale, SCALE_GRANULARITY));
        if (newScale != mScale)
        {
            double oldScale = mScale;
            mScale = newScale;
            scaleChanged(oldScale, newScale);
        }
    }

    void scaleChanged(double oldScale, double newScale)
    {
        setDirty();
    }

    final void addRoot(Node node)
    {
        root.addChild(node);
    }

    final void doPaint(Context ct)
    {
        root.doPaint(ct);
    }

    final void cleanUp()
    {
        if (isDirty)
        {
            root.cleanUp();
            updateBounds();
            layoutDirty = layoutDirty = false;
        }
    }

    final void updateBounds()
    {
        Box2d ttb = root.totalBounds * scale + INSETS;
        root.offset = -ttb.pos;
        root.updateTotalBounds();
        bounds = root.transformedTotalBounds / scale + INSETS;
//        setSize(cast(int)(ttb.width), cast(int)(ttb.height));
    }

    final void setLayoutDirty()
    {
        layoutDirty = true;
        queueDraw();
    }

    final void setBoundsDirty()
    {
        boundsDirty = true;
    }

    final void setDirty()
    {
        layoutDirty = boundsDirty = true;
    }

    final bool isDirty()
    {
        return layoutDirty || boundsDirty || root.isDirty;
    }

//    final Box2d getAdjustments()
//    {
//        Box2d vis = Box2d(offset.x, offset.y, getWidth() / scale, getHeight() / scale);
//        Box2d tot = root.transformedTotalBounds / scale + INSETS;
//    }

    class Root : Node
    {
        override void redraw()
        {
            queueDraw();
        }
        override void updateLayout()
        {
            double next = 0;
            double m = 0;
            foreach(Node c; visibleChildren)
            {
                c.updateTotalBounds();
                c.offsetY = next - c.totalBounds.top + m;
                m = 50;
                next = next + c.totalBounds.height;
            }
            updateTotalBounds();
        }
    }
}


