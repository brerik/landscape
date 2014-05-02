/*
 * Forest File Finder by erik wikforss
 */
module forest.main;
import forest.nodes.node;
import forest.nodes.dir.dirnode;
import forest.map;
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
import core.runtime;
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
forest.def

Linker settings
Link libraries
gtkd

*/



/**
 *
 */
class MyWindow : MainWindow {
    enum {
        APP_NAME = "Forest File Finder",
    }

    Label StatusLbl;

    this() {
        super(APP_NAME);
        setDefaultSize(800, 600);
        Map layout = new Map();
        add(layout);
        showAll();
    }
}

version(Windows) {
    import core.sys.windows.windows;
    extern (Windows)
    immutable RESULT_FAILED = 0;

    int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
                LPSTR lpCmdLine, int nCmdShow) {
        int result;
        try {
            Runtime.initialize();
            result = myWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);
            Runtime.terminate();
        } catch (Throwable e) {
            MessageBoxA(null, e.toString().toStringz(), "Error",
                        MB_OK | MB_ICONEXCLAMATION);
            result = RESULT_FAILED;
        }
        return result;
    }

    int myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
                  LPSTR lpCmdLine, int nCmdShow) {
        auto args = getCommandLineArgs(lpCmdLine);
        Main.init(args);
        new MyWindow();
        Main.run();
        return 0;
    }

    string[] getCommandLineArgs(LPSTR lpCmdLine) {
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
void main(string[] args) {
    Main.init(args);
    new MyWindow();
    Main.run();
}

