/*
 * Forest File Finder by erik wikforss
 */
module forest.fileutil;
import gio.File;
import std.string;
import std.system;
import std.stdio;
import std.utf;
import brew.gstr;
import brew.gio;
import std.c.stdlib;
alias gio.File.File GioFile;

struct FileUtil
{


    version(linux)
    {
        static void openFile(GioFile f)
        {
            system(("xdg-open \"" ~ f.getPath ~ "\"").toStringz);
        }
    }

    version(Windows)
    {
        import std.c.windows.windows;
        import std.windows.charset;

        enum ShellExecuteOperation : string
        {
            edit = "edit",
            explore = "explore",
            find = "find",
            open = "open",
            print = "print"
        }

        static void openFile(GioFile f)
        {
            auto wcsnullptr = cast(const(wchar)*)null;
            auto voidnullptr = cast(void*)null;
            int err = cast(int)ShellExecuteW(voidnullptr, ShellExecuteOperation.open.toUTF16z, f.getPath.toUTF16z, wcsnullptr, wcsnullptr, 1);
            if (err <= 32)
                writefln("error code: %d, %s", err, shellExecuteErrorStrings(err));
        }

        static string shellExecuteErrorStrings(int err)
        {
            switch (err)
            {
                case 0: return "error out of memory";
                case ERROR_FILE_NOT_FOUND: return "ERROR_FILE_NOT_FOUND";
                case ERROR_PATH_NOT_FOUND: return "ERROR_PATH_NOT_FOUND";
    //            case ERROR_BAD_FORMAT: return "ERROR_BAD_FORMAT";
                default: return err > 32 ? "success" : "error";
            }
        }
    }
}
