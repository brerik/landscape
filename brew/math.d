/*
 * Brew Library by erik wikforss
 */
module brew.math;
private import std.math;
private import std.stdio;

struct Math(T) {
    pure static T abs(T a)                                  { return a < 0 ? -a : a; }
    unittest {
        alias Mathd.abs abs;
        assert (abs(-5.0) == 5.0);
        assert (abs(5.0) == 5.0);
    }

    pure static T min(T a, T b)                             { return a < b ? a : b; }
    unittest {
        alias Mathd.min min;
        assert (min(5.0, 5.0) == 5.0);
        assert (min(-5.0, 8.0) == -5.0);
        assert (min(5.0, -8.0) == -8.0);
    }

    pure static T max(T a, T b)                             { return a > b ? a : b; }
    unittest {
        alias Mathd.max max;
        assert (max(5.0, 5.0) == 5.0);
        assert (max(-5.0, 8.0) == 8.0);
        assert (max(5.0, -8.0) == 5.0);
    }

    pure static T clamp(T value, T below, T above)          { return clampAbove(clampBelow(value, below), above); }
    unittest {
        alias Mathd.clamp clamp;
        assert (clamp(5.0, 3.0, 8.0) == 5.0);
        assert (clamp(8.0, 3.0, 5.0) == 5.0);
        assert (clamp(3.0, 5.0, 8.0) == 5.0);
    }
    pure static T clampAbove(T value, T above)              { return min(value, above); }
    pure static T clampBelow(T value, T below)              { return max(value, below); }
    pure static T half(T value) {
        static if (__traits(isIntegral, T)) return value / 2;
        static if (__traits(isFloating, T)) return value * cast(T)0.5;
    }
    unittest {
        alias Mathd.half half;
        assert (half(10.0) == 5.0);
    }

    pure static T twice(T a)                                { return 2 * a; }
    unittest {
        alias Mathd.twice twice;
        assert (twice(10.0) == 20.0);
    }

    pure static T invMag2(T x, T y)                         { return inv(mag2(x, y)); }
    pure static T mag2(T x, T y)                            { return sqrt(magSqr2(x, y)); }
    pure static T magSqr2(T x, T y)                         { return sqr(x) + sqr(y); }
    pure static T invMag3(T x, T y, T z)                    { return inv(mag3(x, y, z)); }
    pure static T mag3(T x, T y, T z)                       { return sqrt(magSqr3(x, y, z)); }
    pure static T magSqr3(T x, T y, T z)                    { return sqr(x) + sqr(y) + sqr(z); }
    pure static T invMag4(T x, T y, T z, T w)               { return inv(mag4(x, y, z, w)); }
    pure static T mag4(T x, T y, T z, T w)                  { return sqrt(magSqr4(x, y, z, w)); }
    pure static T magSqr4(T x, T y, T z, T w)               { return sqr(x) + sqr(y) + sqr(z) + sqr(w); }
    pure static T invSqrt(T a)                              { return inv(sqrt(a)); }
    unittest {
        alias Mathd.invSqrt invSqrt;
        assert (invSqrt(16.0) == 0.25);
    }

    pure static T sqrt(T a)                                 { return cast(T)std.math.sqrt(cast(real)a); }
    unittest {
        alias Mathd.sqrt sqrt;
        assert (sqrt(16.0) == 4.0);
    }

    pure static T invSqr(T a)                               { return inv(sqr(a)); }
    unittest {
        alias Mathd.invSqr invSqr;
        assert (invSqr(4.0) == 0.0625);
    }

    pure static T sqr(T a)                                  { return a * a; }
    unittest {
        alias Mathd.sqr sqr;
        assert (sqr(4.0) == 16.0);
    }

    pure static T inv(T a)                                  { return 1 / a; }
    unittest {
        alias Mathd.inv inv;
        assert (inv(1.0) == 1.0);
        assert (inv(2.0) == 0.5);
        assert (inv(-1.0) == -1.0);
        assert (inv(-2.0) == -0.5);
        assert (inv(0.0) == double.infinity);
        assert (inv(double.infinity) == 0.0);
    }

    pure static T neg(T a)                                  { return -a; }
    unittest {
        alias Mathd.neg neg;
        assert (neg(-5.0) == 5.0);
        assert (neg(5.0) == -5.0);
    }

    pure static T add(T a1, T a2)                           { return a1 + a2; }
    unittest {
        alias Mathd.add add;
        assert (add(5.0, 8.0) == 13.0);
    }

    pure static T dot2(T x1, T y1, T x2, T y2)              { return (x1 * x2) + (y1 * y2); }
    unittest {
        alias Mathd.dot2 dot2;
        assert ((2 * 3) + (4 * 5) == dot2(2, 4, 3, 5));
    }
    static T floor(T value)                                 { return cast(T)std.math.floor(cast(real)value); }
    static T ceil(T value)                                  { return cast(T)std.math.ceil(cast(real)value); }
    static T round(T value)                                 { return cast(T)std.math.round(cast(real)value); }
    pure static T mean(T v1, T v2)                          { return (v1 + v2) / 2; }
    pure static T pi()                                      { return cast(T)std.math.PI; }
    pure static T pi2()                                     { return cast(T)std.math.PI_2; }

    /**
     * Clamps a value into bounds except for bound that is nan
     * Normal clamp if not floating Type
     */
    pure static T clampNan(T value, T minValue, T maxValue) {
        static if (__traits(isFloating, T)) return clampNan(value, minValue, maxValue, T.nan);
        static if (!__traits(isFloating, T)) return clamp(value, minValue, maxValue);
    }

    /**
     * Clamps a value into bounds except for values that is nan
     */
    pure static T clampNan(T value, T minValue, T maxValue, T nan) {
        if (value != nan) {
            if (minValue != nan)
                value = max(value, minValue);
            if (maxValue != nan)
                value = min(value, maxValue);
        }
        return value;
    }

    /**
     * Clamps a value except for values that is not accepted
     */
    static T clampAccept(T value, T minValue, T maxValue, bool function(T) accept) {
        if (accept(value)) {
            if (accept(minValue))
                value = max(value, minValue);
            if (accept(maxValue))
                value = min(value, maxValue);
        }
        return value;
    }

    static T sin(T a)                                       { return cast(T)std.math.sin(cast(real)a); }
    static T cos(T a)                                       { return cast(T)std.math.cos(cast(real)a); }
    static T atan2(T y, T x)                                { return cast(T).std.math.atan2(cast(real)y, cast(real)x); }
    static T fibonacci(int number) {
        T prev = 0;
        T result = 1;
        for (int i = 0; i < number; i++) {
            T p = prev;
            prev = result;
            result += p;
        }
        return result;
    }

    static pure T powerOf2(int number)                      { return powerOfN(number, 2); }
    static pure T powerOf3(int number)                      { return powerOfN(number, 3); }

    static pure T powerOfN(int number, T n) {
        T result = 1;
        for (int i = 0; i < number; i++)
            result *= n;
        return result;
    }

    static pure T phi()                                     { return cast(T)1.618; }
    static pure T invPhi()                                  { return cast(T)(1.0 / 1.618); }
    static pure T sqrt2()                                   { return sqrt(2); }
    static pure T invSqrt2()                                { return inv(sqrt(2)); }
    static T round(T val, T granularity)                    { return round(val / granularity) * granularity; }
    static T floor(T val, T granularity)                    { return floor(val / granularity) * granularity; }
    static T ceil(T val, T granularity)                     { return ceil(val / granularity) * granularity; }

    static void swap(ref T v1, ref T v2) {
        T t = v1;
        v1 = v2;
        v2 = t;
    }
}

alias Math!(float) Mathf;
alias Math!(double) Mathd;
alias Math!(real) Mathr;
alias Math!(int) Mathi;














