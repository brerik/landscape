/*
 * Forest File Finder by erik wikforss
 */
module forest.events.eventhandler;
public import forest.events.event;

interface EventHandler
{
    bool handle(Event e);
}
