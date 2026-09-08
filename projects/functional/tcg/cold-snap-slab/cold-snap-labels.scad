// =========================================================================
// ColdFrontForge - Cold Snap Slab
// Parametric Swappable Header Tag Engine with Batch Render Showcase
// =========================================================================

include <qr-matrices.scad>

/* [Render Mode] */
render_mode = "single"; // [single, showcase_all]

/* [Single Label Configuration] */
preset = "probably_a_10"; // [probably_a_10, near_mint, gem_mint_10, lightly_played, moderately_played, heavily_played, damaged, cooked, custom]

// Custom Overrides (Used if preset == "custom")
custom_title = "MINT-ISH";
custom_grade = "9.5";
custom_color = "Purple";

/* [Color & Hardware Options] */
qr_force_black = false;

/* [Physical Tag Dimensions (mm)] */
tag_w = 62.0;
tag_h = 22.0;
tag_t = 2.2;
border_w = 0.8;
emboss_h = 0.6; // Raised print height for layer swaps

/* [Magnets] */
mag_d = 5.0;
mag_h = 2.0;
mag_fit_tolerance = 0.2;
mag_spacing = 36.0;

/* [Layout Geometry] */
qr_enable = true;
qr_size = 8.5; // 8.5mm allows >= 0.34mm modules for 0.4mm nozzles
heading_font_size = 2.3;
heading_qr_gap = 1.4;

/* [Render Precision] */
$fn = 32;
eps = 0.02;

// =========================================================================
// PRESET LOOKUP TABLE
// =========================================================================
function get_preset_data(p) =
  p == "near_mint" ? ["NEAR MINT", "NM", "Green"]
  : p == "lightly_played" ? ["LIGHTLY PLAYED", "LP", "Yellow"]
  : p == "moderately_played" ? ["MODERATELY PLAYED", "MP", "Orange"]
  : p == "heavily_played" ? ["HEAVILY PLAYED", "HP", "Red"]
  : p == "damaged" ? ["DAMAGED", "DMG", "Grey"]
  : p == "gem_mint_10" ? ["GEM MINT", "10", "Gold"]
  : p == "probably_a_10" ? ["PROBABLY A 10", "10", "Blue"]
  : p == "cooked" ? ["ABSOLUTELY COOKED", "1", "FireBrick"]
  : [custom_title, custom_grade, custom_color];

function get_grade_font_size(str) =
  len(str) >= 3 ? 5.6
  : len(str) == 2 ?
    (is_num(str) || str == "10" ? 10.5 : 6.8)
  : 10.5;

// =========================================================================
// SLENDER GEOMETRIC SNOWFLAKE LOGO
// =========================================================================
module cold_snap_snowflake(r = 1.30, stroke = 0.22) {
  for (a = [0:60:300]) {
    rotate([0, 0, a]) {
      translate([-stroke / 2, 0])
        square([stroke, r]);
      translate([0, r * 0.60]) {
        rotate([0, 0, 45]) translate([-stroke / 2, 0]) square([stroke, r * 0.35]);
        rotate([0, 0, -45]) translate([-stroke / 2, 0]) square([stroke, r * 0.35]);
      }
    }
  }
  circle(r=stroke * 0.95, $fn=6);
}

// =========================================================================
// QR CODE MATRIX RENDERER
// =========================================================================
module render_qr(size = 8.5, matrix) {
  modules = len(matrix);
  cell = size / modules;
  for (r = [0:modules - 1]) {
    for (c = [0:modules - 1]) {
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
module label_accents(title, grade, qr_matrix) {
  difference() {
    offset(r=1.5) square([tag_w - 3.0, tag_h - 3.0], center=true);
    offset(r=1.5 - border_w) square([tag_w - 3.0 - (2 * border_w), tag_h - 3.0 - (2 * border_w)], center=true);
  }

  // Left column: Vertically centered heading + QR block
  heading_cap_h = 1.8;
  left_block_h = heading_cap_h + heading_qr_gap + qr_size;
  left_x = -tag_w / 2 + 4.0;
  left_start_y = -left_block_h / 2;

  translate([left_x, left_start_y]) {
    if (qr_enable && !qr_force_black) {
      render_qr(size=qr_size, matrix=qr_matrix);
    }
    translate([0, qr_size + heading_qr_gap])
      text(title, size=heading_font_size, font="Liberation Sans:style=Bold", halign="left", valign="baseline");
  }

  // Right column: Centered grade numeral/code
  grade_size = get_grade_font_size(grade);
  translate([tag_w / 2 - 4.5, 0])
    text(grade, size=grade_size, font="Liberation Sans:style=Bold", halign="right", valign="center");

  // Snowflake with clearance above bottom border
  translate([0, -tag_h / 2 + 3.6])
    cold_snap_snowflake(r=1.30, stroke=0.22);
}

// =========================================================================
// MASTER TAG GENERATOR
// =========================================================================
module render_single_tag(preset_name) {
  data = get_preset_data(preset_name);
  title = data[0];
  grade = data[1];
  accent_col = data[2];
  qr_mat = get_qr_matrix(preset_name);
  mag_hole_d = mag_d + mag_fit_tolerance;
  mag_hole_h = 1.8;

  // Base wafer
  color("White") {
    difference() {
      linear_extrude(tag_t)
        offset(r=1.5) square([tag_w - 3.0, tag_h - 3.0], center=true);

      
      translate([-mag_spacing / 2, 0, -eps])
        cylinder(d=mag_hole_d, h=mag_hole_h + eps);
      translate([mag_spacing / 2, 0, -eps])
        cylinder(d=mag_hole_d, h=mag_hole_h + eps);
    }
  }

  // Accent Layer
  color(accent_col) {
    translate([0, 0, tag_t])
      linear_extrude(emboss_h)
        label_accents(title, grade, qr_mat);
  }

  // Optional isolated black QR output
  if (qr_enable && qr_force_black) {
    heading_cap_h = 1.8;
    left_block_h = heading_cap_h + heading_qr_gap + qr_size;
    left_x = -tag_w / 2 + 4.0;
    left_start_y = -left_block_h / 2;

    color("Black") {
      translate([left_x, left_start_y, tag_t])
        linear_extrude(emboss_h)
          render_qr(size=qr_size, matrix=qr_mat);
    }
  }
}

// =========================================================================
// OUTPUT ROUTER
// =========================================================================
if (render_mode == "single") {
  render_single_tag(preset);
} else if (render_mode == "showcase_all") {
  // 4x2 catalog showcase grid
  showcase_presets = [
    ["gem_mint_10", "probably_a_10"],
    ["near_mint", "lightly_played"],
    ["moderately_played", "heavily_played"],
    ["damaged", "cooked"],
  ];

  grid_spacing_x = tag_w + 6.0;
  grid_spacing_y = tag_h + 6.0;

  for (col = [0:3]) {
    for (row = [0:1]) {
      translate([col * grid_spacing_x, -row * grid_spacing_y, 0])
        render_single_tag(showcase_presets[col][row]);
    }
  }
}
