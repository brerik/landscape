/*
 * Brew Miscellaneous Library by Brother erik wikforss
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
module brew.insets;
private import std.string;

mixin template TInsets1(T)
{
    T left;
    T right;

    T width() const
    {
        return left + right;
    }
    void swapLeftRight()
    {
        T t = left;
        left = right;
        right = t;
    }
}

mixin template TInsets2(T)
{
    T top;
    T bottom;

    T height() const
    {
        return top + bottom;
    }

    void swapTopBottom()
    {
        T t = top;
        top = bottom;
        bottom = t;
    }
}

mixin template TInsets3(T)
{
    T front;
    T back;

    T depth() const
    {
        return front + back;
    }

    void swapFrontBack()
    {
        T t = front;
        front = back;
        back = t;
    }
}
mixin template TInsets4(T)
{
    T light;
    T heavy;

    T weight() const
    {
        return light + heavy;
    }

    void swapLightHeavy()
    {
        T t = light;
        light = heavy;
        heavy = t;
    }
}

struct Insets(int D, T)
{
    static assert (D>=1 && D<=4);

    static if (D>=1) mixin TInsets1!T;
    static if (D>=2) mixin TInsets2!T;
    static if (D>=3) mixin TInsets3!T;
    static if (D>=4) mixin TInsets4!T;

    enum {
        ONES = fill(1),
        ZERO = fill(0),
    }

    static if (D==1)
    {
        static pure Insets!(1,T) opCall(T left, T right)
        {
            Insets!(1,T) i = {left, right};
            return i;
        }

        void set(T left, T right)
        {
            this.left = left;
            this.right = right;
        }
    }

    static if (D==2)
    {
        static pure Insets!(2,T) opCall(T left, T right, T top, T bottom)
        {
            Insets!(2,T) i = {left, right, top, bottom};
            return i;
        }

        void set(T left, T right, T top, T bottom)
        {
            this.left = left;
            this.right = right;
            this.top = top;
            this.bottom = bottom;
        }
    }

    static if (D==3)
    {
        static pure Insets!(3,T) opCall(T left, T right, T top, T bottom, T front, T back)
        {
            Insets!(3,T) i = {left, right, top, bottom, front, back};
            return i;
        }

        void set(T left, T right, T top, T bottom, T front, T back)
        {
            this.left = left;
            this.right = right;
            this.top = top;
            this.bottom = bottom;
            this.front = front;
            this.back = back;
        }
    }

    static if (D==4)
    {
        static pure Insets!(4,T) opCall(T left, T right, T top, T bottom, T front, T back, T light, T heavy)
        {
            Insets!(4,T) i = {left, right, top, bottom, front, back, light, heavy};
            return i;
        }

        void set(T left, T right, T top, T bottom, T front, T back, T light, T heavy)
        {
            this.left = left;
            this.right = right;
            this.top = top;
            this.bottom = bottom;
            this.front = front;
            this.back = back;
            this.light = light;
            this.heavy = heavy;
        }
    }

    @property
    static pure Insets zero()
    {
        return fill(0);
    }

    @property
    static pure Insets ones()
    {
        return fill(1);
    }

    static pure Insets fill(T a)
    {
        static if (D==1) return Insets!(1,T)(a,a);
        static if (D==2) return Insets!(2,T)(a,a,a,a);
        static if (D==3) return Insets!(3,T)(a,a,a,a,a,a);
        static if (D==4) return Insets!(4,T)(a,a,a,a,a,a,a,a);
    }

    void setAll(T a)
    {
        this = Insets.fill(a);
    }

    string toString() const
    {
        return format("Insets%d%s[%s]", D, T.mangleof, paramString);
    }

    string paramString() const
    {
        static if (__traits(isFloating, T))
        {
            static if (D==1) return format("left=%f, right=%f", left, right);
            static if (D==2) return format("left=%f, right=%f, top=%f, bottom=%f", left, right, top, bottom);
            static if (D==3) return format("left=%f, right=%f, top=%f, bottom=%f, front=%f, back=%f", left, right, top, bottom, front, back);
            static if (D==4) return format("left=%f, right=%f, top=%f, bottom=%f, front=%f, back=%f, light=%f, heavy=%f", left, right, top, bottom, front, back, light, heavy);
        }
        static if (__traits(isIntegral, T))
        {
            static if (D==1) return format("left=%d, right=%d", left, right);
            static if (D==2) return format("left=%d, right=%d, top=%d, bottom=%d", left, right, top, bottom);
            static if (D==3) return format("left=%d, right=%d, top=%d, bottom=%d, front=%d, back=%d", left, right, top, bottom, front, back);
            static if (D==4) return format("left=%d, right=%d, top=%d, bottom=%d, front=%d, back=%d, light=%d, heavy=%d", left, right, top, bottom, front, back, light, heavy);
        }
    }

    void swapSides()
    {
        static if (D>=1) swapLeftRight();
        static if (D>=2) swapTopBottom();
        static if (D>=3) swapFrontBack();
        static if (D>=4) swapLightHeavy();
    }

    Insets swappedSides()
    {
        Insets i = this;
        i.swapSides();
        return i;
    }
}

alias Insets insets_t;
alias insets_t!(2,double) insets_2d;
alias Insets!(1,int) Insets1i;
alias Insets!(2,int) Insets2i;
alias Insets!(3,int) Insets3i;
alias Insets!(1,float) Insets1f;
alias Insets!(2,float) Insets2f;
alias Insets!(3,float) Insets3f;
alias Insets!(1,double) Insets1d;
alias Insets!(2,double) Insets2d;
alias Insets!(3,double) Insets3d;
alias Insets!(1,real) Insets1r;
alias Insets!(2,real) Insets2r;
alias Insets!(3,real) Insets3r;
