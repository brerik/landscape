/*
 * Forest File Finder by erik wikforss
 */
module forest.events.updateevent;
import forest.events.event;

class UpdateEvent : Event
{
    enum Name : string
    {
        update = "update"
    }

    long _deltaMillis;
    double _deltaTime;

    this(long aDeltaMillis)
    {
        super(Name.update);
        _deltaMillis = aDeltaMillis;
        _deltaTime = aDeltaMillis * 0.001;
    }

    final double deltaTime() const
    {
        return _deltaTime;
    }

    final long deltaMillis() const
    {
        return _deltaMillis;
    }
}


