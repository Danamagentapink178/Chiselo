---
name: chiselo-layout
description: Use when creating, editing, validating, or repairing Chiselo .aislide decks and layout-ready HTML for the Chiselo macOS editor.
---

# Chiselo Layout Skill

Create or edit `.aislide` JSON decks and layout-ready HTML artifacts that open cleanly in Chiselo.

## Workflow

1. Read `../../../shared/references/layout-rules.md` before drafting layouts.
2. Use `../../../shared/slide-schema.v1.json` as the contract.
3. Keep the deck source as JSON. Do not output arbitrary HTML as the primary artifact.
4. Use absolute canvas coordinates. Default canvas: `1280 x 720`.
5. Validate before finishing:

```bash
node ai-skills/shared/scripts/validate-deck.mjs path/to/deck.aislide
```

## Output Rules

- Use stable element ids such as `slide1-title`, `slide1-chart-panel`.
- Prefer `text` and `rect` elements for first-pass layouts.
- Keep title and content boxes editable.
- Use `locked: true` for imported backgrounds only.
- Export HTML only after the `.aislide` schema is valid.

## Repair Rules

When fixing a deck, preserve existing element ids unless the user asks for a rewrite. Make the smallest schema-compatible change that solves the visual or layout problem.
