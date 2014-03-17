/*
 * Landscape Filesystem Browser
 * Copyright (C) 2013-2014 Erik Wikforss
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
module landscape.main;
import landscape.nodes.node;
import landscape.nodes.dirgroup;
import landscape.map;
import brew.gstr;
import brew.math;
import brew.misc;
import std.stdio;
import std.utf;
import std.string;
import gtk.MainWindow;
import gtk.AboutDialog;
import gtk.Label;
import gtk.Button;
import gtk.Box;
import gtk.Main;
import gtk.Widget;
import gtk.Layout;
import gtk.Scrollbar;
import gtk.Adjustment;
import gtk.ScrolledWindow;
import gtk.DrawingArea;
import gtkc.gtktypes;
import gtkc.giotypes;
import gdk.DragContext;
import gdk.Event;
import gio.FileEnumerator;
import gio.File;
import cairo.Context;
import glib.Str;

private import stdlib = core.stdc.stdlib : exit;

/*
-defaultlib=libphobos2.so -L-L/usr/lib/x86_64-linux-gnu -L-L/usr/lib/i386-linux-gnu -L-l:libgtkd2.so -L-l:libdl.so


LINUX:
[Compiler settigns]
Other options
-I/usr/include/dmd/gtkd2

[Linker settings]
Link libraries
gtkd2
dl

Other link options
-L/usr/lib/x86_64-linux-gnu -L/usr/lib/i386-linux-gnu


WINDOWS
landscape.def

*/



/**
 *
 */
class MyWindow : MainWindow
{
    static immutable APP_NAME = "Landscape Filesystem Browser";

    Label StatusLbl;

    this()
    {
        super(APP_NAME);
        setDefaultSize(800, 600);
        Map layout = new Map();
        add(layout);
        showAll();
    }
}

version(Windows)
{
    import core.sys.windows.windows;
    extern (Windows)
    int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
                LPSTR lpCmdLine, int nCmdShow)
    {
        int result;

        try
        {
            Runtime.initialize();
            result = myWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);
            Runtime.terminate();
        }
        catch (Throwable e) // catch any uncaught exceptions
        {
            MessageBoxA(null, e.toString().toStringz(), "Error",
                        MB_OK | MB_ICONEXCLAMATION);
            result = 0;     // failed
        }

      return result;
    }

    int myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
                  LPSTR lpCmdLine, int nCmdShow)
    {
        auto args = getCommandLineArgs(lpCmdLine);
        Main.init(args);
        new MyWindow();
        Main.run();
        return 0;
    }

    string[] getCommandLineArgs(LPSTR lpCmdLine)
    {
        int numArgs;
        wstring cmd = GStr.toWString(Str.toString(lpCmdLine));
        LPWSTR* lines = CommandLineToArgvW(cmd.toUTF16z, &numArgs);
        if (lines is null)
            return null;
        string args[];
        args.length = numArgs;
        for (uint i = 0; i < numArgs; i++)
            args[i] = GStr.toString(lines[i]);
        LocalFree(lines);
        return args;
    }
}

version(linux)
void main(string[] args)
{
    Main.init(args);
    new MyWindow();
    Main.run();
}

