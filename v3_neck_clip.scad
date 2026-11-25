// =====================================================================
//  V3 "Sidecar": snap-on holder for the monitor stand's neck
//  A C-clamp snaps around the neck from one side. A slim pocket on the
//  other side holds the remote with its buttons facing outward.
//
//  MEASURE THE NECK: the EX271Q's neck size isn't published either, so
//  neck_w and neck_d are placeholders. Clip it low on the neck so the
//  monitor's height adjustment can't run into it.
//  Print: as exported, standing up, no supports. PETG preferred (the arms
//  flex). 0.2 mm, 4 walls, 20% infill.
// =====================================================================
include <remote_dims.scad>

neck_w     = 60;   // neck width, side to side (the C opens on one side)
neck_d     = 32;   // neck depth, front to back
neck_r     = 3;    // neck corner radius
neck_clear = -0.15; // negative = slight interference so it grips; raise if too tight
arm_t      = 3.2;  // clamp wall thickness
lip        = 3.5;  // how far the lips hook around the far corners
clip_h     = 0.5 * remote_l; // overall height
wall       = 2.8;  // pocket wall
floor_t    = 5;

nw = neck_w + 2 * neck_clear;
nd = neck_d + 2 * neck_clear;
ox = nw / 2 + arm_t;              // clamp outer half-width
oy = nd / 2 + arm_t;

px0 = ox - 0.01;                  // pocket starts at the clamp's outer face
px1 = px0 + wall + pt + wall;     // pocket outer face (remote buttons face +x)
py  = pw / 2 + wall;

module clamp() {
    difference() {
        translate([-ox, -oy, 0]) rbox([2 * ox, 2 * oy, clip_h], 1.2);
        translate([-nw / 2, -nd / 2, -1]) rprism([nw, nd, clip_h + 2], neck_r);
        // snap opening on the -x side, with lead-in chamfers on the lips
        translate([-ox - 1, -(nd / 2 - lip), -1]) cube([arm_t + 2 + neck_r, nd - 2 * lip, clip_h + 2]);
        for (s = [-1, 1])
            translate([-ox, s * (nd / 2 - lip), -1])
                linear_extrude(clip_h + 2) polygon([[-2.5, 0], [0, 2.5], [2.5, 0], [0, -2.5]]);
    }
}

module pocket_body() {
    hull() {
        translate([ox - arm_t, -oy, 0]) rbox([arm_t, 2 * oy, clip_h], 1.2);
        translate([px0, -py, 0]) rbox([px1 - px0, 2 * py, clip_h], 1.2);
    }
}

// Remote frame: buttons toward +x, width along y, port end down.
module pocket_cuts() {
    translate([px0 + wall + pt, 0, floor_t]) rotate([0, 0, 90]) {
        remote_pocket(400);
        translate([0, -wall - 1, 9]) stadium(pw - 18, 400, wall + 2);  // window on the outer face
    }
}

difference() {
    union() { clamp(); pocket_body(); }
    translate([-nw / 2, -nd / 2, -1]) rprism([nw, nd, clip_h + 2], neck_r);
    pocket_cuts();
}
