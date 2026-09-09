// Cold Snap Sorter — Sorter Bay & Frost Pin
// Precision stacking box with reversed internal card ramp
// Units: millimeters

/* [Part Selection] */
PART = "both"; // [bay: Sorter Bay, pin: Frost Pin, both: Sorter Bay and Frost Pin]

/* [Global Settings] */
$fn = 64;
EPS = 0.02;

/* [Card Cavity Dimensions] */
CARD_W            = 70.0;   // Inner pocket width (clears standard & deck sleeves)
CARD_L            = 88.0;   // Pocket length front-to-back
WALL_T            = 3.2;    // Outer wall thickness
BOX_H             = 40.0;   // Total box height (uniform flat rim for stacking)

/* [Internal Slanted Floor - Reversed Ramp] */
RAMP_FRONT_H      = 6.0;    // Low end near the front
RAMP_BACK_H       = 28.0;   // High end near the back

/* [Access Cutouts] */
FRONT_NOTCH_W     = 20.0;   // Smaller U-cutout in the front
FRONT_NOTCH_DEPTH = 12.0;   // Smaller depth for front scoop
SIDE_NOTCH_W      = 22.0;   // Width of side edge-grab cutouts
SIDE_NOTCH_DEPTH  = 14.0;   // Depth of side edge-grab cutouts

/* [Frost Pin & Mortise Interface] */
PIN_TOTAL_L       = 18.0;   // Full connector length
PIN_H             = 6.0;    // Key height/thickness
PIN_WAIST_W       = 5.0;    // Narrow waist width
PIN_FLAIR_W       = 8.2;    // Wide dovetail flair width
PIN_CLEARANCE     = 0.22;   // XY clearance per side for smooth slide/snap fit

/* [Stacking Pegs & Sockets] */
PEG_R             = 2.0;    // Corner registration peg radius
PEG_H             = 2.5;    // Peg height
PEG_INSET         = 2.2;    // Inset from outer corner
SOCKET_TOL        = 0.35;   // Extra socket clearance

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

// 3D Standalone Frost Pin
module frost_pin() {
    linear_extrude(height = PIN_H - (2 * PIN_CLEARANCE), center = true)
        pin_profile_2d(clearance = PIN_CLEARANCE);
}

// Subtractive Side Mortise
module side_mortise() {
    translate([0, 0, -EPS])
        linear_extrude(height = PIN_H + (2 * EPS))
            pin_profile_2d(clearance = 0.0);
}

// Reversed Ramp Surface Inside the Box (Low at front, high at back)
module internal_ramp() {
    hull() {
        // Front low edge
        translate([WALL_T - EPS, WALL_T - EPS, 0])
            cube([CARD_W + 2 * EPS, EPS, RAMP_FRONT_H]);

        // Back high edge
        translate([WALL_T - EPS, TOTAL_L - WALL_T, 0])
            cube([CARD_W + 2 * EPS, EPS, RAMP_BACK_H]);

        // Base footprint
        translate([WALL_T - EPS, WALL_T - EPS, 0])
            cube([CARD_W + 2 * EPS, CARD_L + 2 * EPS, EPS]);
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

// Smaller Front Thumb Scoop (U-shape)
module front_thumb_scoop() {
    translate([(TOTAL_W - FRONT_NOTCH_W) / 2, -EPS, BOX_H - FRONT_NOTCH_DEPTH])
        hull() {
            cube([FRONT_NOTCH_W, WALL_T + 2 * EPS, FRONT_NOTCH_DEPTH + EPS]);
            translate([FRONT_NOTCH_W / 2, 0, 0])
                rotate([-90, 0, 0])
                    cylinder(d = FRONT_NOTCH_W, h = WALL_T + 2 * EPS);
        }
}

// Side Edge Grab Scoops
module side_grab_scoops() {
    y_pos = TOTAL_L * 0.45;

    // Left side notch
    translate([-EPS, y_pos - (SIDE_NOTCH_W / 2), BOX_H - SIDE_NOTCH_DEPTH])
        hull() {
            cube([WALL_T + 2 * EPS, SIDE_NOTCH_W, SIDE_NOTCH_DEPTH + EPS]);
            translate([0, SIDE_NOTCH_W / 2, 0])
                rotate([0, 90, 0])
                    cylinder(d = SIDE_NOTCH_W, h = WALL_T + 2 * EPS);
        }

    // Right side notch
    translate([TOTAL_W - WALL_T - EPS, y_pos - (SIDE_NOTCH_W / 2), BOX_H - SIDE_NOTCH_DEPTH])
        hull() {
            cube([WALL_T + 2 * EPS, SIDE_NOTCH_W, SIDE_NOTCH_DEPTH + EPS]);
            translate([0, SIDE_NOTCH_W / 2, 0])
                rotate([0, 90, 0])
                    cylinder(d = SIDE_NOTCH_W, h = WALL_T + 2 * EPS);
        }
}

// Complete Sorter Bay
module sorter_bay() {
    difference() {
        // Outer box shell + Stacking Pegs + Reversed Ramp Base
        union() {
            cube([TOTAL_W, TOTAL_L, BOX_H]);
            internal_ramp();
            stacking_pegs();
        }

        // 1. Hollow out the main card pocket down to the reversed ramp floor
        translate([WALL_T, WALL_T, RAMP_FRONT_H])
            cube([CARD_W, CARD_L, BOX_H]);

        // 2. Cut matching top slope relief above the reversed ramp
        hull() {
            translate([WALL_T, WALL_T, RAMP_FRONT_H])
                cube([CARD_W, EPS, BOX_H]);
            translate([WALL_T, TOTAL_L - WALL_T - EPS, RAMP_BACK_H])
                cube([CARD_W, EPS, BOX_H]);
        }

        // 3. Smaller front thumb scoop
        front_thumb_scoop();

        // 4. Side finger grips
        side_grab_scoops();

        // 5. Underside stacking sockets
        stacking_sockets();

        // 6. Left Side Mortise
        translate([0, TOTAL_L * 0.5, 4.0])
            rotate([0, 0, 90])
                side_mortise();

        // 7. Right Side Mortise
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