/*
 * Brew Miscellaneous Library for GStr
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
module brew.gstr;
import glib.Str;
import glib.Unicode;
private import gtkc.gio;

/**
 * GLIB Str Extensions
 */
public final class GStr
{

	/*************************************************
	 * Convert C-style 0 terminated string s to char[] string.
	 * copied from phobos
	 */
	public static wstring toWString(char *s, size_t len = 0)
	{
		return toWString(Str.toString(s, len));
	}

	/*************************************************
	 * Convert C-style 0 terminated string s to char[] string.
	 * copied from phobos
	 */
	public static wstring toWString(string s)
	{
		if ( s is null )
		return cast(wstring)null;
		int words;
        auto s2 = cast(const(wchar)[])Unicode.utf8_ToUtf16(s, words);
		return s2.idup;
	}

	/*************************************************
	 * Convert C-style 0 terminated string s to char[] string.
	 * copied from phobos
	 */
	public static string toString(wchar *s, size_t len = 0)
	{
		if ( s is null )
		return cast(string)null;
		if (len == 0)
            len = wcslen(s);
		int words;
        return Unicode.utf16_ToUtf8(cast(ushort[])(s[0..len].dup), words);
	}

	/*************************************************
	 * Convert C-style 0 terminated string s to char[] string.
	 * copied from phobos
	 */
	public static string toString(wstring s)
	{
		if ( s is null )
		return cast(string)null;
		int words;
        wchar s1[] = s[0..$].dup;
        auto s2 = Unicode.utf16_ToUtf8(cast(ushort[])(s1), words);
		return s2.idup;
	}

	/*********************************
	 * Convert array of chars s[] to a C-style 0 terminated string.
	 * copied from phobos
	 */
	public static char* toStringz(wstring s)
	{
		return Str.toStringz(toString(s));
	}

	public static size_t wcslen(wchar *s)
	{
	    if (s is null)
            return 0;
        size_t len = 0;
        while (s[len] != 0)
            len++;
        return len;
	}
}


