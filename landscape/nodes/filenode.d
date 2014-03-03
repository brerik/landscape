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
module landscape.nodes.filenode;
import landscape.nodes.node;
import gio.File;
alias gio.File.File GioFile;


public class FileNode : Node
{
    private GioFile _file;
    private string _displayName;
    public this(GioFile f)
    {
        super();
        _file = f;
        auto fi = f.queryInfo("standard::display-name", FileQueryInfoFlags.NONE, null);
        _displayName = fi !is null ? fi.getDisplayName() : f.getBasename();
        if (_displayName == "\\")
            _displayName = f.getPath();
    }

    public final GioFile file()
    {
        return _file;
    }

    public final string displayName()
    {
        return _displayName;
    }
}

