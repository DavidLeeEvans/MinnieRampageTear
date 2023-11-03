package dex.types;

enum abstract Direction(Int)
{
    var Up;
    var Right;
    var Down;
    var Left;

    public inline function dirX(): Int
    {
        if (cast(this, Direction) == Right)
        {
            return 1;
        }
        else if (cast(this, Direction) == Left)
        {
            return -1;
        }
        else
        {
            return 0;
        }
    }

    public inline function dirY(): Int
    {
        if (cast(this, Direction) == Up)
        {
            return 1;
        }
        else if (cast(this, Direction) == Down)
        {
            return -1;
        }
        else
        {
            return 0;
        }
    }
}
