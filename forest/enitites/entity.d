module forest.entities.entity;
import brew.box, brew.vec, brew.color;

class Entity {
    uint id;
    uint parentId;
    uint childIds[];
    uint layer;
    uint partIds[];
    Vec2f pos;
    Box2f box;
    Color4f fg;
    Color4f bg;
}

