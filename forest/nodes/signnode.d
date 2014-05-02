/*
 * Forest File Finder by erik wikforss
 */
module forest.nodes.signnode;
public import forest.nodes.node;
import brew.box, brew.dim, brew.vec, brew.color, brew.insets, brew.math;
import cairo.Context;

class SignNode : Node {
    enum {
        NONE = 0,
        PLUS = 1,
        MINUS = 2,
        LEFT = 3,
        RIGHT = 4,
        DOWN = 5,
        UP = 6,
        DEFAULT_DIM = Dim2d(20, 20),
        DEFAULT_INSETS = Insets2d(5, 5, 5, 5),
        DEFAULT_COLOR = Color4d.BLACK,
    }

    enum PropName {
        signColor = "signColor",
        sign = "sign",
        lineWidth = "lineWidth",
        signLineWidth = "signLineWidth",
        drawRing ="drawRing"
    }

    private {
        Color4d _signColor = DEFAULT_COLOR;
        double _lineWidth = 1.0;
        double _signLineWidth = 1.0;
        int _sign = NONE;
        bool _drawRing = true;
    }

    this() {
        bounds.dim = DEFAULT_DIM;
        insets = DEFAULT_INSETS;
    }

    final Color4d signColor() const {
        return _signColor;
    }

    final void signColor(in Color4d newColor) {
        if (newColor != _signColor) {
            auto oldColor = _signColor;
            _signColor = newColor;
            emit(PropName.signColor, newColor, oldColor);
        }
    }

    final int sign() const {
        return _sign;
    }

    final void sign(int newSign) {
        if (newSign != _sign) {
            auto oldSign = _sign;
            _sign = newSign;
            emit(PropName.sign, newSign, oldSign);
        }
    }

    final double lineWidth() const {
        return _lineWidth;
    }

    final void lineWidth(double newLineWidth) {
        auto oldLineWidth = _lineWidth;
        if (newLineWidth != oldLineWidth) {
            _lineWidth = newLineWidth;
            emit(PropName.lineWidth, newLineWidth, oldLineWidth);
        }
    }

    override void drawNode(Context ct) {
        Box2d signBounds = bounds - insets;
        if (_drawRing) {
            ct.setSourceRgb(bgColor.red,bgColor.green,bgColor.blue);
            ct.moveTo(bounds.right, bounds.centerY);
            ct.arc(bounds.centerX, bounds.centerY,bounds.halfWidth,0,Math!double.pi*2);
            ct.fillPreserve();
            ct.setLineWidth(_lineWidth);
            ct.setSourceRgb(fgColor.red,fgColor.green,fgColor.blue);
            ct.stroke();
        }
        switch (_sign) {
            case PLUS:
                ct.moveTo(signBounds.centerX, signBounds.top);
                ct.lineTo(signBounds.centerX, signBounds.bottom);
                break;
            case MINUS:
                ct.moveTo(signBounds.left, signBounds.centerY);
                ct.lineTo(signBounds.right, signBounds.centerY);
                break;
            case LEFT:
                ct.moveTo(signBounds.right, signBounds.top);
                ct.lineTo(signBounds.left, signBounds.centerY);
                ct.lineTo(signBounds.right, signBounds.bottom);
                break;
            case RIGHT:
                ct.moveTo(signBounds.left, signBounds.top);
                ct.lineTo(signBounds.right, signBounds.centerY);
                ct.lineTo(signBounds.left, signBounds.bottom);
                break;
            case UP:
                ct.moveTo(signBounds.left, signBounds.bottom);
                ct.lineTo(signBounds.centerX, signBounds.top);
                ct.lineTo(signBounds.right, signBounds.bottom);
                break;
            case DOWN:
                ct.moveTo(signBounds.left, signBounds.top);
                ct.lineTo(signBounds.centerX, signBounds.bottom);
                ct.lineTo(signBounds.right, signBounds.top);
                break;
            default:
                break;
        }
        ct.setLineWidth(_signLineWidth);
        ct.setSourceRgb(_signColor.red,_signColor.green,_signColor.blue);
        ct.stroke();
    }

    override Vec2d tailPoint(Vec2d alignment) const {
        return bounds.alignedPoint(alignment);
    }

    final void drawRing(bool b) {
        if (b != _drawRing) {
            _drawRing = b;
            emit(PropName.drawRing, b, !b);
        }
    }

    final bool drawRing() const {
        return _drawRing;
    }

    final void signLineWidth(double v) {
        if (v != _signLineWidth) {
            auto old = _signLineWidth;
            _signLineWidth = v;
            emit(PropName.signLineWidth, v, old);
        }
    }

    final double signLineWidth() const {
        return _signLineWidth;
    }
}

