/*
 * Forest File Finder by erik wikforss
 */
module forest.nodes.framenode;
public import forest.nodes.node;
import std.string, std.stdio;
import brew.dim;
import brew.box;
import brew.vec;
import brew.color;
import brew.math;
import cairo.Context;

/**
 * Node with rectangular frame
 */
class FrameNode : Node
{
    enum PropName {
        lineWidth = "lineWidth",
        outlined = "outlined",
        filled = "filled",
    }

    private {
        double _lineWidth = 1.0;
        bool _outlined = true;
        bool _filled = true;
    }

    /**
     * Sets line width property and emits changed signal if changed
     * @param newLineWidth
     */
    final void lineWidth(double newLineWidth) {
        if (newLineWidth != _lineWidth) {
            auto oldLineWidth = _lineWidth;
            _lineWidth = newLineWidth;
            emit(PropName.lineWidth, newLineWidth, oldLineWidth);
            redraw();
        }
    }

    final double lineWidth() const {
        return _lineWidth;
    }

    override void drawNode(Context ct) {
        if (filled) {
            ct.rectangle((bounds-insets).tupleof);
            ct.setSourceRgba(bgColor.tupleof);
            ct.fill();
        }
        if (outlined && lineWidth > 0) {
            ct.setLineWidth(lineWidth);
            ct.setSourceRgba(fgColor.tupleof);
            ct.rectangle((bounds-insets).tupleof);
            ct.stroke();
        }
    }

    final bool outlined() const {
        return _outlined;
    }

    final void outlined(bool b) {
        if (b != _outlined) {
            _outlined = b;
            emit(PropName.outlined, _outlined, !_outlined);
        }
    }

    final bool filled() const {
        return _filled;
    }

    final void filled(bool b) {
        if (b != _filled) {
            _filled = b;
            emit(PropName.filled, _filled, !_filled);
        }
    }
}

/**
 * Node with rectangular frame with cut curners
 */
class CutFrameNode : FrameNode
{
    enum PropName {
        topLeftCut = "topLeftCut",
        topRightCut = "topRightCut",
        bottomLeftCut = "bottomLeftCut",
        bottomRightCut = "bottomRightCut",
    }

    enum {
        DEFAULT_CUT = Vec2d(4,4),
    }

    private {
        Vec2d _topLeftCut = DEFAULT_CUT;
        Vec2d _topRightCut = DEFAULT_CUT;
        Vec2d _bottomLeftCut = DEFAULT_CUT;
        Vec2d _bottomRightCut = DEFAULT_CUT;
    }

    final void cut(in Vec2d c) {
        topLeftCut = c;
        topRightCut = c;
        bottomLeftCut = c;
        bottomRightCut = c;
    }

    final void topLeftCut(in Vec2d newVal) {
        if (newVal != _topLeftCut) {
            auto oldVal = _topLeftCut;
            _topLeftCut = newVal;
            emit(PropName.topLeftCut, newVal, oldVal);
        }
    }

    final ref const(Vec2d) topLeftCut() const {
        return _topLeftCut;
    }

    final void topRightCut(in Vec2d newVal) {
        if (newVal != _topRightCut) {
            auto oldVal = _topRightCut;
            _topRightCut = newVal;
            emit(PropName.topRightCut, newVal, oldVal);
        }
    }

    final ref const(Vec2d) topRightCut() const {
        return _topRightCut;
    }

    final void bottomLeftCut(in Vec2d newVal) {
        if (newVal != _bottomLeftCut) {
            auto oldVal = _bottomLeftCut;
            _bottomLeftCut = newVal;
            emit(PropName.bottomLeftCut, newVal, oldVal);
        }
    }

    final ref const(Vec2d) bottomLeftCut() const {
        return _bottomLeftCut;
    }

    final void bottomRightCut(in Vec2d newVal) {
        if (newVal != _bottomRightCut) {
            auto oldVal = _bottomRightCut;
            _bottomRightCut = newVal;
            emit(PropName.bottomRightCut, newVal, oldVal);
        }
    }

    final ref const(Vec2d) bottomRightCut() const {
        return _bottomRightCut;
    }

    final Box2d rectToPaint(double aLineWidth) const {
        Box2d r = insetBounds;
        r.x = r.floorX + aLineWidth / 2.0;
        r.y = r.floorY + aLineWidth / 2.0;
        r.width = r.ceilWidth - aLineWidth;
        r.height = r.ceilHeight - aLineWidth;
        return r;
    }

    override void drawNode(Context ct) {
        void doOutline() {
            auto r = rectToPaint(lineWidth);
            ct.moveTo(r.left, r.top + topLeftCut.y);
            ct.lineTo(r.left + topLeftCut.x, r.top);
            ct.lineTo(r.right - topRightCut.x, r.top);
            ct.lineTo(r.right, r.top + topRightCut.y);
            ct.lineTo(r.right, r.bottom - bottomRightCut.y);
            ct.lineTo(r.right - bottomRightCut.x, r.bottom);
            ct.lineTo(r.left + bottomLeftCut.x, r.bottom);
            ct.lineTo(r.left, r.bottom - bottomLeftCut.y);
            ct.lineTo(r.left, r.bottom - bottomLeftCut.y);
            ct.lineTo(r.left, r.top + topLeftCut.y);
        }
        if (filled) {
            doOutline();
            ct.setSourceRgba(bgColor.tupleof);
            ct.fill();
        }
        if (outlined && lineWidth > 0) {
            ct.setLineWidth(lineWidth);
            ct.setSourceRgba(fgColor.tupleof);
            doOutline();
            ct.stroke();
        }
    }
}
