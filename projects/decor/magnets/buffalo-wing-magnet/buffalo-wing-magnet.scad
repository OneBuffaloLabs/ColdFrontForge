// =============================================================================
// Buffalo Wing Magnet - Buffalo Bills Themed Fridge Magnet
// =============================================================================
// Include vendored BOSL2 library from repository root
include <../../../../lib/BOSL2/std.scad>

/* [Preview / Rendering] */
PART = "all"; // [all, base]
$fn = $preview ? 32 : 90;

/* [Magnet Hardware] */
magnet_d = 10.0;      // Nominal magnet diameter (mm)
magnet_h = 2.0;       // Nominal magnet thickness (mm)
clearance = 0.15;     // Press-fit radial clearance (mm)
EPS = 0.01;           // Manifold overlap offset

/* [Base Dimensions (Placeholder Scaffold)] */
base_length = 60.0;
base_width = 40.0;
base_thickness = 4.0;

module magnet_pocket() {
    cyl(
        d = magnet_d + 2 * clearance,
        h = magnet_h + EPS,
        anchor = BOTTOM,
        $fn = 32
    );
}

module buffalo_wing_magnet_base() {
    difference() {
        cuboid([base_length, base_width, base_thickness], rounding = 4, edges = "Z", anchor = BOTTOM);
        // Rear magnet press-fit pocket
        translate([0, 0, -EPS])
            magnet_pocket();
    }
}

if (PART == "all" || PART == "base") {
    buffalo_wing_magnet_base();
}
