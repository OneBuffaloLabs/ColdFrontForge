$fn = 48;
EPS = 0.02;

// =============================================================================
// COLD SNAP DESK CADDY — PRO STATION
// Outer dimensions: 171.4mm W x 146.0mm D x 70.0mm H
// Fits comfortably on 220 x 215 mm print beds without rotation.
//
// Layout:
//   - Front-left: High-capacity 35pt toploader storage (~70+ toploaders)
//   - Rear-left: Semi-rigid card holder bay
//   - Front-right: Flat penny sleeve bay with floor cutout
//   - Rear-right 1: Tape / pull-tab / accessory bay
//   - Rear-right 2: Marker / pen / tool bay
// =============================================================================

// --- Overall Shell Dimensions ---
BOX_W = 171.4; // Fits 220x215 beds cleanly
BOX_D = 146.0; // Total depth across Y
BOX_H = 70.0;  // Total height along Z

WALL_T = 3.2;    // Outer perimeter structural wall thickness
DIVIDER_T = 3.0; // Internal dividing wall thickness
FLOOR_T = 3.0;   // Solid base floor plate thickness
OUTER_R = 2.5;   // Outer vertical corner radius

// --- Compartment Widths ---
LEFT_BAY_W = 92.0;   // Standard width for toploaders & semi-rigids
RIGHT_BAY_W = 70.0;  // Fits standard 66mm penny sleeves flat with 2mm clearance each side

// --- Continuous Front / Rear Depth Split ---
FRONT_BAY_D = 98.0;  // Depth for 92mm tall penny sleeves laying flat
LEFT_FRONT_D = FRONT_BAY_D;
RIGHT_FRONT_D = FRONT_BAY_D;

// --- Front Cutout Windows ---
LEFT_LIP_H = 24.0;     // Front retaining lip height on toploader bay
LEFT_NOTCH_W = 70.0;   // Toploader finger access window width
SLEEVE_NOTCH_W = 54.0; // Penny sleeve finger access window width

// --- Branding & Maker's Mark ---
ENABLE_LOGO = true;
LOGO_PATH = "../../../../assets/logo/logo-no-text-black.svg";
LOGO_SCALE = 0.20;
LOGO_DEBOSS_D = 0.8; // 4 layers at 0.20mm for crisp empty deboss shadow

// --- Derived Internal Coordinates ---
AVAIL_Y = BOX_D - (2 * WALL_T);
REAR_BAY_D = AVAIL_Y - FRONT_BAY_D - DIVIDER_T; // 38.6mm depth for all rear bays

// Split rear-right area into 2 equal bays
REAR_TOOL_W = (RIGHT_BAY_W - DIVIDER_T) / 2; // 33.5mm each

X_LEFT = WALL_T;
X_RIGHT = WALL_T + LEFT_BAY_W + DIVIDER_T;
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

  // Penny sleeve cutout down to floor
  translate([X_RIGHT + (RIGHT_BAY_W - SLEEVE_NOTCH_W) / 2, -EPS, FLOOR_T]) {
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
module cold_snap_desk_caddy_pro() {
  difference() {
    // Primary outer perimeter solid
    linear_extrude(height = BOX_H) {
      rounded_rect_2d(BOX_W, BOX_D, OUTER_R);
    }

    // Front-left: Deep 35pt toploader pocket
    translate([X_LEFT, WALL_T, FLOOR_T]) {
      pocket_cutter(LEFT_BAY_W, FRONT_BAY_D, BOX_H - FLOOR_T);
    }

    // Rear-left: Semi-rigid pocket
    translate([X_LEFT, Y_REAR, FLOOR_T]) {
      pocket_cutter(LEFT_BAY_W, REAR_BAY_D, BOX_H - FLOOR_T);
    }

    // Front-right: Flat penny sleeve pocket
    translate([X_RIGHT, WALL_T, FLOOR_T]) {
      pocket_cutter(RIGHT_BAY_W, FRONT_BAY_D, BOX_H - FLOOR_T);
    }

    // Rear-right: Utility Bay 1 (Left side of right rear)
    translate([X_RIGHT, Y_REAR, FLOOR_T]) {
      pocket_cutter(REAR_TOOL_W, REAR_BAY_D, BOX_H - FLOOR_T);
    }

    // Rear-right: Utility Bay 2 (Right side of right rear)
    x_tool_2 = X_RIGHT + REAR_TOOL_W + DIVIDER_T;
    translate([x_tool_2, Y_REAR, FLOOR_T]) {
      pocket_cutter(REAR_TOOL_W, REAR_BAY_D, BOX_H - FLOOR_T);
    }

    // Front finger pull cutouts
    front_cutouts();

    // Base debossed maker's mark
    bottom_logo_cutter();
  }
}

cold_snap_desk_caddy_pro();