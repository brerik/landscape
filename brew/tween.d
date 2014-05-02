/*
 * Brew Library by erik wikforss
 */
module brew.tween;

struct Tween(T)
{
    static assert (__traits(isFloating, T));
    alias T function(T,T,T,T) tweener4;

    struct Linear
    {
        /**
         * f(t) = t
         */
        static T easeLinear(T a, T b, T c, T d)
        {
            immutable t = a / d;
            return b + c * t;
        }

        /**
         * f(t) = 0
         */
        static T easeNone(T a, T b, T c, T d)
        {
            return b;
        }
    }

    struct Sine
    {
    //    static pure T easeIn(T a, T b, T c, T d)
    //    {
    //        immutable t = a / d;
    //        return b + c * t * t;
    //    }
    //
    //    static pure T easeOut(T a, T b, T c, T d)
    //    {
    //        immutable t = a / d;
    //        return b + c * t * t;
    //    }
    //    static T easeInOut(T a, T b, T c, T d)
    //    {
    //        return b + (a * c) / d;
    //    }
    }

    struct Quad
    {
        static pure T easeIn(T a, T b, T c, T d)
        {
            immutable t = a / d;
            return b + c * t * t;
        }

        static pure T easeOut(T a, T b, T c, T d)
        {
            immutable t = a / d;
            return b + c * t * t;
        }
        static T easeInOut(T a, T b, T c, T d)
        {
            return b + (a * c) / d;
        }
    }

    struct Cubic
    {

    }

    struct Quint
    {

    }
}

