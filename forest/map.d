/*
 * Forest File Finder by erik wikforss
 */
module forest.map;
import forest.nodes.node;
import forest.nodes.rootnode;
import forest.nodes.dir.dirnode;
import forest.nodes.framenode;
import forest.selection;
import brew.insets;
import brew.box;
import brew.vec;
import brew.dim;
import brew.misc;
import brew.math;
import brew.color;
import brew.cairo;
import brew.gdk;
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
import core.memory;

class Map : DrawingArea {
    alias gio.File.File GioFile;
    enum {
        SCALE_INTERVAL = Intervald(0.2, 2.0),
        SCALE_GRANULARITY = 0.1,
        MAP_INSETS = Insets2d(400,400,400,400),
        BG_COLOR = Color4d(0.25, 0.25, 0.25, 1.0),
    }

    private {
        Adjustment hAdj;
        Adjustment vAdj;
        Vec2d oldMouseCoords = Vec2d.zero;
        double _scale = 1.0;
        bool pressed;
        Box2d bounds;
        Root root;
        bool layoutDirty;
        bool boundsDirty;
        Color4d bgColor;
        Vec2d offset = Vec2d.zero;
        Surface surface;
        Selection _selection;
    }

    this() {
        super();
        bounds = Box2d.zero;
        bgColor = BG_COLOR;
        _selection = new Selection();
        addOnButtonPress(&onMouseButtonPress);
        addOnButtonRelease(&onMouseButtonRelease);
        addOnMotionNotify(&onMouseMotion);
        addOnScroll(&onMouseScroll);
        addOnDraw(&onDrawCb);
        addOnConfigure(&onConfigureEventCb);
        addOnDestroy(&onDestroyCb);
        root = new Root();
        void tryAddDirectory(string p) {
            try {
                addDirectory(p);
            } catch (Throwable e) {
                writefln(e.toString);
            }
        }
        tryAddDirectory("~");
        tryAddDirectory("dkfnfkj");
        tryAddDirectory("/media/erik/761a34b8-3278-45be-aeac-95eeefd205ff/home");

        cleanUp();
    }

    final void addDirectory(string dirPath)
    in {
        assert (dirPath !is null);
    } body {
        auto file = GioFile.parseName(dirPath);
        if (file !is null)
            addDirectory(file);
        else
            throw new Exception("parsed filename result was null");
    }

    final void addDirectory(GioFile file)
    in {
        assert (file !is null);
    } body {
        addRoot(buildDir(file, _selection));
    }

    final void clearSurface() {
        assert (surface);
        Context cr = Context.create(surface);
        setSourceRgba(cr, bgColor);
        cr.paint();
        delete cr;
    }

    final bool onConfigureEventCb(Event ev, Widget wt) {
        if (surface)
            surface.destroy();
        surface = new Surface(getWindow(), CairoContent.COLOR, getAllocatedWidth(), getAllocatedHeight());
        clearSurface();
        return true;
    }

    final bool onDrawCb(Context cr, Widget wt) {
        drawMap();
        cr.setSourceSurface(surface, 0, 0);
        cr.paint();
        GC.collect;
        return false;
    }

    final void drawMap() {
        cleanUp();
        Context cr = Context.create(surface);
        setSourceRgba(cr, bgColor);
        cr.paint();
        cr.translate(Mathd.floor(offset.x), Mathd.floor(offset.y));
        if (scale != 1.0)
            cr.scale(scale, scale);
        root.draw(cr);
        delete cr;
    }

    final void onDestroyCb(Widget wt) {
        if (surface)
            surface.destroy();
        surface = null;
    }

    final DirNode buildDir(GioFile f, Selection s) {
        DirNode n = new DirNode(f, s);
        n.importAllChildren(2);
        return n;
    }

    final bool onMouseButtonPress(Event ev, Widget wt) {
        oldMouseCoords = getRootCoords(ev);
        pressed = true;
        uint clickCount;
        Vec2d coords;
        ev.getCoords(coords.x, coords.y);
        ev.getClickCount(clickCount);
        root.dispatchMouseButtonPressed((coords-offset)/scale, clickCount);
        return true;
    }

    final bool onMouseButtonRelease(Event ev, Widget wt) {
        pressed = false;
        Vec2d coords = getCoords(ev);
        uint clickCount = getClickCount(ev);
        if (coords != Vec2d.nan && !root.dispatchMouseButtonReleased((coords-offset)/scale, clickCount))
            handleMouseButtonReleased(coords, clickCount);
        return true;
    }

    final void handleMouseButtonReleased(Vec2d coords, uint clickCount) {
        _selection.clear();
    }

    final bool onMouseMotion(Event ev, Widget wt) {
        Vec2d newMouseCoords = getRootCoords(ev);
        if (pressed && newMouseCoords != Vec2d.nan) {
            offset += newMouseCoords - oldMouseCoords;
            oldMouseCoords = newMouseCoords;
            queueDraw();
        } else {
            Vec2d coords = getCoords(ev);
            if (coords != Vec2d.nan)
                root.dispatchMouseMotion((coords-offset)/scale);
        }
        return true;
    }

    final bool onMouseScroll(Event ev, Widget w) {
        ModifierType mod;
        int res = ev.getState(mod);
        if (res && mod & ModifierType.CONTROL_MASK) {
            Vec2d d = getScrollDeltas(ev);
            if (d != Vec2d.nan) {
                scale = scale * (1 + (0.1 * d.y));
                queueDraw();
                return true;
            }
        }
        return false;
    }

    final double scale() const {
        return _scale;
    }

    final void scale(double aScale) {
        double newScale = clampRoundScale(aScale);
        if (newScale != _scale) {
            double oldScale = _scale;
            _scale = newScale;
            scaleChanged(newScale, oldScale);
        }
    }

    final double clampRoundScale(double aScale) {
        return clampScale(roundScale(aScale));
    }

    final double clampScale(double aScale) {
        return SCALE_INTERVAL.clamp(aScale);
    }

    final double roundScale(double aScale) {
        return Mathd.round(aScale, SCALE_GRANULARITY);
    }

    final void scaleChanged(double newScale, double oldScale) {
        setDirty();
    }

    final void addRoot(Node node) {
        root.addChild(node);
    }

    final void cleanUp() {
        if (isDirty) {
            root.cleanUp();
            updateBounds();
            layoutDirty = layoutDirty = false;
        }
    }

    final void updateBounds() {
        Box2d ttb = root.totalBounds * scale + MAP_INSETS;
        root.offset = -ttb.pos;
        root.updateTotalBounds();
        bounds = root.transformedTotalBounds / scale + MAP_INSETS;
    }

    final void setLayoutDirty() {
        layoutDirty = true;
        queueDraw();
    }

    final void setBoundsDirty() {
        boundsDirty = true;
    }

    final void setDirty() {
        layoutDirty = boundsDirty = true;
    }

    final bool isDirty() {
        return layoutDirty || boundsDirty || root.isDirty;
    }

//    final Box2d getAdjustments()
//    {
//        Box2d vis = Box2d(offset.x, offset.y, getWidth() / scale, getHeight() / scale);
//        Box2d tot = root.transformedTotalBounds / scale + MAP_INSETS;
//    }

    class Root : RootNode {
        override void redraw() {
            queueDraw();
        }
    }
}


