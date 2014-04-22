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
module landscape.nodes.dir.dirgroup;
import landscape.nodes.dir.dirnode;
import landscape.nodes.node;
import landscape.nodes.filenode;
import landscape.map;
import landscape.nodes.rectnode;
import landscape.nodes.textnode;
import landscape.nodes.dir.dirsign;
import landscape.nodes.docnode;
import landscape.nodes.circlenode;
import brew.misc;
import brew.box;
import brew.math;
import brew.color;
import brew.vec;
import brew.dim;
import brew.insets;
import brew.fun;
import brew.gstr;
import brew.gio;
import std.string;
import std.stdio;
import core.stdc.stdlib;
import cairo.Context;
import gio.File;
import gtkc.pangotypes;
import landscape.fileutil;
import std.utf;
static import std.uri;
import glib.CharacterSet;
import std.c.stdio;

class DirGroup : FileNode
{
    static
    {
        immutable IMPORT_ALL = -1;
        immutable BG_COLOR = Color4d(1,1,.8,1);
        immutable FG_COLOR = Color4d(0,0,0,1);
        immutable DIR_GROUP_OUTLINE_COLOR = Color4d(0.4, 0.4, 0.5);
        immutable FG_OPEN_COLOR = Color4d(.25,.25,.25,1);
        immutable BG_OPEN_COLOR = Color4d(1,1,1,1);
        immutable TAIL_COLOR = Color4d(0.2, 0.2, 0.3, 1.0);
        immutable TAIL_LINE_WIDTH = 1.0;
        immutable CHILD_DIR_SPACING = 8.0;
        immutable CHILD_DIR_SPACING_EXPANDED = 12.0;
        immutable GRID_SIZE_PREF = Dim2i(4,6);
    }
    private {
        ExpandSign dirExpand;
        OpenSign dirOpen;
        DirSymbol dirSymbol;
        TextNode dirText;
        Color4d tailColor;
        double tailLineWidth;
        int mNumDocs;
        bool bShowExpand;
        DirGroup dirs[];
        DocNode docs[];
        bool imported;
        Dim2i _gridSizeMin;
        Dim2i _gridSizePref;
        Dim2i _gridSizeMax;
    }

    this(GioFile aFile)
    {
        super(aFile);
        margin = Insets2d(5,5,5,5);
        bounds = Box2d(0,0,240,24);
        minDim = Dim2d(240,24);
        tailColor = TAIL_COLOR;
        tailLineWidth = TAIL_LINE_WIDTH;
        addChild(dirSymbol = createDirSymbol());
        addChild(dirOpen = createOpenLeaf());
        addChild(dirExpand = createExpandLeaf());
        addChild(dirText = createDirText(displayName));
        dirExpand.addOnMousePressedDlg(&onExpandDlg);
        dirOpen.addOnMousePressedDlg(&onOpenDocsDlg);
        _gridSizePref = GRID_SIZE_PREF;
        _gridSizeMin = Dim2i(2,-1);
        _gridSizeMax = Dim2i(4,-1);

    }

    private OpenSign createOpenLeaf()
    {
        OpenSign sl = new OpenSign();
        sl.name = "OpenSignNode";
        sl.bgColor = BG_OPEN_COLOR;
        sl.fgColor = Color4d(.2,.2,.2);
        sl.sign = OpenSign.HIDDEN;
        sl.visible = false;
        return sl;
    }

    private ExpandSign createExpandLeaf()
    {
        ExpandSign sl = new ExpandSign();
        sl.name = "ExpandSignNode";
        sl.sign = ExpandSign.HIDDEN;
        sl.bgColor = BG_OPEN_COLOR;
        sl.fgColor = Color4d(.2,.2,.2);
        sl.visible = false;
        return sl;
    }

    private DirSymbol createDirSymbol()
    {
        DirSymbol rl = new DirSymbol();
        rl.name = "BoxNode";
        rl.bounds = Box2d(0,0,240,24);
        return rl;
    }

    private TextNode createDirText(string text)
    {
        TextNode rl = new TextNode();
        rl.name = "TextNode";
        rl.text = text;
        rl.fontSize = 10.0;
        rl.insets.set(10,10,5,4);
        rl.bgColor.set(1,1,1,1);
        rl.fgColor.set(0,0,0);
        rl.text = text;
        rl.bounds = Box2d(0,0,240,24);
        rl.minDim = Dim2d(24,24);
        rl.alignment = Vec2d(.5,.5);
        return rl;
    }

    final bool onExpandDlg(in Vec2d point, uint clickCount)
    {
        if (dirExpand.sign == ExpandSign.OPEN)
            showDirsAndUpdate();
        else if (dirExpand.sign == ExpandSign.CLOSE)
            hideDirsAndUpdate();
        else
            return false;
        return true;
    }

    final void importAllChildren(int level)
    {
        alias gio.FileInfo.FileInfo GioFileInfo;
        dirExpand.sign = ExpandSign.HIDDEN;
        dirOpen.sign = OpenSign.HIDDEN;
        imported = true;
        auto e = file.enumerateChildren("standard::*", FileQueryInfoFlags.NONE, null);
        GioFileInfo[] dirInfos;
        GioFileInfo[] docInfos;
        auto info = e.nextFile(null);
        while (info !is null) {
            uint type = info.getAttributeUint32("standard::type");
            bool hidden = (0 != info.getAttributeBoolean("standard::is-hidden"));
            if (type == FileType.TYPE_DIRECTORY && !hidden)
            {
                dirInfos ~= info;
            }
            else if (type == FileType.TYPE_REGULAR && !hidden)
            {
                docInfos ~= info;
            }
            info = e.nextFile(null);
        }
        foreach (GioFileInfo i; dirInfos)
        {
            auto f = e.getChild(i);
            auto child = new DirGroup(f);
            addDir(child);
            dirExpand.sign = ExpandSign.CLOSE;
        }
        foreach (GioFileInfo i; docInfos)
        {
                auto f = e.getChild(i);
                auto child = new DocNode(f);
                child.visible = true;
                addDoc(child);
                dirOpen.sign = OpenSign.CLOSE;
        }
        e.close(null);
        if ((dirs.length > 6 && isChildDir) || (dirs.length > 0 && level-1 == 0))
        {
            hideDirs();
            dirExpand.sign = ExpandSign.OPEN;
        }

        if (hasDocs)
        {
            hideDocs();
            dirOpen.sign = OpenSign.OPEN;
        }
        if (!hasDirs && !hasDocs)
        {
            dirSymbol.nodeColor = DirSymbol.WHITE;
        }
        foreach (DirGroup dir; visibleDirs)
            dir.importAllChildren(level-1);
        setLayoutDirty();
        cleanLayout();
        if (totalBounds.height > 600 && dirExpand.sign == ExpandSign.CLOSE && isChildDir)
        {
            hideDirs();
            dirExpand.sign = ExpandSign.OPEN;
            setLayoutDirty();
            cleanLayout();
        }
    }

    public final void addDir(DirGroup dirGroup)
    {
        addChild(dirGroup);
        dirs ~= dirGroup;
        updateLayout();
    }

    public final void addDoc(DocNode doc)
    {
        addChild(doc);
        docs ~= doc;
    }

    public final void setShowExpand(bool b)
    {
        bShowExpand = b;
        updateBounds();
    }

    public final bool isShowExpand()
    {
        return bShowExpand;
    }

    final string numDocText() const
    {
        return mNumDocs > 0 ? format("%d", mNumDocs) : "";
    }

    public override Vec2d tailPoint(Vec2d alignment)
    {
        return bounds.alignedPoint(alignment);
    }

    final bool onOpenDocsDlg(in Vec2d point, uint clickCount)
    {
        if (dirOpen.sign == OpenSign.OPEN)
            showDocsAndUpdate();
        else if (dirOpen.sign == OpenSign.CLOSE)
            hideDocsAndUpdate();
        else
            return false;
        return true;
    }

    final bool onSelectedDlg(in Vec2d point, uint clickCount)
    {
        selected = !selected;
        return true;
    }

    final void showDirsAndUpdate()
    {
        if (!imported)
            importAllChildren(1);
        foreach (DirGroup c; dirs)
            if (!c.imported)
                c.importAllChildren(1);
        if (hasDirs)
        {
            showDirs();
            dirExpand.sign = ExpandSign.CLOSE;
            foreach (Node c; dirs)
                c.setLayoutDirty();
        }
        else
        {
            dirExpand.sign = ExpandSign.HIDDEN;
        }
        redraw();
    }

    final void showDirs()
    {
        foreach (DirGroup c; dirs)
            c.show();
    }

    final void hideDirsAndUpdate()
    {
        if (hasDirs)
        {
            hideDirs();
            dirExpand.sign = ExpandSign.OPEN;
            foreach (Node c; dirs)
                c.setLayoutDirty();
        }
        else
        {
            dirExpand.sign = ExpandSign.HIDDEN;
        }
        redraw();
    }

    final void hideDirs()
    {
        foreach (DirGroup c; dirs)
            c.hide();
    }

    final void showDocsAndUpdate()
    {
        if (!imported)
            importAllChildren(1);
        if (hasDocs)
        {
            showDocs();
            dirOpen.sign = OpenSign.CLOSE;
            foreach (Node c; docs)
                c.setLayoutDirty();
        }
        else
        {
            dirOpen.sign = OpenSign.HIDDEN;
        }
        redraw();
    }

    final void showDocs()
    {
        foreach (Node d; docs)
            d.show();
    }

    final void hideDocsAndUpdate()
    {

        if (hasDocs)
        {
            hideDocs();
            dirOpen.sign = OpenSign.OPEN;
            foreach (Node c; docs)
                c.setLayoutDirty();
        }
        else
        {
            dirOpen.sign = OpenSign.HIDDEN;
        }
        redraw();
    }

    final void hideDocs()
    {
        foreach (Node d; docs)
            d.hide();
    }

    final void updateAllParentLayouts()
    {
        for(Node p = parent; p !is null; p = p.parent)
            p.updateLayout();
    }

    final void updateChildLayouts()
    {
        foreach (Node c; children)
            c.updateLayout();
    }

    final Dim2d sumDimOfDirs()
    {
        Dim2d d = Dim2d.zero;
        foreach (Node n; dirs)
            d = d + n.bounds.dim;
        return d;
    }

    final Dim2d sumTotalDimOfDirs()
    {
        Dim2d d = Dim2d.zero;
        foreach (Node n; dirs) {
            n.updateTotalBounds();
            d = d + n.transformedTotalBounds.dim;
        }

        return d;
    }

    final Dim2d maxDimOfDirs()
    {
        Dim2d d = Dim2d.zero;
        foreach (Node dir; dirs)
            d = Dim2d.max(d, dir.bounds.dim);
        return d;
    }

    override void updateLayout()
    {
        int length;
        layoutDocs();
        updateDim();
        layoutDirs();
        layoutSymbols();
        cleanTotalBounds();
    }

    final void layoutDirs()
    {
        DirGroup visDirs[] = visibleDirs;
        double marginY = 0;
        if (visDirs.length > 0)
        {
            Vec2d pos1 = Vec2d(bounds.right+80, 0);
            Vec2d pos2 = Vec2d(bounds.right+80, short.min);
            foreach(DirGroup d; visDirs)
            {
                d.cleanTotalBounds();
                d.offset.x = pos1.x;
                d.offset.y = pos1.y - d.bounds.top + marginY;
                if (d.isDirsShown)
                    d.offset.y = Mathd.max(d.offset.y, pos2.y - d.totalBounds.top + CHILD_DIR_SPACING_EXPANDED);
                marginY = CHILD_DIR_SPACING;
                pos1.y = d.transformedBounds.bottom;
                if (d.isDirsShown)
                    pos2.y = d.transformedTotalBounds.bottom;
            }
            Box2d dirBounds = computeDirBounds();
            double dy = bounds.centerY - dirBounds.centerY;
            foreach(Node d; visDirs)
                d.offset.y = d.offset.y + dy;
        }
        setBoundsDirty();
    }

    final const(Box2d) computeDirBounds() {
        static bool accept(in Box2d b) { return b.isNotZero; }
        Box2d b = Box2d.zero;
        foreach(Node d; visibleDirs)
        {
            d.cleanBounds();
            b = Box2d.unionOf(b, d.transformedBounds, &accept);
        }
        return b;
    }

    final void layoutDocs()
    {
        auto box = Box3d(0,0,240,24);
        DocNode visDocs[] = visibleDocs;
        if (visDocs.length > 0)
        {
            immutable INSETS = Insets2d.fill(4);
            immutable CELL_SIZE = DocNode.BOUNDS.dim;
            immutable SPACE = Vec2d(4,4);
            int length = Mathi.clamp(cast(int)visDocs.length, _gridSizeMin.width, _gridSizeMax.width);

//            for (length = 1; cast(double)length / (cast(double)visDocs.length / cast(double)length) < Mathd.sqrt2; length++)
//                continue;
            int col = 0;
            int row = 0;
            foreach (Node d; visDocs)
            {
                auto newX = box.x + INSETS.left + (CELL_SIZE.width + SPACE.x) * col;
                auto newY = box.y + box.height + INSETS.top +(CELL_SIZE.height + SPACE.y) * row;
                d.offset = Vec2d(newX, newY);
                col++;
                if (col >= length)
                {
                    row++;
                    col = 0;
                }
            }
            if (col > 0)
                row++;
            auto newWidth = Mathd.max(box.width, INSETS.width + (CELL_SIZE.width + SPACE.x) * length - SPACE.x);
            auto newHeight = box.height + INSETS.height + (CELL_SIZE.height + SPACE.y) * row - SPACE.y;
            box = Box2d(box.x, box.y, newWidth, newHeight);
        }
        setBoundsDirty();
        bounds = box;
    }

    private final void layoutSymbols()
    {
        dirSymbol.bounds.width = bounds.width;
        dirSymbol.bounds.height = bounds.height;
        dirSymbol.setBoundsDirty();
        dirText.bounds.width = dirSymbol.bounds.width;
        dirExpand.offset.x = dirSymbol.bounds.right - 22;
        dirExpand.offset.y = dirSymbol.bounds.top + 2;
        dirExpand.setBoundsDirty();
        dirOpen.offset.x = dirSymbol.bounds.left+2;
        dirOpen.offset.y = dirSymbol.bounds.top+2;
        dirOpen.setBoundsDirty();
    }

    override void doPaintNode(Context ct)
    {
        paintTails(ct);
    }

    final void paintTails(Context ct)
    {
        Vec2d tailStart = tailBounds.alignedPoint(Vec2d(1,.5)).floorVec + Vec2d.halves;
        for(size_t i = 0; i < dirs.length; i++)
        {
            DirGroup d = dirs[i];
            if (d.visible)
            {
                Vec2d tailStop = (d.tailBounds+d.offset).alignedPoint(Vec2d(0,.5)).floorVec + Vec2d.halves;
                ct.moveTo(tailStart.x,tailStart.y);
                immutable mx = Mathd.mean(tailStart.x, tailStop.x);
                ct.curveTo(mx, tailStart.y, mx, tailStop.y, tailStop.x,tailStop.y);
                ct.setLineWidth(tailLineWidth);
                ct.setSourceRgb(tailColor.red,tailColor.green,tailColor.blue);
                ct.stroke();
            }
        }
    }

    final Box2d tailBounds()
    {
        return dirSymbol.tailBounds;
    }

    final DirGroup[] visibleDirs()
    {
        static bool accept(DirGroup d) { return d.visible; }
        return Filter!DirGroup.filter(dirs, &accept);
    }

    final DocNode[] visibleDocs()
    {
        static bool accept(DocNode d) { return d.visible; }
        return Filter!DocNode.filter(docs, &accept);
    }

    final bool hasDocs() const
    {
        return docs.length > 0;
    }

    final bool hasDirs() const
    {
        return dirs.length > 0;
    }

    final bool isDocsShown()
    {
        return dirOpen.sign() == OpenSign.CLOSE;
    }

    final bool isDirsShown()
    {
        return dirExpand.sign == ExpandSign.CLOSE;
    }

    override void updateBounds()
    {

    }

    final bool isChildDir()
    {
        return is(parent == DirGroup);
    }
}