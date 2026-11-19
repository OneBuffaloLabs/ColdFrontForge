# SnapNote — 3x3 Sticky Note Stencil System & Desk Caddy

![Status](https://img.shields.io/badge/Status-Draft-yellow)
![Lifecycle](https://img.shields.io/badge/Lifecycle-Stage_1-yellow)

> **Release Status:** Stage 1 (Draft) — Concept / WIP CAD.

## 📖 Overview

**SnapNote** is a parametric 3" x 3" (76.2 mm × 76.2 mm) sticky note stencil system and all-in-one desktop caddy. Each stencil features a `1.0` mm drawing plane (`5` layers at `0.2` mm), a `2.0` mm downward 2-sided alignment lip along the top and left edges (leaving bottom and right edges open for sheet peeling), a debossed top index pull tab, and `45°` top-edge slot chamfers so pen tips glide smoothly into channels without snagging.

The companion desk caddy combines a `77.2` mm × `77.2` mm pad tray with a front thumb scoop, a `5`-slot tiered and `12°`-angled stencil rack, and dual `13.0` mm × `50.0` mm vertical pen wells.

<!-- markdownlint-disable MD033 -->
<p align="center">
    <img src="assets/media/renders/hero.png" alt="SnapNote Hero" width="600">
</p>
<!-- markdownlint-enable MD033 -->

## 🗂️ Template Catalog & Downloads

Compiled `.stl` meshes are organized by pack in [`models/`](./models/):

| Category | File | Pull Tab | Description |
| :--- | :--- | :--- | :--- |
| **Core** | [`models/snapnote-caddy.stl`](./models/snapnote-caddy.stl) | — | All-in-one 3x3 pad tray, 5-slot angled stencil rack, and dual pen wells |
| **Core** | [`models/snapnote-base.stl`](./models/snapnote-base.stl) | `BASE` | Blank 3x3 registration stencil for custom layouts |
| **Checklists** | [`models/checklists/snapnote-check.stl`](./models/checklists/snapnote-check.stl) | `CHECK` | 6 ruled lines with `4.0` mm filleted square checkboxes |
| **Checklists** | [`models/checklists/snapnote-bullet.stl`](./models/checklists/snapnote-bullet.stl) | `BULLET` | 6 ruled lines with `3.6` mm circular bullet apertures |
| **Checklists** | [`models/checklists/snapnote-lines.stl`](./models/checklists/snapnote-lines.stl) | `LINES` | 7 evenly spaced edge-to-edge ruled lines |
| **Productivity** | [`models/productivity/snapnote-2x2.stl`](./models/productivity/snapnote-2x2.stl) | `2X2` | Eisenhower 2x2 priority matrix with perimeter margins |
| **Productivity** | [`models/productivity/snapnote-habit.stl`](./models/productivity/snapnote-habit.stl) | `HABIT` | 7-day weekly habit tracker (Mon–Sun columns × 5 rows) |
| **Productivity** | [`models/productivity/snapnote-top3.stl`](./models/productivity/snapnote-top3.stl) | `TOP3` | 3 numbered priority rows (`1`, `2`, `3`) with secondary note lines |
| **Drafting** | [`models/drafting/snapnote-dots.stl`](./models/drafting/snapnote-dots.stl) | `DOTS` | `5.0` mm spaced dot-grid matrix (`15 × 15` over `70` mm × `70` mm) |
| **Drafting** | [`models/drafting/snapnote-panels.stl`](./models/drafting/snapnote-panels.stl) | `PANELS` | 2x2 storyboard comic panels with `2.0` mm dividers and `1.5` mm fillets |
| **Drafting** | [`models/drafting/snapnote-iso.stl`](./models/drafting/snapnote-iso.stl) | `ISO` | Non-intersecting `30°`/`-30°`/`90°` isometric wireframe guide |
| **Games** | [`models/games/snapnote-xo.stl`](./models/games/snapnote-xo.stl) | `XO` | Classic 3x3 Tic-Tac-Toe grid with bridged intersections |
| **Games** | [`models/games/snapnote-dotbox.stl`](./models/games/snapnote-dotbox.stl) | `DOTBOX` | `5 × 5` Dots & Boxes matrix (`4 × 4` playable boxes) |

## 🖨️ Slicer Settings & Tolerances

### Stencils (All Templates)

- **Primary Material:** PLA or PLA+ (rigid, low-warp)
- **Orientation:** Face-down (`render_mode = "print"`, flat top writing surface on `Z = 0`, alignment lip pointing upward)
- **Layer Height:** `0.20` mm (`5` layers for the `1.0` mm drawing plane; `2` layers for `0.4` mm chamfers and debossed tab text)
- **Infill:** `100%` (or `5+` top/bottom shells so the `1.0` mm plate prints completely solid)
- **Wall Perimeters:** `3` perimeters (`Arachne` wall generator recommended for crisp `0.95` mm channels)
- **Supports / Brim:** None required

### First-Layer Calibration & Elephant Foot Compensation

Because SnapNote writing channels are `0.95` mm–`1.05` mm wide (`DOTS` apertures are `1.4` mm) and print **face-down** on the build plate, first-layer squish directly affects slot clearance:

- **Elephant Foot Compensation:** Set to `0.10`–`0.15` mm (or **Initial Layer Horizontal Expansion:** `-0.10` mm in Cura). Without compensation, first-layer squish narrows or fuses `0.95` mm pen channels shut on the writing face.
- **Z-Offset / Bed Leveling:** Avoid over-squishing the first layer; a clean, slightly textured PEI first layer keeps `0.4` mm top-edge chamfers crisp and readable.
- **First-Layer Speed:** `25`–`35` mm/s for outer perimeters to prevent corner lifting around fine `1.4` mm dot grids (`DOTS`) and `1.0` mm line slots.

### Desk Caddy

- **Primary Material:** PLA+ or PETG
- **Orientation:** Flat on the build plate (`Z = 0`)
- **Layer Height:** `0.20` mm
- **Wall Perimeters:** `3`–`4` perimeters (for rigid stencil rack dividers and pen tower walls)
- **Infill:** `15%`–`20%` Gyroid
- **Supports / Brim:** None required (`12°` slot tilt and `8.2` mm × `1.0` mm underside foot pockets print support-free)

## ✒️ Pen Compatibility Chart

Tested channel widths (`0.95` mm–`1.05` mm) and `45°` entry chamfers are tuned for **`0.38` mm–`0.7` mm** pen tips:

| Pen Type | Example Models | Tip Size | Fit & Notes |
| :--- | :--- | :--- | :--- |
| **Fineliner** | Sakura Pigma Micron 05, Staedtler Pigment Liner | `0.38`–`0.5` mm | Ideal fit for `DOTS` (`1.4` mm holes) and fine `0.95` mm lines with zero drag |
| **Gel Pen (Fine)** | Pilot G2 `0.5`, Muji `0.38`/`0.5`, Pentel EnerGel `0.5` | `0.38`–`0.5` mm | Smooth glide along `45°` chamfers; crisp checklist & grid tracking |
| **Gel Pen (Medium)** | Pilot G2 `0.7`, Sharpie S-Gel `0.7` | `0.7` mm | Snug, guided tracking in `0.95` mm–`1.05` mm channels without wandering |
| **Ballpoint** | Standard Bic / Papermate medium ballpoint | `0.7`–`1.0` mm | Works cleanly in `LINES`, `CHECK`, `2X2`, and `XO` (`0.95`–`1.05` mm slots); slightly tight in `1.4` mm `DOTS` holes |

## 🔩 Bill of Materials (BOM)

_Stencils are 100% 3D printed. Optional non-slip feet are recommended for the desk caddy:_

| Qty | Component | Specification | Notes |
| :--- | :--- | :--- | :--- |
| `1` | Printed Desk Caddy | `snapnote-caddy.stl` | Holds 1 standard 3" x 3" pad, 5 stencils, 2 pens |
| `1+` | Printed Stencils | Any template STL | Print `1.0` mm plate at `100%` infill |
| `4` *(optional)* | Adhesive Rubber / Silicone Feet | `8` mm diameter × `1` mm thick | Fits `8.2` mm × `1.0` mm recessed underside pockets |
| `1` | Sticky Note Pad | Standard 3" x 3" (`76.2` mm × `76.2` mm) | Fits `77.2` mm × `77.2` mm caddy tray (`1.0` mm tolerance) |

## 🛠️ Customizing with OpenSCAD

Adjust pad dimensions, clearances, slot widths, or pattern layouts in [`src/snapnote.scad`](./src/snapnote.scad) and the modular pattern files in [`src/`](./src/).

**Key Variables:**

- `part_to_render` — `"caddy"`, `"base"`, `"check"`, `"bullet"`, `"lines"`, `"2x2"`, `"habit"`, `"top3"`, `"dots"`, `"panels"`, `"iso"`, `"xo"`, or `"dotbox"`
- `render_mode` — `"print"` (flipped onto `Z = 0`) or `"design"` (pad fitment view)
- `pad_width` / `pad_height` — Nominal sticky note size (Default: `76.2` mm)
- `pad_clearance` — Stencil registration tolerance (Default: `0.8` mm)

### Automated Builds with Make

```bash
# Build all component STLs
make all

# Build a specific pattern pack
make checklists      # check, bullet, lines
make productivity    # 2x2, habit, top3
make drafting        # dots, panels, iso
make games           # xo, dotbox

# Build a single part
make check

# Clean generated meshes and dependency graphs
make clean
```

## 🧩 Assembly Instructions

1. Print the desk caddy and your desired stencil templates flat on the build plate without supports.
2. *(Optional)* Press four `8` mm × `1` mm adhesive silicone/rubber feet into the underside caddy pockets.
3. Drop a standard 3" x 3" sticky note pad into the front tray, rack stencils upright in the rear slots, and place your pens in the side wells.

---

_Part of the [Cold Front Forge](https://github.com/OneBuffaloLabs/ColdFrontForge) open-source collection. Licensed under CC BY-NC-SA 4.0._

_Looking for finished physical prints or custom colors? Visit our shop: [coldfrontforge.etsy.com](https://coldfrontforge.etsy.com)_
