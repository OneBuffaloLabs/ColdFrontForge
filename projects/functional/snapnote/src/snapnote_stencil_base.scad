// =============================================================================
// SnapNote 3x3 Parametric Stencil Base & Alignment Jig
// =============================================================================
// Reusable parametric base module for 3" x 3" (76.2 mm x 76.2 mm) sticky note
// stencils. Provides a 1.0 mm drawing plane, a 2.0 mm downward alignment lip
// along the top and left edges (leaving bottom and right open for peeling),
// a top index pull tab with debossed pattern ID text, and 45-degree slot
// chamfer utilities for smooth pen-tip entry.
//
// Usage from downstream template files:
//   use <snapnote_stencil_base.scad>
//   snapnote_stencil_assembly(tab_label = "TODO") {
//       // Child 3D slot cutters in design space (Z = 0..sheet_thickness)
//       translate([10, 50, 0]) chamfered_rect_slot([56, 3], rounding = 1.5);
//   }
// =============================================================================

include <../../../../lib/BOSL2/std.scad>

/* [Preview / Rendering] */
// Print orientation flips the stencil upside-down onto Z=0 for support-free FDM printing
render_mode = "print"; // [print: Print Bed (Flipped), design: Design Space (On Pad)]
// Render the clean blank base or include sample chamfered slots for verification
part_to_render = "base"; // [base: Base Stencil Blank, demo: Base with Demo Chamfered Slots]
$fn = $preview ? 32 : 64;

/* [Pad & Clearance Dimensions] */
// Standard 3" x 3" sticky note pad width (mm)
pad_width = 76.2;
// Standard 3" x 3" sticky note pad height (mm)
pad_height = 76.2;
// Fit tolerance added to the pad pocket for swelling/stack variation (mm)
pad_clearance = 0.8;

/* [Stencil Plate & Alignment Lip] */
// Base drawing plane thickness (1.0 mm = 5 layers @ 0.2 mm layer height)
sheet_thickness = 1.0;
// Downward alignment lip depth along top and left edges (mm)
lip_depth = 2.0;
// Wall thickness of the alignment lip (mm)
lip_wall = 2.0;
// Outer corner fillet radius on the top-left registration corner (mm)
corner_radius = 2.0;

/* [Top Index Pull Tab] */
// Width of the top pull tab (mm)
tab_width = 26.0;
// Height the pull tab protrudes above the top lip edge (mm)
tab_height = 10.0;
// Corner rounding radius on the top corners of the pull tab (mm)
tab_corner_radius = 2.5;
// Horizontal offset of the pull tab from pad center (0 = centered)
tab_x_offset = 0.0;
// Debossed pattern identifier (3-6 characters recommended)
tab_label = "BASE";
// Font size for the debossed pull-tab identifier (mm)
tab_text_size = 4.5;
// Deboss depth into the top face of the pull tab (0.4 mm = 2 layers @ 0.2 mm)
tab_text_depth = 0.4;
// Font family for the debossed identifier
tab_font = "Liberation Sans:style=Bold";

/* [Slot Chamfer Defaults] */
// Default 45-degree top-edge chamfer depth for pen guidance (mm)
default_chamfer = 0.4;
// Step count for arbitrary 2D profile chamfering
chamfer_steps = 8;

/* [Hidden] */
EPS = 0.01;

// Derived inner pocket dimensions (design space: [0..inner_w, 0..inner_h])
function snapnote_inner_width(w = pad_width, clr = pad_clearance) = w + clr;
function snapnote_inner_height(h = pad_height, clr = pad_clearance) = h + clr;

// -----------------------------------------------------------------------------
// 2D Footprint Helpers
// -----------------------------------------------------------------------------

// Full outer 2D plate footprint in design space:
//   X: [-lip_wall, inner_w]
//   Y: [0, inner_h + lip_wall]
module snapnote_plate_2d(
    inner_w = snapnote_inner_width(),
    inner_h = snapnote_inner_height(),
    wall = lip_wall,
    r_corner = corner_radius
) {
    total_w = wall + inner_w;
    total_h = inner_h + wall;
    r_outer = min(r_corner, wall);
    r_open = min(0.8, wall * 0.4);

    translate([-wall, 0])
        rect(
            [total_w, total_h],
            rounding = [r_outer, r_open, r_open, r_open],
            anchor = BOTTOM + LEFT
        );
}

// 2D profile of the 2-sided alignment lip (top + left edges only)
module snapnote_lip_2d(
    inner_w = snapnote_inner_width(),
    inner_h = snapnote_inner_height(),
    wall = lip_wall,
    r_corner = corner_radius
) {
    difference() {
        snapnote_plate_2d(inner_w, inner_h, wall, r_corner);
        // Open pad registration pocket (extended past bottom & right open edges)
        translate([0, -EPS])
            square([inner_w + EPS, inner_h + EPS]);
    }
}

// 2D profile of the top index pull tab, overlapping into the top lip
module snapnote_pull_tab_2d(
    inner_w = snapnote_inner_width(),
    inner_h = snapnote_inner_height(),
    wall = lip_wall,
    t_w = tab_width,
    t_h = tab_height,
    t_r = tab_corner_radius,
    x_off = tab_x_offset
) {
    cx = inner_w / 2 + x_off;
    r_top = min(t_r, t_w / 2 - EPS, t_h / 2);

    translate([cx, inner_h + wall - EPS])
        rect(
            [t_w, t_h + EPS],
            rounding = [r_top, r_top, 0, 0],
            anchor = BOTTOM
        );
}

// -----------------------------------------------------------------------------
// Reusable 45-Degree Slot Chamfer Cutters (Design Space: Z = 0..thickness)
// -----------------------------------------------------------------------------

// Converts any arbitrary 2D profile (passed as children) into a 3D slot cutter
// with a 45-degree chamfer on the top writing surface (Z = thickness).
module chamfered_slot_2d(
    chamfer = default_chamfer,
    thickness = sheet_thickness,
    steps = chamfer_steps
) {
    c = max(0, min(chamfer, thickness - 0.1));

    // Through-cut core
    translate([0, 0, -EPS])
        linear_extrude(height = thickness + 2 * EPS)
            children();

    // 45-degree top-edge chamfer flare
    if (c > 0) {
        dz = c / steps;
        for (i = [0 : steps - 1]) {
            z_pos = thickness - c + i * dz;
            r_off = (i + 1) * dz;
            slice_h = (i == steps - 1) ? (dz + EPS) : (dz + EPS * 0.5);
            translate([0, 0, z_pos])
                linear_extrude(height = slice_h)
                    offset(r = r_off)
                        children();
        }
    }
}

// Exact analytical 45-degree chamfered rectangular / stadium slot cutter.
// Suitable for ruled lines, checkboxes, and rounded slots.
module chamfered_rect_slot(
    size = [20, 3],
    chamfer = default_chamfer,
    thickness = sheet_thickness,
    rounding = 0,
    center = false
) {
    c = max(0, min(chamfer, thickness - 0.1));
    r_max = min(size[0], size[1]) / 2;
    r_base = min(rounding, r_max);
    pos_offset = center ? [0, 0] : [size[0] / 2, size[1] / 2];

    translate(pos_offset) {
        // Through-cut core
        translate([0, 0, -EPS])
            linear_extrude(height = thickness + 2 * EPS)
                rect(size, rounding = r_base, anchor = CENTER);

        // Exact 45-degree chamfer frustum on top face
        if (c > 0) {
            hull() {
                translate([0, 0, thickness - c])
                    linear_extrude(height = EPS)
                        rect(size, rounding = r_base, anchor = CENTER);
                translate([0, 0, thickness])
                    linear_extrude(height = EPS)
                        offset(r = c)
                            rect(size, rounding = r_base, anchor = CENTER);
            }
        }
    }
}

// Exact analytical 45-degree chamfered circular hole cutter (e.g. bullet dots).
module chamfered_hole(
    d = 3.0,
    chamfer = default_chamfer,
    thickness = sheet_thickness
) {
    c = max(0, min(chamfer, thickness - 0.1));

    // Through-hole core
    translate([0, 0, -EPS])
        cylinder(h = thickness + 2 * EPS, d = d);

    // 45-degree top countersink flare
    if (c > 0) {
        translate([0, 0, thickness - c])
            cylinder(h = c + EPS, r1 = d / 2, r2 = d / 2 + c + EPS);
    }
}

// -----------------------------------------------------------------------------
// Core Base Stencil Module (Design Space)
// -----------------------------------------------------------------------------
// Design space coordinates:
//   - Inner sticky-note pad pocket spans X=[0..inner_w], Y=[0..inner_h]
//   - Drawing plane spans Z=[0..sheet_thickness]
//   - Alignment lip extends downward to Z=-lip_depth along top & left edges
//   - Child 3D cutters passed via children() are subtracted from the plate
module snapnote_stencil_base(
    p_width = pad_width,
    p_height = pad_height,
    p_clearance = pad_clearance,
    thickness = sheet_thickness,
    l_depth = lip_depth,
    l_wall = lip_wall,
    r_corner = corner_radius,
    t_width = tab_width,
    t_height = tab_height,
    t_radius = tab_corner_radius,
    t_x_offset = tab_x_offset,
    t_label = tab_label,
    t_size = tab_text_size,
    t_depth = tab_text_depth,
    t_font = tab_font
) {
    inner_w = snapnote_inner_width(p_width, p_clearance);
    inner_h = snapnote_inner_height(p_height, p_clearance);
    deboss_d = min(t_depth, thickness - 0.2);

    difference() {
        union() {
            // Base drawing plane (Z = 0..thickness)
            linear_extrude(height = thickness)
                snapnote_plate_2d(inner_w, inner_h, l_wall, r_corner);

            // 2-sided alignment lip extending downward (Z = -l_depth..EPS)
            translate([0, 0, -l_depth])
                linear_extrude(height = l_depth + EPS)
                    snapnote_lip_2d(inner_w, inner_h, l_wall, r_corner);

            // Top index pull tab (Z = 0..thickness)
            if (t_width > 0 && t_height > 0) {
                linear_extrude(height = thickness)
                    snapnote_pull_tab_2d(
                        inner_w, inner_h, l_wall,
                        t_width, t_height, t_radius, t_x_offset
                    );
            }
        }

        // Debossed pattern identifier on top face of pull tab
        if (t_width > 0 && t_height > 0 && len(t_label) > 0 && deboss_d > 0) {
            translate([
                inner_w / 2 + t_x_offset,
                inner_h + l_wall + t_height / 2,
                thickness - deboss_d
            ])
                linear_extrude(height = deboss_d + EPS)
                    text(
                        t_label,
                        size = t_size,
                        font = t_font,
                        halign = "center",
                        valign = "center"
                    );
        }

        // Subtract any child pattern geometry cutters
        if ($children > 0) {
            children();
        }
    }
}

// -----------------------------------------------------------------------------
// Root Assembly Wrapper (Handles Print-Bed Orientation)
// -----------------------------------------------------------------------------
module snapnote_stencil_assembly(
    mode = render_mode,
    p_width = pad_width,
    p_height = pad_height,
    p_clearance = pad_clearance,
    thickness = sheet_thickness,
    l_depth = lip_depth,
    l_wall = lip_wall,
    r_corner = corner_radius,
    t_width = tab_width,
    t_height = tab_height,
    t_radius = tab_corner_radius,
    t_x_offset = tab_x_offset,
    t_label = tab_label,
    t_size = tab_text_size,
    t_depth = tab_text_depth,
    t_font = tab_font
) {
    inner_h = snapnote_inner_height(p_height, p_clearance);
    y_flip_shift = inner_h + l_wall + t_height;

    if (mode == "print") {
        // Flip 180 deg around X so the flat top face sits on Z = 0
        // and the alignment lip prints upward without supports.
        translate([l_wall, y_flip_shift, thickness])
            rotate([180, 0, 0])
                snapnote_stencil_base(
                    p_width, p_height, p_clearance,
                    thickness, l_depth, l_wall, r_corner,
                    t_width, t_height, t_radius, t_x_offset,
                    t_label, t_size, t_depth, t_font
                )
                    children();
    } else {
        snapnote_stencil_base(
            p_width, p_height, p_clearance,
            thickness, l_depth, l_wall, r_corner,
            t_width, t_height, t_radius, t_x_offset,
            t_label, t_size, t_depth, t_font
        )
            children();
    }
}

// -----------------------------------------------------------------------------
// Top-Level Entry Point
// -----------------------------------------------------------------------------
if (part_to_render == "demo") {
    snapnote_stencil_assembly(t_label = "DEMO") {
        // Sample chamfered checkbox + ruled line + bullet dot
        translate([10, 56, 0])
            chamfered_rect_slot([6, 6], rounding = 0.8);
        translate([20, 57.5, 0])
            chamfered_rect_slot([46, 3], rounding = 1.5);
        translate([13, 44, 0])
            chamfered_hole(d = 3.0);
        // Arbitrary 2D profile chamfer test
        translate([20, 42.5, 0])
            chamfered_slot_2d()
                square([46, 3]);
    }
} else {
    snapnote_stencil_assembly();
}
