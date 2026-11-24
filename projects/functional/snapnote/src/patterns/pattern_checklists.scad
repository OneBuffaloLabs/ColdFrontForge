// =============================================================================
// SnapNote 3x3 Checklist, Bullet & Ruled Line Stencil Patterns
// =============================================================================
// Generates three list-focused 3x3 sticky note stencil patterns on the
// SnapNote parametric base:
//   - CHECK  : 6 ruled lines with 4.0 mm x 4.0 mm filleted square checkboxes
//   - BULLET : 6 ruled lines with 3.6 mm circular bullet apertures
//   - LINES  : 7 evenly spaced edge-to-edge ruled lines
//
// CLI export examples:
//   openscad -D 'pattern="check"'  -o ../../exports/snapnote_3x3_check.stl  pattern_checklists.scad
//   openscad -D 'pattern="bullet"' -o ../../exports/snapnote_3x3_bullet.stl pattern_checklists.scad
//   openscad -D 'pattern="lines"'  -o ../../exports/snapnote_3x3_lines.stl  pattern_checklists.scad
// =============================================================================

include <../../../../../lib/BOSL2/std.scad>
use <../snapnote_stencil_base.scad>

/* [Pattern Selection] */
// Select which stencil pattern to render
pattern = "check"; // [check: Checklist (CHECK), bullet: Bullet List (BULLET), lines: Ruled Lines (LINES)]
// Print orientation flips the stencil onto Z=0 for support-free printing
render_mode = "print"; // [print: Print Bed (Flipped), design: Design Space (On Pad)]
$fn = $preview ? 32 : 64;

/* [Pad Reference] */
// Nominal 3" x 3" sticky note size (mm)
pad_size = 76.2;

/* [Slot & Aperture Geometry] */
// Ruled line slot width (0.9-1.0 mm for 0.5/0.7 mm gel pens)
line_slot_width = 0.95;
// End rounding on ruled line slots (half of width for clean stadium ends)
line_slot_rounding = 0.45;
// 45-degree top-edge chamfer depth for smooth pen-tip guidance (mm)
slot_chamfer = 0.4;

// Square checkbox side length (mm)
checkbox_size = 4.0;
// Slight internal corner fillet to prevent nozzle corner blobbing (mm)
checkbox_rounding = 0.4;

// Circular bullet dot diameter (3.5-4.0 mm)
bullet_diameter = 3.6;

/* [Layout & Margins] */
// Left/right writable margins (mm)
margin_x = 7.0;
// Horizontal solid plastic gap between checkbox/bullet and ruled line (mm)
marker_line_gap = 3.0;
// Vertical offset of ruled line relative to marker center (-1.0 aligns baseline)
line_y_offset = -1.0;

// Row count & pitch for CHECK and BULLET patterns (5-6 rows)
list_row_count = 6;
list_row_pitch = 10.5;
list_bottom_y = 11.5;

// Row count & pitch for LINES pattern (6-7 rows)
lines_row_count = 7;
lines_row_pitch = 9.5;
lines_bottom_y = 10.0;

// -----------------------------------------------------------------------------
// Pattern Cutter Modules (Design Space)
// -----------------------------------------------------------------------------

module checklist_cutters(
    rows = list_row_count,
    pitch = list_row_pitch,
    y0 = list_bottom_y
) {
    box_x = margin_x;
    line_x = box_x + checkbox_size + marker_line_gap;
    line_len = pad_size - margin_x - line_x;

    for (i = [0 : rows - 1]) {
        row_y = y0 + i * pitch;

        // 4.0 mm x 4.0 mm filleted square checkbox
        translate([box_x, row_y - checkbox_size / 2, 0])
            chamfered_rect_slot(
                size = [checkbox_size, checkbox_size],
                chamfer = slot_chamfer,
                rounding = checkbox_rounding
            );

        // Paired ruled writing line
        translate([line_x, row_y + line_y_offset - line_slot_width / 2, 0])
            chamfered_rect_slot(
                size = [line_len, line_slot_width],
                chamfer = slot_chamfer,
                rounding = line_slot_rounding
            );
    }
}

module bullet_cutters(
    rows = list_row_count,
    pitch = list_row_pitch,
    y0 = list_bottom_y
) {
    dot_cx = margin_x + bullet_diameter / 2;
    line_x = margin_x + bullet_diameter + marker_line_gap;
    line_len = pad_size - margin_x - line_x;

    for (i = [0 : rows - 1]) {
        row_y = y0 + i * pitch;

        // Circular bullet aperture (3.6 mm)
        translate([dot_cx, row_y, 0])
            chamfered_hole(
                d = bullet_diameter,
                chamfer = slot_chamfer
            );

        // Paired ruled writing line
        translate([line_x, row_y + line_y_offset - line_slot_width / 2, 0])
            chamfered_rect_slot(
                size = [line_len, line_slot_width],
                chamfer = slot_chamfer,
                rounding = line_slot_rounding
            );
    }
}

module lines_cutters(
    rows = lines_row_count,
    pitch = lines_row_pitch,
    y0 = lines_bottom_y
) {
    line_len = pad_size - 2 * margin_x;

    for (i = [0 : rows - 1]) {
        row_y = y0 + i * pitch;

        // Edge-to-edge ruled writing line
        translate([margin_x, row_y - line_slot_width / 2, 0])
            chamfered_rect_slot(
                size = [line_len, line_slot_width],
                chamfer = slot_chamfer,
                rounding = line_slot_rounding
            );
    }
}

// -----------------------------------------------------------------------------
// Top-Level Pattern Assembly
// -----------------------------------------------------------------------------
if (pattern == "check") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "CHECK")
        checklist_cutters();
} else if (pattern == "bullet") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "BULLET")
        bullet_cutters();
} else if (pattern == "lines") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "LINES")
        lines_cutters();
} else {
    assert(false, str("Unknown pattern '", pattern, "'. Expected 'check', 'bullet', or 'lines'."));
}
