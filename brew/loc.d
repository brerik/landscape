/*
 * Brew Library by erik wikforss
 */
module brew.loc;
private import std.string;

struct Loc2
{
    int row, col;

    this(int row, int col)
    {
        this.row = row;
        this.col = col;
    }

    string toString()
    {
        return format("Loc2[row=%d, column=%d]", row, col);
    }
}

