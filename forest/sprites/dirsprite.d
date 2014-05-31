/*
 * Forest File Finder by erik wikforss
 */
module forest.sprites.dirsprite;
import forest.sprites.sprite;
import forest.events.renderevent;
import forest.events.mouseevent;
import forest.events.updateevent;
import forest.events.event;

class DirSprite : Sprite
{
    this()
    {
        connect(&doRender);
    }

    void doRender(RenderEvent e)
    {

    }
}



