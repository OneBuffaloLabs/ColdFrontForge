// Cold Front Forge — Cold Snap Exhibit
// Parametric Architectural Pedestal Plinth & A-Frame Easel
// Multi-Slab & Toploader Tabletop Display

// Include vendored BOSL2 library from repository root
include <../../../../lib/BOSL2/std.scad>

/* [Render Selection] */
// Part to generate for slicer export or preview
part_to_render = "all"; // [all: Assembled Exhibit & Plaque, pedestal: Plinth & Easel Only, plaque: Museum Plaque Insert Only, preview: Exhibit with Card Mockup]

// Show card mockups in preview
show_card_mockup = true;
// Select mockup card type to display in preview mode
mockup_type = "cold_snap"; // [psa_slab: PSA Graded Slab, toploader: 35pt Toploader, cold_snap: Cold Snap Magnetic Slab]

/* [Plinth Base & Column Dimensions] */
plinth_w        = 92.0;  // Base footprint width (X)
plinth_d        = 80.0;  // Base footprint depth (Y)
plinth_h        = 22.0;  // Total plinth base height (Z)

column_w        = 74.0;  // Central column die width
column_d        = 62.0;  // Central column die depth
column_h        = 42.0;  // Central column die height

cornice_h       = 16.0;  // Crowning cornice capital height (Z = 64 to 80)
collar_h        = 8.0;   // Stepped retaining collar basin height (Z = 80 to 88)

/* [Dual-Fit Card Channel Specifications] */
// Forward channel for 35pt raw toploaders
toploader_w     = 79.0;  // Forward channel clearance width
toploader_d     = 2.6;   // Forward channel thickness depth
toploader_drop  = 5.0;   // Forward channel floor drop below collar rim (Z = 83)

// Rear step for PSA Graded Slabs and Cold Snap Slabs
slab_w          = 85.0;  // Rear step clearance width
slab_d          = 8.8;   // Rear step thickness depth
slab_drop       = 6.0;   // Rear step floor drop below collar rim (Z = 82)

front_lip_h     = 6.0;   // Retaining lip height above shelf floor

/* [A-Frame Easel Spine] */
easel_incline   = 78.0;  // Backrest incline angle from horizontal (degrees)
spine_height    = 62.0;  // Vertical span of the backrest spine above collar rim (total exhibit ~150mm)
spine_w_base    = 42.0;  // Easel width at base
spine_w_top     = 22.0;  // Easel width at crest
spine_thick     = 10.0;  // Easel spine structural thickness
truss_w_base    = 18.0;  // Central triangular window base width
truss_w_top     = 4.0;   // Central triangular window top width

/* [Museum Plaque Dimensions] */
plaque_w        = 38.0;  // Plaque outer width
plaque_h        = 32.0;  // Plaque outer height
plaque_t        = 2.4;   // Plaque total thickness
plaque_corner   = 4.0;   // Notched corner chamfer
plaque_fit_tol  = 0.20;  // Slip-fit tolerance for recess pocket

/* [Print & Model Quality] */
$fn = $preview ? 32 : 72;
EPS = 0.02;

// Derived elevations (guaranteeing 100% continuous manifold stacking with zero gaps)
z_base_top        = plinth_h;                          // 22.0
z_column_top      = z_base_top + column_h;             // 64.0
z_cornice_top     = z_column_top + cornice_h;          // 80.0
z_collar_top      = z_cornice_top + collar_h;          // 88.0
z_slab_floor      = z_collar_top - slab_drop;          // 82.0 (solid material below Z=82)
z_toploader_floor = z_collar_top - toploader_drop;      // 83.0 (solid material below Z=83)

// Collar basin dimensions and absolute Y positioning
collar_front_y  = 16.0;
collar_d2       = 30.0;
collar_d1       = 32.0;
collar_w2       = 89.6;
collar_w1       = 91.0;
collar_center_y = collar_front_y + collar_d2 / 2;     // 31.0

// Shelf positioning along Y axis
shelf_front_y   = collar_front_y + 3.5;                // 19.5
y_toploader     = shelf_front_y + toploader_d / 2;     // 20.8
y_slab          = shelf_front_y + toploader_d + slab_d / 2; // 26.5
y_spine_root    = shelf_front_y + toploader_d + slab_d;      // 30.9

// Colors
color_pedestal = [0.95, 0.95, 0.94];
color_plaque   = [0.85, 0.65, 0.18];
color_slab_box = [0.90, 0.15, 0.15, 0.40];
color_card_art = [0.20, 0.40, 0.80, 0.60];

// --- 2D Profiles & Helpers ---

// Classical 8-sided museum plaque profile (rectangle with inverted notched corners)
module plaque_profile_2d(w, h, c) {
    difference() {
        square([w, h], center=true);
        // Notched chamfers on four corners
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * w / 2, sy * h / 2])
                rotate([0, 0, 45])
                    square([c * sqrt(2), c * sqrt(2)], center=true);
        }
    }
}

// Museum Plaque Insert (Printed in Gold / Metallic)
module museum_plaque() {
    color(color_plaque)
    render(convexity=4)
    difference() {
        // Base plate
        linear_extrude(height=plaque_t, convexity=4)
            plaque_profile_2d(plaque_w, plaque_h, plaque_corner);

        // Decorative raised border recess (debossed center plate for custom text or label)
        translate([0, 0, plaque_t - 0.6 + EPS])
            linear_extrude(height=0.6 + 2 * EPS)
                plaque_profile_2d(plaque_w - 4.0, plaque_h - 4.0, max(0.5, plaque_corner - 2.0));
    }
}

// Pedestal Plinth Base (Classical Tiered Moulding with <= 45° overhangs)
module pedestal_base() {
    // Tier 1: Ground block (Z = 0 to 5)
    cube([plinth_w, plinth_d, 5], center=false);

    // Tier 2: Cyma / Chamfer transition moulding (Z = 5 to 19, 45° supportless bevel)
    translate([plinth_w / 2, plinth_d / 2, 5])
        prismoid(size1=[plinth_w, plinth_d], size2=[column_w + 3.0, column_d + 3.0], h=14, anchor=BOTTOM);

    // Tier 3: Plinth upper astragal bead (Z = 19 to 22)
    translate([plinth_w / 2, plinth_d / 2, 19])
        prismoid(size1=[column_w + 3.0, column_d + 3.0], size2=[column_w, column_d], h=3, anchor=BOTTOM);
}

// Central Column Die
module column_die() {
    translate([plinth_w / 2, plinth_d / 2, z_base_top])
        cuboid([column_w, column_d, column_h], chamfer=1.5, edges="Z", anchor=BOTTOM);
}

// Crowning Cornice & Capital (Z = 64 to 88, 100% contiguous, zero gaps)
module capital_cornice() {
    cornice_w = plinth_w; // 92.0 mm (architectural symmetry matching base footprint)
    cornice_d = plinth_d; // 80.0 mm

    // 1. Lower flare: <= 45° flare expansion from column die to cornice rim (Z = 64 to 75)
    translate([plinth_w / 2, plinth_d / 2, z_column_top])
        prismoid(size1=[column_w, column_d], size2=[cornice_w, cornice_d], h=11, anchor=BOTTOM);

    // 2. Cornice fascia band (Z = 75 to 80)
    translate([plinth_w / 2, plinth_d / 2, z_column_top + 11])
        prismoid(size1=[cornice_w, cornice_d], size2=[cornice_w, cornice_d], h=5, anchor=BOTTOM);

    // 3. Upper stepped retaining collar basin Tier 1 (Z = 80 to 82.5)
    translate([plinth_w / 2, collar_center_y, z_cornice_top])
        prismoid(size1=[collar_w1, collar_d1], size2=[collar_w1, collar_d1], h=2.5, anchor=BOTTOM);

    // 4. Upper stepped retaining collar basin Tier 2 (Z = 82.5 to 88)
    translate([plinth_w / 2, collar_center_y, z_cornice_top + 2.5])
        prismoid(size1=[collar_w2, collar_d2], size2=[collar_w2, collar_d2], h=collar_h - 2.5, anchor=BOTTOM);
}

// A-Frame Easel Backrest Spine
module easel_spine() {
    spine_tilt = 90 - easel_incline; // 12 degrees back from vertical
    total_easel_len = (collar_h + spine_height) / cos(spine_tilt);

    // Rooted solidly at z_cornice_top (Z = 80.0) into the deck, extending through the collar
    translate([plinth_w / 2, y_spine_root, z_cornice_top])
        rotate([-spine_tilt, 0, 0])
            difference() {
                // Tapered A-frame solid obelisk
                prismoid(
                    size1=[spine_w_base, spine_thick],
                    size2=[spine_w_top, spine_thick * 0.75],
                    h=total_easel_len,
                    anchor=BOTTOM+FRONT
                );

                // Central triangular truss through-window (starts above collar rim, leaves solid top bridge)
                window_start = (collar_h + 4.0) / cos(spine_tilt);
                window_len   = total_easel_len - window_start - 10.0;
                translate([0, spine_thick / 2, window_start])
                    rotate([90, 0, 0])
                        linear_extrude(height=spine_thick * 3, center=true)
                            polygon([
                                [-truss_w_base / 2, 0],
                                [truss_w_base / 2, 0],
                                [truss_w_top / 2, window_len],
                                [-truss_w_top / 2, window_len]
                            ]);
            }
}

// Dual-Fit Shelf Cutouts
module shelf_cutouts() {
    center_x = plinth_w / 2;
    spine_tilt = 90 - easel_incline;

    // 1. PSA Slab & Cold Snap Slab Rear Pocket
    // Cuts strictly upward from z_slab_floor (Z = 82.0), leaving solid floor below
    translate([center_x, y_slab, z_slab_floor])
        cuboid([slab_w, slab_d, 40], anchor=BOTTOM);

    // Incline relief cut matching easel angle so slab rests completely flush
    translate([center_x, y_spine_root, z_slab_floor])
        rotate([-spine_tilt, 0, 0])
            cuboid([slab_w, 2.0, 40], anchor=BOTTOM+FRONT);

    // 2. 35pt Toploader Forward Channel
    // Cuts strictly upward from z_toploader_floor (Z = 83.0)
    translate([center_x, y_toploader, z_toploader_floor])
        cuboid([toploader_w, toploader_d, 40], anchor=BOTTOM);

    // 3. Plaque Mounting Recess (Front of Column Die)
    pw = plaque_w + 2 * plaque_fit_tol;
    ph = plaque_h + 2 * plaque_fit_tol;
    recess_d = 1.4;
    y_front = (plinth_d - column_d) / 2;
    z_plaque_center = z_base_top + column_h / 2;

    translate([center_x, y_front - EPS, z_plaque_center])
        rotate([-90, 0, 0])
            linear_extrude(height=recess_d + EPS, convexity=4)
                plaque_profile_2d(pw, ph, plaque_corner + plaque_fit_tol);
}

// Bottom Rubber Foot Pads (Four 8mm recessed corners for non-slip desk grip)
module rubber_foot_cutouts() {
    pad_d = 8.5;
    pad_depth = 1.2;
    inset = 10.0;

    for (dx = [inset, plinth_w - inset], dy = [inset, plinth_d - inset]) {
        translate([dx, dy, -EPS])
            cylinder(d=pad_d, h=pad_depth + EPS, $fn=32);
    }
}

// Full Solid Architectural Pedestal with Integrated Easel
module cold_snap_pedestal() {
    color(color_pedestal)
    render(convexity=6)
    difference() {
        union() {
            pedestal_base();
            column_die();
            capital_cornice();
            easel_spine();
        }

        shelf_cutouts();
        rubber_foot_cutouts();
    }
}

// Card & Slab Mockups for Preview Debugging
module card_mockup() {
    spine_tilt = 90 - easel_incline;
    center_x = plinth_w / 2;

    if (mockup_type == "psa_slab") {
        // Standard PSA Graded Slab: 82.5mm W x 137mm H x 8.1mm D
        translate([center_x, y_spine_root, z_slab_floor])
            rotate([-spine_tilt, 0, 0])
                translate([-82.5 / 2, -8.1, 0]) {
                    color(color_slab_box) cube([82.5, 8.1, 137.0]);
                    // Red PSA Label Bar at Top
                    translate([3, 1.0, 114])
                        color("Red") cube([76.5, 6.1, 20]);
                    // Internal Card Window
                    translate([7, 2.0, 10])
                        color(color_card_art) cube([68.5, 4.1, 98]);
                }
    } else if (mockup_type == "toploader") {
        // Standard 35pt Toploader: 76.2mm W x 101.6mm H x 2.0mm D
        translate([center_x, y_spine_root, z_toploader_floor])
            rotate([-spine_tilt, 0, 0])
                translate([-76.2 / 2, -2.0, 0]) {
                    color([0.3, 0.7, 1.0, 0.35]) cube([76.2, 2.0, 101.6]);
                    // Card sleeve inside
                    translate([3, 0.2, 3])
                        color(color_card_art) cube([70.2, 1.6, 95]);
                }
    }
}

// Assembly positioning for the museum plaque
module assembled_plaque() {
    center_x = plinth_w / 2;
    y_front = (plinth_d - column_d) / 2;
    z_plaque_center = z_base_top + column_h / 2;
    recess_d = 1.4;

    translate([center_x, y_front + recess_d - plaque_t, z_plaque_center])
        rotate([-90, 0, 0])
            museum_plaque();
}

// --- Output Dispatcher ---
if (part_to_render == "pedestal") {
    cold_snap_pedestal();
} else if (part_to_render == "plaque") {
    // Lay flat for optimal FDM top-surface finish
    museum_plaque();
} else if (part_to_render == "preview") {
    cold_snap_pedestal();
    assembled_plaque();
    if (show_card_mockup) card_mockup();
} else {
    // "all" - Full assembly view
    cold_snap_pedestal();
    assembled_plaque();
    if ($preview && show_card_mockup) card_mockup();
}
