/*
 * Brew Library by erik wikforss
 */
module brew.polar;

struct Polar(T)
{
    T angle;
    T radius;

    alias Vec!(2,T) Vec2T;

    /**
     *
     * @param angle in radians
     * @param radius
     */
    static pure Polar opCall(T angle, T radius)
    {
        Polar p = {angle, radius};
        return p;
    }

    Vec2T vec() const
    {
        return Vec2T(x,y);
    }

    T x() const
    {
        return cos(angle) * radius;
    }

    T y() const
    {
        return sin(angle) * radius;
    }

    T degrees() const
    {
        return toDegrees(angle);
    }

    T radians() const
    {
        return angle;
    }
}
