/*
 * Forest File Finder by erik wikforss
 */
module forest.nodes.filenode;
import forest.nodes.node;
import forest.fileutil;
import forest.selection;
import gio.File;
alias gio.File.File GioFile;
import std.stdio;

class FileNode : Node {
    private {
        GioFile _file;
        string _displayName;
    }

    this(GioFile aFile, Selection aSelection) {
        super();
        objectSignal.connect(&objectWatcher);
        _file = aFile;
        auto fi = aFile.queryInfo("standard::display-name", FileQueryInfoFlags.NONE, null);
        _displayName = fi !is null ? fi.getDisplayName() : aFile.getBasename();
        if (_displayName == "\\")
            _displayName = aFile.getPath();

        selection = aSelection;
    }

    final GioFile file() {
        return _file;
    }

    final const(GioFile) file() const {
        return _file;
    }

    final string displayName() {
        return _displayName;
    }

    final void objectWatcher(string propName, Object newObject, Object oldObject) {
        if (propName == Node.PropName.selection) {
            Selection newSelection = cast(Selection)newObject;
            Selection oldSelection = cast(Selection)oldObject;
            if (oldSelection !is null)
                oldSelection.disconnect(&selectionWatcher);
            if (newSelection !is null)
                newSelection.connect(&selectionWatcher);
        }
    }

    final void selectionWatcher(Object o, bool s) {
        if (file == o) {
            writefln("selected file: %s", file.getPath());
            selected = s;
        }
    }

    final void selectFile(bool multiSelect) {
        if (multiSelect)
            multiSelectFile();
        else
            selectFile();
    }

    final void selectFile() {
        selected = true;
        if (hasSelection) {
            selection.clear();
            selection.add(file);
        }
    }

    final void multiSelectFile() {
        selected = true;
        if (hasSelection)
            selection.add(file);
    }

    final void unselectFile(bool multiSelect) {
        if (multiSelect)
            multiUnselectFile();
        else
            unselectFile();
    }

    final void unselectFile() {
        selected = false;
        if (hasSelection)
            selection.clear();
    }

    final void multiUnselectFile() {
        selected = false;
        if (hasSelection)
            selection.remove(file);
    }

    final void openFile() {
        FileUtil.openFile(file);
    }
}

