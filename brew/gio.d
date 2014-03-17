/*
 * Brew Miscellaneous Library for GIO File Extensions
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
module brew.gio;
import brew.gstr;
import gio.File;
import gtkc.gio;
alias gio.File.File GioFile;


/**
 * Gets the base name (the last component of the path) for a given GFile.
 * If called for the top level of a system (such as the filesystem root
 * or a uri like sftp://host/) it will return a single directory separator
 * (and on Windows, possibly a drive letter).
 * The base name is a byte string (not UTF-8). It has no defined encoding
 * or rules other than it may not contain zero bytes. If you want to use
 * filenames in a user interface you should use the display name that you
 * can get by requesting the G_FILE_ATTRIBUTE_STANDARD_DISPLAY_NAME
 * attribute with g_file_query_info().
 * This call does no blocking I/O.
 * Returns: string containing the GFile's base name, or NULL if given GFile is invalid. The returned string should be freed with g_free() when no longer needed.
 */
wstring getBasenameW(GioFile f)
{
    // char * g_file_get_basename (GFile *file);
    return GStr.toWString(g_file_get_basename(f.getFileStruct));
}

/**
 * Gets the local pathname for GFile, if one exists.
 * This call does no blocking I/O.
 * Returns: string containing the GFile's path, or NULL if no such path exists. The returned string should be freed with g_free() when no longer needed.
 */
wstring getPathW(GioFile f)
{
    // char * g_file_get_path (GFile *file);
    return GStr.toWString(g_file_get_path(f.getFileStruct));
}

