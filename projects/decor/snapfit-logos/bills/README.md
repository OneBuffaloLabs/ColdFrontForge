# Snap-Fit Buffalo Bills Emblem

A multi-part, glue-free friction-fit display emblem designed for clean multi-color printing on standard single-extruder 3D printers without requiring an AMS or mid-print filament swaps.

<!-- markdownlint-disable MD033 -->
<p align="center">
    <img src="assets/media/renders/snapfit-bills-hero.png" alt="Snap-Fit Buffalo Bills Logo Hero" width="600">
</p>
<!-- markdownlint-enable MD033 -->

## 📥 Download & Print Profiles

Pre-configured print files and component meshes are located in the [`models/`](./models/) directory:

- **White Backing Plate:** `models/snapfit-bills-base-white.stl` — 6.0 mm structural base with precision recessed pockets.
- **Blue Body Insert:** `models/snapfit-bills-insert-blue.stl` — Silhouette buffalo body and legs.
- **Red Streak Insert:** `models/snapfit-bills-insert-red.stl` — Center charging stripe accent.

Also available on creator platforms:

- [MakerWorld](https://makerworld.com/en/models/2418758-snapfit-buffalo-bills-logo)
- [Printables](https://www.printables.com/model/1607775-snapfit-buffalo-bills-logo)
- [Creality Cloud](https://www.crealitycloud.com/model-detail/snapfit-buffalo-bills-logo)

## 🖨️ Recommended Print Settings

### Structural & Surface Settings

- **Orientation:** Flat on the build plate (all pieces lay flat; no supports needed).
- **Material:** PLA or PLA+ (recommended for dimensional stiffness).
- **Layer Height:** 0.20 mm.
- **Wall Generator:** **Arachne (Mandatory)**. Classic wall engines struggle to resolve the tight gaps around the eye and the red streak's tapered tail.
- **Wall Loops:** 3–4 perimeters.
- **Top / Bottom Shells:** 5 top, 4 bottom.
- **Top Surface Pattern:** `Concentric` (creates a clean finish that traces the contours of the logo) or `Monotonic Line`.
- **Infill:** 15%–20% Gyroid.
- **Elephant Foot Compensation:** **0.15 mm**. Critical for friction fit; first-layer squish will prevent inserts from seating cleanly into the base pockets.
- **Supports:** None.
- **Brim:** None required on clean PEI sheets.

## 🔩 Hardware Required

_100% 3D Printed — No extra hardware or glue needed!_

## 🛠️ Customizing with OpenSCAD

Because this design is parametric, you can adjust tolerances or render specific parts using `snapfit-bills.scad`.

**Key Variables:**

- `PART` — Target output: `"assembly"`, `"base"`, `"blue"`, or `"red"`.
- `clearance` — Main body tolerance offset (Default: `0.10 mm`).
- `red_clearance` — Thin streak tolerance offset (Default: `0.05 mm`).
- `base_h` — Total plate depth (Default: `6.0 mm`).

_To export individual component STLs:_

1. Set `PART = "base";`, compile (`F6`), and export `snapfit-bills-base-white.stl`.
2. Set `PART = "blue";`, compile (`F6`), and export `snapfit-bills-insert-blue.stl`.
3. Set `PART = "red";`, compile (`F6`), and export `snapfit-bills-insert-red.stl`.

## 🧩 Assembly & Fit Guide

1. Allow the print bed to cool completely before removing parts to prevent bowing or warping the backing plate.
2. Place the white backing plate flat on a firm, level surface.
3. Align the blue body insert over its recessed pocket and press down firmly with the flat of your thumb until flush.
4. Align the red charging streak insert over the center channel and press down into place.
5. **Troubleshooting:**
   - **Too Tight?** Verify your slicer used the **Arachne** perimeter generator and check for first-layer elephant foot. A light pass with a deburring blade or sand block around the bottom perimeter will ease insertion.
   - **Too Loose?** Differences in filament shrinkage can affect tolerances. If pieces seat loosely, a tiny dot of CA glue inside the pocket will anchor them permanently.

---

_Disclaimer: This is a fan-art project provided for personal use only. It is not affiliated with, authorized by, or endorsed by the Buffalo Bills or the National Football League (NFL)._

_Part of the [Cold Front Forge](https://github.com/OneBuffaloLabs/ColdFrontForge) open-source collection. Licensed under CC BY-NC-SA 4.0._

_Looking for finished physical prints or custom colors? Visit our shop: [coldfrontforge.etsy.com](https://coldfrontforge.etsy.com)_
