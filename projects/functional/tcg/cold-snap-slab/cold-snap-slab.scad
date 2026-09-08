// =========================================================================
// ColdFrontForge - Cold Snap Slab
// Magnetic Two-Piece Toploader Enclosure with Non-Intersecting Pockets
// =========================================================================

/* [Output Selection] */
part = "print_bed_layout"; // [assembly, back_plate, front_plate, print_bed_layout]

/* [Universal Slab Profile Dimensions (mm)] */
slab_w = 81.5;
slab_h = 136.0;
slab_total_t = 6.5;
corner_radius = 3.5;

/* [Internal Toploader Pocket (35pt)] */
tl_raw_w = 76.0;
tl_raw_h = 101.0;
tl_raw_t = 2.0;
tl_clearance = 1.2;

tl_slot_w = tl_raw_w + tl_clearance; // 77.2 mm
tl_slot_h = tl_raw_h + tl_clearance; // 102.2 mm
tl_slot_t = tl_raw_t + 0.4; // 2.4 mm total clamped depth
tl_offset_bottom = 3.5; // Bottom lip margin

/* [Viewing Window] */
window_w = 64.0;
window_h = 90.0;
window_corner_r = 2.0;

/* [Hardware: Frame & Retention Magnets] */
mag_d = 5.0;
mag_h = 2.0;
mag_fit_tolerance = 0.2; // Radial print slop
mag_hole_d = mag_d + mag_fit_tolerance; // 5.2 mm
mag_hole_depth = 1.9; // Blind pocket depth (leaves solid backing)
mag_margin = 4.5; // Corner inset

/* [Swappable Header Seat] */
tag_w = 62.0; // 62mm width gives >= 4.5mm lateral clearance
tag_h = 22.0; // Proportioned vertical envelope
tag_recess_depth = 1.0; // Sinks 1.0mm into front face
tag_clearance = 0.6; // Total perimeter slip-fit gap
tag_mag_spacing = 36.0; // Pitch between label magnets

/* [Render Precision & Math Constants] */
$fn = 48;
eps = 0.02;

plate_t = slab_total_t / 2; // 3.25 mm symmetric half-shell
pocket_depth_half = tl_slot_t / 2; // 1.20 mm per shell
// Positioned above toploader (Y > 105.7) and below corner magnets (Y < 128.9)
tag_center_y = 117.2;

// =========================================================================
// 2D GEOMETRY HELPERS
// =========================================================================
module rounded_rect_2d(size, r) {
  hull() {
    translate([r, r]) circle(r=r);
    translate([size.x - r, r]) circle(r=r);
    translate([size.x - r, size.y - r]) circle(r=r);
    translate([r, size.y - r]) circle(r=r);
  }
}

// 4-corner blind clamping magnet wells (drilled from mating plane)
module corner_magnet_pockets(depth = mag_hole_depth) {
  translate([mag_margin, mag_margin, -eps])
    cylinder(d=mag_hole_d, h=depth + eps);
  translate([slab_w - mag_margin, mag_margin, -eps])
    cylinder(d=mag_hole_d, h=depth + eps);
  translate([mag_margin, slab_h - mag_margin, -eps])
    cylinder(d=mag_hole_d, h=depth + eps);
  translate([slab_w - mag_margin, slab_h - mag_margin, -eps])
    cylinder(d=mag_hole_d, h=depth + eps);
}

// =========================================================================
// BACK PLATE
// =========================================================================
module back_plate() {
  difference() {
    // Base perimeter solid
    linear_extrude(plate_t)
      rounded_rect_2d([slab_w, slab_h], corner_radius);

    // Lower half of internal toploader cavity (inner face)
    translate([(slab_w - tl_slot_w) / 2, tl_offset_bottom, plate_t - pocket_depth_half])
      cube([tl_slot_w, tl_slot_h, pocket_depth_half + eps]);

    // Dual-sided viewing aperture
    translate([(slab_w - window_w) / 2, tl_offset_bottom + (tl_slot_h - window_h) / 2, -eps])
      linear_extrude(plate_t + 2 * eps)
        rounded_rect_2d([window_w, window_h], window_corner_r);

    // Clamping magnet wells (drilled from inner mating face down; leaves 1.35mm solid floor)
    translate([0, 0, plate_t - mag_hole_depth])
      corner_magnet_pockets(depth=mag_hole_depth);
  }
}

// =========================================================================
// FRONT PLATE
// =========================================================================
module front_plate() {
  difference() {
    // Base perimeter solid
    linear_extrude(plate_t)
      rounded_rect_2d([slab_w, slab_h], corner_radius);

    // Upper half of toploader cavity (inner mating face down)
    translate([(slab_w - tl_slot_w) / 2, tl_offset_bottom, plate_t - pocket_depth_half])
      cube([tl_slot_w, tl_slot_h, pocket_depth_half + eps]);

    // Front viewing aperture
    translate([(slab_w - window_w) / 2, tl_offset_bottom + (tl_slot_h - window_h) / 2, -eps])
      linear_extrude(plate_t + 2 * eps)
        rounded_rect_2d([window_w, window_h], window_corner_r);

    // Clamping magnet wells (drilled from inner mating face down; leaves 1.35mm solid floor)
    translate([0, 0, plate_t - mag_hole_depth])
      corner_magnet_pockets(depth=mag_hole_depth);

    // Swappable label tag recess (drilled into front face Z=0; stops at Z=1.0mm)
    translate(
      [
        (slab_w - (tag_w + tag_clearance)) / 2,
        tag_center_y - (tag_h + tag_clearance) / 2,
        -eps,
      ]
    )
      cube([tag_w + tag_clearance, tag_h + tag_clearance, tag_recess_depth + eps]);

    // Lateral pry notch for label removal
    translate([(slab_w + tag_w + tag_clearance) / 2 - 1.0, tag_center_y - 3.5, -eps])
      cube([3.5, 7.0, tag_recess_depth + eps]);

    // Retention magnet wells (drilled from recess floor; leaves 0.45mm solid backing floor)
    translate([slab_w / 2 - tag_mag_spacing / 2, tag_center_y, tag_recess_depth - eps])
      cylinder(d=mag_hole_d, h=1.8 + eps);
    translate([slab_w / 2 + tag_mag_spacing / 2, tag_center_y, tag_recess_depth - eps])
      cylinder(d=mag_hole_d, h=1.8 + eps);
  }
}

// =========================================================================
// SCENE OUTPUT
// =========================================================================
if (part == "assembly") {
  color("GhostWhite") back_plate();
  color("GhostWhite") translate([0, 0, plate_t + 8.0]) front_plate();
} else if (part == "back_plate") {
  back_plate();
} else if (part == "front_plate") {
  front_plate();
} else if (part == "print_bed_layout") {
  back_plate();
  translate([slab_w + 8, 0, 0])
    front_plate();
}
