/*
 * Forest File Finder by erik wikforss
 */
module forest.nodes.node;
import forest.selection;
import brew.math;
public import brew.box;
public import brew.dim;
public import brew.vec;
public import brew.insets;
public import brew.color;
import brew.cairo;
import brew.tween;
import brew.fun;
import brew.misc;
import forest.map;
import std.stdio;
import pango.PgContext;
import cairo.Context;
import std.signals;
import forest.events.mouseevent;
import gtkc.gdktypes;

struct NodeColor {
    Color4d fgColor = Color4d.BLACK;
    Color4d bgColor = Color4d.WHITE;
}
struct NodeDim {
    Dim2d min = Dim2d.zero;
    Dim2d max = Dim2d.zero;
    Dim2d pref = Dim2d.zero;
    Dim2d fit = Dim2d.zero;
}

class Node {
    enum PropName : string {
        selected = "selected",
        pressed = "pressed",
        visible = "visible",
        fgColor = "fgColor",
        bgColor = "bgColor",
        insets = "insets",
        offset = "offset",
        alignment = "alignment",
        layer = "layer",
        animated = "animated",
        margin = "margin",
        animOffset = "animOffset",
        animBounds = "animBounds",
        bounds = "bounds",
        totalBounds = "totalBounds",
        name = "name",
        minDim = "minDim",
        maxDim = "maxDim",
        prefDim = "prefDim",
        fitDim = "fitDim",
        selection = "selection",
    }

    enum {
        DEFAULT_COLOR = NodeColor(Color4d(.2,.2,.2,1), Color4d(.9,.9,.9,1)),
        LAYOUT_ALL = -1,
        NO_DIM = Dim2d.zero,
        NO_INSETS = Insets2d.zero,
        NO_MARGIN = Insets2d.zero,
        DEFAULT_LAYER = 0,
    }

    private {
        string _name;
        NodeDim _dim;
        Box2d _bounds = Box2d.zero;
        Box2d _animBounds = Box2d.zero;
        Box2d _totalBounds = Box2d.zero;
        Insets2d _margin = NO_MARGIN;
        Insets2d _insets = NO_INSETS;
        NodeColor _color = DEFAULT_COLOR;
        Node _parent;
        Node[] _children;
        bool boundsDirty;
        bool layoutDirty;
        bool totalBoundsDirty;
        bool _visible;
        bool showChildren;
        bool isPaintTotalBounds;
        bool isPaintBounds;
        bool _selected;
        bool _pressed;
        bool _animated;
        int _layer = DEFAULT_LAYER;
        Vec2d _offset = Vec2d.zero;
        Vec2d _animOffset = Vec2d.zero;
        Vec2d _alignment = Vec2d.zero;
        Selection _selection;
    }

    bool delegate(in Vec2d, in GdkEventButton) onMousePressedDlgs[];
    bool delegate(in Vec2d, in GdkEventButton) onMouseReleasedDlgs[];
    bool delegate(in Vec2d, in GdkEventMotion) onMouseMotionDlgs[];

    // property name, new value, old value
    mixin Signal!(string, bool, bool)           changedBoolSignal;
    mixin Signal!(string, double, double)       changedDoubleSignal;
    mixin Signal!(string, string, string)       changedStringSignal;
    mixin Signal!(string, int, int)             changedIntSignal;
    mixin Signal!(string, Color4d, Color4d)     changedColor4dSignal;
    mixin Signal!(string, Insets2d, Insets2d)   changedInsets2dSignal;
    mixin Signal!(string, Vec2d, Vec2d)         changedVector2dSignal;
    mixin Signal!(string, Box2d, Box2d)         changedBox2dSignal;
    mixin Signal!(string, Dim2d, Dim2d)         changedDim2dSignal;
    mixin Signal!(MouseEvent)                   mouseEventSignal;
    mixin Signal!(string, Object, Object)       objectSignal;

    final {
        /***************************
         * @param s: Signal Slot   *
         * @param p: Property Name *
         * @param n: New Value     *
         * @param o: Old Value     */
        void connect(changedBoolSignal.slot_t s)            { changedBoolSignal.connect(s); }
        void disconnect(changedBoolSignal.slot_t s)         { changedBoolSignal.disconnect(s); }
        void emit(string p, bool n, bool o)                 { changedBoolSignal.emit(p, n, o); }
        void connect(changedDoubleSignal.slot_t s)          { changedDoubleSignal.connect(s); }
        void disconnect(changedDoubleSignal.slot_t s)       { changedDoubleSignal.disconnect(s); }
        void emit(string p, double n, double o)             { changedDoubleSignal.emit(p, n, o); }
        void connect(changedStringSignal.slot_t s)          { changedStringSignal.connect(s); }
        void disconnect(changedStringSignal.slot_t s)       { changedStringSignal.disconnect(s); }
        void emit(string p, string n, string o)             { changedStringSignal.emit(p, n, o); }
        void connect(changedIntSignal.slot_t s)             { changedIntSignal.connect(s); }
        void disconnect(changedIntSignal.slot_t s)          { changedIntSignal.disconnect(s); }
        void emit(string p, int n, int o)                   { changedIntSignal.emit(p, n, o); }
        void connect(changedColor4dSignal.slot_t s)         { changedColor4dSignal.connect(s); }
        void disconnect(changedColor4dSignal.slot_t s)      { changedColor4dSignal.disconnect(s); }
        void emit(string p, in Color4d n, in Color4d o)     { changedColor4dSignal.emit(p, n, o); }
        void connect(changedInsets2dSignal.slot_t s)        { changedInsets2dSignal.connect(s); }
        void disconnect(changedInsets2dSignal.slot_t s)     { changedInsets2dSignal.disconnect(s); }
        void emit(string p, in Insets2d n, in Insets2d o)   { changedInsets2dSignal.emit(p, n, o); }
        void connect(changedVector2dSignal.slot_t s)        { changedVector2dSignal.connect(s); }
        void disconnect(changedVector2dSignal.slot_t s)     { changedVector2dSignal.disconnect(s); }
        void emit(string p, in Vec2d n, in Vec2d o)         { changedVector2dSignal.emit(p, n, o); }
        void connect(changedBox2dSignal.slot_t s)           { changedBox2dSignal.connect(s); }
        void disconnect(changedBox2dSignal.slot_t s)        { changedBox2dSignal.disconnect(s); }
        void emit(string p, in Box2d n, in Box2d o)         { changedBox2dSignal.emit(p, n, o); }
        void connect(changedDim2dSignal.slot_t s)           { changedDim2dSignal.connect(s); }
        void disconnect(changedDim2dSignal.slot_t s)        { changedDim2dSignal.disconnect(s); }
        void emit(string p, in Dim2d n, in Dim2d o)         { changedDim2dSignal.emit(p, n, o); }
        void connect(objectSignal.slot_t s)                 { objectSignal.connect(s); }
        void disconnect(objectSignal.slot_t s)              { objectSignal.disconnect(s); }
        void emit(string p, Object n, Object o)             { objectSignal.emit(p, n, o); }
        void connect(mouseEventSignal.slot_t s)             { mouseEventSignal.connect(s); }
        void disconnect(mouseEventSignal.slot_t s)          { mouseEventSignal.disconnect(s); }
        void emit(MouseEvent s)                             { mouseEventSignal.emit(s); }
    }

    this() {
        visible = true;
        layer = 0;
        isPaintTotalBounds = false;
        isPaintBounds = false;
    }

    void dispose() {
        foreach (Node child; children)
            child.dispose();
        if (parent !is null)
            parent.removeChild(this);
    }

    void addChild(Node child) {
        if (child.parent is this)
            return;
        if (child.parent !is null)
            child.parent.removeChild(child);
        child.parent = this;
        children ~= child;
        setDirty();
    }

    void addChild(Node child, string target) {
        foreach (Node n; children) {
            if (n.name == target) {
                n.addChild(child);
                return;
            }
        }
    }

    final void addOnMouseMotionDlg(bool delegate(in Vec2d, in GdkEventMotion) dlg) {
        onMouseMotionDlgs ~= dlg;
    }

    final void addOnMousePressedDlg(bool delegate(in Vec2d, in GdkEventButton) dlg) {
        onMousePressedDlgs ~= dlg;
    }

    final void addOnMouseReleasedDlg(bool delegate(in Vec2d, in GdkEventButton) dlg) {
        onMouseReleasedDlgs ~= dlg;
    }

    void removeChild(Node child) {
        if (child.parent !is this)
            return;
        bool removed = false;
        for (int i = 0; i < children.length && !removed; i++) {
            if (children[i] is child) {
                children[i] = children[$-1];
                children.length--;
                removed = true;
                setDirty();
            }
        }
    }

    const(string) path() {
        string a = name;
        if (parent is null)
            return name ~ "\\";
        for (Node p = parent; p !is null; p = p.parent)
            a = p.name ~ "\\" ~ a;
        return a;
    }

    void updateBounds() {
    }

    void onLayout() {
        preUpdateLayout();
        updateChildredLayout();
        updateLayout();
        updateDim();
        cleanTotalBounds();
        postUpdateLayout();
    }

    void preUpdateLayout() {
    }

    void updateLayout() {
    }

    void updateChildredLayout() {
        foreach (Node child; children)
            child.onLayout();
    }

    void postUpdateLayout() {
    }

    void updateDim() {
        Dim2d newDim = bounds.dim;

        static bool accept(double a) { return a > 0; }

        if (prefDim.width > 0)
            newDim.width = prefDim.width;
        else if (fitDim.width > 0)
            newDim.width = fitDim.width;

        if (prefDim.height > 0)
            newDim.height = prefDim.height;
        else if (fitDim.height > 0)
            newDim.height = fitDim.height;

        newDim = newDim.clampAccept(minDim, maxDim, &accept);

        bounds.dim = newDim;
    }

    final const(Box2d) computeBounds() {
        Box2d b = Box2d.zero;
        foreach(Node child; shownChildren)
            b = b.unionWith(child.transformedBounds);
        return b;
    }

    final const(Box2d) computeTotalBounds(Box2d startBounds = Box2d(0,0,0,0)) {
        Box2d b = startBounds;
        foreach(Node child; shownChildren)
            b = b.unionWith(child.transformedTotalBounds);
        return b;
    }

    final const(Box2d) transformedTotalBounds() const {
        return totalBounds.translated(offset);
    }

    final const(Box2d) transformedBounds() const {
        return bounds.translated(offset);
    }

    final void updateTotalBounds() {
        Box2d b = bounds;
        foreach (Node child; visibleChildren)
            b = Box2d.unionOf(b, child.transformedTotalBounds);
        totalBounds = b;
    }

    void cleanLayout() {
        if (layoutDirty) {
            foreach (Node c; children)
                c.cleanLayout();
            onLayout();
            layoutDirty = false;
        }
    }

    void cleanBounds() {
        if(boundsDirty) {
            foreach (Node child; children)
                child.cleanBounds();
            updateBounds();
            boundsDirty = false;
        }
    }

    void cleanTotalBounds() {
        if(totalBoundsDirty) {
            foreach (Node child; children)
                child.cleanTotalBounds();
            updateTotalBounds();
            totalBoundsDirty = false;
        }
    }

    void cleanUp() {
        cleanLayout();
        cleanBounds();
        cleanTotalBounds();
    }

    void draw(Context ct) {
        if (visible) {
            ct.save();
            auto o = offset.roundVec;
            if (o != Vec2d.zero)
                ct.translate(o.x, o.y);
            if (isShown)
                drawNode(ct);
            drawChildren(ct);
            if (isPaintBounds)
                drawBounds(ct);
            if (isPaintTotalBounds)
                drawTotalBounds(ct);
            ct.restore();
        }
    }

    void drawNode(Context ct) {
    }

    void drawChildren(Context ct) {
        foreach (Node n; children)
            n.draw(ct);
    }

    final bool isRoot() {
        return _parent is null;
    }

    final bool isChild() {
        return _parent !is null;
    }

    final bool hasParent() {
        return _parent !is null;
    }

    final bool hasChildren() {
        return _children.length > 0;
    }

    final size_t numChildren() {
        return _children.length;
    }

    final Node childAt(size_t i) {
        return _children[i];
    }

    final void moveTo(Vec2d newOffset) {
        if (newOffset != bounds.pos) {
            offset = newOffset;
            setParentBoundsDirty();
        }
    }

    final void moveBy(Vec2d amount) {
        if (amount != Vec2d.zero) {
            offset = offset + amount;
            setParentBoundsDirty();
        }
    }

    const(Vec2d) tailPoint(Vec2d alignment) {
        return bounds.alignedPoint(alignment);
    }

    final void resizeTo(in Dim2d newSize) {
        if (newSize != bounds.dim) {
            bounds.dim = newSize;
            setParentBoundsDirty();
        }
    }

    final void setDirty() {
        boundsDirty = layoutDirty = totalBoundsDirty = true;
        if (hasParent)
            parent.setDirty();
    }

    final void setParentDirty() {
        if (hasParent)
            parent.setDirty();
    }

    final void setBoundsDirty() {
        boundsDirty = totalBoundsDirty = true;
        if (hasParent)
            parent.setBoundsDirty();
    }

    final void setTotalBoundsDirty() {
        totalBoundsDirty = true;
        if (hasParent)
            parent.setTotalBoundsDirty();
    }

    final void setParentBoundsDirty() {
        if (hasParent)
            parent.setBoundsDirty();
    }

    final void setLayoutDirty() {
        layoutDirty = true;
        if (hasParent)
            parent.setLayoutDirty();
    }

    final void setParentLayoutDirty() {
        if (hasParent)
            parent.setLayoutDirty();
    }

    final bool isDirty() {
        return boundsDirty || layoutDirty || totalBoundsDirty;
    }

    final const(Box2d) absBounds() {
        Box2d a = bounds;
        for (Node p = parent; p !is null; p = p.parent)
            a += p.bounds.pos;
        return a;
    }

    final bool dispatchMouseButtonPressed(in Vec2d point0, in GdkEventButton e) {
        auto point = (point0 - offset);
        if (totalBounds.pointIn(point))
            for(size_t i = _children.length-1; i < children.length; i--)
                if (_children[i].visible && _children[i].dispatchMouseButtonPressed(point, e))
                    return true;
        if (bounds.pointIn(point) && notifyMouseButtonPressed(point, e))
            return true;
        return false;
    }

    final bool notifyMouseButtonPressed(in Vec2d point, in GdkEventButton e) {
        for (size_t i = 0; i < onMousePressedDlgs.length; i++)
            if (onMousePressedDlgs[i](point, e))
                return true;
        return false;
    }

    final bool dispatchMouseButtonReleased(in Vec2d point0, in GdkEventButton e) {
        auto point = (point0 - offset);
        if (totalBounds.pointIn(point))
            for(size_t i = _children.length-1; i < children.length; i--)
                if (_children[i].visible && _children[i].dispatchMouseButtonReleased(point, e))
                    return true;
        if (bounds.pointIn(point) && notifyMouseButtonReleased(point, e))
            return true;
        return false;
    }

    final bool notifyMouseButtonReleased(in Vec2d point, in GdkEventButton e) {
        for (size_t i = 0; i < onMouseReleasedDlgs.length; i++)
            if (onMouseReleasedDlgs[i](point, e))
                return true;
        return false;
    }

    final bool dispatchMouseMotion(in Vec2d point0, in GdkEventMotion e) {
        auto point = (point0 - offset);
        if (totalBounds.pointIn(point))
            for(size_t i = _children.length-1; i < children.length; i--)
                if (_children[i].visible && _children[i].dispatchMouseMotion(point, e))
                    return true;
        if (bounds.pointIn(point) && notifyMouseMotion(point, e))
            return true;
        return false;
    }

    final bool notifyMouseMotion(in Vec2d point, in GdkEventMotion e) {
        for (size_t i = 0; i < onMouseMotionDlgs.length; i++)
            if (onMouseMotionDlgs[i](point, e))
                return true;
        return false;
    }

    final void show() {
        if (!visible) {
            visible = true;
            setDirty();
        }
    }

    final void hide() {
        if (visible) {
            visible = false;
            setDirty();
        }
    }

    final const(Box2d) marginBounds() const {
        return bounds + margin;
    }

    final const(Box2d) insetBounds() const {
        return bounds - insets;
    }

    final void drawBounds(Context ct) {
        rectangleInside(ct, bounds);
        ct.setLineWidth(2.0);
        setSourceRgb(ct, Color3d.RED);
        ct.stroke();
    }

    final void drawTotalBounds(Context ct) {
        rectangleInside(ct, totalBounds);
        ct.setLineWidth(2.0);
        setSourceRgb(ct, Color3d.GREEN);
        ct.stroke();
    }

    final void drawFitBounds(Context ct) {
        rectangleInside(ct, bounds.withDim(fitDim));
        ct.setLineWidth(1.0);
        setSourceRgb(ct, Color3d.MAGENTA);
        ct.stroke();
    }

    alias Filter!(Node).filter filterNode;

    final Node[] visibleChildren() {
        return visibleNodesOf(children);
    }

    final Node[] shownChildren() {
        return shownNodesOf(children);
    }

    static Node[] visibleNodesOf(Node nodes[]) {
        static bool accept(Node n) {
            return n.visible;
        }
        return filterNode(nodes, &accept);
    }

    static Node[] shownNodesOf(Node nodes[])
    {
        static bool accept(Node n) {
            return n.isShown;
        }
        return filterNode(nodes, &accept);
    }

    void redraw() {
        if (hasParent)
            parent.redraw();
    }

    final const(uint) level() {
        uint l = 0;
        for (Node p = parent; p !is null; p = p.parent)
            l++;
        return l;
    }

    final ref const(Vec2d) offset() const {
        return _offset;
    }

    final ref Vec2d offset() {
        return _offset;
    }

    final void offset(in Vec2d newOffset) {
        if (newOffset != _offset) {
            auto oldOffset = _offset;
            _offset = newOffset;
            emit(PropName.offset, newOffset, oldOffset);
        }
    }

    final bool isShown() const {
        return visible && bounds.width > 0 && bounds.height > 0;
    }

    final void selected(bool b) {
        if (_selected != b) {
            _selected = b;
            emit(PropName.selected, b, !b);
        }
    }

    final bool selected() const {
        return _selected;
    }

    final void visible(bool b) {
        if (_visible != b) {
            _visible = b;
            emit(PropName.visible, b, !b);
        }
    }

    final bool visible() const {
        return _visible;
    }

    final void pressed(bool b) {
        if (_pressed != b) {
            _pressed = b;
            emit(PropName.pressed, b, !b);
        }
    }

    final bool pressed() const {
        return _pressed;
    }

    final ref const(Color4d) fgColor() const {
        return _color.fgColor;
    }

    final ref Color4d fgColor() {
        return _color.fgColor;
    }

    final void fgColor(in Color4d newFgColor) {
        if (_color.fgColor != newFgColor) {
            auto oldFgColor = _color.fgColor;
            _color.fgColor = newFgColor;
            emit(PropName.fgColor, newFgColor, oldFgColor);
        }
    }

    final ref const(Color4d) bgColor() const {
        return _color.bgColor;
    }

    final ref Color4d bgColor() {
        return _color.bgColor;
    }

    final void bgColor(in Color4d newBgColor) {
        if (_color.bgColor != newBgColor) {
            auto oldBgColor = _color.bgColor;
            _color.bgColor = newBgColor;
            emit(PropName.bgColor, newBgColor, oldBgColor);
        }
    }

    final void nodeColor(in NodeColor nc) {
        fgColor = nc.fgColor;
        bgColor = nc.bgColor;
    }

    final ref const(NodeColor) nodeColor() const {
        return _color;
    }

    final void insets(in Insets2d newInsets) {
        if (newInsets != _insets) {
            auto oldInsets = _insets;
            _insets = newInsets;
            emit(PropName.insets, newInsets, oldInsets);
        }
    }

    final ref const(Insets2d) insets() const {
        return _insets;
    }

    final ref Insets2d insets() {
        return _insets;
    }

    final void alignment(in Vec2d newAlignment) {
        if (newAlignment != _alignment) {
            auto oldAlignment = _alignment;
            _alignment = newAlignment;
            emit(PropName.alignment, newAlignment, oldAlignment);
        }
    }

    final ref const(Vec2d) alignment() const {
        return _alignment;
    }

    final ref Vec2d alignment() {
        return _alignment;
    }

    final void layer(int newLayer) {
        if (newLayer != _layer) {
            auto oldLayer = _layer;
            _layer = newLayer;
            emit(PropName.layer, newLayer, oldLayer);
        }
    }

    final const(int) layer() const {
        return _layer;
    }

    final void animated(bool b) {
        if (b != _animated) {
            _animated = b;
            emit(PropName.animated, b, !b);
        }
    }

    final bool animated() const {
        return _animated;
    }

    final void margin(in Insets2d newMargin) {
        if (newMargin != _margin) {
            auto oldMargin = _margin;
            _margin = newMargin;
            emit(PropName.margin, newMargin, oldMargin);
        }
    }

    final ref const(Insets2d) margin() const {
        return _margin;
    }

    final ref Insets2d margin() {
        return _margin;
    }

    final void animOffset(in Vec2d newAnimOffset) {
        if (newAnimOffset != _animOffset) {
            auto oldAnimOffset = _animOffset;
            _animOffset = newAnimOffset;
            emit(PropName.animOffset, newAnimOffset, oldAnimOffset);
        }
    }

    final ref const(Vec2d) animOffset() const {
        return _animOffset;
    }

    final ref Vec2d animOffset() {
        return _animOffset;
    }

    final void animBounds(in Box2d newAnimBounds) {
        if (newAnimBounds != _animBounds) {
            auto oldAnimBounds = _animBounds;
            _animBounds = newAnimBounds;
            emit(PropName.animBounds, newAnimBounds, oldAnimBounds);
        }
    }

    final ref const(Box2d) animBounds() const {
        return _animBounds;
    }

    final ref Box2d animBounds() {
        return _animBounds;
    }

    final void bounds(in Box2d newBounds) {
        if (newBounds != _bounds) {
            auto oldBounds = _bounds;
            _bounds = newBounds;
            emit(PropName.bounds, newBounds, oldBounds);
        }
    }

    final ref const(Box2d) bounds() const {
        return _bounds;
    }

    final void totalBounds(in Box2d newTotalBounds) {
        if (newTotalBounds != _totalBounds) {
            auto oldTotalBounds = _totalBounds;
            _totalBounds = newTotalBounds;
            emit(PropName.totalBounds, newTotalBounds, oldTotalBounds);
        }
    }

    final ref const(Box2d) totalBounds() const {
        return _totalBounds;
    }

    final ref Box2d bounds() {
        return _bounds;
    }

    final string name() const {
        return _name;
    }

    final void name(string newName) {
        if (newName != _name) {
            auto oldName = _name;
            _name = newName;
            emit(PropName.name, newName, oldName);
        }
    }

    final void minDim(in Dim2d newMinDim) {
        if (newMinDim != _dim.min) {
            auto oldMinDim = _dim.min;
            _dim.min = newMinDim;
            emit(PropName.minDim, newMinDim, oldMinDim);
        }
    }

    final ref const(Dim2d) minDim() const {
        return _dim.min;
    }

    final void maxDim(in Dim2d newMaxDim) {
        if (newMaxDim != _dim.max) {
            auto oldMaxDim = _dim.max;
            _dim.max = newMaxDim;
            emit(PropName.maxDim, newMaxDim, oldMaxDim);
        }
    }

    final ref const(Dim2d) maxDim() const {
        return _dim.max;
    }

    final void prefDim(in Dim2d newPrefDim) {
        if (newPrefDim != _dim.pref) {
            auto oldPrefDim = _dim.pref;
            _dim.pref = newPrefDim;
            emit(PropName.prefDim, newPrefDim, oldPrefDim);
        }
    }

    final ref const(Dim2d) prefDim() const {
        return _dim.pref;
    }

    final void fitDim(in Dim2d newFitDim) {
        if (newFitDim != _dim.fit) {
            auto oldFitDim = _dim.fit;
            _dim.fit = newFitDim;
            emit(PropName.fitDim, newFitDim, oldFitDim);
        }
    }

    final ref const(Dim2d) fitDim() const {
        return _dim.fit;
    }

    final ref Node parent() {
        return _parent;
    }

    final ref Node[] children() {
        return _children;
    }

    final void selection(Selection newSelection) {
        if (newSelection !is _selection) {
            Selection oldSelection = _selection;
            _selection = newSelection;
            objectSignal.emit(PropName.selection, newSelection, oldSelection);
        }
    }

    final Selection selection() {
        return _selection;
    }

    final const(Selection) selection() const {
        return _selection;
    }

    final bool hasSelection() const {
        return _selection !is null;
    }
}


