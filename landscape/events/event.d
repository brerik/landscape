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
module landscape.events.event;

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
