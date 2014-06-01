/*
 * Brew Library by erik wikforss
 */
module brew.mat;
private import brew.vec;
private import std.string;
private import std.stdio;
private import std.math;

struct Mat(int R, int C, T) {
    static assert (R>=2 && R<=4);
    static assert (C>=2 && C<=4);
    private alias Mat!(R,C,T) MatRCT;
    private alias Mat!(R,2,T) MatR2T;
    private alias Mat!(R,3,T) MatR3T;
    private alias Mat!(R,4,T) MatR4T;
    private alias Mat!(2,2,T) Mat22T;
    private alias Mat!(3,3,T) Mat33T;
    private alias Mat!(4,4,T) Mat44T;
    private alias Vec!(R,T) VecRT;
    private alias Vec!(C,T) VecCT;
    private alias Vec!(1,T) Vec1T;
    private alias Vec!(2,T) Vec2T;
    private alias Vec!(3,T) Vec3T;
    private alias Vec!(4,T) Vec4T;

    static if(C>=1) VecRT c0;
    static if(C>=2) VecRT c1;
    static if(C>=3) VecRT c2;
    static if(C>=4) VecRT c3;

    pure static MatR2T opCall(in VecRT c0, in VecRT c1) {
        MatR2T m = {c0, c1};
        return m;
    }

    pure static MatR3T opCall(in VecRT c0, in VecRT c1, in VecRT c2) {
        MatR3T m = {c0, c1, c2};
        return m;
    }

    pure static MatR4T opCall(in VecRT c0, in VecRT c1, in VecRT c2, in VecRT c3) {
        MatR4T m = {c0, c1, c2, c3};
        return m;
    }

    pure static MatRCT identity() {
        static if (C==2) return MatR2T(VecRT.unitX, VecRT.unitY);
        static if (C==3) return MatR3T(VecRT.unitX, VecRT.unitY, VecRT.unitZ);
        static if (C==4) return MatR4T(VecRT.unitX, VecRT.unitY, VecRT.unitZ, VecRT.unitW);
    }

    string toString() const {
        return format("Mat%dx%d%s[%s]", R, C, T.mangleof, paramString);
    }

    string paramString() const {
        static if(C==1) return format("[%s]", c0.paramString);
        static if(C==2) return format("[%s][%s]", c0.paramString, c1.paramString);
        static if(C==3) return format("[%s][%s][%s]", c0.paramString, c1.paramString, c2.paramString);
        static if(C==4) return format("[%s][%s][%s][%s]", c0.paramString, c1.paramString, c2.paramString, c3.paramString);
    }

    static if (C>=1) {
        pure VecRT col0() const                             { return c0; }
        void col0(in VecRT c)                               { c0 = c; }
    }
    static if (C>=2) {
        pure VecRT col1() const                             { return c1; }
        void col1(in VecRT c)                               { c1 = c; }
    }
    static if (C>=3) {
        pure VecRT col2() const                             { return c2; }
        void col2(in VecRT c)                               { c2 = c; }
    }
    static if (C>=4) {
        pure VecRT col3() const                             { return c3; }
        void col3(in VecRT c)                               { c3 = c; }
    }
    static if (R>=1) {
        pure VecCT row0() const {
            static if (C==1) return Vec1T(c0.x);
            static if (C==2) return Vec2T(c0.x, c1.x);
            static if (C==3) return Vec3T(c0.x, c1.x, c2.x);
            static if (C==4) return Vec4T(c0.x, c1.x, c2.x, c3.x);
        }
        void row0(in VecCT r) {
            static if (C>=1) c0.x = r.x;
            static if (C>=2) c1.x = r.y;
            static if (C>=3) c2.x = r.z;
            static if (C>=4) c3.x = r.w;
        }
    }
    static if (R>=2) {
        pure VecCT row1() const {
            static if (C==1) return Vec1T(c0.y);
            static if (C==2) return Vec2T(c0.y, c1.y);
            static if (C==3) return Vec3T(c0.y, c1.y, c2.y);
            static if (C==4) return Vec4T(c0.y, c1.y, c2.y, c3.y);
        }
        void row1(in VecCT r) {
            static if (C>=1) c0.y = r.x;
            static if (C>=2) c1.y = r.y;
            static if (C>=3) c2.y = r.z;
            static if (C>=4) c3.y = r.w;
        }
    }
    static if (R>=3) {
        pure VecCT row2() const {
            static if (C==1) return Vec1T(c0.z);
            static if (C==2) return Vec2T(c0.z, c1.z);
            static if (C==3) return Vec3T(c0.z, c1.z, c2.z);
            static if (C==4) return Vec4T(c0.z, c1.z, c2.z, c3.z);
        }
        void row2(in VecCT r) {
            static if (C>=1) c0.z = r.x;
            static if (C>=2) c1.z = r.y;
            static if (C>=3) c2.z = r.z;
            static if (C>=4) c3.z = r.w;
        }
    }
    static if (R>=4) {
        pure VecCT row3() const {
            static if (C==1) return Vec1T(c0.w);
            static if (C==2) return Vec2T(c0.w, c1.w);
            static if (C==3) return Vec3T(c0.w, c1.w, c2.w);
            static if (C==4) return Vec4T(c0.w, c1.w, c2.w, c3.w);
        }
        void row0(in VecCT r) {
            static if (C>=1) c0.w = r.x;
            static if (C>=2) c1.w = r.y;
            static if (C>=3) c2.w = r.z;
            static if (C>=4) c3.w = r.w;
        }
    }
    static if (R==2 && C==2) {
        pure Vec2T transform(in Vec2T v)                    { return transform(v, this); }
    }
    static if (R==3 && C==3) {
        pure Vec3T transform(in Vec3T v)                    { return transform(v, this); }
    }
    static if (R==4 && C==4) {
        pure Vec4T transform(in Vec4T v)                    { return transform(v, this); }
    }

    pure static Mat22T mul(in Mat22T m1, in Mat22T m2) {
        return Mat22T(Vec2T(m1.row0.dot(m2.c0), m1.row1.dot(m2.c0)),
                      Vec2T(m1.row0.dot(m2.c1), m1.row1.dot(m2.c1)));
    }
    pure static Mat33T mul(in Mat33T m1, in Mat33T m2) {
        return Mat33T(Vec3T(m1.row0.dot(m2.c0), m1.row1.dot(m2.c0), m1.row2.dot(m2.c0)),
                      Vec3T(m1.row0.dot(m2.c1), m1.row1.dot(m2.c1), m1.row2.dot(m2.c1)),
                      Vec3T(m1.row0.dot(m2.c2), m1.row1.dot(m2.c2), m1.row2.dot(m2.c2)));
    }
    pure static Mat44T mul(in Mat44T m1, in Mat44T m2) {
        return Mat44T(Vec4T(m1.row0.dot(m2.c0), m1.row1.dot(m2.c0), m1.row2.dot(m2.c0), m1.row3.dot(m2.c0)),
                      Vec4T(m1.row0.dot(m2.c1), m1.row1.dot(m2.c1), m1.row2.dot(m2.c1), m1.row3.dot(m2.c1)),
                      Vec4T(m1.row0.dot(m2.c2), m1.row1.dot(m2.c2), m1.row2.dot(m2.c2), m1.row3.dot(m2.c2)),
                      Vec4T(m1.row0.dot(m2.c3), m1.row1.dot(m2.c3), m1.row2.dot(m2.c3), m1.row3.dot(m2.c3)));
    }
    pure static Vec2T transform(in Vec2T v1, in Mat22T m2) {
        return Vec2T(v1.dot(m2.row0), v1.dot(m2.row1));
    }
    pure static Vec3T transform(in Vec3T v1, in Mat33T m2) {
        return Vec3T(v1.dot(m2.row0), v1.dot(m2.row1), v1.dot(m2.row2));
    }
    pure static Vec4T transform(in Vec4T v1, in Mat44T m2) {
        return Vec4T(v1.dot(m2.row0), v1.dot(m2.row1), v1.dot(m2.row2), v1.dot(m2.row3));
    }
}

alias Mat!(2,2,double) Mat2x2d;
alias Mat!(3,3,double) Mat3x3d;
alias Mat!(4,4,double) Mat4x4d;

unittest
{
    Mat2x2d m22 = {Vec2d.unitX,Vec2d.unitY};
    writeln(m22.toString);
    Mat3x3d m33 = {Vec3d.unitX,Vec3d.unitY,Vec3d.unitZ};
    writeln(m33.toString);
    Mat4x4d m44 = {Vec4d.unitX,Vec4d.unitY,Vec4d.unitZ,Vec4d.unitW};
    writeln(m44.toString);
    auto m44id = Mat4x4d.identity;
    writeln(m44id.toString);
}

