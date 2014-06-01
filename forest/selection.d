/*
 * Forest File Finder by erik wikforss
 */
module forest.selection;
import std.signals;
import std.algorithm;

class Selection {
    enum {
        NONE = size_t.max
    }
    enum Mode {
        MULTI,
        SINGLE
    }

    private {
        Object[] _objects;
    }

    mixin Signal!(Object, bool);

    final void add(Object o) {
        if (!contains(o)) {
            _objects ~= o;
            emit(o, true);
        }
    }

    final void remove(Object o) {
        size_t i = indexOf(o);
        if (i != NONE) {
            _objects[i] = _objects[$-1];
            _objects.length--;
            emit(o, false);
        }
    }

    final void set(Object obj, bool s) {
        if (s)
            add(obj);
        else
            remove(obj);
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
