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

