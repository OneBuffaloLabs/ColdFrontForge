// Cold Snap Sorter — Sorter Bay & Frost Pin
// Units: millimeters

/* [Part Selection] */
PART = "both"; // [bay: Sorter Bay, pin: Frost Pin, both: Sorter Bay and Frost Pin]

/* [Global Settings] */
$fn = 64;
EPS = 0.02;

/* [Card Cavity Dimensions] */
CARD_W            = 70.0;   // Inner width (clears standard & deck sleeves)
CARD_L            = 88.0;   // Inner length front-to-back
WALL_T            = 3.2;    // Outer perimeter thickness
BOX_H             = 40.0;   // Uniform outer box height

/* [Internal Slanted Floor] */
RAMP_FRONT_H      = 6.0;    // Low floor height at front
RAMP_BACK_H       = 24.0;   // Elevated floor height at back

/* [Access Scoops] */
FRONT_NOTCH_W     = 28.0;   // Front thumb cutout width
FRONT_NOTCH_DEPTH = 12.0;   // Front thumb cutout depth
SIDE_NOTCH_W      = 24.0;   // Side grab scoop width
SIDE_NOTCH_DEPTH  = 12.0;   // Side grab scoop depth

/* [Frost Pin & Mortise Interface] */
PIN_TOTAL_L       = 18.0;
PIN_H             = 6.0;
PIN_WAIST_W       = 5.0;
PIN_FLAIR_W       = 8.2;
PIN_CLEARANCE     = 0.22;

/* [Stacking Pegs & Sockets] */
PEG_R             = 2.0;
PEG_H             = 2.5;
PEG_INSET         = 2.0;
SOCKET_TOL        = 0.35;

// --- Computed Parameters ---
TOTAL_W = CARD_W + (2 * WALL_T);
TOTAL_L = CARD_L + (2 * WALL_T);

// 2D Profile for the Frost Pin
module pin_profile_2d(clearance = 0.0) {
    w_waist = max(0.5, PIN_WAIST_W - (2 * clearance));
    w_flair = max(0.8, PIN_FLAIR_W - (2 * clearance));
    len_half = (PIN_TOTAL_L / 2) - clearance;

    polygon(points = [
        [-len_half, -w_flair / 2],
        [-len_half,  w_flair / 2],
        [0,          w_waist / 2],
        [ len_half,  w_flair / 2],
        [ len_half, -w_flair / 2],
        [0,         -w_waist / 2]
    ]);
}

// Standalone Frost Pin
module frost_pin() {
    linear_extrude(height = PIN_H - (2 * PIN_CLEARANCE), center = true)
        pin_profile_2d(clearance = PIN_CLEARANCE);
}

// Side Mortise Cutter
module side_mortise() {
    translate([0, 0, -EPS])
        linear_extrude(height = PIN_H + (2 * EPS))
            pin_profile_2d(clearance = 0.0);
}

// Hollow Pocket Cutter (leaves the slanted ramp intact)
module card_pocket_cutter() {
    hull() {
        // Front low baseline (extended up through the top of the box)
        translate([WALL_T, WALL_T, RAMP_FRONT_H])
            cube([CARD_W, EPS, BOX_H]);

        // Back high baseline (extended up through the top of the box)
        translate([WALL_T, TOTAL_L - WALL_T - EPS, RAMP_BACK_H])
            cube([CARD_W, EPS, BOX_H]);
    }
}

// Top Corner Registration Pegs
module stacking_pegs() {
    for (x = [PEG_INSET + WALL_T/2, TOTAL_W - PEG_INSET - WALL_T/2]) {
        for (y = [PEG_INSET + WALL_T/2, TOTAL_L - PEG_INSET - WALL_T/2]) {
            translate([x, y, BOX_H])
                cylinder(r1 = PEG_R, r2 = PEG_R - 0.4, h = PEG_H);
        }
    }
}

// Underside Corner Sockets
module stacking_sockets() {
    r_sock = PEG_R + SOCKET_TOL;
    for (x = [PEG_INSET + WALL_T/2, TOTAL_W - PEG_INSET - WALL_T/2]) {
        for (y = [PEG_INSET + WALL_T/2, TOTAL_L - PEG_INSET - WALL_T/2]) {
            translate([x, y, -EPS])
                cylinder(r1 = r_sock + 0.4, r2 = r_sock, h = PEG_H + 0.5 + EPS);
        }
    }
}

// Front Thumb Scoop
module front_scoop() {
    translate([(TOTAL_W - FRONT_NOTCH_W) / 2, -EPS, BOX_H - FRONT_NOTCH_DEPTH])
        hull() {
            cube([FRONT_NOTCH_W, WALL_T + (2 * EPS), FRONT_NOTCH_DEPTH + EPS]);
            translate([FRONT_NOTCH_W / 2, 0, 0])
                rotate([-90, 0, 0])
                    cylinder(d = FRONT_NOTCH_W, h = WALL_T + (2 * EPS));
        }
}

// Side Grab Scoops
module side_scoops() {
    y_center = TOTAL_L * 0.48;

    // Left wall scoop
    translate([-EPS, y_center - (SIDE_NOTCH_W / 2), BOX_H - SIDE_NOTCH_DEPTH])
        hull() {
            cube([WALL_T + (2 * EPS), SIDE_NOTCH_W, SIDE_NOTCH_DEPTH + EPS]);
            translate([0, SIDE_NOTCH_W / 2, 0])
                rotate([0, 90, 0])
                    cylinder(d = SIDE_NOTCH_W, h = WALL_T + (2 * EPS));
        }

    // Right wall scoop
    translate([TOTAL_W - WALL_T - EPS, y_center - (SIDE_NOTCH_W / 2), BOX_H - SIDE_NOTCH_DEPTH])
        hull() {
            cube([WALL_T + (2 * EPS), SIDE_NOTCH_W, SIDE_NOTCH_DEPTH + EPS]);
            translate([0, SIDE_NOTCH_W / 2, 0])
                rotate([0, 90, 0])
                    cylinder(d = SIDE_NOTCH_W, h = WALL_T + (2 * EPS));
        }
}

// Sorter Bay Unit
module sorter_bay() {
    difference() {
        // Outer solid block + top alignment pegs
        union() {
            cube([TOTAL_W, TOTAL_L, BOX_H]);
            stacking_pegs();
        }

        // Slanted pocket cavity
        card_pocket_cutter();

        // Edge finger scoops
        front_scoop();
        side_scoops();

        // Underside stacking sockets
        stacking_sockets();

        // Left Mortise
        translate([0, TOTAL_L * 0.5, 4.0])
            rotate([0, 0, 90])
                side_mortise();

        // Right Mortise
        translate([TOTAL_W, TOTAL_L * 0.5, 4.0])
            rotate([0, 0, 90])
                side_mortise();
    }
}

// --- Render Selection ---
if (PART == "bay") {
    sorter_bay();
} else if (PART == "pin") {
    frost_pin();
} else if (PART == "both") {
    sorter_bay();

    // Position Frost Pin adjacent on build plate
    translate([TOTAL_W + 12.0, TOTAL_L * 0.5, (PIN_H / 2) - PIN_CLEARANCE])
        rotate([0, 0, 90])
            frost_pin();
}