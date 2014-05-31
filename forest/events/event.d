/*
 * Forest File Finder by erik wikforss
 */
module forest.events.event;

class Event
{
    string _name;
    bool _consumed;

    this(string aName)
    {
        _name = aName;
    }

    final string name() const
    {
        return _name;
    }

    final void name(string aName)
    {
        _name = aName;
    }

    final void consume()
    {
        _consumed = true;
    }

    final bool consumed() const
    {
        return _consumed;
    }

    final void consumed(bool b)
    {
        _consumed = b;
    }
}
