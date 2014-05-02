/*
 * Forest File Finder by erik wikforss
 */
module forest.nodes.filenode;
public import forest.nodes.node;
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
            selected = s;
        }
    }
}

