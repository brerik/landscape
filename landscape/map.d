/*
 * Landscape Filesystem Browser
 * Copyright (C) 2013-2014 Erik Wikforss
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
import landscape.nodes.node;
import landscape.nodes.dirgroup;
import brew.insets;
import brew.box;
import brew.vec;
import brew.dim;
import brew.misc;
import brew.math;
import brew.color;
import brew.cairo;
import glogg.gdk;
import gtk.MainWindow;
import gtk.AboutDialog;
import gtk.Label;
import gtk.Button;
import gtk.Box;
import gtk.Main;
import gtk.Widget;
import gtk.Layout;
import gtk.Scrollbar;
import gtk.Adjustment;
import gtk.ScrolledWindow;
import gtk.DrawingArea;
import gdk.DragContext;
import gdk.Event;
import gio.FileEnumerator;
import gio.File;
import gtkc.pangotypes;
import gtkc.gtktypes;
import gtkc.giotypes;
import gtkc.cairotypes;
import cairo.Context;
import cairo.FontOption;
import cairo.Surface;
import pango.PgContext;
import std.stdio;

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
    alias gio.File.File GioFile;
    static immutable SCALE_BOUNDS = Interval!double(0.2, 2.0);
    static immutable SCALE_GRANULARITY = 0.1;
    static immutable INSETS = Insets2d(400,400,400,400);
    static immutable BG_COLOR = Color4d(0.9, 0.9, 0.9, 1.0);
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
    Surface surface;


    this()
    {
        super();
        bounds = Box2d.zero;
        bgColor = BG_COLOR;
        addOnButtonPress(&onMouseButtonPress);
        addOnButtonRelease(&onMouseButtonRelease);
        addOnMotionNotify(&onMouseMotion);
        addOnScroll(&onMouseScroll);
        addOnDraw(&onDrawCb);
        addOnConfigure(&onConfigureEventCb);
        addOnDestroy(&onDestroyCb);
        root = new Root();
        addRoot(buildDir(GioFile.parseName("~")));
        cleanUp();
    }

    final void clearSurface()
    {
        assert (surface);
        Context cr = Context.create(surface);
        setSourceRgba(cr, bgColor);
        cr.paint();
        delete cr;
    }

    final bool onConfigureEventCb(Event ev, Widget wt)
    {
      if (surface)
        surface.destroy();

      surface = new Surface(getWindow(), CairoContent.COLOR, getAllocatedWidth(), getAllocatedHeight());
      clearSurface();
      return true;
    }

    final bool onDrawCb(Context cr, Widget wt)
    {
        drawMap();
        cr.setSourceSurface(surface, 0, 0);
        cr.paint();
        return false;
    }

    final void drawMap()
    {
        cleanUp();
        Context cr = Context.create(surface);
        setSourceRgba(cr, bgColor);
        cr.paint();
        cr.translate(Mathd.floor(offset.x), Mathd.floor(offset.y));
        if (scale != 1.0)
            cr.scale(scale, scale);
        root.doPaint(cr);
        delete cr;
    }

    final void onDestroyCb(Widget wt)
    {
        if (surface)
            surface.destroy();
        surface = null;
    }

    final DirGroup buildDir(GioFile f)
    {
        DirGroup n = new DirGroup(f);
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
                c.offset.y = next - c.totalBounds.top + m;
                m = 50;
                next = next + c.totalBounds.height;
            }
            updateTotalBounds();
        }
    }
}


