---
name: chiselo-layout
description: Use when creating, editing, validating, or repairing Chiselo .aislide decks and layout-ready HTML for the Chiselo macOS editor.
---

# Chiselo Layout Skill

Produce `.aislide` JSON or layout-ready HTML that Chiselo can edit precisely.

## Process

1. Follow `../../../shared/references/layout-rules.md`.
2. Target `../../../shared/slide-schema.v1.json`.
3. Compose slides with editable elements using absolute geometry.
4. Validate with:

```bash
node ai-skills/shared/scripts/validate-deck.mjs path/to/deck.aislide
```

## Layout Guidance

- Default canvas is `1280 x 720`.
- Keep each slide structurally simple: background shapes, text blocks, media blocks.
- Do not use flex, grid, nested DOM, pseudo-elements, or percentage positioning as the editable source.
- Keep text readable and inside its box.
- Prefer fewer, well-aligned elements over many decorative fragments.

## Editing Guidance

For revisions, return a valid full deck or a clear JSON patch. Preserve ids, coordinates, and layer intent unless the requested change requires moving them.
