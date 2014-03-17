/*
 * Brew Miscellaneous Library for Cairo
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
module brew.cairo;
import brew.color;
import cairo.Context;

void setSourceRgba(Context cr, in Color4d c)
{
    cr.setSourceRgba(c.red, c.green, c.blue, c.alpha);
}

void setSourceRgba(Context cr, in Color4f c)
{
    cr.setSourceRgba(c.red, c.green, c.blue, c.alpha);
}

void setSourceRgba(Context cr, in Color3d c)
{
    cr.setSourceRgba(c.red, c.green, c.blue, 1.0);
}

void setSourceRgba(Context cr, in Color3f c)
{
    cr.setSourceRgba(c.red, c.green, c.blue, 1.0);
}

void setSourceRgb(Context cr, in Color4d c)
{
    cr.setSourceRgb(c.red, c.green, c.blue);
}

void setSourceRgb(Context cr, in Color4f c)
{
    cr.setSourceRgb(c.red, c.green, c.blue);
}

void setSourceRgb(Context cr, in Color3d c)
{
    cr.setSourceRgb(c.red, c.green, c.blue);
}

void setSourceRgb(Context cr, in Color3f c)
{
    cr.setSourceRgb(c.red, c.green, c.blue);
}
