# CAD — OpenArm

The full OpenArm assembly is designed in Onshape.

**Onshape document:** [OpenArm Assembly](https://cad.onshape.com/documents/df36195e73c08f9a76f4d7ba/w/6e8ef89e1a75c97e46a746ab/e/d52665107da01e4d7b02bdb3?renderMode=0&uiState=6a09e84c662c2d04bcc73d98)

---

## Why Onshape Instead of Uploaded Files

The design is changing frequently. Uploading STEP/STL files to the repo creates a maintenance problem — they go stale immediately after any revision, and there's no way to track which version of the CAD corresponds to which version of the documentation.

Onshape keeps everything in one place. Anyone can:
- View the full assembly and all sub-parts
- Inspect part relationships and joint structure
- Download individual components in any format (STEP, STL, IGES, etc.)
- Make a copy of the document and modify it for their own build

This will change if/when the design stabilizes enough to warrant a formal release with downloadable files.

---

## Current Design Status

The CAD is in active development. Major assemblies exist for all four DOF but several details are still being refined:
- Shoulder bracket and double-bearing mount
- Encoder mounting geometry (constraint: magnet-to-sensor gap 0.5–3mm)
- Cable routing through joint shafts
- Belt tensioning mechanism (sliding motor mount vs. idler)

No hardware has been fabricated yet. The CAD will be updated based on prototype testing feedback.

---

## Design Parameters

| Parameter | Value |
|---|---|
| Link lengths (L1, L2, L3) | 75 mm each |
| Shoulder offset from base axis | 31.64 mm |
| Shoulder height | 55 mm |
| Deadzone volume | 180mm × 100mm × 57mm |
| Belt type | HTD-5M, 15mm width |
| Primary fasteners | M3 metric |
| Primary structure | PETG-CF printed + aluminum reinforcement |

---

## Photos

Current CAD renders are in `Photos/current/`.

Early prototypes (2023–2024) are in `Photos/prototypes/`.
