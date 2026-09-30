/* BILLY THE PUPPET (SAW) POKÉBALL */

include <../../../helpers/pokeball/filler.scad>;
include <../../../helpers/pokeball/core.scad>;

// === RENDER SETTINGS ===
part_to_render = "all"; // [all, top, bottom, ring, front_ring, button, filler, chips_black, chips_red]
exploded_view = false;
debug_transparent_chips = false;

// === HARDWARE & FIT CLEARANCES ===
pocket_depth = 2.5;
accent_pocket_extra_depth = 0.5;

eye_clearance = -0.06;
front_ring_press_fit = 0.08;
button_press_fit = 0.06;

// Face Proportions
eye_outer_radius = 6.5;
eye_red_outer = 4.2;
eye_red_inner = 2;
red_ring_depth = 1.2;

spiral_max_radius = 8.5;
spiral_thickness = 2.2;
spiral_turns = 2.5;

// === FACE PLACEMENT & TWEAKS ===
eye_tilt = 40;
eye_pan = 25;
eye_rotation = -15;

brow_tilt = 42;
brow_pan = 27;
brow_thickness = 7;
brow_radius = 12;
brow_angle_start = 0;
brow_angle_end = 110;
brow_rotation = -20;
brow_protrusion = 0;

cheek_tilt = 21;
cheek_pan = 48;

// === BOWTIE PARAMETERS ===
bowtie_tilt = -28;
bowtie_knot_size = 12;
bowtie_wing_length = 25;
bowtie_thickness = 6;
bowtie_peg_radius = 4;
bowtie_peg_depth = 7;
bowtie_peg_clearance = 0.05;

// === COLORS ===
top_color = "white";
bottom_color = "white";
ring_color = "black";
front_ring_color = "black";
button_color = "white";
filler_color = "black";
c_black = "black";
c_red = "red";

c_black_dbg = debug_transparent_chips ? [0, 0, 0, 0.5] : "black";
c_red_dbg = debug_transparent_chips ? [1, 0, 0, 0.5] : "red";

// === RENDER LOGIC ===

if (part_to_render == "chips_black") { color(c_black) layout_chips_black(); }
if (part_to_render == "chips_red") { color(c_red) layout_chips_red(); }

if (part_to_render == "all") {
  if (exploded_view) {
    translate([0, 0, 35]) color(top_color) top_mask();
    translate([0, 0, -35]) color(bottom_color) bottom_shell();
    color(ring_color) center_ring();
    translate([0, -20, 0]) color(front_ring_color) front_ring();
    translate([0, -30, 0]) color(button_color) center_button();
    translate([0, 0, 15]) color(filler_color) alignment_filler();

    translate([0, 0, 35]) {
      color(c_black_dbg) draw_eyes_black(hover=15);
      color(c_red_dbg) draw_eyes_red(hover=30);
      color(c_red) draw_cheeks(is_pocket=false, hover=15);
    }
    translate([0, 0, -35]) {
      color(c_red) draw_bowtie(hover=15);
    }
  } else {
    translate([0, 0, eps]) color(top_color) top_mask();
    translate([0, 0, -eps]) color(bottom_color) bottom_shell();
    color(ring_color) center_ring();
    color(front_ring_color) front_ring();
    color(button_color) center_button();
    color(filler_color) alignment_filler();

    translate([0, 0, eps]) {
      color(c_black_dbg) draw_eyes_black(hover=0);
      color(c_red_dbg) draw_eyes_red(hover=0);
      color(c_red) draw_cheeks(is_pocket=false, hover=0);
    }
    translate([0, 0, -eps]) {
      color(c_red) draw_bowtie(hover=0);
    }
  }
} else if (part_to_render != "chips_black" && part_to_render != "chips_red") {
  // Top flipped 180 degrees
  if (part_to_render == "top") {
    translate([0, 0, -(ring_height / 2)])
      color(top_color) top_mask();
  }

  // Bottom flipped 180 degrees (split equator flat down at Z=0)
  if (part_to_render == "bottom") {
    rotate([180, 0, 0])
      translate([0, 0, ring_height / 2])
        color(bottom_color) bottom_shell();
  }

  // Equatorial band flat at Z=0
  if (part_to_render == "ring") {
    translate([0, 0, ring_height / 2])
      color(ring_color) center_ring();
  }

  // Front ring laid flat on its face at Z=0
  if (part_to_render == "front_ring") {
    rotate([90, 0, 0])
      translate([0, (ball_radius - (front_ring_depth / 2)), front_ring_depth / 2])
        color(front_ring_color) front_ring();
  }

  // Button flipped 180 degrees (actuator top facing +Z, base flange at Z=0)
  if (part_to_render == "button") {
    rotate([-90, 0, 0])
      translate([0, -(ball_radius - (front_ring_depth / 2)), front_ring_depth / 2])
        color(button_color) center_button();
  }

  // Rectangular alignment peg rotated 90 degrees onto its side
  if (part_to_render == "filler") {
    rotate([90, 0, 0])
      translate([0, 0, filler_length / 2])
        color(filler_color) alignment_filler();
  }
}

// === MAIN MODULES ===

module top_mask() {
  difference() {
    union() {
      sphere(r=ball_radius);
      draw_eyebrows();
    }

    translate([0, 0, -50 + (ring_height / 2)])
      cube([150, 150, 100], center=true);

    filler_cutout();

    translate([0, -ball_radius + front_pocket_depth, 0])
      rotate([90, 0, 0])
        cylinder(r=front_ring_outer_r + mechanical_clearance, h=front_pocket_depth + eps * 2, center=false);

    draw_eye_pockets();
    draw_cheeks(is_pocket=true);
  }
}

module bottom_shell() {
  difference() {
    sphere(r=ball_radius);

    translate([0, 0, 50 - (ring_height / 2)])
      cube([150, 150, 100], center=true);

    translate([0, 0, -87])
      cube([150, 150, 100], center=true);

    filler_cutout();

    translate([0, -ball_radius + front_pocket_depth, 0])
      rotate([90, 0, 0])
        cylinder(r=front_ring_outer_r + mechanical_clearance, h=front_pocket_depth + eps * 2, center=false);

    draw_bowtie_pocket();
  }
}

module front_ring() {
  translate([0, -(ball_radius - (front_ring_depth / 2)), 0])
    rotate([90, 0, 0])
      difference() {
        cylinder(r=front_ring_outer_r + front_ring_press_fit, h=front_ring_depth, center=true);
        cylinder(r=front_ring_inner_r - button_press_fit, h=front_ring_depth + eps * 2, center=true);
      }
}

module center_button() {
  translate([0, -(ball_radius - (front_ring_depth / 2)), 0])
    rotate([90, 0, 0])
      union() {
        cylinder(r=front_ring_inner_r, h=front_ring_depth, center=true);
        translate([0, 0, front_ring_depth / 2])
          cylinder(r=button_inner_radius, h=2, center=false);
      }
}

module draw_eyebrows() {
  steps = 20;
  for (m = [1, -1]) {
    place_outward(tilt=brow_tilt, pan=m * brow_pan, hover=0)
      rotate([0, 0, m * brow_rotation])
        translate([0, 0, brow_protrusion])
          mirror([m == -1 ? 1 : 0, 0, 0])
            mirror([0, 1, 0])for (i = [0:steps - 1]) {
              let (
                t1 = i / steps,
                t2 = (i + 1) / steps,
                a1 = brow_angle_start + (brow_angle_end - brow_angle_start) * t1,
                a2 = brow_angle_start + (brow_angle_end - brow_angle_start) * t2,
                x1 = brow_radius * cos(a1),
                y1 = brow_radius * sin(a1),
                x2 = brow_radius * cos(a2),
                y2 = brow_radius * sin(a2)
              )
              hull() {
                translate([x1, y1, 0]) sphere(r=brow_thickness / 2, $fn=16);
                translate([x2, y2, 0]) sphere(r=brow_thickness / 2, $fn=16);
              }
            }
  }
}

module draw_eye_pockets() {
  h_val = pocket_depth + accent_pocket_extra_depth + eps;
  for (m = [1, -1]) {
    place_outward(tilt=eye_tilt, pan=m * eye_pan, hover=0)
      rotate([0, 0, m * eye_rotation])
        translate([0, 0, -eps])
          scale([1.5, 1, 1]) cylinder(r=eye_outer_radius, h=h_val);
  }
}

module draw_eyes_black(hover = 0) {
  z_off = -0.05 + accent_pocket_extra_depth;
  for (m = [1, -1]) {
    place_outward(tilt=eye_tilt, pan=m * eye_pan, hover=hover)
      rotate([0, 0, m * eye_rotation])
        translate([0, 0, z_off]) {
          translate([0, 0, red_ring_depth])
            scale([1.5, 1, 1]) cylinder(r=eye_outer_radius - eye_clearance, h=pocket_depth - red_ring_depth);

          
          difference() {
            scale([1.5, 1, 1]) cylinder(r=eye_outer_radius - eye_clearance, h=red_ring_depth + eps);
            translate([0, 0, -eps]) scale([1.5, 1, 1]) cylinder(r=eye_red_outer, h=red_ring_depth + 3 * eps);
          }

          scale([1.5, 1, 1]) cylinder(r=eye_red_inner, h=red_ring_depth + eps);
        }
  }
}

module draw_eyes_red(hover = 0) {
  preview_lift = $preview ? 0.05 : 0;
  z_off = -0.05 + accent_pocket_extra_depth - preview_lift;
  for (m = [1, -1]) {
    place_outward(tilt=eye_tilt, pan=m * eye_pan, hover=hover)
      rotate([0, 0, m * eye_rotation])
        translate([0, 0, z_off]) {
          difference() {
            scale([1.5, 1, 1]) cylinder(r=eye_red_outer - eye_clearance, h=red_ring_depth + preview_lift);
            translate([0, 0, -eps]) scale([1.5, 1, 1]) cylinder(r=eye_red_inner + eye_clearance, h=red_ring_depth + preview_lift + 2 * eps);
          }
        }
  }
}

module draw_cheeks(is_pocket = true, hover = 0) {
  r_base = spiral_max_radius;
  z_off = is_pocket ? -eps : -0.05 + accent_pocket_extra_depth;
  h_val = is_pocket ? pocket_depth + accent_pocket_extra_depth + eps : pocket_depth;

  thickness = is_pocket ? spiral_thickness + (chip_clearance * 2) : spiral_thickness;

  for (m = [1, -1]) {
    place_outward(tilt=cheek_tilt, pan=m * cheek_pan, hover=hover)
      translate([0, 0, z_off])
        linear_extrude(height=h_val)
          mirror([m == -1 ? 1 : 0, 0, 0])for (i = [0:150]) {
            let (
              t1 = i / 150,
              t2 = (i + 1) / 150,
              a1 = t1 * spiral_turns * 360,
              a2 = t2 * spiral_turns * 360,
              r1 = (t1 * r_base) + 0.5,
              r2 = (t2 * r_base) + 0.5
            )
            hull() {
              translate([r1 * cos(a1), r1 * sin(a1)]) circle(r=thickness / 2, $fn=16);
              translate([r2 * cos(a2), r2 * sin(a2)]) circle(r=thickness / 2, $fn=16);
            }
          }
  }
}

module bowtie_base_shape() {
  module wing() {
    hull() {
      sphere(d=bowtie_knot_size);
      translate([bowtie_wing_length, 0, 0])
        scale([1, 2, 1]) sphere(d=bowtie_knot_size);
    }
  }
  wing();
  mirror([1, 0, 0]) wing();
}

module bowtie_body() {
  translate([0, 0, 2])
    intersection() {
      bowtie_base_shape();
      translate([0, 0, 1])
        cube([100, 100, bowtie_thickness], center=true);
    }
}

module draw_bowtie_pocket() {
  place_outward(tilt=bowtie_tilt, pan=0, hover=0)
    translate([0, 0, -eps])
      cylinder(r=bowtie_peg_radius, h=bowtie_peg_depth + 1);
}

module draw_bowtie(hover = 0) {
  place_outward(tilt=bowtie_tilt, pan=0, hover=hover)
    translate([0, 0, -bowtie_thickness]) {
      bowtie_body();
      translate([0, 0, bowtie_thickness - eps])
        cylinder(r=bowtie_peg_radius - bowtie_peg_clearance, h=bowtie_peg_depth + eps);
    }
}

// === PRINTABLE CHIP LAYOUTS ===

module layout_chips_black() {
  for (m = [1, -1]) {
    translate([m * 18, 0, 0]) {
      scale([1.5, 1, 1]) cylinder(r=eye_outer_radius - eye_clearance, h=pocket_depth - red_ring_depth);

      translate([0, 0, pocket_depth - red_ring_depth - eps])
        difference() {
          scale([1.5, 1, 1]) cylinder(r=eye_outer_radius - eye_clearance, h=red_ring_depth + eps);
          translate([0, 0, -eps]) scale([1.5, 1, 1]) cylinder(r=eye_red_outer, h=red_ring_depth + 3 * eps);
        }

      translate([0, 0, pocket_depth - red_ring_depth - eps])
        scale([1.5, 1, 1]) cylinder(r=eye_red_inner, h=red_ring_depth + eps);
    }
  }
}

module layout_chips_red() {
  for (m = [1, -1]) {
    translate([m * 18, 25, 0])
      difference() {
        scale([1.5, 1, 1]) cylinder(r=eye_red_outer - eye_clearance, h=red_ring_depth);
        translate([0, 0, -eps]) scale([1.5, 1, 1]) cylinder(r=eye_red_inner + eye_clearance, h=red_ring_depth + 2 * eps);
      }
  }

  for (m = [1, -1]) {
    translate([m * 18, -10, 0])
      linear_extrude(height=pocket_depth)
        mirror([m == -1 ? 1 : 0, 0, 0])for (i = [0:150]) {
          let (
            t1 = i / 150,
            t2 = (i + 1) / 150,
            a1 = t1 * spiral_turns * 360,
            a2 = t2 * spiral_turns * 360,
            r1 = (t1 * spiral_max_radius) + 0.5,
            r2 = (t2 * spiral_max_radius) + 0.5
          )
          hull() {
            translate([r1 * cos(a1), r1 * sin(a1)]) circle(r=spiral_thickness / 2, $fn=16);
            translate([r2 * cos(a2), r2 * sin(a2)]) circle(r=spiral_thickness / 2, $fn=16);
          }
        }
  }

  translate([0, -45, 0]) {
    bowtie_body();
    translate([0, 0, bowtie_thickness - eps])
      cylinder(r=bowtie_peg_radius - bowtie_peg_clearance, h=bowtie_peg_depth + eps);
  }
}
