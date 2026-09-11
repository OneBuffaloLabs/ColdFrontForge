// Cold Snap Sorter — Sorter Bay & Frost Links
// Units: millimeters

/* [Part Selection] */
PART = "both"; // [bay: Sorter Bay, single_link: 1x2 Frost Link, quad_link: 2x2 Frost Link, links: Both Links (1x2 & 2x2), both: Sorter Bay and Both Links]

/* [Global Settings] */
$fn = 64;
EPS = 0.02;

/* [Card Cavity Dimensions] */
CARD_W            = 70.0;   // Pocket width (clears standard & sleeved cards)
CARD_L            = 72.0;   // Pocket length (cards overhang the back)
WALL_T            = 5.5;    // Perimeter wall thickness
BOX_H             = 24.0;   // Overall box height (flush top rim)

/* [Internal Slanted Floor] */
RAMP_FRONT_H      = 5.0;    // Low floor height behind front wall
RAMP_BACK_H       = 24.0;   // Flush with top rim (BOX_H) at the rear

/* [Stacking / Linking Pegs & Sockets] */
PEG_R             = 1.6;    // Peg radius
PEG_H             = 2.2;    // Peg height
SOCKET_TOL        = 0.35;   // Clearance for underside sockets
PEG_INSET         = 2.8;    // Inset from outer corner

/* [Bottom Logo Settings] */
LOGO_FILE         = "../../../../assets/logo/logo-no-text-black.svg";
LOGO_WIDTH        = 45.0;   // Logo width across the base
LOGO_DEPTH        = 0.6;    // Deboss depth

/* [Frost Link Bracket] */
LINK_THICKNESS    = 2.4;    // Flat link plate thickness
LINK_BORDER       = 2.8;    // Margin around sockets

// --- Computed Parameters ---
TOTAL_W = CARD_W + (2 * WALL_T);
TOTAL_L = CARD_L + (2 * WALL_T);

PEG_X_LEFT  = PEG_INSET;
PEG_X_RIGHT = TOTAL_W - PEG_INSET;
PEG_Y_FRONT = PEG_INSET;
PEG_Y_BACK  = TOTAL_L - PEG_INSET;

SPAN_BETWEEN_BAYS = 2 * PEG_INSET;

// Top Corner Registration Pegs
module stacking_pegs() {
    for (pos = [
        [PEG_X_LEFT,  PEG_Y_FRONT],
        [PEG_X_RIGHT, PEG_Y_FRONT],
        [PEG_X_LEFT,  PEG_Y_BACK],
        [PEG_X_RIGHT, PEG_Y_BACK]
    ]) {
        translate([pos[0], pos[1], BOX_H - EPS])
            cylinder(r1 = PEG_R, r2 = PEG_R - 0.25, h = PEG_H + EPS);
    }
}

// Underside Sockets
module stacking_sockets() {
    r_sock = PEG_R + SOCKET_TOL;
    for (pos = [
        [PEG_X_LEFT,  PEG_Y_FRONT],
        [PEG_X_RIGHT, PEG_Y_FRONT],
        [PEG_X_LEFT,  PEG_Y_BACK],
        [PEG_X_RIGHT, PEG_Y_BACK]
    ]) {
        translate([pos[0], pos[1], -EPS])
            cylinder(r = r_sock, h = PEG_H + 0.6 + EPS);

        translate([pos[0], pos[1], -EPS])
            cylinder(r1 = r_sock + 0.5, r2 = r_sock, h = 0.8 + EPS);
    }
}

// Slanted Card Pocket
module card_pocket_cutter() {
    hull() {
        translate([WALL_T, WALL_T, RAMP_FRONT_H])
            cube([CARD_W, EPS, BOX_H]);

        translate([WALL_T, TOTAL_L - WALL_T - EPS, RAMP_BACK_H])
            cube([CARD_W, EPS, EPS]);
    }
}

// Debossed Cold Front Forge Logo on Base Plate
module bottom_logo() {
    translate([TOTAL_W / 2, TOTAL_L / 2, -EPS])
        rotate([0, 0, 0])
            linear_extrude(height = LOGO_DEPTH + EPS)
                resize([LOGO_WIDTH, 0], auto = true)
                    offset(0)
                        import(LOGO_FILE, center = true);
}

// Sorter Bay Assembly
module sorter_bay() {
    difference() {
        union() {
            cube([TOTAL_W, TOTAL_L, BOX_H]);
            stacking_pegs();
        }

        card_pocket_cutter();
        stacking_sockets();
        bottom_logo();
    }
}

// Flat Horizontal 1x2 Frost Link Bracket (Dual-peg strap)
module frost_single_link() {
    r_outer = PEG_R + SOCKET_TOL + LINK_BORDER;
    r_inner = PEG_R + SOCKET_TOL;

    difference() {
        hull() {
            cylinder(r = r_outer, h = LINK_THICKNESS);
            translate([SPAN_BETWEEN_BAYS, 0, 0])
                cylinder(r = r_outer, h = LINK_THICKNESS);
        }

        translate([0, 0, -EPS])
            cylinder(r = r_inner, h = LINK_THICKNESS + (2 * EPS));

        translate([SPAN_BETWEEN_BAYS, 0, -EPS])
            cylinder(r = r_inner, h = LINK_THICKNESS + (2 * EPS));
    }
}

// Flat 2x2 Frost Link Bracket (Quad-corner junction lock)
module frost_quad_link() {
    r_outer = PEG_R + SOCKET_TOL + LINK_BORDER;
    r_inner = PEG_R + SOCKET_TOL;

    difference() {
        hull() {
            translate([0, 0, 0])
                cylinder(r = r_outer, h = LINK_THICKNESS);
            translate([SPAN_BETWEEN_BAYS, 0, 0])
                cylinder(r = r_outer, h = LINK_THICKNESS);
            translate([0, SPAN_BETWEEN_BAYS, 0])
                cylinder(r = r_outer, h = LINK_THICKNESS);
            translate([SPAN_BETWEEN_BAYS, SPAN_BETWEEN_BAYS, 0])
                cylinder(r = r_outer, h = LINK_THICKNESS);
        }

        for (x = [0, SPAN_BETWEEN_BAYS]) {
            for (y = [0, SPAN_BETWEEN_BAYS]) {
                translate([x, y, -EPS])
                    cylinder(r = r_inner, h = LINK_THICKNESS + (2 * EPS));
            }
        }
    }
}

// Both Links Pair (1x2 and 2x2 grouped together)
module frost_links_pair() {
    frost_single_link();

    translate([0, 20.0, 0])
        frost_quad_link();
}

// --- Output Selection ---
if (PART == "bay") {
    sorter_bay();
} else if (PART == "single_link") {
    frost_single_link();
} else if (PART == "quad_link") {
    frost_quad_link();
} else if (PART == "links") {
    frost_links_pair();
} else if (PART == "both") {
    sorter_bay();

    translate([TOTAL_W + 12.0, 16.0, 0])
        frost_single_link();

    translate([TOTAL_W + 12.0, 36.0, 0])
        frost_quad_link();
}