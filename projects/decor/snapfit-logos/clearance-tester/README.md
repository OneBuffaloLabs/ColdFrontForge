# SnapFit Clearance Tester

A quick calibration print to test fitment tolerances before committing to a full-sized multi-part logo print. It features three test pockets (0.05 mm, 0.10 mm, and 0.15 mm) alongside a matching test plug to dial in your slicer settings and filament shrinkage.

## 📥 Files

- `clearance-tester.scad` — Parametric OpenSCAD source file.
- `clearance-tester.stl` — Print-ready mesh including the 3-pocket base and test block.

## 🖨️ Recommended Print Settings

Match the exact settings you plan to use on final logo prints:

- **Material:** PLA or PLA+
- **Layer Height:** 0.20 mm
- **Wall Generator:** **Arachne** (Required to match the geometry of thin perimeter borders)
- **Wall Loops:** 3–4
- **Infill:** 15% Gyroid or Grid
- **Elephant Foot Compensation:** 0.15 mm
- **Supports:** None
- **Brim:** None

## 🧪 How to Test

1. Let the print cool completely before removing it from the build plate.
2. Insert the test plug into each pocket starting with `0.15 mm`, then `0.10 mm`, and finally `0.05 mm`.
3. Press firmly with your thumb:
   - **Ideal Fit:** The plug seats flush with a firm thumb press and does not fall out when inverted.
   - **Too Tight:** If `0.15 mm` won't seat, check for first-layer elephant foot or reduce your extrusion multiplier / flow rate slightly.
   - **Too Loose:** If `0.05 mm` drops in with no resistance, increase your flow rate or check belt tension.

---

_Part of the [Cold Front Forge](https://github.com/OneBuffaloLabs/ColdFrontForge) open-source collection. Licensed under CC BY-NC-SA 4.0._
