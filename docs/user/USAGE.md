# Usage Guide

## Open HTML

Use the Open button or drag a `.html`, `.htm`, or `.xhtml` file into the Chiselo window. You can also drag a file onto `Chiselo.app` in Finder.

Each document opens in a browser-style tab.

## Select And Edit

- Click rendered HTML content to select an element.
- Double-click text-like elements to edit text in place.
- Use the left DOM tree only when nested elements are hard to click.
- Use Shift/Cmd-click for multi-select.
- Press arrow keys to nudge selected objects.
- Hold Shift with arrow keys for larger nudges.
- Use Command + mouse wheel to zoom.

## Layout Modes

`Free` mode writes absolute positioning and gives HTML an Office-like direct layout editing feel.

`Transform` mode writes `transform: translate(...)` and is gentler when preserving the original document flow matters.

## Images

Select an image and use the replace image action. Chiselo embeds the replacement as a data URL so exported HTML remains portable.

## Tables

Select a table, row, or cell to reveal row/column actions. Chiselo handles simple tables and includes extra protection for merged cells.

## Delivery Check

The left sidebar flags delivery risks such as broken resources, temporary editor markers, complex tables, SVG usage, text overflow, out-of-bounds elements, and obvious overlaps. When a risk points to a real HTML element, click it to select that element on the canvas.

## Freeze Layout

Freeze Layout converts the current rendered HTML into a structured editable Chiselo tab. This is useful when an HTML page, document, poster, dashboard, or slide-style page should behave like a fixed visual canvas for precise Office-like adjustment.

## Export

- HTML: clean edited document with Chiselo temporary attributes removed.
- PDF: high-fidelity visual final output.
- PPTX: best-effort object-editable delivery file.

PDF is the fidelity fallback when a delivery format cannot represent a CSS effect as editable objects.
