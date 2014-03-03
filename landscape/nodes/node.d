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
module landscape.nodes.node;
import brew.math;
import brew.box;
import brew.dim;
import brew.vec;
import brew.insets;
import brew.color;
import brew.tween;
import brew.fun;
import brew.misc;
import landscape.map;
import std.stdio;
import pango.PgContext;
import cairo.Context;
import std.signals;
import landscape.events.mouseevent;

public class ChangedSignal(T) : NamedSignal
{
    public T newValue;
    public T oldValue;

    public this(string aName, T aNewValue, T aOldValue)
    {
        super(aName);
        newValue = aNewValue;
        oldValue = aOldValue;
    }
}


struct NodeColor
{
    Color4d fgColor;
    Color4d bgColor;
}

class Node
{
    enum PropName : string
    {
        selected = "selected",
        pressed = "pressed",
        visible = "visible",
        fgColor = "fgColor",
        bgColor = "bgColor",
        insets = "insets",
        offset = "offset",
        alignment = "alignment"
    }
    static immutable LAYOUT_ALL = -1;
    static immutable NO_DIM = Dim2d.zero;
    static immutable NO_INSETS = Insets2d.zero;
    static immutable NO_MARGIN = Insets2d.zero;
    string name;
    Dim2d maxDim = Dim2d.zero;
    Dim2d minDim = Dim2d.zero;
    Dim2d prefDim = Dim2d.zero;
    Dim2d fitDim = Dim2d.zero;
    Box2d bounds = Box2d.zero;
    Box2d visBounds = Box2d.zero;
    Box2d totalBounds = Box2d.zero;
    Insets2d margin = NO_MARGIN;
    Insets2d _insets = NO_INSETS;
    Color4d _fgColor = Color4d(.2,.2,.2,1);
    Color4d _bgColor = Color4d(.9,.9,.9,1);
    Node parent;
    Node children[];
    bool boundsDirty;
    bool layoutDirty;
    bool totalBoundsDirty;
    bool _visible;
    bool showChildren;
    bool isPaintTotalBounds;
    bool isPaintBounds;
    bool _selected;
    bool _pressed;
    int layer;
    Vec2d _offset = Vec2d.zero;
    Vec2d _alignment = Vec2d.zero;

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
    mixin Signal!(MouseEvent) mouseEventSignal;

    void connect(changedBoolSignal.slot_t s)
    {
        changedBoolSignal.connect(s);
    }
    void disconnect(changedBoolSignal.slot_t s)
    {
        changedBoolSignal.disconnect(s);
    }
    void emit(string name, bool newValue, bool oldValue)
    {
        changedBoolSignal.emit(name, newValue, oldValue);
    }

    void connect(changedDoubleSignal.slot_t s)
    {
        changedDoubleSignal.connect(s);
    }
    void disconnect(changedDoubleSignal.slot_t s)
    {
        changedDoubleSignal.disconnect(s);
    }
    void emit(string name, double newValue, double oldValue)
    {
        changedDoubleSignal.emit(name, newValue, oldValue);
    }

    void connect(changedStringSignal.slot_t s)
    {
        changedStringSignal.connect(s);
    }
    void disconnect(changedStringSignal.slot_t s)
    {
        changedStringSignal.disconnect(s);
    }
    void emit(string name, string newValue, string oldValue)
    {
        changedStringSignal.emit(name, newValue, oldValue);
    }

    void connect(changedIntSignal.slot_t s)
    {
        changedIntSignal.connect(s);
    }
    void disconnect(changedIntSignal.slot_t s)
    {
        changedIntSignal.disconnect(s);
    }
    void emit(string name, int newValue, int oldValue)
    {
        changedIntSignal.emit(name, newValue, oldValue);
    }

    void connect(changedColor4dSignal.slot_t s)
    {
        changedColor4dSignal.connect(s);
    }
    void disconnect(changedColor4dSignal.slot_t s)
    {
        changedColor4dSignal.disconnect(s);
    }
    void emit(string name, in Color4d newValue, in Color4d oldValue)
    {
        changedColor4dSignal.emit(name, newValue, oldValue);
    }

    void connect(changedInsets2dSignal.slot_t s)
    {
        changedInsets2dSignal.connect(s);
    }
    void disconnect(changedInsets2dSignal.slot_t s)
    {
        changedInsets2dSignal.disconnect(s);
    }
    void emit(string name, in Insets2d newValue, in Insets2d oldValue)
    {
        changedInsets2dSignal.emit(name, newValue, oldValue);
    }
    void connect(changedVector2dSignal.slot_t s)
    {
        changedVector2dSignal.connect(s);
    }
    void disconnect(changedVector2dSignal.slot_t s)
    {
        changedVector2dSignal.disconnect(s);
    }
    void emit(string name, in Vec2d newValue, in Vec2d oldValue)
    {
        changedVector2dSignal.emit(name, newValue, oldValue);
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

    final void addOnMouseReleasedDlg(bool delegate(in Vec2d, uint clickCount) dlg)
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

    final const(string) path()
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

    final bool isRoot()
    {
        return parent is null;
    }

    final bool isChild()
    {
        return parent !is null;
    }

    final bool hasParent()
    {
        return parent !is null;
    }

    final bool hasChildren()
    {
        return children.length > 0;
    }

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

    final const(Box2d) marginBounds() const
    {
        return bounds.addInsets(margin);
    }

    final const(Box2d) insetsBounds() const
    {
        return bounds.addInsets(insets);
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

    final ref const(Vec2d) offset() const
    {
        return _offset;
    }

    final ref Vec2d offset()
    {
        return _offset;
    }

    final void offset(in Vec2d newOffset)
    {
        if (newOffset != _offset)
        {
            auto oldOffset = _offset;
            _offset = newOffset;
            emit(PropName.offset, newOffset, oldOffset);
        }
    }

    public final bool isShown() const
    {
        return visible && bounds.width > 0 && bounds.height > 0;
    }

    public final Box2d insettedBounds() const
    {
        return bounds - insets;
    }

    public final void selected(bool b)
    {
        if (_selected != b)
        {
            _selected = b;
            emit(PropName.selected, b, !b);
        }
    }
    public final bool selected() const
    {
        return _selected;
    }

    public final void visible(bool b)
    {
        if (_visible != b)
        {
            _visible = b;
            emit(PropName.visible, b, !b);
        }
    }
    public final bool visible() const
    {
        return _visible;
    }

    public final void pressed(bool b)
    {
        if (_pressed != b)
        {
            _pressed = b;
            emit(PropName.pressed, b, !b);
        }
    }
    public final bool pressed() const
    {
        return _pressed;
    }

    public final ref const(Color4d) fgColor() const
    {
        return _fgColor;
    }
    public final ref Color4d fgColor()
    {
        return _fgColor;
    }
    public final void fgColor(in Color4d newFgColor)
    {
        if (_fgColor != newFgColor)
        {
            auto oldFgColor = _fgColor;
            _fgColor = newFgColor;
            emit(PropName.fgColor, newFgColor, oldFgColor);
        }
    }

    public final ref const(Color4d) bgColor() const
    {
        return _bgColor;
    }

    public final ref Color4d bgColor()
    {
        return _bgColor;
    }

    /**
     * Sets background color and emits bgColor changed signal
     * @param newBgColor - new background color
     */
    public final void bgColor(in Color4d newBgColor)
    {
        if (_bgColor != newBgColor)
        {
            auto oldBgColor = _bgColor;
            _bgColor = newBgColor;
            emit(PropName.bgColor, newBgColor, oldBgColor);
        }
    }

    /**
     * Sets fgColor and bgColor and emits their changed signals
     * @param NodeColor - foreground color and background color
     */
    public final void nodeColor(in NodeColor c)
    {
        fgColor = c.fgColor;
        bgColor = c.bgColor;
    }

    /**
     * Gets fgColor and bgColor
     * @return NodeColor[fgColor, bgColor]
     */
    public final const(NodeColor) nodeColor() const
    {
        NodeColor c = {fgColor, bgColor};
        return c;
    }

    /**
     * Sets insets and emits insets changed signal
     * @param new insets
     */
    public final void insets(in Insets2d newInsets)
    {
        if (newInsets != _insets)
        {
            auto oldInsets = _insets;
            _insets = newInsets;
            emit(PropName.insets, newInsets, oldInsets);
        }
    }

    /**
     * Gets insets as const ref
     * @return insets
     */
    public final ref const(Insets2d) insets() const
    {
        return _insets;
    }

    /**
     * Gets insets as mutable ref
     * @return insets
     */
    public final ref Insets2d insets()
    {
        return _insets;
    }

    /**
     * Sets alignment and emits alignment changed signal
     * @param new alignment
     */
    public final void alignment(in Vec2d newAlignment)
    {
        if (newAlignment != _alignment)
        {
            auto oldAlignment = _alignment;
            _alignment = newAlignment;
            emit(PropName.alignment, newAlignment, oldAlignment);
        }
    }

    /**
     * Gets alignment as const ref
     * @return alignment
     */
    public final ref const(Vec2d) alignment() const
    {
        return _alignment;
    }

    /**
     * Gets alignment as mutable ref
     * @return alignment
     */
    public final ref Vec2d alignment()
    {
        return _alignment;
    }
}


