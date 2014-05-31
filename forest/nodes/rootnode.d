/*
 * Forest File Finder by erik wikforss
 */
module forest.nodes.rootnode;
import forest.nodes.node;
import forest.nodes.framenode;
import brew.vec;
import brew.color;
import brew.insets;

class RootNode : CutFrameNode {
    enum  {
        ROOT_COLOR = NodeColor(Color4d(0.1, 0.1, 0.1, 1.0), Color4d(0.9, 0.9, 0.9, 1.0)),
        ROOT_PADDING = Insets2d(160,160,100,100),
        ROOT_CUT = Vec2d.fill(8),
        ROOT_LINE_WIDTH = 2.0,
        NODE_SPACING = 50,
    }
    enum PropName {
        worldBounds = "worldBounds",
    }

    private {
        Box2d _worldBounds = Box2d(0,0,800,600);
    }

    this() {
        cut = ROOT_CUT;
        nodeColor = ROOT_COLOR;
        lineWidth = ROOT_LINE_WIDTH;
    }

    override void updateLayout() {
        double next = 0;
        double m = 0;
        foreach (Node c; visibleChildren) {
            c.updateTotalBounds();
            c.offset.y = next - c.totalBounds.top + m;
            m = NODE_SPACING;
            next = next + c.totalBounds.height;
        }
        updateBounds();
        updateTotalBounds();
    }

    override void updateBounds() {
        bounds = computeTotalBounds() + ROOT_PADDING;
    }

    final void worldBounds(in Box2d newWorldBounds) {
        if (newWorldBounds != _worldBounds) {
            auto oldWorldBounds = _worldBounds;
            _worldBounds = newWorldBounds;
            emit(PropName.worldBounds, newWorldBounds, oldWorldBounds);
        }
    }

    final ref const(Box2d) worldBounds() const {
        return _worldBounds;
    }
}

