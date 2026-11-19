// =============================================================================
// SnapNote 3x3 Casual Games Stencil Patterns
// =============================================================================
// Generates two tabletop desk-game 3x3 sticky note stencil patterns on the
// SnapNote parametric base:
//   - XO     : Classic 3x3 Tic-Tac-Toe grid with bridged intersections &
//              continuous perimeter framing (zero floating center island)
//   - DOTBOX : 5x5 Dots & Boxes dot matrix (4x4 playable boxes) with rigid
//              plastic webbing between perforations
// =============================================================================

include <../../../../../lib/BOSL2/std.scad>
use <../snapnote_stencil_base.scad>

/* [Pattern Selection] */
// Select which game stencil pattern to render
pattern = "xo"; // [xo: Tic-Tac-Toe (XO), dotbox: Dots & Boxes 5x5 (DOTBOX)]
// Print orientation flips the stencil onto Z=0 for support-free printing
render_mode = "print"; // [print: Print Bed (Flipped), design: Design Space (On Pad)]
$fn = $preview ? 24 : 48;

/* [Pad Reference] */
// Nominal 3" x 3" sticky note size (mm)
pad_size = 76.2;

/* [Shared Slot Parameters] */
// Default 45-degree top-edge chamfer depth for smooth pen-tip guidance (mm)
slot_chamfer = 0.4;

/* [Tic-Tac-Toe (XO)] */
// Outer perimeter framing margin around the 3x3 board (mm)
xo_margin = 7.1;
// Width of grid line channels (mm)
xo_line_width = 1.05;
// Solid bridge gap at each # intersection to anchor the center square (mm)
xo_bridge_gap = 3.2;

/* [Dots & Boxes (DOTBOX)] */
// Number of dots per axis (5 = 5x5 dots / 4x4 playable boxes)
dotbox_count = 5;
// Center-to-center dot pitch (mm)
dotbox_pitch = 14.0;
// Circular dot aperture diameter for stamping bold game dots (mm)
dotbox_dot_d = 2.6;

// -----------------------------------------------------------------------------
// Pattern Cutter Modules (Design Space)
// -----------------------------------------------------------------------------

module xo_cutters() {
    board_span = pad_size - 2 * xo_margin; // 62.0 mm
    cell = board_span / 3;                 // ~20.67 mm
    seg_len = cell - xo_bridge_gap;        // ~17.47 mm per segment
    cx = pad_size / 2;
    cy = pad_size / 2;

    // Two vertical and two horizontal hash lines, each split into 3 bridged
    // segments so intersections stay solid and the center square stays anchored.
    for (line_idx = [-0.5, 0.5]) {
        line_off = line_idx * cell;
        for (seg_idx = [-1, 0, 1]) {
            seg_off = seg_idx * cell;

            // Vertical hash segments
            translate([cx + line_off, cy + seg_off, 0])
                chamfered_rect_slot(
                    size = [xo_line_width, seg_len],
                    chamfer = slot_chamfer,
                    rounding = xo_line_width * 0.45,
                    center = true
                );

            // Horizontal hash segments
            translate([cx + seg_off, cy + line_off, 0])
                chamfered_rect_slot(
                    size = [seg_len, xo_line_width],
                    chamfer = slot_chamfer,
                    rounding = xo_line_width * 0.45,
                    center = true
                );
        }
    }
}

module dotbox_cutters() {
    span = (dotbox_count - 1) * dotbox_pitch; // 56.0 mm
    origin = (pad_size - span) / 2;           // 10.1 mm

    for (ix = [0 : dotbox_count - 1], iy = [0 : dotbox_count - 1]) {
        translate([origin + ix * dotbox_pitch, origin + iy * dotbox_pitch, 0])
            chamfered_hole(
                d = dotbox_dot_d,
                chamfer = slot_chamfer
            );
    }
}

// -----------------------------------------------------------------------------
// Top-Level Pattern Assembly
// -----------------------------------------------------------------------------
if (pattern == "xo") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "XO")
        xo_cutters();
} else if (pattern == "dotbox") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "DOTBOX")
        dotbox_cutters();
} else {
    assert(false, str("Unknown pattern '", pattern, "'. Expected 'xo' or 'dotbox'."));
}
