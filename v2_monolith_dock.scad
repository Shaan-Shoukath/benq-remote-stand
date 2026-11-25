// =====================================================================
//  V2 "Monolith": upright desk dock
//  A tapered block the remote drops into nearly upright, with a slight
//  backward lean. A front window shows the bottom buttons, and side
//  scallops let you pinch it out.
//  Print: as exported, no supports. 0.2 mm, 3 walls, 20% infill (weight helps).
// =====================================================================
include <remote_dims.scad>

lean      = 8;    // backward lean, degrees
wall      = 3;    // collar wall
floor_t   = 5;    // under the remote (port relief comes out of this)
slot_h    = 0.4 * remote_l;  // how deep the remote sits
base_h    = 8;
base_flare_x = 8; // base wider than collar, each side
base_flare_y = 14;// base deeper than collar, each side
window_w  = pw - 18;
scallop_d = 28;
lead_in   = 1.2;  // 45° chamfer round the pocket mouth so the remote never catches a sharp edge

cw = pw + 2 * wall;
cd = pt + 2 * wall;
z0 = pt * sin(lean) + floor_t;

module in_remote_frame() translate([0, -pt / 2, z0]) rotate([-lean, 0, 0]) children();

bx = cw / 2 + base_flare_x;
by = cd / 2 + base_flare_y;
by_off = 3;   // shift the base back a little under the lean

module body() {
    intersection() {
        hull() {
            translate([-bx, -by + by_off, 0]) rbox([2 * bx, 2 * by, base_h], 4);
            in_remote_frame()
                translate([-cw / 2, -wall, -floor_t]) rbox([cw, cd, slot_h + floor_t], 1.2);
        }
        translate([-500, -500, 0]) cube(1000);
    }
}

module cuts() {
    in_remote_frame() {
        remote_pocket(400);
        hull() {                                                        // lead-in chamfer at the mouth
            translate([-pw / 2, 0, slot_h - lead_in]) cube([pw, pt, 0.01]);
            translate([-pw / 2 - 2 * lead_in, -2 * lead_in, slot_h + lead_in])
                cube([pw + 4 * lead_in, pt + 4 * lead_in, 0.01]);
        }
        translate([0, -60, 9]) stadium(window_w, 400, 61);               // front window, through the tapered front
        for (s = [-1, 1])                                               // pinch scallops
            translate([s * cw / 2, -50, slot_h]) rotate([-90, 0, 0]) cylinder(d = scallop_d, h = 100);
    }
}

fx = bx - 7; fy = by - 7;
feet = [[-fx, -fy + by_off], [fx, -fy + by_off], [-fx, fy + by_off], [fx, fy + by_off]];

floating_plinth(feet) difference() { body(); cuts(); }

%in_remote_frame() remote_body();   // ghost remote: preview only, not exported
