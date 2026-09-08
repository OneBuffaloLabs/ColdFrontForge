// =========================================================================
// ColdFrontForge - Cold Snap Slab
// Parametric Swappable Header Tag Engine
// =========================================================================

include <qr-matrices.scad>

/* [Label Configuration] */
preset = "probably_a_10"; // [probably_a_10, near_mint, gem_mint_10, lightly_played, moderately_played, heavily_played, damaged, cooked, custom]

// Custom Overrides (Used if preset == "custom")
custom_title       = "MINT-ISH";
custom_grade       = "9.5";
custom_color       = "Purple";

/* [Color & Hardware Options] */
qr_force_black     = false;

/* [Physical Tag Dimensions (mm)] */
tag_w              = 62.0;      // Matches revised slab pocket width
tag_h              = 22.0;      // Fits comfortably between card cavity and top magnets
tag_t              = 2.2;
border_w           = 0.8;
emboss_h           = 0.6;       // Raised print height for layer swaps

/* [Magnets] */
mag_d              = 5.0;
mag_h              = 2.0;
mag_fit_tolerance  = 0.2;
mag_spacing        = 36.0;      // Matches revised slab retention holes

/* [Layout Geometry] */
qr_enable          = true;
qr_size            = 7.2;       // 25x25 cell array size
heading_font_size  = 2.5;
heading_qr_gap     = 1.6;

/* [Render Precision] */
$fn = 32;
eps = 0.02;

// =========================================================================
// PRESET LOOKUP TABLE
// =========================================================================
function get_preset_data(p) =
  p == "near_mint"          ? ["NEAR MINT",          "NM",  "Green"]
  : p == "lightly_played"   ? ["LIGHTLY PLAYED",     "LP",  "Yellow"]
  : p == "moderately_played"? ["MODERATELY PLAYED",  "MP",  "Orange"]
  : p == "heavily_played"   ? ["HEAVILY PLAYED",     "HP",  "Red"]
  : p == "damaged"          ? ["DAMAGED",            "DMG", "Grey"]
  : p == "gem_mint_10"      ? ["GEM MINT",           "10",  "Gold"]
  : p == "probably_a_10"    ? ["PROBABLY A 10",      "10",  "Blue"]
  : p == "cooked"           ? ["ABSOLUTELY COOKED",  "1",   "FireBrick"]
  : [custom_title, custom_grade, custom_color];

label_data   = get_preset_data(preset);
title_text   = label_data[0];
grade_text   = label_data[1];
accent_color = label_data[2];
active_qr    = get_qr_matrix(preset);

// Dynamic font size: keeps letter shorthands proportional
function get_grade_font_size(str) =
  len(str) >= 3 ? 5.6
  : len(str) == 2 ? 
      (is_num(str) || str == "10" ? 10.5 : 6.8)
  : 10.5;

grade_font_size = get_grade_font_size(grade_text);

// =========================================================================
// SLENDER GEOMETRIC SNOWFLAKE LOGO (Bottom Center)
// =========================================================================
module cold_snap_snowflake(r = 1.30, stroke = 0.22) {
  for (a = [0 : 60 : 300]) {
    rotate([0, 0, a]) {
      translate([-stroke / 2, 0])
        square([stroke, r]);
      translate([0, r * 0.60]) {
        rotate([0, 0, 45])  translate([-stroke / 2, 0]) square([stroke, r * 0.35]);
        rotate([0, 0, -45]) translate([-stroke / 2, 0]) square([stroke, r * 0.35]);
      }
    }
  }
  circle(r = stroke * 0.95, $fn = 6);
}

// =========================================================================
// QR CODE MATRIX RENDERER
// =========================================================================
module render_qr(size = 7.2, matrix) {
  modules = len(matrix);
  cell = size / modules;
  for (r = [0 : modules - 1]) {
    for (c = [0 : modules - 1]) {
      if (matrix[r][c] == 1) {
        translate([c * cell, (modules - 1 - r) * cell])
          square([cell + 0.01, cell + 0.01]);
      }
    }
  }
}

// =========================================================================
// EMBOSSED ACCENT ELEMENTS
// =========================================================================
module label_accents() {
  // 1. Perimeter Border Line
  difference() {
    offset(r = 1.5) square([tag_w - 3.0, tag_h - 3.0], center = true);
    offset(r = 1.5 - border_w) square([tag_w - 3.0 - (2 * border_w), tag_h - 3.0 - (2 * border_w)], center = true);
  }

  // 2. Left Section: Heading + QR Block (Vertically Centered)
  heading_cap_h = 1.8;
  left_block_h  = heading_cap_h + heading_qr_gap + qr_size;
  left_x        = -tag_w / 2 + 4.2;
  left_start_y  = -left_block_h / 2;

  translate([left_x, left_start_y]) {
    if (qr_enable && !qr_force_black) {
      render_qr(size = qr_size, matrix = active_qr);
    }
    translate([0, qr_size + heading_qr_gap])
      text(title_text, size = heading_font_size, font = "Liberation Sans:style=Bold", halign = "left", valign = "baseline");
  }

  // 3. Right Section: Grade (Vertically Centered)
  translate([tag_w / 2 - 4.5, 0])
    text(grade_text, size = grade_font_size, font = "Liberation Sans:style=Bold", halign = "right", valign = "center");

  // 4. Logo: Snowflake with margin off the bottom border
  translate([0, -tag_h / 2 + 3.6])
    cold_snap_snowflake(r = 1.30, stroke = 0.22);
}

// =========================================================================
// MASTER TAG MODULE
// =========================================================================
module cold_snap_label() {
  mag_hole_d = mag_d + mag_fit_tolerance;
  mag_hole_h = 1.8; // Blind depth from bottom plane; leaves 0.40mm front floor

  // Base wafer
  color("White") {
    difference() {
      linear_extrude(tag_t)
        offset(r = 1.5) square([tag_w - 3.0, tag_h - 3.0], center = true);

      // Underside blind retention wells
      translate([-mag_spacing / 2, 0, -eps])
        cylinder(d = mag_hole_d, h = mag_hole_h + eps);
      translate([mag_spacing / 2, 0, -eps])
        cylinder(d = mag_hole_d, h = mag_hole_h + eps);
    }
  }

  // Accent Layer
  color(accent_color) {
    translate([0, 0, tag_t])
      linear_extrude(emboss_h)
        label_accents();
  }

  // Optional: Isolated black QR cutout for multi-material setups
  if (qr_enable && qr_force_black) {
    heading_cap_h = 1.8;
    left_block_h  = heading_cap_h + heading_qr_gap + qr_size;
    left_x        = -tag_w / 2 + 4.2;
    left_start_y  = -left_block_h / 2;

    color("Black") {
      translate([left_x, left_start_y, tag_t])
        linear_extrude(emboss_h)
          render_qr(size = qr_size, matrix = active_qr);
    }
  }
}

cold_snap_label();