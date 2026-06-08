---
name: image-analysis
description: Use when you encounter an image file path or URL during research or file exploration — diagrams, screenshots, schematics, charts, or any visual content that cannot be understood from filename alone. Delegates analysis to the vision subagent and returns a text description you can reason over.
compatibility: opencode
---

## What I do

When you encounter an image (by file path, URL, or embedded reference) during
your work, do NOT skip or ignore it. Images often contain critical information
— architecture diagrams, circuit schematics, UI screenshots, charts — that
cannot be inferred from surrounding text alone.

## When to use me

Trigger this skill when you find:
- A file path ending in .png, .jpg, .jpeg, .gif, .webp, .svg
- A URL pointing to an image
- A markdown image reference: `![...](...)`
- A PDF page that is image-based rather than text-based

## Procedure

1. Note the image path or URL exactly.
2. Delegate to the `@vision` subagent with this prompt:
