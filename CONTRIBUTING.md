# Contributing

Thanks for helping Chiselo improve.

Chiselo is a non-commercial, source-available project. By contributing, you agree that your contribution can be distributed under the [Chiselo Personal Non-Commercial License 1.0](LICENSE).

## Ground Rules

- Keep the product goal clear: HTML is the primary asset, Chiselo adds an Office-like visual editing layer, and HTML/PDF/PPTX are delivery formats.
- Prefer small, testable changes.
- Do not add commercial-only dependencies or license-incompatible code.
- Do not paste proprietary code or private documents into issues or pull requests.
- Include before/after screenshots for visual editing changes when possible.

## Development Setup

```bash
swift build
swift run Chiselo
```

Useful checks:

```bash
node --check Sources/Chiselo/Resources/Editor/editor.js
swift scripts/import-smoke-test.swift
swift scripts/import-adapter-test.swift
swift scripts/precision-adjustment-test.swift
```

## Pull Requests

Good pull requests include:

- a short explanation of the problem;
- the implementation approach;
- commands that were run;
- screenshots or exported artifacts for UI/export changes;
- notes about limitations or remaining risks.

## Project Voice

The repository is intentionally honest that Chiselo started as a vibe-coded project by a non-programmer using AI assistance. Improvements are welcome, but please keep feedback practical and kind.
