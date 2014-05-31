/*
 * Forest File Finder by erik wikforss
 */
module forest.nodes.circlenode;
import std.string;
import forest.nodes.node;
import brew.dim, brew.box, brew.vec, brew.color, brew.math;
import cairo.Context;

class CircleNode : Node {
    double lineWidth = 2.0;
    bool isDraw = true;
    bool isFill = true;

    this() {
        super();
    }

    override void drawNode(Context ct) {
        if (isFill) {
            pathCircle(ct);
            ct.setSourceRgb(bgColor.red, bgColor.green, bgColor.blue);
            ct.fill();
        }
        if (isDraw) {
            ct.setLineWidth(lineWidth);
            ct.setSourceRgb(fgColor.red, fgColor.green, fgColor.blue);
            pathCircle(ct);
            ct.stroke();
        }
    }

    final void pathCircle(Context ct) {
        ct.moveTo(bounds.maxX, bounds.centerY);
        ct.arc(bounds.centerX, bounds.centerY, bounds.halfWidth, 0, 2 * Mathd.pi);
//        const M_1_4 = 1.0 / 5.0;
//        const M_3_4 = 4.0 / 5.0;
//        ct.moveTo(bounds.minX, bounds.centerY);
//        ct.curveTo(bounds.minX, bounds.alignedY(M_1_4), bounds.alignedX(M_1_4), bounds.minY, bounds.centerX, bounds.minY);
//        ct.curveTo(bounds.alignedX(M_3_4), bounds.minY, bounds.maxX, bounds.alignedY(M_1_4), bounds.maxX, bounds.centerY);
//        ct.curveTo(bounds.maxX, bounds.alignedY(M_3_4), bounds.alignedX(M_3_4), bounds.maxY, bounds.centerX, bounds.maxY);
//        ct.curveTo(bounds.alignedX(M_1_4), bounds.maxY, bounds.minX, bounds.alignedY(M_3_4), bounds.minX, bounds.centerY);
//        ct.closePath();

    }
}

