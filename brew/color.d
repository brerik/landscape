/*
 * Brew Miscellaneous Library by Brother Erik Wigforss
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
module brew.color;
private import brew.math;
private import std.string;

mixin template ColorRed(T)
{
    T red;

    int redi() const
    {
        return cast(int)(red * 255);
    }
}
mixin template ColorGreen(T)
{
    T green;

    int greeni() const
    {
        return cast(int)(green * 255);
    }
}
mixin template ColorBlue(T)
{
    T blue;

    int bluei() const
    {
        return cast(int)(blue * 255);
    }
}
mixin template ColorAlpha(T)
{
    T alpha;

    int alphai() const
    {
        return cast(int)(alpha * 255);
    }
}

struct Color(int D, T)
{
    static assert (D>=3||D<=4);
    static if (D>=1) mixin ColorRed!T;
    static if (D>=2) mixin ColorGreen!T;
    static if (D>=3) mixin ColorBlue!T;
    static if (D>=4) mixin ColorAlpha!T;

    static if (D==3)
    {
        pure static Color!(3,T)opCall(T red, T green, T blue)
        {
            Color!(3,T) p = {red, green, blue};
            return p;
        }
    }

    static if (D==4)
    {
        pure static Color!(4,T)opCall(T red, T green, T blue, T alpha = 1)
        {
            Color!(4,T) p = {red, green, blue, alpha};
            return p;
        }
    }

    pure static Color black()
    {
        static if (D==3) return Color!(3,T)(0,0,0);
        static if (D==4) return Color!(4,T)(0,0,0,1);
    }

    pure static Color zero()
    {
        static if (D==3) return Color!(3,T)(0,0,0);
        static if (D==4) return Color!(4,T)(0,0,0,0);
    }

    pure static Color nan()
    {
        static if (D==3) return Color!(3,T)(T.nan,T.nan,T.nan);
        static if (D==4) return Color!(4,T)(T.nan,T.nan,T.nan,T.nan);
    }

    pure static Color white()
    {
        static if (D==3) return Color!(3,T)(1,1,1);
        static if (D==4) return Color!(4,T)(1,1,1,1);
    }

    string toString() const
    {
        return format("Color%d%s[%s]", D, T.mangleof, paramString);
    }

    string paramString() const
    {
        static if (D==3) return format("red=%f, green=%f, blue=%f", red, green, blue);
        static if (D==4) return format("red=%f, green=%f, blue=%f, alpha=%f", red, green, blue, alpha);
    }

    pure static T toT(int b)
    {
        return cast(T)b / cast(T)255;
    }

    int rgba() const
    {
        static if (D>=4) return rgba(redi, greeni, bluei, alphai);
        static if (D==3) return rgba(redi, greeni, bluei, 255);
    }

    pure static int rgba(int red, int green, int blue, int alpha = 255)
    {
        return ((red&255) << 16u) | ((green&255) << 8u) | (blue&255) | ((alpha&255) << 24u);
    }

    pure static clamp(int c)
    {
        return Mathi.clamp(c, 0, 255);
    }

    pure static clampAbove(int c)
    {
        return Mathi.clampAbove(c, 255);
    }

    pure static clampBelow(int c)
    {
        return Mathi.clampBelow(c, 0);
    }

    pure static clamp(T c)
    {
        return Math!T.clamp(c, 0, 1);
    }

    pure static clampAbove(T c)
    {
        return Math!T.clampAbove(c, 1);
    }

    pure static clampBelow(T c)
    {
        return Math!T.clampBelow(c, 0);
    }

    void set(T red, T green, T blue, T alpha=1)
    {
        static if (D>=1) this.red = red;
        static if (D>=2) this.blue = blue;
        static if (D>=3) this.green = green;
        static if (D>=4) this.alpha = alpha;
    }
}

alias Color!(3,float) Color3f;
alias Color!(4,float) Color4f;
alias Color!(3,double) Color3d;
alias Color!(4,double) Color4d;
alias Color!(3,real) Color3r;
alias Color!(4,real) Color4r;


