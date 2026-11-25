// =====================================================================
//  Fit test: a 10-minute print to check the pocket size before a full stand.
//  Slide the remote through the ring. It should pass with a little play
//  and the corners shouldn't catch.
//   - Too tight: raise `clearance` (or remote_w / remote_t) in remote_dims.scad.
//   - Rattles a lot: lower `clearance`.
//  The thin tab on one side is printed with the pocket's numbers so you can
//  tell test prints apart.
//  Print: flat, no supports, 0.2 mm.
// =====================================================================
include <remote_dims.scad>

ring_h = 6;
wall   = 2.4;

// The opening is the exact pocket cross-section the stands use (pw x pt,
// square corners). Only the outside of the ring is rounded.
linear_extrude(ring_h) difference() {
    offset(r = wall) square([pw, pt], center = true);
    square([pw, pt], center = true);
}
translate([pw / 2 + wall - 0.5, -6, 0]) cube([24, 12, 1.2]);   // long enough for labels like "47.4x11.8"
translate([pw / 2 + wall + 1, -3.5, 1.2]) linear_extrude(0.6)
    text(str(pw, "x", pt), size = 3, font = "Liberation Sans:style=Bold");
