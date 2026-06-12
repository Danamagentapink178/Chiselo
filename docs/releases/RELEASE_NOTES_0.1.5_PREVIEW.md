# Chiselo 0.1.5 Preview

Chiselo is a native macOS app for refining and delivering HTML pages and visual documents.

中文：Chiselo 是一款 HTML 精修与交付工具。打开现有或生成的 HTML 页面/文档，调整文字、图片、表格、模块和版式，交付前预检问题，然后导出干净 HTML、高保真 PDF 或尽量可编辑的 PPTX。

Creator note: Chiselo was built through vibe coding by a humanities-background creator who does not come from a programming background. Thanks to Codex and GPT for making this kind of software exploration possible.

## What Changed In 0.1.5

- Repositioned Chiselo around HTML finishing and delivery instead of generated-HTML-only, slide-only, or blank-project authoring workflows.
- Updated app language toward page refinement, canvas refinement, delivery preflight, object structure, and Chiselo project files.
- Kept generated HTML as one supported input source without making it the product identity.
- Clarified the intended workflow: identify document structure, refine objects precisely, check delivery risks, export HTML/PDF/PPTX, and review or restore earlier versions.
- Updated packaging and publishing docs for the `0.1.5` preview build.

## Who This Preview Is For

- People who already have an HTML page, document, report, dashboard, poster, or presentation-like file.
- People who receive generated HTML and need a precise second-pass editing and delivery tool.
- People who want delivery checks before exporting HTML, PDF, or PPTX.
- Personal, educational, research, evaluation, and non-commercial hobby users.

Commercial use is not allowed under the included license.

## Highlights

- Open HTML documents and Chiselo project files (`.html`, `.htm`, `.xhtml`, `.aislide`, `.json`).
- Drag HTML files into the app.
- Select visible page objects directly on the canvas.
- Edit text in place.
- Move, resize, align, duplicate, delete, and adjust layer order.
- Multi-select page objects with Shift/Cmd-click.
- Replace images with embedded PNG/JPG/GIF/SVG/WebP data URLs.
- Edit tables, including safer handling for `rowspan` and `colspan`.
- Show page/canvas boundaries, center lines, ruler ticks, snapping guides, and distribution controls.
- Run delivery checks for broken resources, SVG usage, clean HTML export, text overflow, out-of-bounds elements, and overlaps.
- Restore save snapshots from `.chiselo-history/`.
- Export clean standalone HTML.
- Export high-fidelity PDF.
- Export best-effort object-editable PPTX.

## Install

1. Download `Chiselo-0.1.5.dmg` after the GitHub Release asset is published.
2. Open the DMG.
3. Drag `Chiselo.app` to `Applications`.
4. Launch Chiselo.

This preview build is ad-hoc signed and not notarized. If macOS blocks the first launch, read the included `首次打开帮助.txt`.

## Known Limitations

Chiselo is an early preview. The following areas are still active research:

- complex scripts;
- responsive layouts;
- pseudo-elements;
- animations;
- cross-origin resources;
- perfect PPTX mapping for every CSS effect.

For important files, keep the generated `.chiselo-backup` and `.chiselo-history/` files until you have reviewed the final output.

## License

Chiselo is source-available for personal, educational, research, evaluation, and non-commercial hobby use only.

Commercial use is forbidden. This is not an OSI-approved open source license.
