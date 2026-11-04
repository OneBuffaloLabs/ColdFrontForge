# Cold Snap Exhibit — Architectural Pedestal Plinth & A-Frame Easel

A museum-grade tabletop card plinth and easel engineered to showcase high-value trading cards—including PSA graded slabs, Cold Snap Slabs, and standard 35pt toploaders—with classical architectural presence, an optimal 78° viewing angle, and 100% support-free FDM printing.

<!-- markdownlint-disable MD033 -->
<p align="center">
    <img src="assets/media/photos/SlabPedestal1.webp" alt="Cold Snap Exhibit Hero" width="600">
</p>
<!-- markdownlint-enable MD033 -->

## 📥 Download & Print Profiles

Pre-rendered `.stl` files are organized in the [`models/`](./models/) directory:

- **Pedestal & Easel:** [`models/cold-snap-exhibit.stl`](./models/cold-snap-exhibit.stl) — Monolithic pedestal plinth with integrated A-frame spine.
- **Museum Plaque:** [`models/cold-snap-exhibit-plaque.stl`](./models/cold-snap-exhibit-plaque.stl) — Classical notched-corner museum placard insert for multi-color or silk metallic accents.

## 🏛️ Design & Engineering Highlights

- **Stepped Classical Plinth Base:** $92\,\text{mm (W)} \times 80\,\text{mm (D)}$ footprint with tiered moulding and a $42\,\text{mm}$ tall central column die.
- **100% Support-Free Printing:** All moulding transitions, cornice flares, and inverted chamfers strictly adhere to $\le 45^\circ$ overhang limits.
- **Dual-Fit Stepped Shelf Channel:**
  - **Forward Channel:** $79.0\,\text{mm (W)} \times 2.6\,\text{mm (D)} \times 4.0\,\text{mm (Drop)}$ sized for raw 35pt card toploaders.
  - **Rear Step:** $85.0\,\text{mm (W)} \times 8.8\,\text{mm (D)} \times 5.0\,\text{mm (Drop)}$ sized for PSA graded slabs and Cold Snap magnetic slabs.
  - **Front Retaining Lip:** $6.0\,\text{mm}$ lip height securely prevents cards from sliding forward without obstructing lower card text or art.
- **A-Frame Easel Spine:** Tapered obelisk spine leaning at an optimal $78^\circ$ viewing angle ($12^\circ$ tilt from vertical). An open central triangular truss window sheds top-heavy mass and centers gravity directly over the base.
- **Modular Museum Plaque:** Front column face features an inset pocket accommodating the included notched plaque for custom card labels or metallic accents.
- **Non-Slip Desk Grip:** Underside includes four $8.5\,\text{mm}$ recessed pockets for standard adhesive rubber bumper pads.

## 🖨️ Recommended Print Settings

### Pedestal & Easel
- **Orientation:** Base flat on build plate ($Z = 0$). No supports required!
- **Material:** PLA, PLA+, or PETG (Matte White or Marble PLA recommended).
- **Layer Height:** 0.16–0.20 mm.
- **Wall Loops:** 3–4 walls.
- **Top / Bottom Shells:** 5 top, 4 bottom.
- **Infill:** 15%–20% Gyroid or Grid.
- **Supports:** None (100% support-free design).

### Museum Plaque Insert
- **Orientation:** Flat on build plate.
- **Material:** Silk Gold, Bronze, or Silver PLA.
- **Layer Height:** 0.12–0.16 mm for sharp corner details.
- **Infill:** 100% solid.

## 🛠️ Customizing with OpenSCAD

Because this design is parametric, you can adjust dimensions, angles, or clearances using [`cold-snap-exhibit.scad`](./cold-snap-exhibit.scad):

**Key Variables:**
- `part_to_render` — Output target: `"all"`, `"pedestal"`, `"plaque"`, or `"preview"`.
- `easel_incline` — Display viewing angle (Default: `78.0°`).
- `toploader_w` / `toploader_d` — Forward channel dimensions (Default: `79.0 x 2.6 mm`).
- `slab_w` / `slab_d` — Rear slab step dimensions (Default: `85.0 x 8.8 mm`).
- `show_card_mockup` — Toggles translucent bounding box card mockups in preview mode.

### Automated Builds with Make
```bash
# Build both pedestal and plaque STLs
make all

# Build only the pedestal
make pedestal

# Build only the plaque insert
make plaque

# Clean compiled meshes
make clean
```

---

_Part of the [Cold Front Forge](https://github.com/OneBuffaloLabs/ColdFrontForge) open-source collection. Licensed under CC BY-NC-SA 4.0._
