# Slasher Spheres: Billy the Puppet Sphere

A multi-part, support-free display sphere merging classic creature-catching geometry with the eerie, mechanical look of Billy the Puppet from the _Saw_ franchise. Engineered in OpenSCAD for glue-free friction assembly, featuring recessed eye sockets, signature cheek spiral inlays, an integrated chin/jawline base, and a flattened footing for shelf stability.

<!-- markdownlint-disable MD033 -->
<p align="center">
    <img src="assets/media/renders/billy-ball-hero.png" alt="Billy the Puppet Sphere Hero" width="600">
</p>
<!-- markdownlint-enable MD033 -->

## 📥 Download & Print Profiles

Pre-configured print files and component meshes are organized in the [`models/`](./models/) directory:

- **Shell Components:**
  - `models/billy-ball-top.stl` — White upper hemisphere with orbital sockets and cheek spiral recesses.
  - `models/billy-ball-bottom.stl` — Black lower hemisphere with flattened display base and puppet chin contours.
  - `models/billy-ball-ring.stl` — Black center equatorial dividing band.
- **Internal Core & Button:**
  - `models/billy-ball-filler.stl` — Rectangular internal alignment core peg.
  - `models/billy-ball-front-ring.stl` — Outer black button bezel housing.
  - `models/billy-ball-button.stl` — Stepped center red actuator (matching Billy's bow tie).
- **Detail Chips (Face Inserts):**
  - `models/billy-chips-black.stl` — Black eye socket backings.
  - `models/billy-chips-red.stl` — Red cheek spiral inserts and eye pupil accents.

Also available on creator platforms:

- [MakerWorld](https://makerworld.com/) _(Coming Soon)_
- [Printables](https://www.printables.com/) _(Coming Soon)_
- [Creality Cloud](https://www.crealitycloud.com/) _(Coming Soon)_

## 🖨️ Recommended Print Settings

### Structural & Shell Settings

- **Material:** PLA or PETG.
- **Layer Height:** 0.20 mm.
- **Wall Generator:** **Arachne (Mandatory)** to resolve the fine lines of the cheek spirals without gaps.
- **Wall Loops:** 3–4 perimeters for solid pocket floors.
- **Infill:** 15% Gyroid for hemispheres; **100% solid infill for detail chips** to withstand insertion pressure.
- **Seam Position:** **Back / Rear** to ensure a smooth, porcelain-like finish across the face.
- **Orientation:** Flat-face down on the build plate for hemispheres and dividing rings. Print the core filler peg flat on its side for maximum shear strength.
- **Supports:** None required.
- **Elephant Foot Compensation:** **0.15 mm**. Critical for high-tolerance spiral inserts and mating rims.

## 🔩 Hardware Required

_100% 3D Printed — No screws, inserts, or adhesives needed under calibrated tolerances._

## 🛠️ Customizing with OpenSCAD

Adjust clearances, feature depths, or export component STLs using `billy-ball.scad`.

**Key Variables:**

- `part_to_render` — Target export mode (`"top"`, `"bottom"`, `"ring"`, `"front_ring"`, `"button"`, `"filler"`, `"chips_black"`, `"chips_red"`).
- `mechanical_clearance` — Clearances for the core peg, center ring, and button housing (Default: `0.05 mm`).
- `spiral_clearance` — Tolerance offset for circular cheek inserts (Default: `0.02 mm`).
- `eye_pocket_depth` — Depth of the eye cavities (Default: `4.0 mm`).

## 🧩 Assembly Instructions

1. **Install Face Chips:** Press the black socket backings and red pupil chips into the upper eye cavities. Press the red cheek spirals into the circular pockets on the white top shell, making sure the spiral orientation is aligned before pushing completely flush.
2. **Build Core & Shells:** Slide the rectangular filler peg into the bottom hemisphere, slide the center ring over the peg, and press the top hemisphere down until flush.
3. **Install Front Button:** Press the red button into the black bezel ring, then press that combined assembly into the front equator socket.
4. **Troubleshooting:**
   - **Spiral Fit:** If the spirals feel too tight, check that the Arachne wall generator was enabled during slicing, or lightly shave any first-layer squish with a hobby knife.
   - **Spinning Inserts:** Because the spirals are circular, a tiny dab of CA glue behind them prevents them from rotating over time.
   - **Too Loose?** A small drop of CA glue inside the internal peg slot or button bezel guarantees permanent display stability.

---

_Disclaimer: This is a fan-art project provided for personal use only. It is not affiliated with, authorized by, or endorsed by the Saw franchise, Lionsgate Films, Twisted Pictures, Pokémon, or Nintendo._

_Part of the [Cold Front Forge](https://github.com/OneBuffaloLabs/ColdFrontForge) open-source collection. Licensed under CC BY-NC-SA 4.0._

_Looking for finished physical prints or custom colors? Visit our shop: [coldfrontforge.etsy.com](https://coldfrontforge.etsy.com)_
