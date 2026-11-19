// =============================================================================
// SnapNote — 3x3 Sticky Note Stencil System & Desk Caddy
// =============================================================================
// Unified entry point for the SnapNote parametric suite:
//   - caddy  : All-in-one 3x3 desk caddy with 5-slot stencil rack & dual pen wells
//   - base   : Blank 3x3 parametric stencil with 2-sided lip & pull tab
//   - check  : Checklist stencil (6 ruled lines + 4.0 mm filleted checkboxes)
//   - bullet : Bullet list stencil (6 ruled lines + 3.6 mm circular bullets)
//   - lines  : Ruled lines stencil (7 evenly spaced writing channels)
// =============================================================================

include <../../../lib/BOSL2/std.scad>

use <src/snapnote_stencil_base.scad>
use <src/snapnote_caddy.scad>
use <src/patterns/pattern_checklists.scad>

/* [Part Selection] */
// Select which SnapNote component to render
part_to_render = "caddy"; // [caddy: Desk Caddy, base: Stencil Base Blank, check: Checklist Stencil, bullet: Bullet List Stencil, lines: Ruled Lines Stencil]
// Stencil print orientation ("print" flips onto Z=0; "design" shows pad fitment)
render_mode = "print"; // [print: Print Bed (Flipped), design: Design Space (On Pad)]
$fn = $preview ? 32 : 64;

if (part_to_render == "caddy") {
    snapnote_caddy();
} else if (part_to_render == "base") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "BASE");
} else if (part_to_render == "check") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "CHECK")
        checklist_cutters();
} else if (part_to_render == "bullet") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "BULLET")
        bullet_cutters();
} else if (part_to_render == "lines") {
    snapnote_stencil_assembly(mode = render_mode, t_label = "LINES")
        lines_cutters();
} else {
    assert(false, str("Unknown part_to_render: ", part_to_render));
}
