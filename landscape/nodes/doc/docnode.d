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
module landscape.nodes.doc.docnode;
import landscape.nodes.node;
import landscape.selection;
import landscape.nodes.textnode;
import landscape.nodes.framenode;
import landscape.nodes.circlenode;
import landscape.nodes.iconnode;
import landscape.nodes.filenode;
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
import landscape.fileutil;


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
        selected = !selected;
        if (clickCount == 2)
            FileUtil.openFile(file);
        else if (clickCount == 1)
            writefln("Clicked %s\n", file.getPath());
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
        rl.bgColor.set(1,1,1,1);
        rl.fgColor.set(.25, .25, .5,1);
        return rl;
    }

    final TextNode createTextNode(string text) {
        TextNode rl = new TextNode();
        rl.name = "TextNode";
        rl.bgColor.set(1,1, 1,1);
        rl.fgColor.set(0,0,0);
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
