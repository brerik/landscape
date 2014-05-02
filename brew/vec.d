/*
 * Brew Library by erik wikforss
 */
module brew.vec;
private import brew.math;
private import std.string;
private import std.stdio;

mixin template TVec1(T)
{
    alias Math!T MathT;
    T x;
    pure T negX() const
    {
        return MathT.neg(x);
    }
    pure T invX() const
    {
        return MathT.inv(x);
    }
    pure T sqrX() const
    {
        return MathT.sqr(x);
    }
    pure T absX() const
    {
        return MathT.abs(x);
    }
    T floorX() const
    {
        return MathT.floor(x);
    }
    T roundX() const
    {
        return MathT.round(x);
    }
    T ceilX() const
    {
        return MathT.ceil(x);
    }
}
mixin template TVec2(T)
{
    alias Math!T MathT;
    T y;
    pure T negY() const
    {
        return MathT.neg(y);
    }
    pure T invY() const
    {
        return MathT.inv(y);
    }
    pure T sqrY() const
    {
        return MathT.sqr(y);
    }
    pure T absY() const
    {
        return MathT.abs(y);
    }
    T floorY() const
    {
        return MathT.floor(y);
    }
    T roundY() const
    {
        return MathT.round(y);
    }
    T ceilY() const
    {
        return MathT.ceil(y);
    }
}
mixin template TVec3(T)
{
    alias Math!T MathT;
    T z;
    pure T negZ() const
    {
        return MathT.neg(z);
    }
    pure T invZ() const
    {
        return MathT.inv(z);
    }
    pure T sqrZ() const
    {
        return MathT.sqr(z);
    }
    pure T absZ() const
    {
        return MathT.abs(z);
    }
    T floorZ() const
    {
        return MathT.floor(z);
    }
    T roundZ() const
    {
        return MathT.round(z);
    }
    T ceilZ() const
    {
        return MathT.ceil(z);
    }
}
mixin template TVec4(T)
{
    alias Math!T MathT;
    T w;
    pure T negW() const
    {
        return MathT.neg(w);
    }
    pure T invW() const
    {
        return MathT.inv(w);
    }
    pure T sqrW() const
    {
        return MathT.sqr(w);
    }
    pure T absW() const
    {
        return MathT.abs(w);
    }
    T floorW() const
    {
        return MathT.floor(w);
    }
    T roundW() const
    {
        return MathT.round(w);
    }
    T ceilW() const
    {
        return MathT.ceil(w);
    }
}
struct Vec(int D, T)
{
    static assert (D>=1);
    static assert (D<=4);
    alias Math!T MathT;
    alias Vec!(1,T) Vec1;
    alias Vec!(2,T) Vec2;
    alias Vec!(3,T) Vec3;
    alias Vec!(4,T) Vec4;

    static if (D>=1) mixin TVec1!T;
    static if (D>=2) mixin TVec2!T;
    static if (D>=3) mixin TVec3!T;
    static if (D>=4) mixin TVec4!T;

    pure static Vec1 opCall(T x)
    {
        Vec1 v = {x};
        return v;
    }

    pure static Vec2 opCall(T x, T y)
    {
        Vec2 v = {x,y};
        return v;
    }

    pure static Vec3 opCall(T x, T y, T z)
    {
        Vec3 v = {x,y,z};
        return v;
    }

    pure static Vec4 opCall(T x, T y, T z, T w)
    {
        Vec4 v = {x,y,z,w};
        return v;
    }

    pure static Vec fill(T a)
    {
        static if (D==1) return Vec(a);
        static if (D==2) return Vec(a,a);
        static if (D==3) return Vec(a,a,a);
        static if (D==4) return Vec(a,a,a,a);
    }

    @property
    pure static Vec zero()
    {
        return fill(0);
    }

    @property
    pure static Vec ones()
    {
        return fill(1);
    }

    @property
    pure static Vec halves()
    {
        return fill(cast(T).5);
    }

    @property
    pure static Vec negOnes()
    {
        return fill(-1);
    }

    @property
    pure static Vec unitX()
    {
        static if (D==1) return Vec(1);
        static if (D==2) return Vec(1,0);
        static if (D==3) return Vec(1,0,0);
        static if (D==4) return Vec(1,0,0,0);
    }

    @property
    pure static Vec negUnitX()
    {
        static if (D==1) return Vec(-1);
        static if (D==2) return Vec(-1,0);
        static if (D==3) return Vec(-1,0,0);
        static if (D==4) return Vec(-1,0,0,0);
    }

    @property
    pure static Vec unitY()
    {
        static if (D==1) return Vec(0);
        static if (D==2) return Vec(0,1);
        static if (D==3) return Vec(0,1,0);
        static if (D==4) return Vec(0,1,0,0);
    }

    @property
    pure static Vec negUnitY()
    {
        static if (D==1) return Vec(0);
        static if (D==2) return Vec(0,-1);
        static if (D==3) return Vec(0,-1,0);
        static if (D==4) return Vec(0,-1,0,0);
    }

    @property
    pure static Vec unitZ()
    {
        static if (D==1) return Vec(0);
        static if (D==2) return Vec(0,0);
        static if (D==3) return Vec(0,0,1);
        static if (D==4) return Vec(0,0,1,0);
    }

    @property
    pure static Vec negUnitZ()
    {
        static if (D==1) return Vec(0);
        static if (D==2) return Vec(0,0);
        static if (D==3) return Vec(0,0,-1);
        static if (D==4) return Vec(0,0,-1,0);
    }

    @property
    pure static Vec unitW()
    {
        static if (D==1) return Vec(0);
        static if (D==2) return Vec(0,0);
        static if (D==3) return Vec(0,0,0);
        static if (D==4) return Vec(0,0,0,1);
    }

    @property
    pure static Vec negUnitW()
    {
        static if (D==1) return Vec(0);
        static if (D==2) return Vec(0,0);
        static if (D==3) return Vec(0,0,0);
        static if (D==4) return Vec(0,0,0,-1);
    }

    @property
    pure static Vec nan()
    {
        static if (__traits(hasMember, T, "nan")) T NAN = T.nan;
        static if (!__traits(hasMember, T, "nan")) T NAN = 0;
        return fill(NAN);
    }

    string toString() const
    {
        return format("Vec%d%s[%s]", D, T.mangleof, paramString);
    }

    string paramString() const
    {
        static if (__traits(isFloating, T))
        {
            static if (D==1) return format("x=%f", x);
            static if (D==2) return format("x=%f, y=%f", x, y);
            static if (D==3) return format("x=%f, y=%f, z=%f", x, y, z);
            static if (D==4) return format("x=%f, y=%f, z=%f, w=%f", x, y, z, w);
        }
        static if (__traits(isIntegral, T))
        {
            static if (D==1) return format("x=%d", x);
            static if (D==2) return format("x=%d, y=%d", x, y);
            static if (D==3) return format("x=%d, y=%d, z=%d", x, y, z);
            static if (D==4) return format("x=%d, y=%d, z=%d, w=%d", x, y, z, w);
        }
    }

    pure Vec opNeg() const
    {
        return neg;
    }

    pure Vec opAdd(in Vec v) const
    {
        return add(this, v);
    }

    void opAddAssign(in Vec v)
    {
        this = add(this, v);
    }

    pure Vec opSub(in Vec v) const
    {
        return sub(this, v);
    }

    void opSubAssign(in Vec v)
    {
        this = sub(this, v);
    }

    pure Vec opMul(in Vec v) const
    {
        return mul(this, v);
    }

    void opMulAssign(in Vec v)
    {
        this = mul(this, v);
    }

    pure Vec opMul(T s) const
    {
        return mul(this, s);
    }

    void opMulAssign(T s)
    {
        this = mul(this, s);
    }

    pure Vec opDiv(in Vec v) const
    {
        return div(this, v);
    }

    void opDivAssign(in Vec v)
    {
        this = div(this, v);
    }

    pure Vec opDiv(T s) const
    {
        return div(this, s);
    }

    void opDivAssign(T s)
    {
        this = div(this, s);
    }

    pure T dot(in Vec v) const
    {
        return dot(this, v);
    }

    pure Vec sub(in Vec v) const
    {
        return sub(this, v);
    }

    pure Vec add(in Vec v) const
    {
        return add(this, v);
    }

    pure Vec mul(in Vec v) const
    {
        return mul(this, v);
    }

    pure Vec mul(T s) const
    {
        return mul(this, s);
    }

    pure Vec div(in Vec v) const
    {
        return div(this, v);
    }

    pure Vec div(T s) const
    {
        return div(this, s);
    }

    pure T mag() const
    {
        static if (D==1) return x;
        static if (D==2) return MathT.mag2(x, y);
        static if (D==3) return MathT.mag3(x, y, z);
        static if (D==4) return MathT.mag4(x, y, z, w);
    }

    pure T magSqr() const
    {
        static if (D==1) return sqrX;
        static if (D==2) return MathT.magSqr2(x, y);
        static if (D==3) return MathT.magSqr3(x, y, z);
        static if (D==4) return MathT.magSqr4(x, y, z, w);
    }

    pure T invMag() const
    {
        static if (D==1) return invX;
        static if (D==2) return MathT.invMag2(x, y);
        static if (D==3) return MathT.invMag3(x, y, z);
        static if (D==4) return MathT.invMag4(x, y, z, w);
    }

    pure Vec inv() const
    {
        static if (D==1) return Vec(invX);
        static if (D==2) return Vec(invX, invY);
        static if (D==3) return Vec(invX, invY, invZ);
        static if (D==4) return Vec(invX, invY, invZ, invW);
    }

    pure Vec neg() const
    {
        static if (D==1) return Vec(negX);
        static if (D==2) return Vec(negX, negY);
        static if (D==3) return Vec(negX, negY, negZ);
        static if (D==4) return Vec(negX, negY, negZ, negW);
    }

    pure Vec normalized() const
    {
        return div(mag);
    }

    void normalize()
    {
        this = div(mag);
    }

    pure static Vec clamp(in Vec v, in Vec vMin, in Vec vMax)
    {
        return min(max(v, vMin), vMax);
    }

    pure static Vec min(in Vec v1, in Vec v2)
    {
        Vec v;
        static if (D >= 1) v.x = MathT.min(v1.x, v2.x);
        static if (D >= 2) v.y = MathT.min(v1.y, v2.y);
        static if (D >= 3) v.z = MathT.min(v1.z, v2.z);
        static if (D >= 4) v.w = MathT.min(v1.w, v2.w);
        return v;
    }

    pure static Vec max(in Vec v1, in Vec v2)
    {
        Vec v;
        static if (D >= 1) v.x = MathT.max(v1.x, v2.x);
        static if (D >= 2) v.y = MathT.max(v1.y, v2.y);
        static if (D >= 3) v.z = MathT.max(v1.z, v2.z);
        static if (D >= 4) v.w = MathT.max(v1.w, v2.w);
        return v;
    }

    pure static T dot(in Vec v1, in Vec v2)
    {
        T r = 0;
        static if (D>=1) r += v1.x * v2.x;
        static if (D>=2) r += v1.y * v2.y;
        static if (D>=3) r += v1.z * v2.z;
        static if (D>=4) r += v1.w * v2.w;
        return r;
    }

    pure static Vec add(in Vec v1, in Vec v2)
    {
        Vec vr;
        static if (D>=1) vr.x = v1.x + v2.x;
        static if (D>=2) vr.y = v1.y + v2.y;
        static if (D>=3) vr.z = v1.z + v2.z;
        static if (D>=4) vr.w = v1.w + v2.w;
        return vr;
    }

    pure static Vec sub(in Vec v1, in Vec v2)
    {
        Vec vr;
        static if (D>=1) vr.x = v1.x - v2.x;
        static if (D>=2) vr.y = v1.y - v2.y;
        static if (D>=3) vr.z = v1.z - v2.z;
        static if (D>=4) vr.w = v1.w - v2.w;
        return vr;
    }

    pure static Vec mul(in Vec v1, in Vec v2)
    {
        Vec vr;
        static if (D>=1) vr.x = v1.x * v2.x;
        static if (D>=2) vr.y = v1.y * v2.y;
        static if (D>=3) vr.z = v1.z * v2.z;
        static if (D>=4) vr.w = v1.w * v2.w;
        return vr;
    }

    pure static Vec div(in Vec v1, in Vec v2)
    {
        static if (__traits(isFloating, T))
        {
            return mul(v1, v2.inv);
        }
        static if (__traits(isIntegral, T))
        {
            Vec vr;
            static if (D>=1) vr.x = v1.x / v2.x;
            static if (D>=2) vr.y = v1.y / v2.y;
            static if (D>=3) vr.z = v1.z / v2.z;
            static if (D>=4) vr.w = v1.w / v2.w;
            return vr;
        }

    }

    pure static Vec mul(in Vec v1, T s2)
    {
        Vec vr;
        static if (D>=1) vr.x = v1.x * s2;
        static if (D>=2) vr.y = v1.y * s2;
        static if (D>=3) vr.z = v1.z * s2;
        static if (D>=4) vr.w = v1.w * s2;
        return vr;
    }

    pure static Vec div(in Vec v1, T s2)
    {
        static if (__traits(isFloating, T))
        {
            return mul(v1, MathT.inv(s2));
        }
        static if (__traits(isIntegral, T))
        {
            Vec r;
            static if (D>=1) r.x = v1.x / s2;
            static if (D>=2) r.y = v1.y / s2;
            static if (D>=3) r.z = v1.z / s2;
            static if (D>=4) r.w = v1.w / s2;
            return r;
        }
    }

    pure Vec abs() const
    {
        static if (D==1) return Vec!(D,T)(absX);
        static if (D==2) return Vec!(D,T)(absX,absY);
        static if (D==3) return Vec!(D,T)(absX,absY,absZ);
        static if (D==4) return Vec!(D,T)(absX,absY,absZ,absW);
    }

    pure static Vec mean(in Vec v1, in Vec v2)
    {
        Vec v;
        static if (D >= 1) v.x = MathT.mean(v1.x, v2.x);
        static if (D >= 2) v.y = MathT.mean(v1.y, v2.y);
        static if (D >= 3) v.z = MathT.mean(v1.z, v2.z);
        static if (D >= 4) v.w = MathT.mean(v1.w, v2.w);
        return v;
    }

    Vec floorVec() const
    {
        static if (D==1) return Vec!(D,T)(floorX);
        static if (D==2) return Vec!(D,T)(floorX,floorY);
        static if (D==3) return Vec!(D,T)(floorX,floorY,floorZ);
        static if (D==4) return Vec!(D,T)(floorX,floorY,floorZ,floorW);
    }

    Vec ceilVec() const
    {
        static if (D==1) return Vec!(D,T)(ceilX);
        static if (D==2) return Vec!(D,T)(ceilX,ceilY);
        static if (D==3) return Vec!(D,T)(ceilX,ceilY,ceilZ);
        static if (D==4) return Vec!(D,T)(ceilX,ceilY,ceilZ,ceilW);
    }

    Vec roundVec() const
    {
        static if (D==1) return Vec!(D,T)(roundX);
        static if (D==2) return Vec!(D,T)(roundX,roundY);
        static if (D==3) return Vec!(D,T)(roundX,roundY,roundZ);
        static if (D==4) return Vec!(D,T)(roundX,roundY,roundZ,roundW);
    }

    bool isNan() const
    {
        return this == nan;
    }

    bool isZero() const
    {
        return this == zero;
    }
}

alias Vec!(1,float) Vec1f;
alias Vec!(2,float) Vec2f;
alias Vec!(3,float) Vec3f;
alias Vec!(4,float) Vec4f;
alias Vec!(1,double) Vec1d;
alias Vec!(2,double) Vec2d;
alias Vec!(3,double) Vec3d;
alias Vec!(4,double) Vec4d;
alias Vec!(1,real) Vec1r;
alias Vec!(2,real) Vec2r;
alias Vec!(3,real) Vec3r;
alias Vec!(4,real) Vec4r;
alias Vec!(1,int) Vec1i;
alias Vec!(2,int) Vec2i;
alias Vec!(3,int) Vec3i;
alias Vec!(4,int) Vec4i;






