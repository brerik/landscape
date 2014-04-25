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
module landscape.nodes.filenode;
public import landscape.nodes.node;
import landscape.selection;
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

