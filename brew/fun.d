/*
 * Brew Library by erik wikforss
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
