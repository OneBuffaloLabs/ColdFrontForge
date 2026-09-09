/* [Divider Plate Dimensions] */
plate_width          = 69.0;
plate_height         = 96.0;
plate_thickness      = 2.4;

/* [Cardboard Wall Saddle Hook] */
// Hook side: -1 for left, 1 for right
hook_side            = -1;    // [-1: Left, 1: Right]

// Gap matching standard corrugated divider wall thickness
wall_gap             = 5;

// Depth of the saddle bridge across the top of the cardboard (typically ~5mm)
bridge_depth         = 5.0;

// Length of the outer hook leg hanging down into the adjacent channel
hook_drop_length     = 18.0;

// Total vertical height of the outer hook leg along the divider side
hook_leg_height      = 30.0;

hook_thickness       = 2.4;
ramp_width           = 7.0;

/* [Bottom Corner Cutaways] */
bottom_cut_x         = 10.0;
bottom_cut_y         = 10.0;

/* [Branding Cutout] */
enable_logo_cutout   = true;
logo_width           = 40.0;
logo_y_offset        = 48.0;
logo_svg_path        = "../../../../assets/logo/logo-no-text.svg";

/* [Hidden] */
EPS = 0.02;
$fn = $preview ? 32 : 64;

module plate_profile_2d() {
    polygon(points = [
        [0, plate_height],
        [plate_width, plate_height],
        [plate_width, bottom_cut_y],
        [plate_width - bottom_cut_x, 0],
        [bottom_cut_x, 0],
        [0, bottom_cut_y]
    ]);
}

module side_hook() {
    base_x = (hook_side == -1) ? 0 : plate_width;
    dir    = (hook_side == -1) ? 1 : -1;

    translate([base_x, plate_height, 0]) {
        // Top bridge spanning only the top ~5mm of the partition
        scale([dir, 1, 1])
            translate([-(wall_gap + hook_thickness), -bridge_depth, 0])
                cube([wall_gap + hook_thickness, bridge_depth, hook_thickness]);

        // Outer hook leg hanging on the other side of the cardboard
        scale([dir, 1, 1])
            translate([-(wall_gap + hook_thickness), -hook_leg_height, 0])
                cube([hook_thickness, hook_leg_height, hook_drop_length]);

        // Lead-in reinforcement ramp tapering onto the front plate
        scale([dir, 1, 1])
            translate([0, -bridge_depth, 0])
                rotate([90, 0, -90])
                    linear_extrude(height = ramp_width)
                        polygon(points = [
                            [0, 0],
                            [0, hook_thickness],
                            [bridge_depth, 0]
                        ]);
    }
}

module cold_snap_wedge() {
    union() {
        difference() {
            linear_extrude(height = plate_thickness)
                plate_profile_2d();

            if (enable_logo_cutout) {
                translate([plate_width / 2, logo_y_offset, -EPS])
                    linear_extrude(height = plate_thickness + 2 * EPS)
                        resize([logo_width, 0], auto = true)
                            import(file = logo_svg_path, center = true);
            }
        }

        side_hook();
    }
}

cold_snap_wedge();