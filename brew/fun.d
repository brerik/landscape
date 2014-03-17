/*
 * Brew Miscellaneous Library for Functional Programming
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
module brew.fun;
private import brew.math;

template Filter(T)
{
    T[] filter(T[] arr, bool function(T) accept)
    {
        T res[];
        size_t newlen = 0;
        size_t maxlen = arr.length;
        for (size_t i = 0; i < arr.length; i++)
        {
            if (accept(arr[i]))
            {
                if(res.length < newlen+1) {
                    res.length = Math!size_t.clamp(res.length*2, newlen+1, maxlen);
                }
                res[newlen] = arr[i];
                newlen++;
            }
            else
            {
                maxlen--;
            }
        }
        res.length = newlen;
        return res;
    }
}

template Find(T)
{
    T findFirst(T[] elements, bool function(T) accept)
    {
        for (ulong i = 0; i < elements.length; i++)
            if (accept(elements[i]))
                return elements[i];
        return null;
    }

    T findLast(T[] elements, bool function(T) accept)
    {
        for (ulong i = elements.length-1; i < elements.length; i--)
            if (accept(elements[i]))
                return elements[i];
        return null;
    }

    T[] findAll(T[] elements, bool function(T) accept)
    {
        T[] result;
        for (ulong i = 0; i < elements.length; i++)
            if (accept(elements[i]))
            {
                result.length++;
                result[$-1] = elements[i];
            }
        return result;
    }
}
