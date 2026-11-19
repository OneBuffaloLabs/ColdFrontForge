// =============================================================================
// SnapNote 3x3 Productivity & Workflow Stencil Patterns
// =============================================================================
// Generates three workflow-oriented 3x3 sticky note stencil patterns on the
// SnapNote parametric base:
//   - 2X2   : Eisenhower 2x2 priority matrix with perimeter margins
//   - HABIT : 7-day weekly habit tracker (Mon-Sun columns + 5 tracking rows)
//   - TOP3  : Top 3 numbered priority rows (1, 2, 3) with secondary note lines
// =============================================================================

include <../../../../../lib/BOSL2/std.scad>
use <../snapnote_stencil_base.scad>

/* [Pattern Selection] */
// Select which productivity stencil pattern to render
pattern = "2x2"; // [2x2: Eisenhower Matrix (2X2), habit: 7-Day Habit Tracker (HABIT), top3: Top 3 Focus (TOP3)]
// Print orientation flips the stencil onto Z=0 for support-free printing
render_mode = "print"; // [print: Print Bed (Flipped), design: Design Space (On Pad)]
$fn = $preview ? 32 : 64;

/* [Pad Reference] */
// Nominal 3" x 3" sticky note size (mm)
pad_size = 76.2;

/* [Shared Slot Parameters] */
// Minimum 0.9 mm slot width for 0.5/0.7 mm gel pens
line_slot_width = 0.95;
line_slot_rounding = 0.45;
// 45-degree top-edge chamfer depth for smooth pen-tip guidance (mm)
slot_chamfer = 0.4;

/* [Eisenhower 2x2 Matrix] */
// Perimeter boundary margin to prevent ink spilling off pad edges (mm)
matrix_margin = 6.0;
// Width of the centered perpendicular cross-divider slots (mm)
matrix_divider_width = 1.0;

/* [7-Day Habit Tracker] */
habit_margin_x = 5.0;
// Width of left habit-name writing lines (mm)
habit_label_width = 20.0;
// Gap between habit-name lines and the 7-day grid (mm)
habit_grid_gap = 2.5;
// Number of daily columns (Monday-Sunday)
habit_days = 7;
// Number of habit tracking rows (4-5)
habit_rows = 5;
// Center-to-center column pitch across the 7-day grid (mm)
habit_col_pitch = 6.2;
// Tracking cell aperture size (leaves 2.6 mm bottom / 1.8 mm top walls >= 0.8 mm)
habit_cell_size = 3.6;
habit_cell_rounding = 0.5;
// Row spacing and vertical positions
habit_row_pitch = 9.5;
habit_bottom_y = 13.5;
habit_header_line_y = 60.5;
habit_header_tick_h = 5.0;

/* [Top 3 Priority Focus] */
top3_margin_x = 6.5;
// Stencil numeral height (mm) for 1, 2, 3
top3_num_size = 7.0;
top3_num_font = "Liberation Sans:style=Bold";
// Primary task line width and secondary note line width (mm)
top3_main_line_w = 1.05;
top3_sub_line_w = 0.95;
// Vertical spacing between Top 3 blocks and secondary note lines
top3_block_pitch = 19.0;
top3_bottom_y = 14.5;
top3_sub_offset_y = 7.5;

// -----------------------------------------------------------------------------
// Pattern Cutter Modules (Design Space)
// -----------------------------------------------------------------------------

module matrix_2x2_cutters() {
    cx = pad_size / 2;
    cy = pad_size / 2;
    span = pad_size - 2 * matrix_margin;

    // Centered vertical divider
    translate([cx, cy, 0])
        chamfered_rect_slot(
            size = [matrix_divider_width, span],
            chamfer = slot_chamfer,
            rounding = matrix_divider_width * 0.45,
            center = true
        );

    // Centered horizontal divider
    translate([cx, cy, 0])
        chamfered_rect_slot(
            size = [span, matrix_divider_width],
            chamfer = slot_chamfer,
            rounding = matrix_divider_width * 0.45,
            center = true
        );
}

module habit_tracker_cutters() {
    grid_x0 = habit_margin_x + habit_label_width + habit_grid_gap;
    total_w = pad_size - 2 * habit_margin_x;

    // Header horizontal divider line (spans full table width)
    translate([habit_margin_x, habit_header_line_y - line_slot_width / 2, 0])
        chamfered_rect_slot(
            size = [total_w, line_slot_width],
            chamfer = slot_chamfer,
            rounding = line_slot_rounding
        );

    // Header column tick dividers (6 ticks between 7 day columns;
    // offset 1.8 mm above header line so no closed loops/islands form)
    tick_y0 = habit_header_line_y + 1.8;
    for (d = [1 : habit_days - 1]) {
        tick_x = grid_x0 + d * habit_col_pitch - line_slot_width / 2;
        translate([tick_x, tick_y0, 0])
            chamfered_rect_slot(
                size = [line_slot_width, habit_header_tick_h],
                chamfer = slot_chamfer,
                rounding = line_slot_rounding
            );
    }

    // 5 habit tracking rows: left label line + 7 daily check cells
    for (r = [0 : habit_rows - 1]) {
        row_y = habit_bottom_y + r * habit_row_pitch;

        // Habit label writing line
        translate([habit_margin_x, row_y - line_slot_width / 2, 0])
            chamfered_rect_slot(
                size = [habit_label_width, line_slot_width],
                chamfer = slot_chamfer,
                rounding = line_slot_rounding
            );

        // 7 daily tracking cells (Monday-Sunday)
        for (d = [0 : habit_days - 1]) {
            cell_cx = grid_x0 + (d + 0.5) * habit_col_pitch;
            translate([cell_cx, row_y, 0])
                chamfered_rect_slot(
                    size = [habit_cell_size, habit_cell_size],
                    chamfer = slot_chamfer,
                    rounding = habit_cell_rounding,
                    center = true
                );
        }
    }
}

module top3_cutters() {
    main_x = top3_margin_x + 9.5;
    main_len = pad_size - top3_margin_x - main_x;
    sub_x = main_x + 2.0;
    sub_len = pad_size - top3_margin_x - sub_x;

    for (idx = [0 : 2]) {
        // Number 1 at top, 2 in middle, 3 at bottom
        num_str = str(3 - idx);
        sub_y = top3_bottom_y + idx * top3_block_pitch;
        main_y = sub_y + top3_sub_offset_y;

        // Stencil numeral (1, 2, 3 — open-path digits with no enclosed islands)
        translate([top3_margin_x + 3.0, main_y + 0.5, 0])
            chamfered_slot_2d(chamfer = 0.3)
                text(
                    num_str,
                    size = top3_num_size,
                    font = top3_num_font,
                    halign = "center",
                    valign = "center"
                );

        // Primary priority task line
        translate([main_x, main_y - top3_main_line_w / 2, 0])
            chamfered_rect_slot(
                size = [main_len, top3_main_line_w],
                chamfer = slot_chamfer,
                rounding = top3_main_line_w * 0.45
            );

        // Secondary note line underneath
        translate([sub_x, sub_y - top3_sub_line_w / 2, 0])
            chamfered_rect_slot(
                size = [sub_len, top3_sub_line_w],
                chamfer = slot_chamfer,
                rounding = line_slot_rounding
            );
    }
}

// -----------------------------------------------------------------------------
// Top-Level Pattern Assembly
// -----------------------------------------------------------------------------
if (pattern == "2x2") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "2X2")
        matrix_2x2_cutters();
} else if (pattern == "habit") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "HABIT")
        habit_tracker_cutters();
} else if (pattern == "top3") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "TOP3")
        top3_cutters();
} else {
    assert(false, str("Unknown pattern '", pattern, "'. Expected '2x2', 'habit', or 'top3'."));
}
