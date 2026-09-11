/* [Divider Plate Dimensions] */
plate_width = 75.0;
plate_height = 110.0;
plate_thickness = 2.4;

/* [Cardboard Wall Saddle Hook] */
// Hook configuration: -1 for left, 1 for right, 0 for dual
hook_side = -1; // [-1: Left, 1: Right, 0: Dual]

// Gap matching standard corrugated divider wall thickness (5.0mm partition)
wall_gap = 5.2;

// Depth of the saddle bridge across the top of the cardboard
bridge_depth = 5.0;

// Length of the outer hook leg hanging down into the adjacent channel
hook_drop_length = 18.0;

// Total vertical height of the outer hook leg along the divider side
hook_leg_height = 30.0;

hook_thickness = 2.4;
ramp_width = 7.0;

/* [Compliant Spring Finger] */
// Leaf thickness (~1.0mm allows clean spring deflection in PLA/PETG)
spring_thickness = 1.0;

// How far the finger tip pinches inward into the gap (reach ~3.2mm into a 5.2mm gap leaves a ~2.0mm resting throat)
spring_reach = 3.2;

// Length of the spring finger along the vertical leg
spring_length = 22.0;

/* [Bottom Corner Cutaways] */
bottom_cut_x = 10.0;
bottom_cut_y = 10.0;

/* [Branding Cutout] */
enable_logo_cutout = true;
logo_width = 50.0;
logo_y_offset = 58.0;
logo_svg_path = "../../../../assets/logo/logo-no-text.svg";

/* [Hidden] */
EPS = 0.02;
$fn = $preview ? 32 : 64;

module plate_profile_2d() {
  polygon(
    points=[
      [0, plate_height],
      [plate_width, plate_height],
      [plate_width, bottom_cut_y],
      [plate_width - bottom_cut_x, 0],
      [bottom_cut_x, 0],
      [0, bottom_cut_y],
    ]
  );
}

module single_hook(side = -1) {
  base_x = (side == -1) ? 0 : plate_width;
  dir = (side == -1) ? 1 : -1;

  translate([base_x, plate_height, 0]) {
    // Top bridge spanning only the top of the partition
    scale([dir, 1, 1])
      translate([-(wall_gap + hook_thickness), -bridge_depth, 0])
        cube([wall_gap + hook_thickness, bridge_depth, hook_thickness]);

    // Outer hook leg hanging on the other side of the cardboard
    scale([dir, 1, 1])
      translate([-(wall_gap + hook_thickness), -hook_leg_height, 0])
        cube([hook_thickness, hook_leg_height, hook_drop_length]);

    // Compliant spring finger on the inside of the outer leg
    // Tapers inward toward the divider plate to pinch 2mm walls, deflecting flat for 5mm walls
    scale([dir, 1, 1])
      translate([-(wall_gap), -bridge_depth, 0])
        linear_extrude(height=hook_drop_length)
          polygon(
            points=[
              [0, 0],
              [spring_thickness, 0],
              [spring_reach + spring_thickness, -spring_length * 0.75],
              [spring_reach, -spring_length * 0.75],
              [spring_thickness, -spring_length],
              [0, -spring_length],
            ]
          );

    // Lead-in reinforcement ramp tapering onto the front plate
    scale([dir, 1, 1])
      translate([0, -bridge_depth, 0])
        rotate([90, 0, -90])
          linear_extrude(height=ramp_width)
            polygon(
              points=[
                [0, 0],
                [0, hook_thickness],
                [bridge_depth, 0],
              ]
            );
  }
}

module side_hooks() {
  if (hook_side == -1 || hook_side == 0) {
    single_hook(-1);
  }
  if (hook_side == 1 || hook_side == 0) {
    single_hook(1);
  }
}

module cold_snap_wedge() {
  union() {
    difference() {
      linear_extrude(height=plate_thickness)
        plate_profile_2d();

      if (enable_logo_cutout) {
        translate([plate_width / 2, logo_y_offset, -EPS])
          linear_extrude(height=plate_thickness + 2 * EPS)
            resize([logo_width, 0], auto=true)
              import(file=logo_svg_path, center=true);
      }
    }

    side_hooks();
  }
}

cold_snap_wedge();
