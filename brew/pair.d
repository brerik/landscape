/*
 * Brew Library by erik wikforss
 */
module brew.pair;

struct Pair(T)
{
    T first;
    T second;

    static Pair opCall(T first, T second)
    {
        Pair p = {first, second};
        return p;
    }
}

