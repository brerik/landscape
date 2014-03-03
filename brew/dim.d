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
module brew.dim;
private import brew.math;
private import brew.vec;
private import std.string;
private import std.stdio;

mixin template TDim1(T)
{
    T width;

    pure T halfWidth() const
    {
        return Math!T.half(width);
    }
    T floorWidth() const
    {
        return Math!T.floor(width);
    }
    T roundWidth() const
    {
        return Math!T.round(width);
    }
    T ceilWidth() const
    {
        return Math!T.ceil(width);
    }
}
mixin template TDim2(T)
{
    T height;

    pure T halfHeight() const
    {
        return Math!T.half(height);
    }
    T floorHeight() const
    {
        return Math!T.floor(height);
    }
    T roundHeight() const
    {
        return Math!T.round(height);
    }
    T ceilHeight() const
    {
        return Math!T.ceil(height);
    }
}
mixin template TDim3(T)
{
    T depth;

    pure T halfDepth() const
    {
        return Math!T.half(depth);
    }
    T floorDepth() const
    {
        return Math!T.floor(depth);
    }
    T roundDepth() const
    {
        return Math!T.round(depth);
    }
    T ceilDepth() const
    {
        return Math!T.ceil(depth);
    }
}
mixin template TDim4(T)
{
    T weight;

    pure T halfWeight() const
    {
        return Math!T.half(weight);
    }
    T floorWeight() const
    {
        return Math!T.floor(weight);
    }
    T roundWeight() const
    {
        return Math!T.round(weight);
    }
    T ceilWeight() const
    {
        return Math!T.ceil(weight);
    }
}

struct Dim(int D, T)
{
    alias Math!T MathT;
    static assert (D>=1);
    static assert (D<=4);

    static if (D>=1) mixin TDim1!T;
    static if (D>=2) mixin TDim2!T;
    static if (D>=3) mixin TDim3!T;
    static if (D>=4) mixin TDim4!T;

    string toString() const
    {
        return format("Dim%d%s[%s]", D, T.mangleof, paramString);
    }

    string paramString() const
    {
        static if (__traits(isFloating, T))
        {
            static if (D==1) return format("width=%f", width);
            static if (D==2) return format("width=%f, height=%f", width, height);
            static if (D==3) return format("width=%f, height=%f, depth=%f", width, height, depth);
            static if (D==4) return format("width=%f, height=%f, depth=%f, weight=%f", width, height, depth, weight);
        }
        static if (__traits(isIntegral, T))
        {
            static if (D==1) return format("width=%d", width);
            static if (D==2) return format("width=%d, height=%d", width, height);
            static if (D==3) return format("width=%d, height=%d, depth=%d", width, height, depth);
            static if (D==4) return format("width=%d, height=%d, depth=%d, weight=%d", width, height, depth, weight);
        }
    }

    pure static Dim!(1,T) opCall(T width)
    {
        Dim!(1,T) d = {width};
        return d;
    }
    pure static Dim!(2,T) opCall(T width, T height)
    {
        Dim!(2,T) d = {width, height};
        return d;
    }
    pure static Dim!(3,T) opCall(T width, T height, T depth)
    {
        Dim!(3,T) d = {width, height, depth};
        return d;
    }
    pure static Dim!(4,T) opCall(T width, T height, T depth, T weight)
    {
        Dim!(4,T) d = {width, height, depth, weight};
        return d;
    }

    pure static Dim fill(T a)
    {
        static if (D==1) return Dim(a);
        static if (D==2) return Dim(a,a);
        static if (D==3) return Dim(a,a,a);
        static if (D==4) return Dim(a,a,a,a);
    }

    @property
    pure static Dim zero()
    {
        return fill(0);
    }

    @property
    pure static Dim ones()
    {
        return fill(1);
    }

    @property
    pure static Dim nan()
    {
        static if (__traits(hasMember, T, "nan")) T NAN = T.nan;
        static if (!__traits(hasMember, T, "nan")) T NAN = 0;
        return fill(NAN);
    }

    Dim halfDim() const
    {
        static if (D==1) return Dim(halfWidth);
        static if (D==2) return Dim(halfWidth, halfHeight);
        static if (D==3) return Dim(halfWidth, halfHeight, halfDepth);
        static if (D==4) return Dim(halfWidth, halfHeight, halfDepth, halfWeight);
    }

    Vec!(D,T) centerPos() const
    {
        static if (D==1) return Vec!(D,T)(halfWidth);
        static if (D==2) return Vec!(D,T)(halfWidth, halfHeight);
        static if (D==3) return Vec!(D,T)(halfWidth, halfHeight, halfDepth);
        static if (D==4) return Vec!(D,T)(halfWidth, halfHeight, halfDepth, halfWeight);
    }

    static if (D==1)
    {
        void set(T width)
        {
            this.width = width;
        }
    }
    static if (D==2)
    {
        void set(T width, T height)
        {
            this.width = width;
            this.height = height;
        }
    }
    static if (D==3)
    {
        void set(T width, T height, T depth)
        {
            this.width = width;
            this.height = height;
            this.depth = depth;
        }
    }
    static if (D==4)
    {
        void set(T width, T height, T depth, T weight)
        {
            this.width = width;
            this.height = height;
            this.depth = depth;
            this.weight = weight;
        }
    }

    Dim clampNan(in Dim minDim, in Dim maxDim) const
    {
        alias Math!T.clampNan clampNan;
        Dim res = this;
        static if (D>=1) res.width = clampNan(res.width, minDim.width, maxDim.width);
        static if (D>=2) res.height = clampNan(res.height, minDim.height, maxDim.height);
        static if (D>=3) res.depth = clampNan(res.depth, minDim.depth, maxDim.depth);
        static if (D>=4) res.weight = clampNan(res.weight, minDim.weight, maxDim.weight);
        return res;
    }

    Dim clampAccept(in Dim minDim, in Dim maxDim, bool function(T) accept) const
    {
        alias Math!T.clampAccept clampAccept;
        Dim res = this;
        static if (D>=1) res.width = clampAccept(res.width, minDim.width, maxDim.width, accept);
        static if (D>=2) res.height = clampAccept(res.height, minDim.height, maxDim.height, accept);
        static if (D>=3) res.depth = clampAccept(res.depth, minDim.depth, maxDim.depth, accept);
        static if (D>=4) res.weight = clampAccept(res.weight, minDim.weight, maxDim.weight, accept);
        return res;
    }

    static pure Dim max(in Dim d1, in Dim d2)
    {
        alias Math!T.max max;
        Dim res;
        static if (D>=1) res.width = max(d1.width, d2.width);
        static if (D>=2) res.height = max(d1.height, d2.height);
        static if (D>=3) res.depth = max(d1.depth, d2.depth);
        static if (D>=4) res.weight = max(d1.weight, d2.weight);
        return res;
    }

    static pure Dim min(in Dim d1, in Dim d2)
    {
        alias Math!T.min min;
        Dim res;
        static if (D>=1) res.width = min(d1.width, d2.width);
        static if (D>=2) res.height = min(d1.height, d2.height);
        static if (D>=3) res.depth = min(d1.depth, d2.depth);
        static if (D>=4) res.weight = min(d1.weight, d2.weight);
        return res;
    }

    pure Dim opAdd(in Dim d) const
    {
        Dim res;
        static if (D>=1) res.width = width + d.width;
        static if (D>=2) res.height = height + d.height;
        static if (D>=3) res.depth = depth + d.depth;
        static if (D>=4) res.weight = weight + d.weight;
        return res;
    }
}
alias Dim!(1,float) Dim1f;
alias Dim!(2,float) Dim2f;
alias Dim!(3,float) Dim3f;
alias Dim!(4,float) Dim4f;
alias Dim!(1,double) Dim1d;
alias Dim!(2,double) Dim2d;
alias Dim!(3,double) Dim3d;
alias Dim!(3,double) Dim4d;
alias Dim!(1,real) Dim1r;
alias Dim!(2,real) Dim2r;
alias Dim!(3,real) Dim3r;
alias Dim!(4,real) Dim4r;
alias Dim!(1,int) Dim1i;
alias Dim!(2,int) Dim2i;
alias Dim!(3,int) Dim3i;
alias Dim!(4,int) Dim4i;

unittest
{
    Dim4f d4 = {1,2,3,4};
    writeln(d4.toString);
    Dim2f d2 = {1,2};
    writeln(d2.toString);
}





