# Chiselo Layout Rules

Use canvas coordinates. The default canvas is 1280 x 720.

## Element Rules

- Every element must have a stable `id`.
- Use absolute `x`, `y`, `w`, `h`, `rotation`, and `z`.
- Keep text inside its box. Increase `h` or reduce `fontSize` if text overflows.
- Use rectangles and simple shapes as editable elements instead of decorative nested HTML.
- Avoid percentage units, flex, grid, CSS transforms beyond `rotation`, and pseudo-elements in editable output.
- Use `locked: true` only for background or imported elements that should not move accidentally.

## Visual Rules

- Keep margins consistent across slides.
- Prefer 64 to 96 px outer margins on a 1280 x 720 canvas.
- Snap important blocks to shared left edges, centers, or baselines.
- Avoid text smaller than 18 px for presentation content.
- Keep title text within 44 to 68 px unless the slide is intentionally title-only.
- Use restrained z ordering: background shapes first, content next, annotations last.

## Import Strategy

For arbitrary AI HTML:

1. Convert obvious text boxes, images, and shapes into schema elements.
2. Preserve only layout-critical styles.
3. If the DOM is too nested or fluid, render it as a locked background and add editable overlay elements.
