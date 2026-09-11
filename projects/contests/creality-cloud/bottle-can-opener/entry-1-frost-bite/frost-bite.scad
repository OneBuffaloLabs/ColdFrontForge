$fn = 64;
EPS = 0.02;

// Body Dimensions
HANDLE_W        = 22.0;
HANDLE_L        = 28.0;
HEAD_D          = 36.0;
THICKNESS       = 5.0;

// Internal Slot for Can Tab
SLOT_W          = 16.0;
SLOT_H          = 2.2;
SLOT_DEPTH      = 24.0;
LIP_BEVEL_L     = 3.0;

// Keyring Eyelet
EYELET_OD       = 8.0;
EYELET_ID       = 4.2;

// Snowflake Emblem
 LOGO_FILE       = "assets/snowflake.svg";
LOGO_DEPTH      = 0.8;
LOGO_SCALE      = 0.20;

module outer_profile_2d() {
    // Round head
    circle(d = HEAD_D);

    // Rectangular handle / can-tab sleeve
    translate([-HANDLE_W/2, -HEAD_D/2 - HANDLE_L + 6.0])
        square([HANDLE_W, HANDLE_L]);

    // Keyring eyelet lug at the top
    translate([0, HEAD_D/2 + EYELET_OD/2 - 1.5])
        circle(d = EYELET_OD);
}

module tab_slot_cutter() {
    y_entry = -HEAD_D/2 - HANDLE_L + 6.0;

    translate([-SLOT_W/2, y_entry - EPS, (THICKNESS - SLOT_H)/2]) {
        // Main flat pocket that slides over the soda can tab
        cube([SLOT_W, SLOT_DEPTH + EPS, SLOT_H]);

        // Entry mouth lead-in chamfer
        translate([0, -EPS, -0.6])
            cube([SLOT_W, LIP_BEVEL_L, SLOT_H + 1.2]);
    }
}

module keyring_hole() {
    translate([0, HEAD_D/2 + EYELET_OD/2 - 1.5, -EPS])
        cylinder(d = EYELET_ID, h = THICKNESS + 2*EPS, $fn = 32);
}

module snowflake_relief() {
    translate([0, 0, THICKNESS - LOGO_DEPTH + EPS])
        linear_extrude(height = LOGO_DEPTH + EPS)
            scale([LOGO_SCALE, LOGO_SCALE])
                import(LOGO_FILE, center = true);
}

module frost_bite() {
    difference() {
        linear_extrude(height = THICKNESS)
            outer_profile_2d();

        tab_slot_cutter();
        keyring_hole();
        snowflake_relief();
    }
}

frost_bite();