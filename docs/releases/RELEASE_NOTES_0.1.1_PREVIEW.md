# Chiselo 0.1.1 Preview

Chiselo is a native macOS app for refining and delivering HTML pages and visual documents.

中文：Chiselo 是一款 HTML 精修与交付工具。打开现有或生成的 HTML 页面/文档，调整文字、图片、表格、模块和版式，然后导出可交付文件。

Creator note: Chiselo was built through vibe coding by a humanities-background creator who does not come from a programming background. Thanks to Codex and GPT for making this kind of software exploration possible.

## What Changed In 0.1.1

- Reorganized the public repository structure so the app source now lives in the top-level `Chiselo/` folder.
- Fixed CI after the repository cleanup.
- Improved HTML text editing stability by locking computed typography while editing.
- Forced plain-text paste during HTML text editing to reduce accidental font mismatches.
- Made delivery-check summary rows clickable so warnings can jump to the related HTML element.

## Who This Preview Is For

- People who already have an HTML page, document, poster, dashboard, or presentation-like file.
- People working with generated HTML and then needing a fast visual editing pass.
- Personal, educational, research, evaluation, and non-commercial hobby users.

Commercial use is not allowed under the included license.

## Highlights

- Open HTML documents and Chiselo project files (`.html`, `.htm`, `.xhtml`, `.aislide`, `.json`).
- Drag HTML files into the app.
- Select visible rendered objects directly on the canvas.
- Edit text in place.
- Move, resize, align, duplicate, delete, and adjust layer order.
- Use an object-structure fallback for nested selections.
- Replace images with embedded data URLs.
- Edit table rows, columns, cells, and common table styles.
- Run delivery checks for broken resources, clean HTML export, SVG/table notices, overflow, out-of-bounds elements, and obvious overlaps.
- Export clean standalone HTML.
- Export high-fidelity PDF.
- Export best-effort object-editable PPTX.

## Install

1. Download `Chiselo-0.1.1.dmg`.
2. Open the DMG.
3. Drag `Chiselo.app` to `Applications`.
4. Launch Chiselo.

This preview build is ad-hoc signed and not notarized. If macOS blocks the first launch, use Finder right-click -> Open.

## Known Limitations

Chiselo is an early preview. The following areas are still active research:

- complex scripts;
- responsive layouts;
- pseudo-elements;
- animations;
- cross-origin resources;
- perfect PPTX mapping for every CSS effect.

For important files, work on a copy and review exported output before delivery.

## License

Chiselo is source-available for personal, educational, research, evaluation, and non-commercial hobby use only.

Commercial use is forbidden. This is not an OSI-approved open source license.
