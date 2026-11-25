// =====================================================================
//  V6 "Puck": round disc stand
//  A thick coaster-like disc with a soft top edge and one fine inlaid
//  ring. The remote leans back in a slot across the middle.
//  Print: as exported, no supports. 0.2 mm, 4 walls, 60-100% infill (weight = stability).
//  Tip: pause at the ring's layer height and swap filament for a
//  two-tone ring.
// =====================================================================
include <remote_dims.scad>

disc_d   = max(0.9 * remote_l, pw + 34);  // diameter (grows with the remote)
lean     = 15;
disc_h   = slab_top(lean, slot_engage);
edge_r   = 4;
slot_y   = -0.07 * disc_d;
ring_r   = disc_d / 2 - 7;   // decorative groove radius
ring_w   = 1.2;
ring_dep = 0.8;

module body() {
    hull() for (z = [edge_r, disc_h - edge_r])
        translate([0, 0, z]) rotate_extrude($fn = 128) translate([disc_d / 2 - edge_r, 0]) circle(edge_r, $fn = 24);
}

module ring_groove()
    translate([0, 0, disc_h - ring_dep]) difference() {
        cylinder(r = ring_r + ring_w / 2, h = 10, $fn = 128);
        translate([0, 0, -1]) cylinder(r = ring_r - ring_w / 2, h = 12, $fn = 128);
    }

feet = [for (a = [45, 135, 225, 315]) [cos(a) * (disc_d / 2 - 11), sin(a) * (disc_d / 2 - 11)]];

floating_plinth(feet) difference() { body(); lean_slot(lean, slot_y); ring_groove(); }

%lean_remote(lean, slot_y);   // ghost remote: preview only, not exported
