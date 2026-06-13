# Chiselo 0.1.10 Preview

Chiselo is a native macOS app for high-fidelity refinement and delivery of existing HTML files.

中文：Chiselo 是一款 HTML 精修与交付工具。打开已有 HTML 页面/文档，精修文字、图片、表格、模块和版式，交付前预检问题，然后导出干净 HTML、高保真 PDF 或尽量可编辑的 PPTX。

## What Changed In 0.1.10

- Adds `视觉变更复核` to export preflight so changed objects can be reviewed one by one before delivery.
- Returns target lists for changed visual objects, not only the first changed object.
- Lets the sidebar delivery check and export preflight use the same changed-object targeting behavior.
- Keeps deleted or non-locatable changes in the risk count while only offering buttons for real selectable objects.
- Updates packaging to `0.1.10`.

## Why This Matters

High-quality HTML finishing is not just about finding export risks. Users also need confidence that their own adjustments did not accidentally move, resize, recolor, or rewrite nearby objects. This preview makes the visual-diff workflow more operational: detect changed objects, step through them, confirm the change, then export HTML, PDF, or PPTX.

## Install

1. Download `Chiselo-0.1.10.dmg` after the GitHub Release asset is published.
2. Open the DMG.
3. Drag `Chiselo.app` to `Applications`.
4. Launch Chiselo.

This preview build is ad-hoc signed and not notarized. If macOS blocks the first launch, read the included `首次打开帮助.txt`.

For GitHub Releases, publish the final downloadable build as a normal release instead of a pre-release when the website button should always resolve to the newest asset through `/releases/latest`.

## Known Limitations

Chiselo is an early preview. Complex scripts, responsive layouts, animations, pseudo-elements, canvas pixels, closed components, cross-origin embedded pages, and perfect editable PPTX mapping for every CSS effect still need ongoing work.

For important files, keep the `.chiselo-backup` and `.chiselo-history/` files until you have reviewed the final output.

## License

Chiselo is source-available for personal, educational, research, evaluation, and non-commercial hobby use only.

Commercial use is forbidden. This is not an OSI-approved open source license.
