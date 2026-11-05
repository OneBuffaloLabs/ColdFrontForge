<!-- =====================================================================
     AUTO-GENERATED FILE - DO NOT EDIT MANUALLY
     Built by: commercial/tcg/cold-snap-tag/scripts/generate_dimensions.py
     Source:   commercial/tcg/cold-snap-tag/assets/cad/cold-snap-tag-core.scad
     ===================================================================== -->
# Cold Snap Tag™ — Dimensions & Technical Specifications Reference

Official mechanical dimensions, tolerances, and hardware specifications for the Cold Snap Tag™ ecosystem. Built automatically via `make` to maintain 100% single-source-of-truth synchronization with CAD primitives.

---

## 1. Physical Tag Dimensions

| Form Factor | Width ($X$) | Height ($Y$) | Wafer ($Z$) | Text Emboss ($Z$) | Total ($Z$) | Corner Radius ($R$) | Border Width |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Standard Tag (Slab)** | **68.00 mm** | **22.00 mm** | 2.20 mm | +0.80 mm | 3.00 mm | 1.50 mm | 0.90 mm |
| **Extended Rx (Dispenser)**| **68.00 mm** | **42.00 mm** | 2.20 mm | +0.80 mm | 3.00 mm | 1.50 mm | 0.90 mm |

---

## 2. Retention Magnet Specifications (5x2 mm Neodymium)

* **Hardware:** 2x Neodymium Disc Magnets (Ø 5.00 mm × 2.00 mm, Grade N35 or N52).
* **Center-to-Center Spacing:** **36.00 mm** (X = -18.00 mm and X = +18.00 mm, centered at Y = 0.00 mm).
* **Inner Edge-to-Edge Gap:** **31.00 mm**.
* **Outer Edge-to-Edge Span:** **41.00 mm**.
* **Perimeter Margin (Sides):** **13.50 mm** to tag left and right edges.
* **Vertical Margin (Standard 22mm):** **8.50 mm** to tag top and bottom edges.
* **Vertical Margin (Rx 42mm):** **18.50 mm** to tag top and bottom edges.
* **Tag Bore Diameter:** **5.15 mm** (+0.15 mm radial tolerance for snug friction push-fit with CA glue).
* **Tag Bore Depth:** **1.80 mm** (leaves 0.40 mm / 2 solid layers of top skin).
* **Entry Chamfer:** **0.35 mm × 45°** self-centering funnel and glue well.

---

## 3. Mating Receptacle Pocket Dimensions (Cavity Specs)

When designing a socket on an accessory (display stand, slab, pedestal, or wall frame) to receive a Cold Snap Tag:

| Pocket Dimension | Measurement | Description |
| :--- | :--- | :--- |
| **Pocket Width (X)** | **68.50 mm** | Nominal 68.0 mm + 0.25 mm slip clearance per side. |
| **Pocket Height (Y)** | **22.50 mm** (Std) / **42.50 mm** (Rx) | Nominal + 0.25 mm slip clearance per side. |
| **Pocket Depth (Z)** | **2.20 mm** (Flush) / **1.00 mm** (Proud) | 2.20 mm seats base wafer flush with body surface. |
| **Corner Radius (R)**| **1.75 mm** | Nominal 1.50 mm + 0.25 mm slip clearance. |
| **Socket Magnet Bore** | **Ø 5.15 mm × 2.00 mm** | Sits 2.0 mm magnet flush with pocket floor. |
| **Magnet Spacing** | **36.00 mm** center-to-center | Aligns with tag magnets. |
| **Rear Ejection Hole** | **Ø 2.00 mm** pass-through | For maintenance and easy magnet extraction. |

---

## 4. Typography & Micro-Lettering Constraints

Standard 0.4mm FDM nozzle physical extrusion limit:

* **Hard Minimum Font Size:** **3.70 mm** (Any smaller and closed character counters in 'e', 'a', 'o', 'B', 'P' fuse solid).
* **Emboss Height:** **0.80 mm** proud of wafer floor (4 layers at 0.20mm base or 5 layers at 0.16mm modifier).
* **Standard Letter Spacing:** **1.10 – 1.15** for optimal character perimeter separation.
* **Standard Font:** `Varela Round` (monoline geometric geometry prevents thin serif blowouts).
* **Slicer Engine Requirement:** **Arachne Perimeter Generator** + **0.16 mm Layer Height Modifier** above Z = 2.20 mm.

---

## 5. OpenSCAD Reference Variables

Ready to copy into any `.scad` model:

```openscad
// ==========================================
// COLD SNAP TAG™ STANDARDS (mm)
// ==========================================
TAG_WIDTH                = 68.0;
TAG_HEIGHT_STANDARD      = 22.0;
TAG_HEIGHT_RX            = 42.0;
TAG_WAFER_THICKNESS      = 2.20;
TAG_EMBOSS_HEIGHT        = 0.80;
TAG_CORNER_RADIUS        = 1.50;
TAG_BORDER_WIDTH         = 0.90;
TAG_MIN_TEXT_SIZE        = 3.70; // Minimum legible font size on 0.4mm nozzle

// Magnet Hardpoints (5x2mm Neodymium Disc)
TAG_MAG_DIAMETER         = 5.0;
TAG_MAG_THICKNESS        = 2.0;
TAG_MAG_SPACING          = 36.0; // Center-to-center pitch
TAG_MAG_BORE_D           = 5.15; // +0.15mm friction fit with CA glue
TAG_MAG_BORE_DEPTH       = 1.80; // Blind bore into tag underside
TAG_MAG_CHAMFER          = 0.35; // 45-degree lead-in funnel

// Mating Receptacle Pocket Specs
TAG_POCKET_CLEARANCE     = 0.25; // Per side
TAG_POCKET_W             = TAG_WIDTH + (2 * TAG_POCKET_CLEARANCE);         // 68.5 mm
TAG_POCKET_H_STD         = TAG_HEIGHT_STANDARD + (2 * TAG_POCKET_CLEARANCE);// 22.5 mm
TAG_POCKET_H_RX          = TAG_HEIGHT_RX + (2 * TAG_POCKET_CLEARANCE);      // 42.5 mm
TAG_POCKET_DEPTH_FLUSH   = TAG_WAFER_THICKNESS;                            // 2.20 mm
TAG_POCKET_CORNER_R      = TAG_CORNER_RADIUS + TAG_POCKET_CLEARANCE;       // 1.75 mm
```
