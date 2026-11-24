// =============================================================================
// SnapNote 3x3 All-in-One Desk Caddy
// =============================================================================
// Unified desktop organizer for 3" x 3" sticky note pads, SnapNote stencils,
// and writing instruments. Features:
//   - Front 77.2 mm x 77.2 mm sticky note pad tray with ergonomic thumb scoop
//   - 5-slot tiered & 12-degree angled stencil rack with left-lip relief
//   - Dual vertical pen wells (13.0 mm ID, 50.0 mm depth)
//   - 4 underside recessed pockets (8.2 mm dia x 1.0 mm deep) for silicone feet
//   - 100% support-free FDM printability flat on the build plate (Z = 0)
// =============================================================================

include <../../../../lib/BOSL2/std.scad>

/* [Preview / Rendering] */
$fn = $preview ? 32 : 64;

/* [Pad Tray Dimensions] */
// Nominal 3" x 3" sticky note pad size (mm)
pad_nominal = 76.2;
// Total clearance added to pad cavity for commercial pad variance (mm)
pad_clearance = 1.0;
// Vertical depth of the sticky note pad cavity (mm)
pad_cavity_depth = 12.0;
// Thickness of outer perimeter walls (mm)
wall_thickness = 3.5;
// Solid floor thickness under pad cavity and pen wells (mm)
base_floor = 3.0;
// Outer vertical corner fillet radius (mm)
outer_rounding = 4.0;

/* [Front Thumb Scoop] */
// Width of the ergonomic front finger/thumb scoop (mm)
scoop_width = 34.0;
// Height remaining at bottom of scoop above Z=0 (mm)
scoop_floor_z = 3.5;
// Corner rounding radius at the bottom of the thumb scoop (mm)
scoop_corner_r = 6.0;

/* [Stencil Organizer Rack] */
// Number of upright stencil storage slots (minimum 5)
num_stencil_slots = 5;
// Main slot channel width for 1.0 mm stencil plates (minimum 1.6 mm)
slot_channel_width = 1.8;
// Extra channel width on the left side to clear the 2.0 mm stencil alignment lip
slot_lip_relief_width = 3.6;
// Length along the left edge widened for alignment-lip clearance (mm)
slot_lip_relief_len = 4.0;
// Stencil slot length (fits 79.0 mm wide SnapNote stencils with 1.0 mm play)
slot_length = 80.0;
// Vertical engagement depth of each stencil slot (mm)
slot_depth = 22.0;
// Backward tilt angle of stencil slots (10-15 deg keeps pull tabs visible)
slot_tilt_deg = 12.0;
// Center-to-center Y spacing between adjacent stencil slots (mm)
slot_pitch = 7.2;
// Progressive vertical step per slot from front to back (mm)
slot_step_z = 3.0;
// Height of the first (front-most) stencil slot floor above Z=0 (mm)
rack_start_floor_z = 6.0;

/* [Dual Pen Wells] */
// Internal diameter of each pen well (minimum 12.0 mm)
pen_well_d = 13.0;
// Internal depth of each pen well (minimum 45.0 mm)
pen_well_depth = 50.0;
// Width of the right-hand pen tower block (mm)
pen_tower_width = 23.0;
// Top rim chamfer on each pen well for smooth insertion (mm)
pen_rim_chamfer = 1.2;

/* [Underside Silicone Feet Pockets] */
// Diameter of recessed silicone foot pockets (mm)
foot_d = 8.2;
// Depth of recessed silicone foot pockets (mm)
foot_depth = 1.0;
// Inset distance from outer caddy edges to foot center (mm)
foot_inset = 10.0;

/* [Hidden] */
EPS = 0.01;

// Derived layout dimensions
pad_cavity_w = pad_nominal + pad_clearance; // 77.2 mm
pad_cavity_h = pad_nominal + pad_clearance; // 77.2 mm

tray_outer_w = pad_cavity_w + 2 * wall_thickness; // 84.2 mm
tray_outer_h = pad_cavity_h + 2 * wall_thickness; // 84.2 mm
tray_total_z = base_floor + pad_cavity_depth;     // 15.0 mm

// Rack dimensions (behind the pad tray; extra rear margin for 12 deg slot tilt)
rack_depth_y = (num_stencil_slots - 1) * slot_pitch + 20.0;
total_width = tray_outer_w + pen_tower_width - wall_thickness; // Shared inner wall
total_depth = tray_outer_h + rack_depth_y - wall_thickness;    // Shared divider wall
pen_tower_z = base_floor + pen_well_depth;                     // 53.0 mm

// -----------------------------------------------------------------------------
// Helper Modules
// -----------------------------------------------------------------------------

// Rounded footprint in XY from [0, 0] to [total_width, total_depth]
module caddy_footprint_2d(w = total_width, d = total_depth, r = outer_rounding) {
    rect([w, d], rounding = r, anchor = BOTTOM + LEFT);
}

// Single tilted stencil slot cutter (centered at X=0, Y=0, Z=0 at slot bottom)
// Includes a widened left-edge relief for the 2.0 mm SnapNote alignment lip.
module stencil_slot_cutter(
    len = slot_length,
    ch_w = slot_channel_width,
    lip_w = slot_lip_relief_width,
    lip_len = slot_lip_relief_len,
    depth = slot_depth,
    tilt = slot_tilt_deg
) {
    // Tilt backward (+Y) around X axis; extend upward past top surface
    extra_top = 15.0;
    rotate([-tilt, 0, 0]) {
        // Main 1.8 mm stencil plate channel
        translate([0, -ch_w / 2, 0])
            cube([len, ch_w, depth + extra_top]);

        // Left-edge alignment lip relief pocket
        translate([-EPS, -lip_w / 2, 0])
            cube([lip_len + EPS, lip_w, depth + extra_top]);

        // Top lead-in chamfer on main channel for easy blind insertion
        translate([0, 0, depth - 0.5])
            hull() {
                translate([0, -ch_w / 2, 0])
                    cube([len, ch_w, EPS]);
                translate([-0.5, -(ch_w / 2 + 0.8), 1.2])
                    cube([len + 1.0, ch_w + 1.6, EPS]);
            }
    }
}

// Ergonomic front thumb scoop cutter
module front_thumb_scoop_cutter() {
    cx = tray_outer_w / 2;
    scoop_h = tray_total_z - scoop_floor_z + 4.0;
    cut_depth_y = wall_thickness + 6.0;

    translate([cx, wall_thickness + 4.0, scoop_floor_z])
        rotate([90, 0, 0])
            linear_extrude(height = cut_depth_y)
                rect(
                    [scoop_width, scoop_h],
                    rounding = [0, 0, scoop_corner_r, scoop_corner_r],
                    anchor = BOTTOM
                );
}

// -----------------------------------------------------------------------------
// Main Assembly
// -----------------------------------------------------------------------------
module snapnote_caddy() {
    // Center X of the pad cavity
    pad_cx = tray_outer_w / 2;
    // Start X of the stencil slots (centered behind the pad cavity)
    slot_start_x = pad_cx - slot_length / 2;
    // Start Y of the first stencil slot
    first_slot_y = tray_outer_h + 4.5;

    // X center of the dual pen tower
    pen_cx = tray_outer_w - wall_thickness + pen_tower_width / 2;
    // Y positions of the two pen wells
    pen_y1 = total_depth * 0.30;
    pen_y2 = total_depth * 0.68;

    difference() {
        // ---------------------------------------------------------------------
        // Positive Body: Solid Stepped Zones
        // ---------------------------------------------------------------------
        intersection() {
            // Clip all zones cleanly to the rounded outer footprint
            linear_extrude(height = pen_tower_z + 10.0)
                caddy_footprint_2d();

            union() {
                // 1. Front Pad Tray Zone
                cube([tray_outer_w, tray_outer_h, tray_total_z]);

                // 2. Tiered Stencil Rack Zone (stepped upward per slot)
                for (i = [0 : num_stencil_slots - 1]) {
                    tier_y = (i == 0)
                        ? (tray_outer_h - wall_thickness)
                        : (first_slot_y + (i - 0.5) * slot_pitch);
                    tier_depth = (i == num_stencil_slots - 1)
                        ? (total_depth - tier_y + EPS)
                        : (slot_pitch + 6.0);
                    tier_top_z = rack_start_floor_z + i * slot_step_z + slot_depth;

                    translate([0, tier_y, 0])
                        cube([tray_outer_w, tier_depth, tier_top_z]);
                }

                // 3. Right-Hand Dual Pen Tower
                translate([tray_outer_w - wall_thickness, 0, 0])
                    cube([pen_tower_width + EPS, total_depth + EPS, pen_tower_z]);
            }
        }

        // ---------------------------------------------------------------------
        // Subtracted Cavities & Features
        // ---------------------------------------------------------------------

        // 1. Sticky note pad cavity (77.2 mm x 77.2 mm)
        translate([wall_thickness, wall_thickness, base_floor])
            cube([pad_cavity_w, pad_cavity_h, tray_total_z + EPS]);

        // 2. Front ergonomic thumb scoop for single-sheet peeling
        front_thumb_scoop_cutter();

        // 3. Angled & tiered stencil storage slots
        for (i = [0 : num_stencil_slots - 1]) {
            slot_y = first_slot_y + i * slot_pitch;
            slot_z = rack_start_floor_z + i * slot_step_z;
            translate([slot_start_x, slot_y, slot_z])
                stencil_slot_cutter();
        }

        // 4. Dual vertical pen wells (13.0 mm ID, 50.0 mm depth)
        for (py = [pen_y1, pen_y2]) {
            // Main cylindrical pen bore
            translate([pen_cx, py, base_floor])
                cylinder(h = pen_well_depth + EPS, d = pen_well_d);

            // Top rim chamfer for smooth pen insertion
            translate([pen_cx, py, pen_tower_z - pen_rim_chamfer])
                cylinder(
                    h = pen_rim_chamfer + EPS,
                    r1 = pen_well_d / 2,
                    r2 = pen_well_d / 2 + pen_rim_chamfer + EPS
                );
        }

        // 5. Four underside recessed pockets for 8 mm adhesive silicone feet
        foot_coords = [
            [foot_inset, foot_inset],
            [total_width - foot_inset, foot_inset],
            [foot_inset, total_depth - foot_inset],
            [total_width - foot_inset, total_depth - foot_inset]
        ];
        for (pt = foot_coords) {
            translate([pt[0], pt[1], -EPS])
                cylinder(h = foot_depth + EPS, d = foot_d);
        }
    }
}

// Render caddy flat on the build plate (Z = 0)
snapnote_caddy();
