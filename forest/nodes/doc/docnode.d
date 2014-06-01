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
import forest.fileutil;


private import gtkc.gio;
private import gtkc.glib;
private import core.stdc.stdio;

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

    final bool onPressedDlg(in Vec2d point, uint clickCount) {
        if (clickCount == 2) {
            selectFile(Selection.Mode.SINGLE);
            FileUtil.openFile(file);
        } else if (clickCount == 1) {
            if (selected)
                unselectFile(Selection.Mode.SINGLE);
            else
                selectFile(Selection.Mode.SINGLE);
        }
        return true;
    }

    final bool onReleaseDlg(in Vec2d point, uint clickCount) {
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
