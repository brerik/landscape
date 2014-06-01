/*
 * Forest File Finder by erik wikforss
 */
module forest.nodes.textnode;
import forest.nodes.node;
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

public class TextNode : Node
{
    public enum PropName : string {
        text = "text",
        fontSize = "fontSize",
    }

    string _text;
    PgFontDescription _fontDesc;
    PgLayout _textLayout;

    this() {
        this("");
    }

    this(string aText) {
        _text = aText;
        connect(&watchBox);
    }

    ~this()
    {
    }

    final void watchBox(string propName, Box2d newBox, Box2d oldBox) {
        if (propName == Node.PropName.bounds)
            updateTextWidth();
    }

    final void updateTextWidth() {
        if (_textLayout !is null) {
            _textLayout.setWidth(cast(int)((bounds.width-insets.width)*PANGO_SCALE));
            updateFitDim();
        }
        redraw();
    }

    /**
     * Gets text property
     * @return text
     */
    public final string text() const
    {
        return _text;
    }

    /**
     * Sets text property and emits prop changed signal if changed
     * @param newText
     */
    public final void text(string newText)
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
            emit(PropName.text, newText, oldText);
        }
    }

    /**
     * Gets Pango Font Description
     */
    public final PgFontDescription fontDesc()
    {
        if (_fontDesc is null)
            _fontDesc = new PgFontDescription("Sans", 10);
        return _fontDesc;
    }

    /**
     * Sets font size property and emits changed signal if changed
     * @param new font size
     */
    public final void fontSize(double newSize)
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
            emit(PropName.fontSize, newSize, oldSize);
        }
    }

    /**
     * Gets font size property value
     * @return font size
     */
    public final double fontSize()
    {
        return cast(double)fontDesc.getSize() / cast(double)PANGO_SCALE;
    }

    /**
     * Paints text
     * @param ct - Cairo Context
     */
    public override void drawNode(Context ct)
    {
        ct.save();
        // update text

        if (_textLayout is null)
        {
            _textLayout = PgCairo.createLayout(ct);
            _textLayout.setFontDescription(fontDesc);
            _textLayout.setWidth(cast(int)((bounds.width-insets.width)*PANGO_SCALE));
            _textLayout.setWrap(PangoWrapMode.WORD_CHAR);
            _textLayout.setText(text);
        }

        updateFitDim();
        Dim2i size;
        _textLayout.getPixelSize(size.width, size.height);
        // paint text
        ct.setSourceRgba(fgColor.tupleof);
        double tx = bounds.x + insets.left + (bounds.width - insets.width - size.width) * alignment.x;
        double ty = bounds.y + insets.top + (bounds.height - insets.height - size.height) * alignment.y;
        ct.translate(tx, ty);
        PgCairo.showLayout(ct, _textLayout);
        ct.restore();
    }

    final void updateFitDim() {
        Dim2i size;
        _textLayout.getPixelSize(size.width, size.height);
        Dim2d newDim;
        newDim.width = Mathd.ceil(size.width + insets.width);
        newDim.height = Mathd.ceil(size.height + insets.height);
        if (newDim != fitDim)
        {
            fitDim = newDim;
            setLayoutDirty();
        }
    }
}

