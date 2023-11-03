package dex.util.rng.wfc;

import dex.util.rng.wfc.Pattern;


typedef Cell =
{
    /** The x-position of the cell in the wave. */
    var x: Int;

    /** The y-position of the cell in the wave. */
    var y: Int;

    /** The id of the tile pattern used to fill this cell; only valid if `observed` is `true`. */
    var pattern: Pattern;

    /** The entropy remaining for this unobserved cell. It is named this way to be compatible with the `PriorityQueue` datatype. */
    var priority: Int;

    /** The list of pattern ids that are currently possible states for this cell. Its length should be equal to `priority`, and if `observed` it should be `null`. */
    var ?possiblePatterns: Array<Pattern>;

    /** When `true`, this cell will have collapsed to one pattern id. */
    var observed: Bool;

    /** Used to keep track of whether a cell has been added to the priority queue or not. */
    var seen: Bool;
}
