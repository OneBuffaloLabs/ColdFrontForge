$fn = 48;
EPS = 0.02;

// =============================================================================
// COLD SNAP DESK CADDY XL — STREAM & BREAK STATION (220mm Bed Optimized)
// Outer dimensions: 216.0mm W x 146.0mm D x 70.0mm H
// Fits standard 220 x 215 build plates with margin to spare.
// =============================================================================

// --- Overall Shell Dimensions ---
BOX_W = 216.0; // Optimized width to fit within 220mm build volume
BOX_D = 146.0; // Total depth across Y
BOX_H = 70.0;  // Total height along Z

WALL_T = 3.2;    // Outer perimeter structural wall thickness
DIVIDER_T = 3.0; // Internal dividing wall thickness
FLOOR_T = 3.0;   // Solid base floor plate thickness
OUTER_R = 2.5;   // Outer vertical corner radius

// --- Compartment Widths ---
LEFT_BAY_W = 86.0;    // Clear width for toploaders (76.2mm) & semi-rigids (~82.5mm)
SLEEVE_BAY_W = 60.7;  // Derived dynamically below, or set fixed

// --- Continuous Front / Rear Depth Split ---
FRONT_BAY_D = 98.0; // Uniform front depth for 92mm tall penny sleeves laying flat
LEFT_FRONT_D = FRONT_BAY_D;
SLEEVE_BAY_D = FRONT_BAY_D;

// --- Front Cutout Access Windows ---
LEFT_LIP_H = 24.0;     // Front retaining lip height on toploader bay
LEFT_NOTCH_W = 68.0;   // Toploader finger access window width
SLEEVE_NOTCH_W = 46.0; // Finger relief width on penny sleeve bays

// --- Branding & Maker's Mark ---
ENABLE_LOGO = true;
LOGO_PATH = "../../../../assets/logo/logo-no-text-black.svg";
LOGO_SCALE = 0.22;
LOGO_DEBOSS_D = 0.8;

// --- Derived Internal Coordinates ---
AVAIL_X_RIGHT = BOX_W - (2 * WALL_T) - (2 * DIVIDER_T) - LEFT_BAY_W;
BAY_RIGHT_W = AVAIL_X_RIGHT / 2; // ~60.8mm each if BOX_W=216, OR adjust BOX_W/bays below

AVAIL_Y = BOX_D - (2 * WALL_T);
REAR_BAY_D = AVAIL_Y - FRONT_BAY_D - DIVIDER_T; // 38.6mm depth for all rear bays

X_LEFT = WALL_T;
X_MID = WALL_T + LEFT_BAY_W + DIVIDER_T;
X_RIGHT = X_MID + BAY_RIGHT_W + DIVIDER_T;
Y_REAR = WALL_T + FRONT_BAY_D + DIVIDER_T;

// Generates 2D rounded footprint with filleted corners
module rounded_rect_2d(width, depth, radius) {
  hull() {
    for (dx = [radius, width - radius]) {
      for (dy = [radius, depth - radius]) {
        translate([dx, dy]) circle(r = radius);
      }
    }
  }
}

// Generates pocket cutout with 45-degree chamfered floor transitions
module pocket_cutter(width, depth, height, chamfer = 2.0) {
  translate([0, 0, chamfer]) {
    cube([width, depth, height - chamfer + 2 * EPS]);
  }
  hull() {
    translate([chamfer, chamfer, 0])
      cube([width - 2 * chamfer, depth - 2 * chamfer, EPS]);
    translate([0, 0, chamfer])
      cube([width, depth, EPS]);
  }
}

// Front access finger cutouts
module front_cutouts() {
  // Toploader relief window above retaining lip
  translate([X_LEFT + (LEFT_BAY_W - LEFT_NOTCH_W) / 2, -EPS, LEFT_LIP_H]) {
    cube([LEFT_NOTCH_W, WALL_T + 2 * EPS, BOX_H]);
  }

  // Penny sleeve bay 1 cutout down to floor
  translate([X_MID + (BAY_RIGHT_W - SLEEVE_NOTCH_W) / 2, -EPS, FLOOR_T]) {
    cube([SLEEVE_NOTCH_W, WALL_T + 2 * EPS, BOX_H]);
  }

  // Penny sleeve bay 2 cutout down to floor
  translate([X_RIGHT + (BAY_RIGHT_W - SLEEVE_NOTCH_W) / 2, -EPS, FLOOR_T]) {
    cube([SLEEVE_NOTCH_W, WALL_T + 2 * EPS, BOX_H]);
  }
}

// Debossed brand mark on exterior bottom surface
module bottom_logo_cutter() {
  if (ENABLE_LOGO) {
    translate([BOX_W / 2, BOX_D / 2, -EPS]) {
      linear_extrude(height = LOGO_DEBOSS_D + EPS) {
        scale([LOGO_SCALE, LOGO_SCALE, 1]) {
          import(file = LOGO_PATH, center = true);
        }
      }
    }
  }
}

// Main assembly
module cold_snap_desk_caddy_xl() {
  difference() {
    // Primary outer perimeter solid
    linear_extrude(height = BOX_H) {
      rounded_rect_2d(BOX_W, BOX_D, OUTER_R);
    }

    // Front-left: 35pt toploader pocket
    translate([X_LEFT, WALL_T, FLOOR_T]) {
      pocket_cutter(LEFT_BAY_W, FRONT_BAY_D, BOX_H - FLOOR_T);
    }

    // Rear-left: Semi-rigid pocket
    translate([X_LEFT, Y_REAR, FLOOR_T]) {
      pocket_cutter(LEFT_BAY_W, REAR_BAY_D, BOX_H - FLOOR_T);
    }

    // Front-center: Penny sleeve bay 1
    translate([X_MID, WALL_T, FLOOR_T]) {
      pocket_cutter(BAY_RIGHT_W, FRONT_BAY_D, BOX_H - FLOOR_T);
    }

    // Front-right: Penny sleeve bay 2
    translate([X_RIGHT, WALL_T, FLOOR_T]) {
      pocket_cutter(BAY_RIGHT_W, FRONT_BAY_D, BOX_H - FLOOR_T);
    }

    // Rear-center: Tool / tape bay
    translate([X_MID, Y_REAR, FLOOR_T]) {
      pocket_cutter(BAY_RIGHT_W, REAR_BAY_D, BOX_H - FLOOR_T);
    }

    // Rear-right: Marker & accessory bay
    translate([X_RIGHT, Y_REAR, FLOOR_T]) {
      pocket_cutter(BAY_RIGHT_W, REAR_BAY_D, BOX_H - FLOOR_T);
    }

    // Front finger pull cutouts
    front_cutouts();

    // Base debossed maker's mark
    bottom_logo_cutter();
  }
}

cold_snap_desk_caddy_xl();