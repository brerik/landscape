/*
 * Landscape Filesystem Browser
 * Copyright (C) 2013-2014 erik wikforss
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
module landscape.sprites.dirsprite;
import landscape.sprites.sprite;
import landscape.events.renderevent;
import landscape.events.mouseevent;
import landscape.events.updateevent;
import landscape.events.event;

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



