/*
 * Forest File Finder by erik wikforss
 */
module forest.event;
import brew.vec;

public class Event
{
    string _name;

    this(string name)
    {
        _name = name;
    }

    string name() const
    {
        return _name;
    }
}

public class MapEvent : Event
{
    Vec2d _mapPos;
    Vec2d _screenPos;

    public this(string name)
    {
        super(name);
    }

}

class PropertyEvent(T) : Event
{
    T _oldValue;
    T _newValue;

    this(string name, T oldValue, T newValue)
    {
        super(name);
        _oldValue = oldValue;
        _newValue = newValue;
    }

    T oldValeu() const
    {
        return _oldValue;
    }

    T newValue() const
    {
        return _newValue;
    }
}





