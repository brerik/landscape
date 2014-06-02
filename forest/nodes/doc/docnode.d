/*
 * Forest File Finder by erik wikforss
 */
module forest.nodes.doc.docnode;
import forest.nodes.node;
import forest.selection;
import forest.nodes.textnode;
import forest.nodes.framenode;
import forest.nodes.circlenode;
import forest.nodes.iconnode;
import forest.nodes.filenode;
import brew.math;
import brew.box;
import brew.dim;
import brew.vec;
import brew.color;
import brew.insets;
import gio.File;
import gio.FileIcon;
import cairo.Context;
import std.stdio;
import std.string;


import gtkc.gio;
import gtkc.glib;
import core.stdc.stdio;
import gtkc.gdktypes;

alias gio.File.File GioFile;

class DocNode : FileNode
{
    enum {
        DOC_BOUNDS = Box2d(0,0,110,110),
    }

    CutFrameNode docLeaf;
    TextNode textLeaf;

    this(GioFile aFile, Selection aSelection) {
        super(aFile, aSelection);
        name = aFile.getBasename();
        bounds = DOC_BOUNDS;
        insets.setAll(0);
        addChild(docLeaf = createBoxNode());
        addChild(textLeaf = createTextNode(displayName));
        connect(&watchBoolChanged);
        addOnMousePressedDlg(&onPressedDlg);
        addOnMouseReleasedDlg(&onReleaseDlg);
        updateRect();
    }

    final bool onPressedDlg(in Vec2d point, in GdkEventButton e) {
        bool multiSelect = (e.state & ModifierType.CONTROL_MASK) != 0;
        if (e.type == EventType.DOUBLE_BUTTON_PRESS) {
            selectFile(multiSelect);
            openFile();
        } else if (e.type == EventType.BUTTON_PRESS) {
            if (selected)
                unselectFile(multiSelect);
            else
                selectFile(multiSelect);
        }
        return true;
    }

    final bool onReleaseDlg(in Vec2d point, in GdkEventButton e) {
        return true;
    }

    final void watchBoolChanged(string propName, bool newValue, bool oldValue) {
        if (propName == PropName.selected)
            updateRect();
    }

    final void updateRect() {
        docLeaf.cut = Vec2d(4,4);
        docLeaf.lineWidth = selected ? 2 : 1;
        docLeaf.insets = Insets2d.fill(selected ? 0 : 1);
    }

    final CutFrameNode createBoxNode() {
        CutFrameNode rl = new CutFrameNode();
        rl.name = "BoxNode";
        rl.bounds = insetBounds;
        rl.insets.setAll(0);
        rl.cut = Vec2d(4,4);
        rl.bgColor = Color4d.WHITE;
        rl.fgColor = Color4d(.25, .25, .5,1);
        return rl;
    }

    final TextNode createTextNode(string text) {
        TextNode rl = new TextNode();
        rl.name = "TextNode";
        rl.bgColor = Color4d.WHITE;
        rl.fgColor = Color4d.BLACK;
        rl.text = text;
        rl.fontSize = 9.0;
        rl.alignment = Vec2d(.5,.5);
        rl.insets.setAll(4);
        rl.bounds = insetBounds;
        return rl;
    }

    final void text(string t) {
        textLeaf.text = t;
    }

    final string text() const {
        return textLeaf.text;
    }

    override void updateLayout() {
        docLeaf.bounds = insetBounds;
        textLeaf.bounds = insetBounds;
    }
}
