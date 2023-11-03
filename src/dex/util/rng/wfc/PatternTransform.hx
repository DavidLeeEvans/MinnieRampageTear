package dex.util.rng.wfc;

enum PatternTransform
{
    /**
     * No transform, keep the pattern as in the input image.
     */
    None;

    /**
     * Flip the pattern horizontally.
     */
    FlipHorizontal;

    /**
     * Flip the pattern horizontally.
     */
    FlipVertical;

    /**
     * Flip the pattern both horizontally and vertically.
     */
    FlipHorizontalAndVertical;

    /**
     * Rotate the pattern.
     */
    Rotate(rot: PatternRotation);
}
