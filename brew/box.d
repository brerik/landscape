/*
 * Brew Miscellaneous Library by Brother Erik Wikforss
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
module brew.box;
private import brew.vec;
private import brew.dim;
private import brew.math;
private import brew.insets;
private import std.string;
private import std.stdio;

mixin template TBox1(T)
{
    mixin TVec1!T;
    mixin TDim1!T;;

    pure T centerX() const
    {
        return x + halfWidth;
    }

    pure T left() const
    {
        return x;
    }

    pure T right() const
    {
        return x + width;
    }

    pure T alignedX(T alignX) const
    {
        return x + width * alignX;
    }

    pure bool pointInX(T px) const
    {
        return px >= x && px < x + width;
    }

    pure T minX() const
    {
        return left;
    }

    pure T maxX() const
    {
        return right;
    }
}

mixin template TBox2(T)
{
    mixin TVec2!T;
    mixin TDim2!T;

    pure T centerY() const
    {
        return y + halfHeight;
    }

    pure T top() const
    {
        return y;
    }

    pure T bottom() const
    {
        return y + height;
    }

    pure T alignedY(T alignY) const
    {
        return y + height * alignY;
    }

    pure bool pointInY(T py) const
    {
        return py >= y && py < y + height;
    }

    pure T minY() const
    {
        return top;
    }

    pure T maxY() const
    {
        return bottom;
    }
}

mixin template TBox3(T)
{
    mixin TVec3!T;
    mixin TDim3!T;

    pure T centerZ() const
    {
        return z + halfDepth;
    }

    pure T near() const
    {
        return z;
    }

    pure T far() const
    {
        return z + depth;
    }

    pure T alignedZ(T alignZ) const
    {
        return z + depth * alignZ;
    }

    pure bool pointInZ(T pz) const
    {
        return pz >= z && pz < z + depth;
    }

    pure T minZ() const
    {
        return near;
    }

    pure T maxZ() const
    {
        return far;
    }
}

mixin template TBox4(T)
{
    mixin TVec4!T;
    mixin TDim4!T;

    pure T centerW() const
    {
        return w + halfWeight;
    }

    pure T alignedW(T alignW) const
    {
        return w + weight * alignW;
    }

    pure bool pointInW(T pw) const
    {
        return pw >= w && pw < w + weight;
    }

    pure T minW() const
    {
        return w;
    }

    pure T maxW() const
    {
        return w + weight;
    }
}

struct Box(int D, T)
{
    static assert (D >= 1);
    static assert (D <= 4);

    alias Math!T MathT;
    alias Vec!(D,T) VecDT;
    alias Dim!(D,T) DimDT;
    alias Box!(D,T) BoxDT;

    static if (D>=1) mixin TBox1!T;
    static if (D>=2) mixin TBox2!T;
    static if (D>=3) mixin TBox3!T;
    static if (D>=4) mixin TBox4!T;

    string toString()
    {
        return format("Box%d%s[%s]", D, T.mangleof, paramString);
    }

    string paramString() const
    {
        return format("%s, %s", pos.paramString, dim.paramString);
    }

    static pure Box!(1,T) opCall(T x, T width)
    {
        Box!(1,T) b = {x, width};
        return b;
    }

    static pure Box!(2,T) opCall(T x, T y, T width, T height)
    {
        Box!(2,T) b = {x, width, y, height};
        return b;
    }

    static pure Box!(3,T) opCall(T x, T y, T z, T width, T height, T depth)
    {
        Box!(3,T) b = {x, width, y, height, z, depth};
        return b;
    }

    static pure Box!(4,T) opCall(T x, T y, T z, T w, T width, T height, T depth, T weight)
    {
        Box!(4,T) b = {x, width, y, height, z, depth, w, weight};
        return b;
    }

    static pure BoxDT opCall(VecDT p, DimDT d)
    {
        static if (D==1) BoxDT b = {p.x, d.width};
        static if (D==2) BoxDT b = {p.x, d.width, p.y, d.height};
        static if (D==3) BoxDT b = {p.x, d.width, p.y, d.height, p.z, d.depth};
        static if (D==4) BoxDT b = {p.x, d.width, p.y, d.height, p.z, d.depth, p.w, d.weight};
        return b;
    }

    static pure BoxDT opCall(in VecDT p1, in VecDT p2)
    {
        BoxDT b;
        VecDT pmin = VecDT.min(p1,p2);
        VecDT pmax = VecDT.max(p1,p2);
        static if (D>=1)
        {
            b.x = pmin.x;
            b.width = pmax.x - pmin.x;
        }
        static if (D>=2)
        {
            b.y = pmin.y;
            b.height = pmax.y - pmin.y;
        }
        static if (D>=3)
        {
            b.z = pmin.z;
            b.depth = pmax.z - pmin.z;
        }
        static if (D>=4)
        {
            b.w = pmin.w;
            b.weight = pmax.w - pmin.w;
        }
        return b;
    }

    @property
    pure static Box zero()
    {
        return Box(VecDT.zero, DimDT.zero);
    }
    @property
    pure static Box ones()
    {
        return Box(VecDT.ones, DimDT.ones);
    }

    @property
    pure static Box nan()
    {
        return Box(VecDT.nan, DimDT.nan);
    }

    VecDT centerPos() const
    {
        static if (D==1) return VecDT(centerX);
        static if (D==2) return VecDT(centerX, centerY);
        static if (D==3) return VecDT(centerX, centerY, centerZ);
        static if (D==4) return VecDT(centerX, centerY, centerZ, centerW);
    }

    VecDT pos() const
    {
        static if (D==1) return VecDT(x);
        static if (D==2) return VecDT(x, y);
        static if (D==3) return VecDT(x, y, z);
        static if (D==4) return VecDT(x, y, z, w);
    }

    VecDT farPos() const
    {
        static if (D==1) return VecDT(x+width);
        static if (D==2) return VecDT(x+width, y+height);
        static if (D==3) return VecDT(x+width, y+height, z+depth);
        static if (D==4) return VecDT(x+width, y+height, z+depth, w+weight);
    }

    DimDT dim() const
    {
        static if (D==1) return DimDT(width);
        static if (D==2) return DimDT(width, height);
        static if (D==3) return DimDT(width, height, depth);
        static if (D==4) return DimDT(width, height, depth, weight);
    }

    void dim(in DimDT d)
    {
        static if (D>=1) width = d.width;
        static if (D>=2) height = d.height;
        static if (D>=3) depth = d.height;
        static if (D>=4) weight = d.weight;
    }

    void pos(in VecDT p)
    {
        static if (D>=1) x = p.x;
        static if (D>=2) y = p.y;
        static if (D>=3) z = p.z;
        static if (D>=4) w = p.w;
    }

    pure Box unionWith(in Box b) const
    {
        return unionOf(this, b);
    }

    pure static Box unionOf(in Box b1, in Box b2)
    {
        VecDT p1 = VecDT.min(b1.pos, b2.pos);
        VecDT p2 = VecDT.max(b1.farPos, b2.farPos);
        return opCall(p1,p2);
    }

    static Box unionOf(in Box b1, in Box b2, bool function(in Box) accept)
    {
        if (accept(b1))
        {
            if(accept(b2))
                return unionOf(b1, b2);
            else
                return b1;
        }
        else
        {
            return b2;
        }
    }

    pure bool isNotZero() const
    {
        return this != zero;
    }

    pure bool isZero() const
    {
        return this == zero;
    }

    pure bool isNan() const
    {
        return this == nan;
    }

    pure bool isNotNan() const
    {
        return this != nan;
    }

    void opAddAssign(in VecDT v)
    {
        static if (D>=1) x += v.x;
        static if (D>=2) y += v.y;
        static if (D>=3) z += v.z;
        static if (D>=4) w += v.w;
    }

    void opSubAssign(in VecDT v)
    {
        static if (D>=1) x -= v.x;
        static if (D>=2) y -= v.y;
        static if (D>=3) z -= v.z;
        static if (D>=4) w -= v.w;
    }

    pure Box opAdd(in VecDT a) const
    {
        Box b = this;
        b.pos = b.pos + a;
        return b;
    }
    pure Box opSub(in VecDT a) const
    {
        Box b = this;
        b.pos = b.pos - a;
        return b;
    }
    pure Box opAdd(in Box a) const
    {
        Box b = this;
        b.pos = b.pos + a.pos;
        static if (D>=1) b.width += a.width;
        static if (D>=2) b.height += a.height;
        static if (D>=3) b.depth += a.depth;
        static if (D>=4) b.weight += a.weight;
        return b;
    }
    pure Box opSub(in BoxDT a) const
    {
        Box b = this;
        b.pos = b.pos - a.pos;
        static if (D>=1) b.width -= a.width;
        static if (D>=2) b.height -= a.height;
        static if (D>=3) b.depth -= a.depth;
        static if (D>=4) b.weight -= a.weight;
        return b;
    }
    pure Box opMul(in BoxDT a) const
    {
        Box b = this;
        b.pos = b.pos * a.pos;
        static if (D>=1) b.width *= a.width;
        static if (D>=2) b.height *= a.height;
        static if (D>=3) b.depth *= a.depth;
        static if (D>=4) b.weight *= a.weight;
        return b;
    }
    pure Box opMul(in T a) const
    {
        Box b = this;
        b.pos = b.pos * a;
        static if (D>=1) b.width *= a;
        static if (D>=2) b.height *= a;
        static if (D>=3) b.depth *= a;
        static if (D>=4) b.weight *= a;
        return b;
    }
    pure Box opDiv(in T a) const
    {
        Box b = this;
        b.pos = b.pos / a;
        static if (D>=1) b.width /= a;
        static if (D>=2) b.height /= a;
        static if (D>=3) b.depth /= a;
        static if (D>=4) b.weight /= a;
        return b;
    }

    pure Box translated(in VecDT v) const
    {
        Box b = this;
        static if (D>=1) b.x += v.x;
        static if (D>=2) b.y += v.y;
        static if (D>=3) b.z += v.z;
        static if (D>=4) b.w += v.w;
        return b;
    }

    void translate(in VecDT v)
    {
        static if (D>=1) x += v.x;
        static if (D>=2) y += v.y;
        static if (D>=3) z += v.z;
        static if (D>=4) w += v.w;
    }

    pure VecDT alignedPoint(in VecDT alignment) const
    {
        VecDT v;
        static if (D>=1) v.x = alignedX(alignment.x);
        static if (D>=2) v.y = alignedY(alignment.y);
        static if (D>=3) v.z = alignedZ(alignment.z);
        static if (D>=4) v.w = alignedW(alignment.w);
        return v;
    }

    Box opSub(in Insets!(D,T) insets) const
    {
        return subInsets(insets);
    }

    Box!(D,T) subInsets(in Insets!(D,T) insets) const
    {
        Box!(D,T) b = this;
        static if (D>=1)
        {
            b.x += insets.left;
            b.width -= insets.width;
        }
        static if (D>=2)
        {
            b.y += insets.top;
            b.height -= insets.height;
        }
        static if (D>=3)
        {
            b.z += insets.front;
            b.depth -= insets.depth;
        }
        static if (D>=4)
        {
            b.w += insets.light;
            b.weight -= insets.heavy;
        }
        return b;
    }

    Box opAdd(in Insets!(D,T) insets) const
    {
        return addInsets(insets);
    }

    Box addInsets(in Insets!(D,T) insets) const
    {
        Box b = this;
        static if (D>=1)
        {
            b.x -= insets.left;
            b.width += insets.width;
        }
        static if (D>=2)
        {
            b.y -= insets.top;
            b.height += insets.height;
        }
        static if (D>=3)
        {
            b.z -= insets.front;
            b.depth += insets.depth;
        }
        static if (D>=4)
        {
            b.w -= insets.light;
            b.weight += insets.heavy;
        }
        return b;
    }

    Box withDim(DimDT d) const
    {
        return Box(pos, d);
    }
    Box withPos(VecDT p) const
    {
        return Box(p, dim);
    }

    static if (D>=1)
    {
        Box withX(T x) const
        {
            Box b = this;
            b.x = x;
            return b;
        }
        Box withWidth(T width) const
        {
            Box b = this;
            b.width = width;
            return b;
        }
    }
    static if (D>=2)
    {
        Box withY(T y) const
        {
            Box b = this;
            b.y = y;
            return b;
        }
        Box withHeight(T height) const
        {
            Box b = this;
            b.height = height;
            return b;
        }
        Vec!(2,T) topLeft() const
        {
            return Vec!(2,T)(left, top);
        }
        Vec!(2,T) bottomRight() const
        {
            return Vec!(2,T)(right, bottom);
        }
    }
    static if (D>=3)
    {
        Box withZ(T z) const
        {
            Box b = this;
            b.z = z;
            return b;
        }
        Box withDepth(T depth) const
        {
            Box b = this;
            b.depth = depth;
            return b;
        }
    }
    static if (D>=4)
    {
        Box withW(T w) const
        {
            Box b = this;
            b.w = w;
            return b;
        }
        Box withWeight(T weight) const
        {
            Box b = this;
            b.weight = weight;
            return b;
        }
    }
    bool pointIn(in VecDT p) const
    {
        static if (D==1) return pointInX(p.x);
        static if (D==2) return pointInX(p.x) && pointInY(p.y);
        static if (D==3) return pointInX(p.x) && pointInY(p.y) && pointInZ(p.z);
        static if (D==4) return pointInX(p.x) && pointInY(p.y) && pointInZ(p.z) && pointInW(p.w);
    }
    static Box lerp(T t, in Box b0, in Box b1)
    {
        return b0 + ((b1-b0) * t);
    }
    static Box lerp(T t, in Box b0, in Box b1, T d)
    {
        return b0 + ((b1-b0) * t) / d;
    }

    Box scaled(in VecDT s) const
    {
        Box r = this;
        static if (D>=1)
        {
            r.x *= s.x;
            r.width *= s.x;
        }
        static if (D>=2)
        {
            r.y *= s.y;
            r.height *= s.y;
        }
        static if (D>=3)
        {
            r.z *= s.z;
            r.depth *= s.z;
        }
        static if (D>=4)
        {
            r.w *= s.w;
            r.weight *= s.w;
        }
        return r;
    }
}

alias Box!(1,float) Box1f;
alias Box!(2,float) Box2f;
alias Box!(3,float) Box3f;
alias Box!(4,float) Box4f;
alias Box!(1,double) Box1d;
alias Box!(2,double) Box2d;
alias Box!(3,double) Box3d;
alias Box!(4,double) Box4d;
alias Box!(1,real) Box1r;
alias Box!(2,real) Box2r;
alias Box!(3,real) Box3r;
alias Box!(4,real) Box4r;
alias Box!(1,int) Box1i;
alias Box!(2,int) Box2i;
alias Box!(3,int) Box3i;
alias Box!(4,int) Box4i;

unittest
{
    Box2d b2d = Box2d(1.0,2.0,3.0,4.0);
    writeln(b2d.toString);
    Box2i b2i = Box2i(1,2,3,4);
    writeln(b2i.toString);
    assert (b2d.x == 1.0);
    assert (b2d.y == 2.0);
    assert (b2d.width == 3.0);
    assert (b2d.height == 4.0);
}

