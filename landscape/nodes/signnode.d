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
module landscape.nodes.signnode;
public import landscape.nodes.node;
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
    }

    public enum PropName : string {
        signColor = "signColor",
        sign = "sign",
        lineWidth = "lineWidth",
        signLineWidth = "signLineWidth",
        drawRing ="drawRing"
    }

    static immutable DIM = Dim2d(20, 20);
    static immutable INSETS = Insets2d(5, 5, 5, 5);

    private int _sign = NONE;
    private Color4d _signColor = Color4d.BLACK;
    private double _lineWidth = 1.0;
    private double _signLineWidth = 1.0;
    private bool _drawRing = true;

    this() {
        bounds.dim = DIM;
        insets = INSETS;
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

    final void sign(int newSign)
    {
        if (newSign != _sign)
        {
            auto oldSign = _sign;
            _sign = newSign;
            emit(PropName.sign, newSign, oldSign);
        }
    }
    final double lineWidth() const
    {
        return _lineWidth;
    }

    final void lineWidth(double newLineWidth)
    {
        auto oldLineWidth = _lineWidth;
        if (newLineWidth != oldLineWidth)
        {

            _lineWidth = newLineWidth;
            emit(PropName.lineWidth, newLineWidth, oldLineWidth);
        }
    }

    override void drawNode(Context ct)
    {
        Box2d signBounds = bounds - insets;
        if (_drawRing)
        {
            ct.setSourceRgb(bgColor.red,bgColor.green,bgColor.blue);
            ct.moveTo(bounds.right, bounds.centerY);
            ct.arc(bounds.centerX, bounds.centerY,bounds.halfWidth,0,Math!double.pi*2);
            ct.fillPreserve();
            ct.setLineWidth(_lineWidth);
            ct.setSourceRgb(fgColor.red,fgColor.green,fgColor.blue);
            ct.stroke();
        }
        switch (_sign)
        {
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

    final void drawRing(bool b)
    {
        if (b != _drawRing)
        {
            _drawRing = b;
            emit(PropName.drawRing, b, !b);
        }
    }

    final bool drawRing() const
    {
        return _drawRing;
    }

    final void signLineWidth(double v)
    {
        if (v != _signLineWidth)
        {
            auto old = _signLineWidth;
            _signLineWidth = v;
            emit(PropName.signLineWidth, v, old);
        }
    }

    final double signLineWidth() const
    {
        return _signLineWidth;
    }
}

