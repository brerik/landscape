/*
 * Landscape Filesystem Browser
 * Copyright (C) 2013-2014 Erik Wikforss
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

module landscape.selection;
import std.signals;

class Selection {
    enum {
        NONE = size_t.max
    }

    private {
        Object[] _objects;
    }

    mixin Signal!(Object, bool);

    final void add(Object o) {
        _objects ~= o;
        emit(o, true);
    }

    final void remove(Object o) {
        for (size_t i = 0; i < _objects.length; i++) {
            if (_objects[i] == o) {
                _objects[i] = _objects[$-1];
                _objects.length--;
                emit(o, false);
                return;
            }
        }
    }

    final void clear() {
        for (size_t i = _objects.length-1; i < _objects.length; i--)
            emit(_objects[i], false);
        _objects.length = 0;
    }

    final bool contains(Object o) {
        return indexOf(o) >= 0;
    }

    /**
     * returns index or NONE if not found
     */
    final size_t indexOf(Object o) {
        for (size_t i = 0; i < _objects.length; i++)
            if (o is _objects[i])
                return i;
        return NONE;
    }

    final Object get(size_t i) {
        return (i < _objects.length)
            ? _objects[i]
            : null;
    }
}
