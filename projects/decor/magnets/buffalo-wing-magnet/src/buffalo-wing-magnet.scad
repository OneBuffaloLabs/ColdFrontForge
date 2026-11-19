// =============================================================================
// Buffalo Wing Magnet - Multi-Part Press-Fit Fridge Magnet
// =============================================================================
// 3-part friction-fit assembly (white base tray, orange wing, green celery)
// designed for single-extruder / non-AMS printing with 0.2 mm glue relief
// wells and configurable rear magnet pockets (dual 5x2 mm or single 10x2 mm).
// =============================================================================

// Include vendored BOSL2 library from repository root
include <../../../../../lib/BOSL2/std.scad>

/* [Preview / Rendering] */
render_mode = "all"; // [all, base, wing, celery]
// Orientation in XY plane (horizontal aligns long axis with X for Ctrl+4 Top View)
display_orientation = "horizontal"; // [horizontal, vertical]
$fn = $preview ? 32 : 120;

/* [Core Dimensions] */
// Target overall height of the wing + celery artwork (mm)
target_height = 75.0;
// Total thickness of the white base tray (mm)
base_thickness = 4.8;
// Depth of the recessed front insert pockets (mm)
pocket_depth = 2.0;
// Height the color inserts sit proud above the white base rim (mm)
insert_protrusion = 1.3; // [1.0:0.1:1.5]
// Outer white rim border around the artwork (mm)
border_thickness = 1.8;
// Morphological closing radius to bridge the gap between wing and celery on the base
base_fill_gap = 4.0;

/* [Tolerances & Glue Relief] */
// Horizontal friction-fit clearance applied to female base pockets (mm)
pocket_clearance = 0.10;
// Depth of the inset glue relief well on each pocket floor (mm)
glue_well_depth = 0.20;
// Perimeter shelf width around each pocket floor that supports the insert (mm)
glue_well_inset = 1.20;
// Manifold boolean overlap offset (mm)
EPS = 0.01;

/* [Magnet Hardware] */
magnet_config = "dual_5x2"; // [dual_5x2, single_10x2]
// Dual 5x2 mm magnet pocket dimensions
dual_magnet_d = 5.2;
dual_magnet_h = 2.1;
// Single 10x2 mm magnet pocket dimensions
single_magnet_d = 10.2;
single_magnet_h = 2.1;

/* [Magnet Positions (Relative to Centered 75 mm Artwork)] */
// Upper 5x2 magnet offset (upper neck / wing transition)
dual_upper_pos = [-1.5, 16.0];
// Lower 5x2 magnet offset (lower drumette body)
dual_lower_pos = [-0.5, -14.0];
// Single 10x2 magnet offset (center of mass in main drumette body)
single_center_pos = [-0.5, -6.0];

/* [Internal Constants] */
wing_svg = "../assets/wing_body.svg";
celery_svg = "../assets/celery_streak.svg";
svg_ref_width = 31.951;
svg_ref_height = 75.0;
scale_factor = target_height / svg_ref_height;
insert_thickness = pocket_depth + insert_protrusion;
pocket_floor_z = base_thickness - pocket_depth;

// =============================================================================
// 2D Vector Profiles
// =============================================================================

module wing_2d() {
    scale([scale_factor, scale_factor])
        translate([-svg_ref_width / 2, -svg_ref_height / 2])
            import(file = wing_svg, center = false);
}

module celery_2d() {
    scale([scale_factor, scale_factor])
        translate([-svg_ref_width / 2, -svg_ref_height / 2])
            import(file = celery_svg, center = false);
}

module base_outline_2d() {
    // Bridge internal gap between wing and celery, then add outer white border
    offset(delta = border_thickness)
        offset(r = -base_fill_gap)
            offset(r = base_fill_gap)
                union() {
                    wing_2d();
                    celery_2d();
                }
}

// =============================================================================
// Sub-Modules (Design Space)
// =============================================================================

module insert_pocket_cutter(depth) {
    // Female pocket expanded by pocket_clearance for friction fit
    linear_extrude(height = depth + EPS)
        offset(delta = pocket_clearance)
            children();
}

module glue_well_cutter() {
    // Inset relief channel on the pocket floor leaving a perimeter support shelf
    linear_extrude(height = glue_well_depth + EPS)
        offset(delta = -glue_well_inset)
            children();
}

module magnet_pockets_cutter() {
    if (magnet_config == "dual_5x2") {
        for (pos = [dual_upper_pos, dual_lower_pos]) {
            translate([pos.x * scale_factor, pos.y * scale_factor, -EPS])
                cyl(d = dual_magnet_d, h = dual_magnet_h + EPS, anchor = BOTTOM, $fn = 64);
        }
    } else if (magnet_config == "single_10x2") {
        translate([single_center_pos.x * scale_factor, single_center_pos.y * scale_factor, -EPS])
            cyl(d = single_magnet_d, h = single_magnet_h + EPS, anchor = BOTTOM, $fn = 64);
    }
}

module base_tray() {
    difference() {
        // Solid white base plate
        linear_extrude(height = base_thickness)
            base_outline_2d();

        // Wing insert pocket
        translate([0, 0, pocket_floor_z])
            insert_pocket_cutter(pocket_depth)
                wing_2d();

        // Wing pocket floor glue relief well
        translate([0, 0, pocket_floor_z - glue_well_depth])
            glue_well_cutter()
                wing_2d();

        // Celery insert pocket
        translate([0, 0, pocket_floor_z])
            insert_pocket_cutter(pocket_depth)
                celery_2d();

        // Celery pocket floor glue relief well
        translate([0, 0, pocket_floor_z - glue_well_depth])
            glue_well_cutter()
                celery_2d();

        // Rear magnet pocket(s)
        magnet_pockets_cutter();
    }
}

module wing_insert() {
    linear_extrude(height = insert_thickness)
        wing_2d();
}

module celery_insert() {
    linear_extrude(height = insert_thickness)
        celery_2d();
}

// =============================================================================
// Render / Print-Bed Assembly
// =============================================================================

orient_z = (display_orientation == "horizontal") ? 90 : 0;

rotate([0, 0, orient_z]) {
    if (render_mode == "all") {
        color("White")
            base_tray();
        color("OrangeRed")
            translate([0, 0, pocket_floor_z])
                wing_insert();
        color("ForestGreen")
            translate([0, 0, pocket_floor_z])
                celery_insert();
    } else if (render_mode == "base") {
        base_tray();
    } else if (render_mode == "wing") {
        wing_insert();
    } else if (render_mode == "celery") {
        celery_insert();
    }
}
