# [Model Name]

A brief, 1-2 sentence description of what this model is, what problem it solves, or why you designed it.

<!-- markdownlint-disable MD033 -->
<p align="center">
    <img src="assets/media/renders/hero.png" alt="[Model Name] Hero" width="600">
</p>
<!-- markdownlint-enable MD033 -->

<!-- OPTIONAL: Contest Entry Block (Remove if not participating in a contest) -->

## 🏆 Contest Entry

- **Contest:** [Contest Name](https://example.com)
- **Host Platform:** [Creality Cloud / MakerWorld / Printables]
- **Category:** [e.g., Functional Prints / Daily Utilities]
<!-- END OPTIONAL -->

## 📥 Download & Print Profiles

Pre-sliced `.3mf` project files and individual `.stl` files are organized in the [`models/`](./models/) directory:

- **Single Color:** [`models/single/`](./models/single/) — Standard debossed single-material version.
- **Multi-Color Flush:** [`models/multi-color-flush/`](./models/multi-color-flush/) — Inlaid flat two-tone surface profile.
- **Multi-Color Embossed:** [`models/multi-color-embossed/`](./models/multi-color-embossed/) — Raised tactile multi-material profile.

Also available on creator platforms:

- [MakerWorld](https://makerworld.com/)
- [Printables](https://www.printables.com/)
- [Creality Cloud](https://www.crealitycloud.com/)

## 🖨️ Recommended Print Settings

### Structural Settings (All Variants)

- **Material:** [e.g., PETG or PLA+]
- **Layer Height:** 0.20 mm
- **Wall Loops:** [e.g., 4 walls for load-bearing parts]
- **Top / Bottom Shells:** 5 top, 4 bottom
- **Infill:** [e.g., 20%–25% Gyroid]
- **Supports:** [e.g., None required]
- **Brim:** [e.g., None required on clean PEI]

### Multi-Color Print Profiles (CFS / AMS)

- **Prime Tower:** Enabled (Width: 35 mm, Brim: 5 mm)
- **Sparse Layers:** Enable "No sparse layers (beta)" to reduce prime tower waste on single-color base layers
- **Top Surface Pattern:** `Monotonic` or `Monotonic Line`

## 🔩 Hardware Required

_100% 3D Printed - No extra hardware needed!_

<!-- Or list screws/inserts:
- 4x M3x12mm Socket Head Screws
- 4x M3 Heat Set Inserts
-->

## 🛠️ Customizing with OpenSCAD

Because this design is parametric, you can easily adjust dimensions or tolerances to fit your needs using `[model-name].scad`.

**Key Variables:**

- `PART` — Model mode: `"single"`, `"assembly"`, `"body"`, or `"insert"`
- `LOGO_STYLE` — Multi-color mode: `"flush"` or `"embossed"`
- `[variable_1]` — [Description] (Default: `XX mm`)

_To export multi-material STLs:_

1. Set `PART = "body";`, render (`F6`), and export `[model]-body.stl`.
2. Set `PART = "insert";`, render (`F6`), and export `[model]-insert.stl`.
3. Load both files into your slicer as a single multi-part object.

## 🧩 Assembly Instructions

1. [Step 1]
2. [Step 2]
3. [Step 3]

---

_Part of the [Cold Front Forge](https://github.com/OneBuffaloLabs/ColdFrontForge) open-source collection. Licensed under CC BY-NC-SA 4.0._

_Looking for finished physical prints or custom colors? Visit our shop: [coldfrontforge.etsy.com](https://coldfrontforge.etsy.com)_
