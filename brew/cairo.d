/*
 * Brew Library by erik wikforss
 */
module brew.cairo;
import brew.color;
import brew.box;
import cairo.Context;

void setSourceRgba(Context cr, in Color4d c) {
    cr.setSourceRgba(c.tupleof);
}

void setSourceRgba(Context cr, in Color4f c) {
    cr.setSourceRgba(c.tupleof);
}

void setSourceRgba(Context cr, in Color3d c) {
    cr.setSourceRgba(c.tupleof, 1.0);
}

void setSourceRgba(Context cr, in Color3f c) {
    cr.setSourceRgba(c.tupleof, 1.0);
}

void setSourceRgb(Context cr, in Color4d c) {
    cr.setSourceRgb(c.tupleof[0..3]);
}

void setSourceRgb(Context cr, in Color4f c) {
    cr.setSourceRgb(c.tupleof[0..3]);
}

void setSourceRgb(Context cr, in Color3d c) {
    cr.setSourceRgb(c.tupleof);
}

void setSourceRgb(Context cr, in Color3f c) {
    cr.setSourceRgb(c.tupleof);
}

void rectangleInside(Context cr, in Box2d b) {
    rectangle(cr, toRectangleInside(b, cr.getLineWidth()));
}

void rectangleOutside(Context cr, in Box2d b) {
    rectangle(cr, toRectangleOutside(b, cr.getLineWidth()));
}

void rectangle(Context cr, in Box2d b) {
    cr.rectangle(b.tupleof);
}

pure Box2d toRectangleInside(in Box2d b, double lineWidth) {
    auto halfLineWidth = 0.5 * lineWidth;
    return Box2d(b.x + halfLineWidth, b.y + halfLineWidth, b.width - lineWidth, b.height - lineWidth);
}

pure Box2d toRectangleOutside(in Box2d b, double lineWidth) {
    auto halfLineWidth = 0.5 * lineWidth;
    return Box2d(b.x - halfLineWidth, b.y - halfLineWidth, b.width + lineWidth, b.height + lineWidth);
}
