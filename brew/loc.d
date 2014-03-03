/*
 * Brew Miscellaneous Library by Brother Erik Wigforss
 * Copyright (C) 2013-2014 Erik Wigforss
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
module brew.loc;
private import std.string;

struct Loc2
{
    int row, col;

    this(int row, int col)
    {
        this.row    = row;
        this.col = col;
    }

    string toString()
    {
        return format("Loc2[row=%d, column=%d]", row, col);
    }
}

