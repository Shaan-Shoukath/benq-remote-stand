// =====================================================================
//  V7 "Pebble": sculpted dome stand
//  A smooth river-stone dome. The remote leans out of its crown, and the
//  dome's height grips it deeper than a flat slab can.
//  Print: as exported, no supports. 0.2 mm (0.12 mm for a smoother dome),
//  4 walls, 40-100% infill (weight = stability).
// =====================================================================
include <remote_dims.scad>

peb_w  = pw + 44;   // footprint width
peb_d  = max(78, 0.8 * remote_l);  // footprint depth
lean   = 12;
peb_h  = slab_top(lean, max(18, 0.18 * remote_l));  // crown height: the remote sits ~18 mm deep
slot_y = -4;

module body() {
    // The lower part of a tall ellipsoid gives steep sides near the desk and
    // a soft crown. Clipped to the desk plane.
    intersection() {
        translate([0, 0, peb_h - peb_h * 1.6])
            resize([peb_w, peb_d, peb_h * 3.2]) sphere(1, $fn = 96);
        translate([-500, -500, 0]) cube(1000);
    }
}

// Kept well inside the dome's footprint ellipse.
feet = [for (x = [-1, 1], y = [-1, 1]) [x * 0.5 * peb_w / 2, y * 0.5 * peb_d / 2]];

floating_plinth(feet) difference() { body(); lean_slot(lean, slot_y); }

%lean_remote(lean, slot_y);   // ghost remote: preview only, not exported
