# Buffalo Wing Magnet

![Status](https://img.shields.io/badge/Status-Testing-orange)
![Lifecycle](https://img.shields.io/badge/Lifecycle-Stage_2-orange)

> **Release Status:** Stage 2 (Testing) — Prototyping & tolerance testing.

A 3-part, glue-optional friction-fit fridge magnet inspired by Buffalo's iconic wing-and-celery combo and classic Bills-style stripe silhouette—engineered for crisp multi-color printing on any single-extruder printer without an AMS/MMU.

## 📥 Model Files

Pre-configured component meshes are located in [`models/v1/`](./models/v1/):

- **White Base Tray:** `models/v1/buffalo-wing-magnet-base-white.stl` — `4.8 mm` structural backing tray with `2.0 mm` recessed pockets, `0.20 mm` glue relief wells, and rear magnet pocket(s).
- **Orange Wing Body:** `models/v1/buffalo-wing-magnet-wing-orange.stl` — `3.3 mm` scalloped wing insert (sits `1.3 mm` proud above the base rim).
- **Green Celery Streak:** `models/v1/buffalo-wing-magnet-celery-green.stl` — `3.3 mm` tapered celery stick accent (sits `1.3 mm` proud above the base rim).

## 🔩 Bill of Materials (BOM)

| Item | Qty | Spec | Notes |
| :--- | :--- | :--- | :--- |
| **3D Printed Parts** | 3 | Base (White), Wing (Orange), Celery (Green) | PLA or PLA+ recommended |
| **Neodymium Magnets** *(Option A — Default)* | 2 | `5 × 2 mm` round disc magnets | Dual vertical centerline pockets (`dual_5x2`) prevent spinning |
| **Neodymium Magnets** *(Option B)* | 1 | `10 × 2 mm` round disc magnet | Centered drumette pocket (`single_10x2`) |
| **CA Glue (Super Glue)** | Optional | Gel or medium-viscosity | Optional for permanent magnet & insert retention in `0.20 mm` glue wells |

## 🖨️ Recommended Print Settings

- **Orientation:** Flat on the build plate, face up (all 3 parts lie flat; no supports required).
- **Material:** PLA or PLA+ (stiff filament gives the cleanest press-fit).
- **Layer Height:** `0.20 mm` (or `0.16 mm` for finer top-surface relief).
- **Wall Generator:** **Arachne (Mandatory)**. Classic wall engines can drop or under-extrude the narrow celery tip and tight wing notches.
- **Wall Loops:** `3` perimeters.
- **Infill:** `15%` Gyroid.
- **Elephant Foot Compensation:** `0.15 mm` (prevents first-layer squish from tightening the `0.10 mm` insert fit).
- **Supports / Brim:** None required on a clean PEI sheet.

## 🛠️ Customizing with OpenSCAD

Open [buffalo-wing-magnet.scad](./buffalo-wing-magnet.scad) in OpenSCAD or build via `make buffalo-wing-magnet`:

- `render_mode` — `"all"`, `"base"`, `"wing"`, or `"celery"`
- `display_orientation` — `"horizontal"` (default, aligns with `Ctrl+4` Top View) or `"vertical"`
- `magnet_config` — `"dual_5x2"` (default, two `5.2 × 2.1 mm` pockets) or `"single_10x2"` (one `10.2 × 2.1 mm` pocket)
- `target_height` — Overall artwork height (Default: `75.0 mm`)
- `base_thickness` — Total white base thickness (Default: `4.8 mm`)
- `pocket_depth` — Recessed pocket depth (Default: `2.0 mm`)
- `insert_protrusion` — Proud relief height above the base rim (Default: `1.3 mm`)
- `pocket_clearance` — Horizontal friction-fit offset on female pockets (Default: `0.10 mm`)
- `glue_well_depth` — Inset floor relief channel depth (Default: `0.20 mm`)

## 🧩 Assembly & Troubleshooting

1. **Cool completely:** Let the build plate cool before removing parts so the `4.8 mm` base tray stays dead flat.
2. **Test-fit inserts dry first:**
   - Seat the **orange wing** into the white base pocket and press firmly with your thumb until it bottoms out on the `1.2 mm` perimeter shelf (`1.3 mm` proud).
   - Seat the **green celery** insert into the diagonal channel.
3. **Optional adhesive:** If you want a permanent bond (or your filament shrinks slightly), add a tiny drop of CA glue into the `0.20 mm` recessed glue wells on the pocket floors before pressing the inserts home.
4. **Install magnet(s):** Press your `5 × 2 mm` (or `10 × 2 mm`) neodymium magnet(s) into the `2.1 mm` rear pocket(s). Add a small dab of CA glue if the magnet fit is loose.
5. **Fit Troubleshooting:**
   - **Too tight?** Confirm **Arachne** walls are enabled and add `0.15 mm` elephant foot compensation, or lightly chamfer the bottom edge of the insert with a deburring tool.
   - **Too loose?** Filament brands vary slightly in shrinkage; a drop of CA glue in the floor relief well locks everything permanently.

---

_Disclaimer: This is an original parody/fan-art project provided for personal, non-commercial use only. It is not affiliated with, authorized by, or endorsed by the Buffalo Bills or the National Football League (NFL)._
