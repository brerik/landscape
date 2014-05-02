/*
 * Brew Library by erik wikforss
 */
module brew.color;
private import brew.math;
private import std.string;

mixin template ColorRed(T)
{
    T _red;
    T red() const                       { return _red; }
    void red(T r)                       { _red = r; }
    int redi() const                    { return cast(int)(_red * 255); }
    void redi(int r)                    { _red = cast(T)(r / 255); }
}

mixin template ColorGreen(T)
{
    T _green;
    T green() const                     { return _green; }
    void green(T g)                     { _green = g; }
    int greeni() const                  { return cast(int)(_green * 255); }
    void greeni(int g)                  { _green = cast(T)(g / 255); }
}
mixin template ColorBlue(T)
{
    T _blue;
    T blue() const                      { return _blue; }
    void blue(T b)                      { _blue = b; }
    int bluei() const                   { return cast(int)(_blue * 255); }
    void bluei(int b)                   { _blue = cast(T)(b / 255); }
}
mixin template ColorAlpha(T)
{
    T _alpha;
    T alpha() const                     { return _alpha; }
    void alpha(T a)                     { _alpha = a; }
    int alphai() const                  { return cast(int)(_alpha * 255); }
    void alphai(int a)                  { _alpha = cast(T)(a / 255); }
}
mixin template ColorAlpha1(T)
{
    T alpha() const                     { return 1; }
    int alphai() const                  { return 255; }
}

struct Color(int D, T)
{
    static assert (D>=3||D<=4);
    static if (D>=1) mixin ColorRed!T;
    static if (D>=2) mixin ColorGreen!T;
    static if (D>=3) mixin ColorBlue!T;
    static if (D>=4) mixin ColorAlpha!T;
    static if (D<4) mixin ColorAlpha1!T;

    static if (D==3)
    {
        /**
         * Creates a RGB color
         * @param red component
         * @param green component
         * @param blue component
         * @param alpha ignored
         */
        pure static Color!(3,T)opCall(T red, T green, T blue, T alpha = 1)
        {
            Color!(3,T) p = {red, green, blue};
            return p;
        }
    }

    static if (D==4)
    {
        /**
         * Creates a RGBA color
         * @param red component
         * @param green component
         * @param blue component
         * @param alpha component
         */
        pure static Color!(4,T)opCall(T red, T green, T blue, T alpha = 1)
        {
            Color!(4,T) p = {red, green, blue, alpha};
            return p;
        }
    }

    enum {
        BLACK = Color(0,0,0),
        WHITE = Color(1,1,1),
        ZERO = Color(0,0,0,0),
        GREEN = Color(0,1,0),
        DK_BLUE = Color(0,0,.5),
        BLUE = Color(0,0,1),
        RED = Color(1,0,0),
        ORANGE = Color(1,.5,0),
        OLIVE = Color(.5,.5,0),
        YELLOW = Color(1,1,0),
        PALE = Color(1,1,.5),
        CYAN = Color(0,1,1),
        MAGENTA = Color(1,0,1),
        PINK = Color(1,.5,1),
        GREY = Color(.5,.5,.5),
        NAN = Color(T.nan,T.nan,T.nan,T.nan),
    }

    @property
    pure static Color nan()
    {
        return Color(T.nan,T.nan,T.nan,T.nan);
    }

    @property
    pure static Color zero()
    {
        return Color(0,0,0,0);
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


