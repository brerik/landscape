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
module landscape.nodes.node;
import brew.math;
public import brew.box;
public import brew.dim;
public import brew.vec;
public import brew.insets;
public import brew.color;
import brew.tween;
import brew.fun;
import brew.misc;
import landscape.map;
import std.stdio;
import pango.PgContext;
import cairo.Context;
import std.signals;
import landscape.events.mouseevent;

struct NodeColor
{
    Color4d fgColor = Color4d.BLACK;
    Color4d bgColor = Color4d.WHITE;
}
struct NodeDim
{
    Dim2d min = Dim2d.zero;
    Dim2d max = Dim2d.zero;
    Dim2d pref = Dim2d.zero;
    Dim2d fit = Dim2d.zero;
}

class Node
{
    enum PropName
    {
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
    }

    bool delegate(in Vec2d, uint clickCount) onMousePressedDlgs[];
    bool delegate(in Vec2d, uint clickCount) onMouseReleasedDlgs[];
    bool delegate(in Vec2d) onMouseMotionDlgs[];

    // property name, new value, old value
    mixin Signal!(string, bool, bool) changedBoolSignal;
    mixin Signal!(string, double, double) changedDoubleSignal;
    mixin Signal!(string, string, string) changedStringSignal;
    mixin Signal!(string, int, int) changedIntSignal;
    mixin Signal!(string, Color4d, Color4d) changedColor4dSignal;
    mixin Signal!(string, Insets2d, Insets2d) changedInsets2dSignal;
    mixin Signal!(string, Vec2d, Vec2d) changedVector2dSignal;
    mixin Signal!(string, Box2d, Box2d) changedBox2dSignal;
    mixin Signal!(string, Dim2d, Dim2d) changedDim2dSignal;
    mixin Signal!(MouseEvent) mouseEventSignal;

    final
    {
        void connect(changedBoolSignal.slot_t s)
        {
            changedBoolSignal.connect(s);
        }
        void disconnect(changedBoolSignal.slot_t s)
        {
            changedBoolSignal.disconnect(s);
        }
        void emit(string propName, bool newValue, bool oldValue)
        {
            changedBoolSignal.emit(propName, newValue, oldValue);
        }
        void connect(changedDoubleSignal.slot_t s)
        {
            changedDoubleSignal.connect(s);
        }
        void disconnect(changedDoubleSignal.slot_t s)
        {
            changedDoubleSignal.disconnect(s);
        }
        void emit(string propName, double newValue, double oldValue)
        {
            changedDoubleSignal.emit(propName, newValue, oldValue);
        }
        void connect(changedStringSignal.slot_t s)
        {
            changedStringSignal.connect(s);
        }
        void disconnect(changedStringSignal.slot_t s)
        {
            changedStringSignal.disconnect(s);
        }
        void emit(string propName, string newValue, string oldValue)
        {
            changedStringSignal.emit(propName, newValue, oldValue);
        }
        void connect(changedIntSignal.slot_t s)
        {
            changedIntSignal.connect(s);
        }
        void disconnect(changedIntSignal.slot_t s)
        {
            changedIntSignal.disconnect(s);
        }
        void emit(string propName, int newValue, int oldValue)
        {
            changedIntSignal.emit(propName, newValue, oldValue);
        }
        void connect(changedColor4dSignal.slot_t s)
        {
            changedColor4dSignal.connect(s);
        }
        void disconnect(changedColor4dSignal.slot_t s)
        {
            changedColor4dSignal.disconnect(s);
        }
        void emit(string propName, in Color4d newValue, in Color4d oldValue)
        {
            changedColor4dSignal.emit(propName, newValue, oldValue);
        }
        void connect(changedInsets2dSignal.slot_t s)
        {
            changedInsets2dSignal.connect(s);
        }
        void disconnect(changedInsets2dSignal.slot_t s)
        {
            changedInsets2dSignal.disconnect(s);
        }
        void emit(string propName, in Insets2d newValue, in Insets2d oldValue)
        {
            changedInsets2dSignal.emit(propName, newValue, oldValue);
        }
        void connect(changedVector2dSignal.slot_t s)
        {
            changedVector2dSignal.connect(s);
        }
        void disconnect(changedVector2dSignal.slot_t s)
        {
            changedVector2dSignal.disconnect(s);
        }
        void emit(string propName, in Vec2d newValue, in Vec2d oldValue)
        {
            changedVector2dSignal.emit(propName, newValue, oldValue);
        }
        void connect(changedBox2dSignal.slot_t s)
        {
            changedBox2dSignal.connect(s);
        }
        void disconnect(changedBox2dSignal.slot_t s)
        {
            changedBox2dSignal.disconnect(s);
        }
        void emit(string propName, in Box2d newValue, in Box2d oldValue)
        {
            changedBox2dSignal.emit(propName, newValue, oldValue);
        }
        void connect(changedDim2dSignal.slot_t s)
        {
            changedDim2dSignal.connect(s);
        }
        void disconnect(changedDim2dSignal.slot_t s)
        {
            changedDim2dSignal.disconnect(s);
        }
        void emit(string propName, in Dim2d newValue, in Dim2d oldValue)
        {
            changedDim2dSignal.emit(propName, newValue, oldValue);
        }
        void connect(mouseEventSignal.slot_t s)
        {
            mouseEventSignal.connect(s);
        }
        void disconnect(mouseEventSignal.slot_t s)
        {
            mouseEventSignal.disconnect(s);
        }
        void emit(MouseEvent s)
        {
            mouseEventSignal.emit(s);
        }
    }

    this()
    {
        visible = true;
        layer = 0;
        isPaintTotalBounds = false;
        isPaintBounds = false;
    }

    void dispose()
    {
        foreach (Node child; children)
            child.dispose();
        if (parent !is null)
            parent.removeChild(this);
    }

    void addChild(Node child)
    {
        if (child.parent is this)
            return;
        if (child.parent !is null)
            child.parent.removeChild(child);
        child.parent = this;
        children ~= child;
        setDirty();
    }

    void addChild(Node child, string target)
    {
        foreach (Node n; children) {
            if (n.name == target) {
                n.addChild(child);
                return;
            }
        }
    }

    final void addOnMouseMotionDlg(bool delegate(in Vec2d) dlg)
    {
        onMouseMotionDlgs ~= dlg;
    }

    final void addOnMousePressedDlg(bool delegate(in Vec2d, uint clickCount) dlg)
    {
        onMousePressedDlgs ~= dlg;
    }

    void addOnMouseReleasedDlg(bool delegate(in Vec2d, uint clickCount) dlg)
    {
        onMouseReleasedDlgs ~= dlg;
    }

    void removeChild(Node child)
    {
        if (child.parent !is this)
            return;
        bool removed = false;
        for (int i = 0; i < children.length && !removed; i++)
        {
            if (children[i] is child)
            {
                children[i] = children[$-1];
                children.length--;
                removed = true;
                setDirty();
            }
        }
    }

    const(string) path()
    {
        string a = name;
        if (parent is null)
            return name ~ "\\";
        for (Node p = parent; p !is null; p = p.parent)
            a = p.name ~ "\\" ~ a;
        return a;
    }

    void updateBounds()
    {
    }

    void onLayout()
    {
        preUpdateLayout();
        updateChildredLayout();
        updateLayout();
        updateDim();
        cleanTotalBounds();
        postUpdateLayout();
    }

    void preUpdateLayout()
    {
    }

    void updateLayout()
    {
    }

    void updateChildredLayout()
    {
        foreach (Node child; children)
            child.onLayout();
    }

    void postUpdateLayout()
    {

    }

    void updateDim()
    {
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

    final const(Box2d) transformedTotalBounds() const
    {
        return totalBounds.translated(offset);
    }

    final const(Box2d) transformedBounds() const
    {
        return bounds.translated(offset);
    }

    final void updateTotalBounds()
    {
        Box2d b = bounds;
        foreach (Node child; visibleChildren)
            b = Box2d.unionOf(b, child.transformedTotalBounds);
        totalBounds = b;
    }

    void cleanLayout()
    {
        if (layoutDirty)
        {
            foreach (Node c; children)
                c.cleanLayout();
            onLayout();
            layoutDirty = false;
        }
    }

    void cleanBounds()
    {
        if(boundsDirty)
        {
            foreach (Node child; children)
                child.cleanBounds();
            updateBounds();
            boundsDirty = false;
        }
    }

    void cleanTotalBounds()
    {
        if(totalBoundsDirty)
        {
            foreach (Node child; children)
                child.cleanTotalBounds();
            updateTotalBounds();
            totalBoundsDirty = false;
        }
    }

    void cleanUp()
    {
        cleanLayout();
        cleanBounds();
        cleanTotalBounds();
    }

    void doPaint(Context ct)
    {
        if (visible)
        {
            ct.save();
            auto o = offset.roundVec;
            if (o != Vec2d.zero)
                ct.translate(o.x, o.y);
            if (isShown)
                doPaintNode(ct);
            doPaintChildren(ct);
            if (isPaintBounds)
                doPaintBounds(ct);
            if (isPaintTotalBounds)
                doPaintTotalBounds(ct);
            ct.restore();
        }
    }

    void doPaintNode(Context ct)
    {
    }

    void doPaintChildren(Context ct)
    {
        for(size_t i = 0; i < children.length; i++)
            children[i].doPaint(ct);
    }

    /**
     * @return true if node has no parent
     */
    final bool isRoot()
    {
        return parent is null;
    }

    /**
     * @return true if node is a child aka has a parent
     */
    final bool isChild()
    {
        return parent !is null;
    }

    /**
     * @return true if node has a parent
     */
    final bool hasParent()
    {
        return parent !is null;
    }

    /**
     * @return true if node has at least one child
     */
    final bool hasChildren()
    {
        return children.length > 0;
    }

    /**
     * @return number of children
     */
    final size_t numChildren()
    {
        return children.length;
    }

    final Node childAt(size_t i)
    {
        return children[i];
    }

    final void moveTo(Vec2d newOffset)
    {
        if (newOffset != bounds.pos)
        {
            offset = newOffset;
            setParentBoundsDirty();
        }
    }

    final void moveBy(Vec2d amount) {
        if (amount != Vec2d.zero)
        {
            offset = offset + amount;
            setParentBoundsDirty();
        }
    }

    const(Vec2d) tailPoint(Vec2d alignment) {
        return bounds.alignedPoint(alignment);
    }

    final void resizeTo(in Dim2d newSize)
    {
        if (newSize != bounds.dim)
        {
            bounds.dim = newSize;
            setParentBoundsDirty();
        }
    }

    final void setDirty()
    {
        boundsDirty = layoutDirty = totalBoundsDirty = true;
        if (hasParent)
            parent.setDirty();
    }

    final void setParentDirty()
    {
        if (hasParent)
            parent.setDirty();
    }

    final void setBoundsDirty()
    {
        boundsDirty = totalBoundsDirty = true;
        if (hasParent)
            parent.setBoundsDirty();
    }

    final void setTotalBoundsDirty()
    {
        totalBoundsDirty = true;
        if (hasParent)
            parent.setTotalBoundsDirty();
    }

    final void setParentBoundsDirty()
    {
        if (hasParent)
            parent.setBoundsDirty();
    }

    final void setLayoutDirty()
    {
        layoutDirty = true;
        if (hasParent)
            parent.setLayoutDirty();
    }

    final void setParentLayoutDirty()
    {
        if (hasParent)
            parent.setLayoutDirty();
    }

    final bool isDirty()
    {
        return boundsDirty || layoutDirty || totalBoundsDirty;
    }

    final const(Box2d) absBounds()
    {
        Box2d a = bounds;
        for (Node p = parent; p !is null; p = p.parent)
            a += p.bounds.pos;
        return a;
    }

    final bool dispatchMouseButtonPressed(in Vec2d point0, uint clickCount)
    {
        Vec2d point = (point0 - offset);
        if (totalBounds.pointIn(point))
        {
            for(size_t i = children.length-1; i < children.length; i--)
            {
                auto child = children[i];
                if (child.visible && child.dispatchMouseButtonPressed(point, clickCount))
                    return true;
                }

        }
        if (bounds.pointIn(point) && notifyMouseButtonPressed(point, clickCount))
            return true;
        return false;
    }

    final bool notifyMouseButtonPressed(in Vec2d point, uint clickCount)
    {
        for (size_t i = 0; i < onMousePressedDlgs.length; i++)
            if (onMousePressedDlgs[i](point, clickCount))
                return true;
        return false;
    }

    final bool dispatchMouseButtonReleased(in Vec2d point0, uint clickCount)
    {
        Vec2d point = (point0 - offset);
        if (totalBounds.pointIn(point))
        {
            for(size_t i = children.length-1; i < children.length; i--)
            {
                auto child = children[i];
                if (child.visible && child.dispatchMouseButtonReleased(point, clickCount))
                    return true;
            }
        }
        if (bounds.pointIn(point) && notifyMouseButtonReleased(point, clickCount))
            return true;
        return false;
    }

    final bool notifyMouseButtonReleased(in Vec2d point, uint clickCount)
    {
        for (size_t i = 0; i < onMouseReleasedDlgs.length; i++)
            if (onMouseReleasedDlgs[i](point, clickCount))
                return true;
        return false;
    }

    final bool dispatchMouseMotion(in Vec2d point0)
    {
        Vec2d point = (point0 - offset);
        if (totalBounds.pointIn(point))
        {
            for(size_t i = children.length-1; i < children.length; i--)
            {
                auto child = children[i];
                if (child.visible && child.dispatchMouseMotion(point))
                    return true;
            }
        }
        if (bounds.pointIn(point) && notifyMouseMotion(point))
            return true;
        return false;
    }

    final bool notifyMouseMotion(in Vec2d point)
    {
        for (size_t i = 0; i < onMouseMotionDlgs.length; i++)
            if (onMouseMotionDlgs[i](point))
                return true;
        return false;
    }

    final void show()
    {
        if (!visible)
        {
            visible = true;
            setDirty();
        }
    }

    final void hide()
    {
        if (visible)
        {
            visible = false;
            setDirty();
        }
    }

    /**
     * @return bounds plus margin
     */
    final const(Box2d) marginBounds() const
    {
        return bounds + margin;
    }

    /**
     * @return bounds minus insets
     */
    final const(Box2d) insetBounds() const
    {
        return bounds - insets;
    }

    final void doPaintBounds(Context ct)
    {
        ct.rectangle(bounds.x+.5, bounds.y+.5, bounds.width, bounds.height);
        ct.setLineWidth(2.0);
        ct.setSourceRgb(1,0,0);
        ct.stroke();
    }

    final void doPaintTotalBounds(Context ct)
    {
        ct.rectangle(totalBounds.x+.5, totalBounds.y+.5, totalBounds.width, totalBounds.height);
        ct.setLineWidth(2.0);
        ct.setSourceRgb(0,1,0);
        ct.stroke();
    }

    final void doPaintFitBounds(Context ct)
    {
        ct.rectangle(bounds.x+.5, bounds.y+.5, fitDim.width, fitDim.height);
        ct.setLineWidth(1.0);
        ct.setSourceRgb(1,0,1);
        ct.stroke();
    }

    alias Filter!(Node).filter filterNode;

    final Node[] visibleChildren()
    {
        return visibleNodesOf(children);
    }

    final Node[] shownChildren()
    {
        return shownNodesOf(children);
    }

    static Node[] visibleNodesOf(Node nodes[])
    {
        static bool accept(Node n)
        {
            return n.visible;
        }
        return filterNode(nodes, &accept);
    }

    static Node[] shownNodesOf(Node nodes[])
    {
        static bool accept(Node n)
        {
            return n.isShown;
        }
        return filterNode(nodes, &accept);
    }

    void redraw()
    {
        if (hasParent)
            parent.redraw();
    }

    /**
     * @return level >= 0
     */
    final const(int) level()
    {
        int l = 0;
        for (Node p = parent; p !is null; p = p.parent)
            l++;
        return l;
    }


    /**
     * Gets offset property as const ref
     * @return offset
     */
    final ref const(Vec2d) offset() const
    {
        return _offset;
    }

    /**
     * Gets offset property as mutable ref
     * @return offset
     */
    final ref Vec2d offset()
    {
        return _offset;
    }

    /**
     * Sets offset property and emits signal if changed
     * @param newOffset - new offset
     */
    final void offset(in Vec2d newOffset)
    {
        if (newOffset != _offset)
        {
            auto oldOffset = _offset;
            _offset = newOffset;
            emit(PropName.offset, newOffset, oldOffset);
        }
    }

    final bool isShown() const
    {
        return visible && bounds.width > 0 && bounds.height > 0;
    }

    /**
     * Sets selected property
     */
    final void selected(bool b)
    {
        if (_selected != b)
        {
            _selected = b;
            emit(PropName.selected, b, !b);
        }
    }

    /**
     * Gets selected property
     */
    final bool selected() const
    {
        return _selected;
    }

    /**
     * Sets visible property and emits changed signal if changed
     */
    final void visible(bool b)
    {
        if (_visible != b)
        {
            _visible = b;
            emit(PropName.visible, b, !b);
        }
    }

    /**
     * Gets visible property
     */
    final bool visible() const
    {
        return _visible;
    }

    /**
     * Sets pressed property and emits signal if changed
     */
    final void pressed(bool b)
    {
        if (_pressed != b)
        {
            _pressed = b;
            emit(PropName.pressed, b, !b);
        }
    }

    /**
     * Gets pressed property
     * @return pressed
     */
    final bool pressed() const
    {
        return _pressed;
    }

    /**
     * Gets foreground color property as const ref
     * @return foreground color
     */
    final ref const(Color4d) fgColor() const
    {
        return _color.fgColor;
    }

    /**
     * Gets foreground color property as mutable ref
     * @return foreground color
     */
    final ref Color4d fgColor()
    {
        return _color.fgColor;
    }

    /**
     * Sets foreground color property and emits fgColor changed signal
     * @param newFgColor - new foreground color
     */
    final void fgColor(in Color4d newFgColor)
    {
        if (_color.fgColor != newFgColor)
        {
            auto oldFgColor = _color.fgColor;
            _color.fgColor = newFgColor;
            emit(PropName.fgColor, newFgColor, oldFgColor);
        }
    }

    /**
     * Gets background color property as const ref
     * @return background color
     */
    final ref const(Color4d) bgColor() const
    {
        return _color.bgColor;
    }

    /**
     * Gets background color property as mutable ref
     * @return background color
     */
    final ref Color4d bgColor()
    {
        return _color.bgColor;
    }

    /**
     * Sets background color property and emits bgColor changed signal
     * @param newBgColor - new background color
     */
    final void bgColor(in Color4d newBgColor)
    {
        if (_color.bgColor != newBgColor)
        {
            auto oldBgColor = _color.bgColor;
            _color.bgColor = newBgColor;
            emit(PropName.bgColor, newBgColor, oldBgColor);
        }
    }

    /**
     * Sets fgColor and bgColor proprty and emits their changed signals
     * emits bgColor and fgColor signal
     * @param NodeColor - foreground color and background color
     */
    final void nodeColor(in NodeColor nc)
    {
        fgColor = nc.fgColor;
        bgColor = nc.bgColor;
    }

    /**
     * Gets fgColor and bgColor property
     * @return NodeColor[fgColor, bgColor]
     */
    final ref const(NodeColor) nodeColor() const
    {
        return _color;
    }

    /**
     * Sets insets property and emits changed signal
     * @param new insets
     */
    final void insets(in Insets2d newInsets)
    {
        if (newInsets != _insets)
        {
            auto oldInsets = _insets;
            _insets = newInsets;
            emit(PropName.insets, newInsets, oldInsets);
        }
    }

    /**
     * Gets insets property as const ref
     * @return insets
     */
    final ref const(Insets2d) insets() const
    {
        return _insets;
    }

    /**
     * Gets insets property as mutable ref
     * @return insets
     */
    final ref Insets2d insets()
    {
        return _insets;
    }

    /**
     * Sets alignment property and emits alignment changed signal
     * @param new alignment
     */
    final void alignment(in Vec2d newAlignment)
    {
        if (newAlignment != _alignment)
        {
            auto oldAlignment = _alignment;
            _alignment = newAlignment;
            emit(PropName.alignment, newAlignment, oldAlignment);
        }
    }

    /**
     * Gets alignment property as const ref
     * @return alignment
     */
    final ref const(Vec2d) alignment() const
    {
        return _alignment;
    }

    /**
     * Gets alignment property as mutable ref
     * @return alignment
     */
    final ref Vec2d alignment()
    {
        return _alignment;
    }

    /**
     * Sets layer property and emits changed signal
     * @param newLayer
     */
    final void layer(int newLayer)
    {
        if (newLayer != _layer)
        {
            auto oldLayer = _layer;
            _layer = newLayer;
            emit(PropName.layer, newLayer, oldLayer);
        }
    }

    /**
     * Gets layer property
     * @return layer
     */
    final const(int) layer() const
    {
        return _layer;
    }

    /**
     * Sets animated property and emits changed signal if changed
     * @param new animated value
     */
    final void animated(bool b)
    {
        if (b != _animated)
        {
            _animated = b;
            emit(PropName.animated, b, !b);
        }
    }

    /**
     * Gets the animated property
     * @return animated value
     */
    final bool animated() const
    {
        return _animated;
    }

    /**
     * Sets margin property and emits changed signal if changed
     * @param new margin
     */
    final void margin(in Insets2d newMargin)
    {
        if (newMargin != _margin)
        {
            auto oldMargin = _margin;
            _margin = newMargin;
            emit(PropName.margin, newMargin, oldMargin);
        }
    }

    /**
     * Gets margin property as const ref
     * @return margin
     */
    final ref const(Insets2d) margin() const
    {
        return _margin;
    }

    /**
     * Gets margin property as mutable ref
     * @return margin
     */
    final ref Insets2d margin()
    {
        return _margin;
    }

    /**
     * Sets animated offset property and emits changed signal if changed
     * @param new animated offset
     */
    final void animOffset(in Vec2d newAnimOffset)
    {
        if (newAnimOffset != _animOffset)
        {
            auto oldAnimOffset = _animOffset;
            _animOffset = newAnimOffset;
            emit(PropName.animOffset, newAnimOffset, oldAnimOffset);
        }
    }

    /**
     * Gets animated offset property as const ref
     * @return animated offset
     */
    final ref const(Vec2d) animOffset() const
    {
        return _animOffset;
    }

    /**
     * Gets animated offset property as mutable ref
     * @return animated offset
     */
    final ref Vec2d animOffset()
    {
        return _animOffset;
    }

    /**
     * Sets animated boundaries property and emits changed signal if changed
     * @param new animated boundaries
     */
    final void animBounds(in Box2d newAnimBounds)
    {
        if (newAnimBounds != _animBounds)
        {
            auto oldAnimBounds = _animBounds;
            _animBounds = newAnimBounds;
            emit(PropName.animBounds, newAnimBounds, oldAnimBounds);
        }
    }

    /**
     * Gets animated boundaries property as const ref
     * @return animated boundaries
     */
    final ref const(Box2d) animBounds() const
    {
        return _animBounds;
    }

    /**
     * Gets animated boundaries property as mutable ref
     * @return animated boundaries
     */
    final ref Box2d animBounds()
    {
        return _animBounds;
    }

    /**
     * Sets boundaries property and emits changed signal if changed
     * @param new boundaries
     */
    final void bounds(in Box2d newBounds)
    {
        if (newBounds != _bounds)
        {
            auto oldBounds = _bounds;
            _bounds = newBounds;
            emit(PropName.bounds, newBounds, oldBounds);
        }
    }

    /**
     * Gets boundaries property as const ref
     * @return boundaries
     */
    final ref const(Box2d) bounds() const
    {
        return _bounds;
    }
    /**
     * Sets total boundaries property and emits changed signal if changed
     * @param new boundaries
     */
    final void totalBounds(in Box2d newTotalBounds)
    {
        if (newTotalBounds != _totalBounds)
        {
            auto oldTotalBounds = _totalBounds;
            _totalBounds = newTotalBounds;
            emit(PropName.totalBounds, newTotalBounds, oldTotalBounds);
        }
    }

    /**
     * Gets total boundaries property as const ref
     * @return boundaries
     */
    final ref const(Box2d) totalBounds() const
    {
        return _totalBounds;
    }

    /**
     * Gets boundaries property as mutable ref
     * @return boundaries
     */
    final ref Box2d bounds()
    {
        return _bounds;
    }

    /**
     * Gets name property
     */
    final string name() const
    {
        return _name;
    }

    final void name(string newName)
    {
        if (newName != _name)
        {
            auto oldName = _name;
            _name = newName;
            emit(PropName.name, newName, oldName);
        }
    }


    /**
     * Sets minimum dimension property and emits minimum dimension changed signal
     * @param new alignment
     */
    final void minDim(in Dim2d newMinDim)
    {
        if (newMinDim != _dim.min)
        {
            auto oldMinDim = _dim.min;
            _dim.min = newMinDim;
            emit(PropName.minDim, newMinDim, oldMinDim);
        }
    }

    /**
     * Gets minimum dimension property as const ref
     * @return alignment
     */
    final ref const(Dim2d) minDim() const
    {
        return _dim.min;
    }

    /**
     * Sets maximum dimension property and emits maximum dimension changed signal
     * @param new alignment
     */
    final void maxDim(in Dim2d newMaxDim)
    {
        if (newMaxDim != _dim.max)
        {
            auto oldMaxDim = _dim.max;
            _dim.max = newMaxDim;
            emit(PropName.maxDim, newMaxDim, oldMaxDim);
        }
    }

    /**
     * Gets maximum dimension property as const ref
     * @return alignment
     */
    final ref const(Dim2d) maxDim() const
    {
        return _dim.max;
    }

    /**
     * Sets preferred dimension property and emits preferred dimension changed signal
     * @param new alignment
     */
    final void prefDim(in Dim2d newPrefDim)
    {
        if (newPrefDim != _dim.pref)
        {
            auto oldPrefDim = _dim.pref;
            _dim.pref = newPrefDim;
            emit(PropName.prefDim, newPrefDim, oldPrefDim);
        }
    }

    /**
     * Gets preferred dimension property as const ref
     * @return alignment
     */
    final ref const(Dim2d) prefDim() const
    {
        return _dim.pref;
    }

    /**
     * Sets best fit dimension property and emits best fit dimension changed signal
     * @param new alignment
     */
    final void fitDim(in Dim2d newFitDim)
    {
        if (newFitDim != _dim.fit)
        {
            auto oldFitDim = _dim.fit;
            _dim.fit = newFitDim;
            emit(PropName.fitDim, newFitDim, oldFitDim);
        }
    }

    /**
     * Gets best fit dimension property as const ref
     * @return alignment
     */
    final ref const(Dim2d) fitDim() const
    {
        return _dim.fit;
    }

    final ref Node parent()
    {
        return _parent;
    }

    final ref Node[] children()
    {
        return _children;
    }
}


