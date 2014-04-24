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
module landscape.nodes.dir.dirsign;
import landscape.nodes.signnode;
import landscape.nodes.framenode;
import landscape.nodes.node;
import brew.color;
import brew.insets;
import brew.dim;
import cairo.Context;

public class DirSymbol : CutFrameNode {
    enum {
        GREY = NodeColor(Color4d(0.2, 0.2, 0.2, 1.0), Color4d(0.8, 0.8, 0.8, 1.0)),
        BLUE = NodeColor(Color4d(0.0, 0.1, 0.5, 1.0), Color4d(0.6, 0.7, 1.0, 1.0)),
        RED = NodeColor(Color4d(0.5, 0.0, 0.1, 1.0), Color4d(1.0, 0.6, 0.7, 1.0)),
        GREEN = NodeColor(Color4d(0.0, 0.5, 0.1, 1.0), Color4d(0.6, 1.0, 0.7, 1.0)),
        YELLOW = NodeColor(Color4d(0.6, 0.5, 0.0, 1.0), Color4d(1.0, 1.0, 0.5, 1.0)),
        VIOLET = NodeColor(Color4d(0.5, 0.2, 0.6, 1.0), Color4d(0.7, 0.65, 1.0, 1.0)),
        WHITE = NodeColor(Color4d(0.5, 0.5, 0.5, 1.0), Color4d(1.0, 1.0, 1.0, 1.0)),
        OCEAN = NodeColor(Color4d(0.0, 0.5, 0.5, 1.0), Color4d(0.3, 0.8, 0.8, 1.0)),
        SELECTED_INSETS = Insets2d.ZERO,
        DEFAULT_INSETS = Insets2d.ONES,
        DEFAULT_BOUNDS = Box2d(0, 0,240, 24),
        SELECTED_LINE_WIDTH = 2.0,
        DEFAULT_LINE_WIDTH = 1.0,
        DEFAULT_CUT = Vec2d(4,4),
        DIVIDER_POSITION = 21,
    }

    static {
        immutable COLORS = [GREY, BLUE, RED, GREEN, YELLOW, VIOLET, WHITE, OCEAN];
        ref const(NodeColor) nextColor() {
            static size_t next = 0;
            return COLORS[next++ % COLORS.length];
        }
    }

    bool dividerVisible;
    double dividerPosition = DIVIDER_POSITION;

    this() {
        super();
        connect(&watchBool);
        nodeColor = nextColor;
        updateRect();
    }

    private void watchBool(string propName, bool newValue, bool oldValue) {
        if (Node.PropName.selected == propName)
            updateRect();
    }

    final void updateRect() {
        cut = DEFAULT_CUT;
        lineWidth = selected ? SELECTED_LINE_WIDTH : DEFAULT_LINE_WIDTH;
        insets = selected ? SELECTED_INSETS : DEFAULT_INSETS;
    }

    Box2d tailBounds() {
        return bounds - SELECTED_INSETS;
    }

    override void drawNode(Context ct) {
        void drawDividerIfVisible() {
            void drawDivider() {
                auto r = rectToPaint(lineWidth);
                ct.setLineWidth(lineWidth);
                ct.setSourceRgb(fgColor.red, fgColor.green, fgColor.blue);
                ct.moveTo(r.left + DEFAULT_CUT.x, r.top + dividerPosition);
                ct.lineTo(r.right - DEFAULT_CUT.x, r.top + dividerPosition);
                ct.stroke();
            }
            if (dividerVisible)
                drawDivider();
        }
        super.drawNode(ct);
        drawDividerIfVisible();
    }
}

class OpenSign : SignNode {
    enum {
        OPEN = DOWN,
        CLOSE = UP,
        HIDDEN = NONE,
    }

    this() {
        sign = HIDDEN;
        connect(&watchInt);
        drawRing = false;
    }

    void watchInt(string name, int newSign, int oldSign) {
        void handleSignProperty() {
            void handleSign() {
                void handleOpenSign() {
                    signColor.set(0,0,.25);
                    insets = Insets2d(5,5,5,5);
                    visible = true;
                }
                void handleCloseSign() {
                    signColor.set(.25,0,0);
                    insets= Insets2d(5,5,5,5);
                    visible = true;
                }
                void handleHiddenSign() {
                    signColor.set(0,0,0);
                    insets = Insets2d(5,5,5,5);
                    visible = false;
                }
                void handleDefaultSign() {
                    signColor.set(0,0,0);
                    insets = Insets2d(5,5,5,5);
                    visible = true;
                }
                switch (newSign) {
                    case OPEN: handleOpenSign(); break;
                    case CLOSE: handleCloseSign(); break;
                    case HIDDEN: handleHiddenSign(); break;
                    default: handleDefaultSign(); break;
                }
            }
            handleSign();
            setLayoutDirty();
            redraw();
        }
        if (name == PropName.sign)
            handleSignProperty();
    }
}

class ExpandSign : SignNode {
    enum {
        OPEN = RIGHT,
        CLOSE = LEFT,
        HIDDEN = NONE,
    }

    this() {
        sign = HIDDEN;
        connect(&watchInt);
        drawRing = false;
    }

    void watchInt(string propName, int newSign, int oldSign) {
        void handleSignProperty() {
            void handleSign() {
                void handleOpen() {
                    signColor.set(0,.25,0);
                    visible = true;
                    bounds.dim = Dim2d(20,20);
                }
                void handleClose() {
                    signColor.set(.25,0,0);
                    visible = true;
                    bounds.dim = Dim2d(20,20);
                }
                void handleHidden() {
                    signColor.set(0,0,0);
                    visible = false;
                }
                void handleDefault() {
                    signColor.set(0,0,0);
                    visible = true;
                    bounds.dim = Dim2d(20,20);
                }
                switch (newSign) {
                    case OPEN: handleOpen(); break;
                    case CLOSE: handleClose(); break;
                    case HIDDEN: handleHidden(); break;
                    default: handleDefault(); break;
                }
            }
            handleSign();
            setLayoutDirty();
            redraw();
        }
        if (propName == PropName.sign)
            handleSignProperty();
    }
}
