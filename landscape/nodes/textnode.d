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
module landscape.nodes.textnode;
import landscape.nodes.node;
import brew.math;
import brew.box;
import brew.dim;
import brew.vec;
import brew.color;
import std.string;
import cairo.Context;
import cairo.FontOption;
import pango.PgLayout;
import pango.PgCairo;
import pango.PgFontDescription;
import gtkc.pangotypes;

class TextNode : Node
{
    string _text;
    PgFontDescription _fontDesc;
    PgLayout _textLayout;

    this()
    {
        _text = "";
    }

    this(string aText)
    {
        _text = aText;
    }

    ~this()
    {
        if (_fontDesc !is null)
        {
            _fontDesc.free();
            _fontDesc = null;
        }
    }

    final string text() const
    {
        return _text;
    }

    final void text(string newText)
    in
    {
        assert (newText !is null);
    }
    body
    {

        auto oldText = _text;
        if (newText != oldText)
        {
            _text = newText;
            if (_textLayout !is null)
                _textLayout.setText(_text);
            emit("text", newText, oldText);
        }
    }

    final PgFontDescription fontDesc()
    {
        if (_fontDesc is null)
            _fontDesc = new PgFontDescription("Sans", 10);
        return _fontDesc;
    }

    final void fontSize(double newSize)
    in
    {
        assert (newSize >= 1.0);
    }
    body
    {
        auto oldSize = fontSize;
        if (oldSize != newSize)
        {
            fontDesc.setSize(cast(int)(newSize * cast(double)PANGO_SCALE));
            emit("fontSize", newSize, oldSize);
        }
    }

    final double fontSize()
    {
        return cast(double)fontDesc.getSize() / cast(double)PANGO_SCALE;
    }

    override void doPaintNode(Context ct)
    {
        ct.save();
        alias Math!double.ceil ceil;
        // update text

        if (_textLayout is null)
        {
            _textLayout = PgCairo.createLayout(ct);
            _textLayout.setFontDescription(fontDesc);
            _textLayout.setWidth(cast(int)((bounds.width-insets.width)*PANGO_SCALE));
            _textLayout.setWrap(PangoWrapMode.WORD_CHAR);
            _textLayout.setText(text);
        }

        // update fit dim
        Dim2i size;
        _textLayout.getPixelSize(size.width, size.height);
        Dim2d newDim;
        newDim.width = ceil(size.width + insets.width);
        newDim.height = ceil(size.height + insets.height);
        if (newDim != fitDim)
        {
            fitDim = newDim;
            setLayoutDirty();
        }

        // paint text
        ct.setSourceRgb(fgColor.red, fgColor.green, fgColor.blue);
        double tx = bounds.x + insets.left + (bounds.width - insets.width - size.width) * alignment.x;
        double ty = bounds.y + insets.top + (bounds.height - insets.height - size.height) * alignment.y;
        ct.translate(tx, ty);
        PgCairo.showLayout(ct, _textLayout);
        ct.restore();
    }
}

