# TCG Supply & Card Dimensions Reference

Physical dimensions measured with a digital caliper. Use these numbers as a baseline when modeling slots, trays, bins, and display stands.

> **Note on Fit & Tolerance:** These numbers represent the raw item size. Always add **1.0 mm to 1.5 mm of extra wiggle room (clearance)** to your design so items slide in and out smoothly without jamming, especially across different filament types and print settings.

---

## Measurement Table

| Item / Supply             | Width (X) | Height (Y) | Thickness (Z) | Recommended Extra Room | Practical Notes                                                                |
| :------------------------ | :-------- | :--------- | :------------ | :--------------------- | :----------------------------------------------------------------------------- |
| **Penny Sleeves**         | 67.0 mm   | 92.0 mm    | Variable      | +1.5 mm to +2.0 mm     | Soft plastic bunches up at the edges; add finger cutouts to pull easily.       |
| **Top Loaders (35pt)**    | 76.0 mm   | 101.0 mm   | ~2.0 mm       | +1.0 mm to +1.5 mm     | Card sits recessed inside with **9.0 mm of open clearance** above it.          |
| **Semi-Rigid Holders**    | 85.0 mm   | 122.0 mm   | ~1.5 mm       | +1.2 mm to +1.5 mm     | Flexible grading submission holders (Cardboard Gold / Ultra PRO).              |
| **Magnetic One-Touch**    | 44.0 mm   | 110.0 mm   | ~8.0 mm       | +0.8 mm to +1.2 mm     | Standard 35pt magnetic case. Thicker point sizes (55pt–130pt) need wider bays. |
| **TAG Graded Slab**       | 80.0 mm   | 134.0 mm   | ~6.5 mm       | +1.0 mm to +1.5 mm     | Same width as PSA, but 2.0 mm shorter in height. Has beveled edges.            |
| **PSA Graded Slab**       | 80.0 mm   | 136.0 mm   | ~6.5 mm       | +1.0 mm to +1.5 mm     | Taller than TAG. Use this height as your default for universal slab slots.     |
| **Cardboard Box Divider** | Variable  | Variable   | ~5.0 mm       | +0.5 mm to +1.0 mm     | Standard cardboard wall/divider thickness for multi-row storage boxes.         |

---

## Toploader Internal Card Stance

- **Card Top Lip Offset:** **9.0 mm**
- When a standard card sits fully seated at the bottom of a 101.0 mm toploader, there is **9.0 mm of empty space** between the top edge of the card and the top opening of the toploader.
- Use this 9.0 mm delta when designing retaining lips, display bezels, or viewing windows so the frame covers only the empty plastic rather than the card artwork.

---

## Multi-Row Card Storage Box Specs

Reference specs for modular inserts, drop-in dividers, and row spacers designed for standard multi-row corrugated cardboard storage boxes (such as Monster 5-Row 3950+ boxes):

- **Divider Wall Thickness:** **5.0 mm** (fluted cardboard row partitions)
- **Design Consideration:** For slip-over channel clips, row index tabs, or custom dividing walls, set internal slot widths to **5.5 mm – 6.0 mm** to easily straddle the corrugated partition without crushing the cardboard.

---

## Universal Graded Slab Dimensions (Fits Both PSA & TAG)

Both PSA and TAG slabs share the same 80.0 mm width and ~6.5 mm thickness. Because TAG is 2.0 mm shorter than PSA, you can design a single universal slot that fits both:

- **Slot Width:** 81.5 mm (80.0 mm slab + 1.5 mm wiggle room)
- **Slot Height Clearance:** 136.0 mm (clears the taller PSA slab)
- **Slot Thickness:** 7.7 mm (6.5 mm slab + 1.2 mm wiggle room)

---

## OpenSCAD Reference Variables

Ready to copy into any `.scad` script:

```openscad
// ==========================================
// TCG RAW REFERENCE MEASUREMENTS (mm)
// ==========================================
PENNY_SLEEVE_DIM          = [67.0, 92.0];
TOPLOADER_35PT_DIM        = [76.0, 101.0, 2.0];
SEMI_RIGID_DIM            = [85.0, 122.0, 1.5];
MAGNETIC_HOLDER_DIM       = [44.0, 110.0, 8.0];

// Toploader Internal Offsets
TOPLOADER_CARD_HEADROOM   = 9.0; // Space between top of seated card and opening

// Storage Box Specs (Monster / BCW Multi-Row)
BOX_DIVIDER_THICKNESS     = 5.0; // Standard corrugated row partition

// Graded Slabs
SLAB_PSA_DIM              = [80.0, 136.0, 6.5];
SLAB_TAG_DIM              = [80.0, 134.0, 6.5];

// Pre-calculated Universal Slot (Includes 1.2mm-1.5mm clearance for PSA & TAG)
UNIVERSAL_SLAB_SLOT       = [81.5, 136.0, 7.7];

// Standard wiggle room to add to raw measurements
DEFAULT_CLEARANCE         = 1.2;
```
