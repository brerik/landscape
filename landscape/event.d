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
module landscape.event;
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





