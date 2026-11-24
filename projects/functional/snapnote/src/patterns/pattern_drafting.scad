// =============================================================================
// SnapNote 3x3 Grid & Wireframing Drafting Stencil Patterns
// =============================================================================
// Generates three technical drafting 3x3 sticky note stencil patterns on the
// SnapNote parametric base:
//   - DOTS   : 5.0 mm spaced circular dot-grid matrix over 70 mm x 70 mm
//   - PANELS : 2x2 storyboard comic panels with 2.0 mm dividers & >=1.0 mm fillets
//   - ISO    : Isometric 30/90-degree wireframe guideline grid (non-intersecting)
// =============================================================================

include <../../../../../lib/BOSL2/std.scad>
use <../snapnote_stencil_base.scad>

/* [Pattern Selection] */
// Select which drafting stencil pattern to render
pattern = "dots"; // [dots: 5mm Dot Grid (DOTS), panels: 2x2 Storyboard Panels (PANELS), iso: Isometric Wireframe (ISO)]
// Print orientation flips the stencil onto Z=0 for support-free printing
render_mode = "print"; // [print: Print Bed (Flipped), design: Design Space (On Pad)]
$fn = $preview ? 24 : 48;

/* [Pad Reference] */
// Nominal 3" x 3" sticky note size (mm)
pad_size = 76.2;

/* [Shared Slot Parameters] */
// Default 45-degree top-edge chamfer depth for smooth pen-tip guidance (mm)
slot_chamfer = 0.35;

/* [5mm Dot-Grid Matrix] */
// Uniform dot spacing (mm)
dot_pitch = 5.0;
// Inner canvas span (70 mm x 70 mm -> 15 x 15 dots at 5.0 mm pitch)
dot_canvas_size = 70.0;
// Dot aperture diameter (1.2-1.5 mm for fine pen points)
dot_diameter = 1.4;

/* [2x2 Storyboard Panels] */
// Outer margin around the 2x2 panel frame (mm)
panel_outer_margin = 5.1;
// Structural divider width between adjacent panels (mm)
panel_divider_width = 2.0;
// Corner fillet radius (>= 1.0 mm to prevent cracking)
panel_corner_radius = 1.5;

/* [Isometric Wireframe Guide] */
// Isometric lattice edge length between vertices (mm)
iso_pitch = 12.0;
// Length of each non-intersecting wireframe guide dash (mm)
iso_dash_len = 6.2;
// Width of wireframe guide slots (mm)
iso_slot_width = 0.95;
// Outer margin keeping isometric slots inside the pad perimeter (mm)
iso_margin = 6.5;

// -----------------------------------------------------------------------------
// Pattern Cutter Modules (Design Space)
// -----------------------------------------------------------------------------

module dots_cutters() {
    count = floor(dot_canvas_size / dot_pitch) + 1; // 15 dots across 70 mm
    span = (count - 1) * dot_pitch;
    origin = (pad_size - span) / 2;

    for (ix = [0 : count - 1], iy = [0 : count - 1]) {
        translate([origin + ix * dot_pitch, origin + iy * dot_pitch, 0])
            chamfered_hole(
                d = dot_diameter,
                chamfer = 0.3,
                $fn = $preview ? 12 : 20
            );
    }
}

module panels_cutters() {
    inner_span = pad_size - 2 * panel_outer_margin;
    panel_size = (inner_span - panel_divider_width) / 2;
    offset_c = (panel_divider_width + panel_size) / 2;
    cx = pad_size / 2;
    cy = pad_size / 2;

    for (sx = [-1, 1], sy = [-1, 1]) {
        translate([cx + sx * offset_c, cy + sy * offset_c, 0])
            chamfered_rect_slot(
                size = [panel_size, panel_size],
                chamfer = slot_chamfer,
                rounding = panel_corner_radius,
                center = true
            );
    }
}

// Helper: places a single non-intersecting isometric guide slot if its midpoint
// and endpoints fall safely inside the writable margin.
module _iso_segment(p1, p2) {
    mid = (p1 + p2) / 2;
    vec = p2 - p1;
    ang = atan2(vec[1], vec[0]);
    half_len = iso_dash_len / 2;
    dir = vec / norm(vec);
    e1 = mid - dir * half_len;
    e2 = mid + dir * half_len;
    lo = iso_margin;
    hi = pad_size - iso_margin;

    if (e1[0] >= lo && e1[0] <= hi && e1[1] >= lo && e1[1] <= hi &&
        e2[0] >= lo && e2[0] <= hi && e2[1] >= lo && e2[1] <= hi) {
        translate([mid[0], mid[1], 0])
            rotate([0, 0, ang])
                chamfered_rect_slot(
                    size = [iso_dash_len, iso_slot_width],
                    chamfer = slot_chamfer,
                    rounding = iso_slot_width * 0.45,
                    center = true
                );
    }
}

module iso_cutters() {
    dx = iso_pitch * cos(30);
    dy = iso_pitch;
    half_dy = iso_pitch * sin(30); // 0.5 * iso_pitch

    cx = pad_size / 2;
    cy = pad_size / 2;

    cols = ceil((pad_size / 2) / dx) + 1;
    rows = ceil((pad_size / 2) / dy) + 1;

    for (c = [-cols : cols], r = [-rows : rows]) {
        // Staggered isometric vertex coordinates centered on pad
        vx = cx + c * dx;
        vy = cy + r * dy + ((abs(c) % 2 == 1) ? half_dy : 0);
        v = [vx, vy];

        // Three canonical isometric directions (30 deg, -30 deg, 90 deg)
        _iso_segment(v, [vx + dx, vy + half_dy]);
        _iso_segment(v, [vx + dx, vy - half_dy]);
        _iso_segment(v, [vx, vy + dy]);
    }
}

// -----------------------------------------------------------------------------
// Top-Level Pattern Assembly
// -----------------------------------------------------------------------------
if (pattern == "dots") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "DOTS")
        dots_cutters();
} else if (pattern == "panels") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "PANELS")
        panels_cutters();
} else if (pattern == "iso") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "ISO")
        iso_cutters();
} else {
    assert(false, str("Unknown pattern '", pattern, "'. Expected 'dots', 'panels', or 'iso'."));
}
