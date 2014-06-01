/*
 * Brew Library by erik wikforss
 */
module brew.misc;
private import brew.math;

struct Interval(T)
{
    T min, max;

    pure static Interval!T opCall(T min, T max)
    {
        Interval!T interval = {min, max};
        return interval;
    }

    T length() const
    {
        return Math!T.abs(max - min);
    }

    T clamp(T value) const
    {
        return Math!T.clamp(value, min, max);
    }
    T clampAbove(T value) const
    {
        return Math!T.clampAbove(value, max);
    }
    T clampBelow(T value) const
    {
        return Math!T.clampBelow(value, min);
    }
}
alias Interval!double Intervald;
alias Interval!float Intervalf;
alias Interval!int Intervali;
alias Interval!long Intervall;

enum CardinalDirection
{
    EAST,
    EAST_NORTH_EAST,
    NORTH_EAST,
    NORTH_NORTH_EAST,
    NORTH,
    NORTH_NORTH_WEST,
    NORTH_WEST,
    WEST_NORTH_WEST,
    WEST,
    WEST_SOUTH_WEST,
    SOUTH_WEST,
    SOUTH_SOUTH_WEST,
    SOUTH,
    SOUTH_SOUTH_EAST,
    SOUTH_EAST,
    EAST_SOUTH_EAST
}

enum Direction {
    LEFT,
    UP,
    RIGHT,
    DOWN
}


