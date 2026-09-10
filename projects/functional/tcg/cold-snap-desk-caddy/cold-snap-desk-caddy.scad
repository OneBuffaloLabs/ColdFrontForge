$fn = 48;
EPS = 0.02;

// =============================================================================
// COLD SNAP DESK CADDY
// Layout:
//   - Left-front bay: Sized for toploaders/sleeves with a mid-height retaining lip
//   - Left-rear bay: Full-height slot for semi-rigids
//   - Right bay: Full-depth slot for penny sleeves with a floor-level cutout
// =============================================================================

// --- Overall Shell Dimensions ---
BOX_W = 170.0; // Total width across the X axis
BOX_D = 104.0; // Total depth across the Y axis
BOX_H = 70.0;  // Total height of the outer perimeter walls along the Z axis

WALL_T = 3.2;    // Outer perimeter structural wall thickness
DIVIDER_T = 3.0; // Internal dividing wall thickness
FLOOR_T = 3.0;   // Solid base floor plate thickness
OUTER_R = 2.5;   // Radius for outer vertical corner rounding

// --- Compartment Allocation ---
RIGHT_BAY_W = 70.0;  // Width of the right-side vertical penny sleeve bay
LEFT_FRONT_D = 58.0; // Depth of the front-left toploader storage bay

// --- Front Cutout Windows ---
LEFT_LIP_H = 24.0;   // Height of the front retaining lip on the left bay
LEFT_NOTCH_W = 70.0; // Horizontal width of the toploader access window

RIGHT_NOTCH_W = 54.0; // Horizontal width of the front penny sleeve cutout
RIGHT_POST_W = 8.0;   // Width of the front-right structural corner post

// --- Branding & Maker's Mark ---
ENABLE_LOGO = true;  // Toggle for rendering the SVG bottom deboss
LOGO_PATH = "../../../../assets/logo/logo-no-text-black.svg"; // Path to brand SVG[cite: 2]
LOGO_SCALE = 0.20;   // Adjusted scale factor for the base deboss mark
LOGO_DEBOSS_D = 0.6; // Subtraction depth into the bottom floor plate

// --- Internal Derived Coordinates ---
AVAIL_X = BOX_W - (2 * WALL_T) - DIVIDER_T;
LEFT_BAY_W = AVAIL_X - RIGHT_BAY_W;

AVAIL_Y = BOX_D - (2 * WALL_T);
RIGHT_BAY_D = AVAIL_Y;
LEFT_REAR_D = AVAIL_Y - LEFT_FRONT_D - DIVIDER_T;

// Generates a 2D rounded footprint with filleted corners
module rounded_rect_2d(width, depth, radius) {
  hull() {
    for (dx = [radius, width - radius]) {
      for (dy = [radius, depth - radius]) {
        translate([dx, dy]) circle(r = radius);
      }
    }
  }
}

// Generates an interior pocket cutout with sloped floor transitions
module pocket_cutter(width, depth, height, chamfer = 2.0) {
  translate([0, 0, chamfer])
    cube([width, depth, height - chamfer + 2 * EPS]);

  hull() {
    translate([chamfer, chamfer, 0])
      cube([width - 2 * chamfer, depth - 2 * chamfer, EPS]);
    translate([0, 0, chamfer])
      cube([width, depth, EPS]);
  }
}

// Cuts the front-facing access windows for supply removal
module front_cutouts() {
  // Toploader finger relief above the front retaining lip
  translate([WALL_T + (LEFT_BAY_W - LEFT_NOTCH_W) / 2, -EPS, LEFT_LIP_H])
    cube([LEFT_NOTCH_W, WALL_T + 2 * EPS, BOX_H]);

  // Full-depth penny sleeve finger relief down to the floor plate
  x_right_start = WALL_T + LEFT_BAY_W + DIVIDER_T;
  translate([x_right_start + (RIGHT_BAY_W - RIGHT_NOTCH_W - RIGHT_POST_W), -EPS, FLOOR_T])
    cube([RIGHT_NOTCH_W, WALL_T + 2 * EPS, BOX_H]);
}

// Subtractive logo mark on the exterior bottom surface
module bottom_logo_cutter() {
  if (ENABLE_LOGO) {
    translate([BOX_W / 2, BOX_D / 2, -EPS])
      linear_extrude(height = LOGO_DEBOSS_D + EPS)
        scale([LOGO_SCALE, LOGO_SCALE])
          import(file = LOGO_PATH, center = true);
  }
}

// Main assembly composing the outer perimeter and interior cavities
module cold_snap_desk_caddy() {
  difference() {
    // Primary solid shell
    linear_extrude(height = BOX_H)
      rounded_rect_2d(BOX_W, BOX_D, OUTER_R);

    // Front-left toploader storage pocket
    translate([WALL_T, WALL_T, FLOOR_T])
      pocket_cutter(LEFT_BAY_W, LEFT_FRONT_D, BOX_H - FLOOR_T);

    // Rear-left semi-rigid storage pocket
    y_left_rear = WALL_T + LEFT_FRONT_D + DIVIDER_T;
    translate([WALL_T, y_left_rear, FLOOR_T])
      pocket_cutter(LEFT_BAY_W, LEFT_REAR_D, BOX_H - FLOOR_T);

    // Full-depth right penny sleeve storage pocket
    x_right = WALL_T + LEFT_BAY_W + DIVIDER_T;
    translate([x_right, WALL_T, FLOOR_T])
      pocket_cutter(RIGHT_BAY_W, RIGHT_BAY_D, BOX_H - FLOOR_T);

    // Front access cutouts
    front_cutouts();

    // Exterior base logo
    bottom_logo_cutter();
  }
}

cold_snap_desk_caddy();