$fn = 64;
EPS = 0.02;

// Model Part Selector: "single", "assembly", "body", "snowflake"
PART            = "single";

// Snowflake Style (for multi-color): "flush" or "embossed"
LOGO_STYLE      = "flush";

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

// Snowflake Emblem Dimensions
LOGO_FILE       = "assets/snowflake.svg";
LOGO_DEPTH      = 0.8;
LOGO_EMBOSS_H   = 0.6;
LOGO_SCALE      = (PART == "single") ? 0.18 : 0.17;

module outer_profile_2d() {
    circle(d = HEAD_D);

    translate([-HANDLE_W/2, -HEAD_D/2 - HANDLE_L + 6.0])
        square([HANDLE_W, HANDLE_L]);

    translate([0, HEAD_D/2 + EYELET_OD/2 - 1.5])
        circle(d = EYELET_OD);
}

module tab_slot_cutter() {
    y_entry = -HEAD_D/2 - HANDLE_L + 6.0;

    translate([-SLOT_W/2, y_entry - EPS, (THICKNESS - SLOT_H)/2]) {
        cube([SLOT_W, SLOT_DEPTH + EPS, SLOT_H]);

        translate([0, -EPS, -0.6])
            cube([SLOT_W, LIP_BEVEL_L, SLOT_H + 1.2]);
    }
}

module keyring_hole() {
    translate([0, HEAD_D/2 + EYELET_OD/2 - 1.5, -EPS])
        cylinder(d = EYELET_ID, h = THICKNESS + 2*EPS, $fn = 32);
}

module snowflake_negative() {
    translate([0, 0, THICKNESS - LOGO_DEPTH])
        linear_extrude(height = LOGO_DEPTH + EPS)
            scale([LOGO_SCALE, LOGO_SCALE])
                import(LOGO_FILE, center = true);
}

module body_part() {
    difference() {
        linear_extrude(height = THICKNESS)
            outer_profile_2d();

        tab_slot_cutter();
        keyring_hole();
        snowflake_negative();
    }
}

module snowflake_insert() {
    insert_height = (LOGO_STYLE == "embossed") ? (LOGO_DEPTH + LOGO_EMBOSS_H) : LOGO_DEPTH;

    translate([0, 0, THICKNESS - LOGO_DEPTH])
        linear_extrude(height = insert_height)
            scale([LOGO_SCALE, LOGO_SCALE])
                import(LOGO_FILE, center = true);
}

if (PART == "single") {
    body_part();
} else if (PART == "body") {
    body_part();
} else if (PART == "snowflake") {
    snowflake_insert();
} else {
    color("Black")
        body_part();

    color("White")
        snowflake_insert();
}