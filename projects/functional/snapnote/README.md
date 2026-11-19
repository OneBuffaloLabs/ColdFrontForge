# SnapNote — 3x3 Sticky Note Stencil System & Desk Caddy

![Status](https://img.shields.io/badge/Status-Draft-yellow)
![Lifecycle](https://img.shields.io/badge/Lifecycle-Stage_1-yellow)

> **Release Status:** Stage 1 (Draft) — Concept / WIP CAD.

A parametric 3" x 3" (76.2 mm x 76.2 mm) sticky note stencil system and all-in-one desk caddy featuring 2-sided corner registration, 45° chamfered pen channels, a 5-slot tiered stencil rack, and dual pen wells.

<!-- markdownlint-disable MD033 -->
<p align="center">
    <img src="assets/media/renders/hero.png" alt="SnapNote Hero" width="600">
</p>
<!-- markdownlint-enable MD033 -->

## 📥 Download & Print Profiles

Individual `.stl` files are organized in the [`models/`](./models/) directory:

- **Desk Caddy:** [`models/snapnote-caddy.stl`](./models/snapnote-caddy.stl) — All-in-one 3x3 pad tray, 5-slot angled stencil rack, and dual pen wells.
- **Stencil Base Blank:** [`models/snapnote-base.stl`](./models/snapnote-base.stl) — Blank 3x3 registration stencil (`BASE`).
- **Checklist Stencil:** [`models/snapnote-check.stl`](./models/snapnote-check.stl) — 6 ruled lines with 4.0 mm filleted checkboxes (`CHECK`).
- **Bullet List Stencil:** [`models/snapnote-bullet.stl`](./models/snapnote-bullet.stl) — 6 ruled lines with 3.6 mm circular bullets (`BULLET`).
- **Ruled Lines Stencil:** [`models/snapnote-lines.stl`](./models/snapnote-lines.stl) — 7 evenly spaced ruled lines (`LINES`).

## 🖨️ Recommended Print Settings

### Structural Settings (All Variants)

- **Primary Material:** PLA+
- **Layer Height:** 0.20 mm
- **Wall Loops:** 3–4 perimeters
- **Top / Bottom Shells:** 5 top, 4 bottom
- **Infill:** 15%–20% Gyroid
- **Supports:** None required (stencils print flipped flat on `Z = 0`; caddy prints flat on `Z = 0`)
- **Brim:** None required on clean PEI

## 🔩 Hardware Required

_100% 3D Printed - No extra hardware needed!_

_Optional:_ 4x 8 mm adhesive silicone bumper feet for the underside caddy pockets (8.2 mm x 1.0 mm).

## 🛠️ Customizing with OpenSCAD

Because this design is parametric, you can easily adjust pad dimensions, clearances, slot widths, or pattern layouts using [`snapnote.scad`](./snapnote.scad) and the modular source files in [`src/`](./src/).

**Key Variables:**

- `part_to_render` — Model to render: `"caddy"`, `"base"`, `"check"`, `"bullet"`, or `"lines"`
- `render_mode` — Stencil orientation: `"print"` (flipped onto `Z = 0`) or `"design"`
- `pad_width` / `pad_height` — Nominal sticky note size (Default: `76.2 mm`)
- `pad_clearance` — Stencil registration tolerance (Default: `0.8 mm`)

### Automated Builds with Make

This project includes a `Makefile` to generate STLs automatically via OpenSCAD:

```bash
# Build all component STLs
make all

# Build an individual part (caddy, base, check, bullet, lines)
make check

# Clean generated meshes
make clean
```

## 🧩 Assembly Instructions

1. Print the desk caddy and your desired stencil templates flat on the build plate without supports.
2. *(Optional)* Press four 8 mm adhesive silicone feet into the underside caddy pockets.
3. Drop a standard 3" x 3" sticky note pad into the front tray, rack stencils upright in the rear slots, and place your pens in the side wells.

---

_Part of the [Cold Front Forge](https://github.com/OneBuffaloLabs/ColdFrontForge) open-source collection. Licensed under CC BY-NC-SA 4.0._

_Looking for finished physical prints or custom colors? Visit our shop: [coldfrontforge.etsy.com](https://coldfrontforge.etsy.com)_
