// =====================================================================
//  BenQ RC-0013 remote (CR2032) — shared dimensions + helpers
//  Same remote on EX271Q, EX271U, EX2710U, EX2710R, EX3210U, EX3210R,
//  EX321UX and EX381U (per BenQ's user manuals)
//  Every stand design includes this file. Before a full print, print
//  fit_test.scad (about 10 min) and slide the remote through it. If it's
//  tight or loose, adjust remote_w / remote_t (or clearance) here and
//  re-export each design.
// =====================================================================

// BenQ RC-0013 (EX271Q manual). BenQ publishes no size. Two independent
// sources agree:
//  - a seller's listing: 3.94 x 1.8 x 0.4 in = 100 x 45.7 x 10.2 mm
//  - the pocket of the MakerWorld "BenQ Remote Holder – Under Desk"
//    (50.2 x 14.74 mm, ~7.7 mm corners), with its even ~2.25 mm/side
//    slack removed: 45.95 x 10.24 mm, ~5.5 mm corners
//  - length: the holder's floor runs 103.1-104.9 mm from its end wall to
//    its retaining hook; minus the same slack at each end = 98.6-100.4 mm
remote_l = 100;    // length, mm (end to end)
remote_w = 45.8;   // width, mm (across the buttons)
remote_t = 10.2;   // thickness, mm
remote_r = 5.5;    // corner radius of the remote's outline, mm

// Bump on the bottom edge. BenQ's quick-start guide shows it's the battery
// insulation pull-tab (CR2032, no charging port). The relief keeps the
// remote seated even if the tab is still in.
port_w = 13;       // relief width
port_d = 3;        // relief depth below the pocket floor

clearance = 1.2;   // gap per side. Calibrated: 0.6 gripped the remote tightly on a real print; 1.2 leaves ~0.6 mm of real play

// --- derived pocket size --------------------------------------------
pw = remote_w + 2 * clearance;   // pocket width
pt = remote_t + 2 * clearance;   // pocket thickness
pr = remote_r + clearance;      // outline corner radius of the pocket

$fn = 48;

// Box with every edge rounded (r). Origin at the min corner.
module rbox(size, r = 2) {
    r = min(r, size.x / 2 - 0.01, size.y / 2 - 0.01, size.z / 2 - 0.01);
    hull() for (x = [r, size.x - r], y = [r, size.y - r], z = [r, size.z - r])
        translate([x, y, z]) sphere(r, $fn = 24);
}

// Prism with rounded vertical edges only. Origin at the min corner.
module rprism(size, r = 2) {
    r = min(r, size.x / 2 - 0.01, size.y / 2 - 0.01);
    hull() for (x = [r, size.x - r], y = [r, size.y - r])
        translate([x, y, 0]) cylinder(r = r, h = size.z);
}

// The remote's envelope standing on end, port end down. Centered in X;
// front (button) face at y = 0, back at y = pt; bottom at z = 0.
// Includes the relief for the port bump below z = 0.
module remote_pocket(len = remote_l) {
    hull() for (x = [-pw / 2 + pr, pw / 2 - pr], z = [pr, len - pr])
        translate([x, 0, z]) rotate([-90, 0, 0]) cylinder(r = pr, h = pt);
    translate([-port_w / 2, pt / 2 - 3.5, -port_d]) rbox([port_w, 7, port_d + 1], 1);
}

// Stadium-shaped slot along Z (for windows). Centered in X at x = 0.
module stadium(w, h, depth) {
    hull() for (z = [w / 2, h - w / 2])
        translate([0, 0, z]) rotate([-90, 0, 0]) cylinder(d = w, h = depth);
}

// Slab with rounded plan corners (cr) and rounded top/bottom edges (er).
// Centered in X/Y, sitting on z = 0.
module rslab(size, cr = 10, er = 3) {
    hull() for (x = [-1, 1], y = [-1, 1], z = [er, size.z - er])
        translate([x * (size.x / 2 - cr), y * (size.y / 2 - cr), z])
            rotate_extrude($fn = 64) translate([cr - er, 0]) circle(er, $fn = 24);
}

// Leaning slot for the "drop it in" stands. The remote leans back by
// `lean` degrees. Its thickness is centered on y = slot_y at the slot
// bottom. The lowest point of the cut (the pocket's back-bottom edge or
// the tilted port relief) sits floor_min above the desk.
// Stand-in remote for previews, in the same frame as remote_pocket().
// Use it with the % modifier: OpenSCAD shows it ghosted and never
// exports it to the STL.
module remote_body()
    translate([0, clearance, 0]) hull()
        for (x = [-remote_w / 2 + remote_r, remote_w / 2 - remote_r], z = [remote_r, remote_l - remote_r])
            translate([x, 0, z]) rotate([-90, 0, 0]) cylinder(r = remote_r, h = remote_t);

module lean_remote(lean, slot_y = 0, floor_min = 1.6)
    translate([0, slot_y - pt / 2, slot_z0(lean, floor_min)]) rotate([-lean, 0, 0]) remote_body();

function slot_z0(lean, floor_min) =
    floor_min + max(pt * sin(lean), (pt / 2 + 3.5) * sin(lean) + port_d * cos(lean));
// Stand height that gives the remote's front face `engage` mm of grip.
function slab_top(lean, engage, floor_min = 1.6) = slot_z0(lean, floor_min) + engage * cos(lean);
// Default grip depth for the slot stands. It grows with longer remotes.
slot_engage = max(12, 0.12 * remote_l);
module lean_slot(lean, slot_y = 0, floor_min = 1.6) {
    translate([0, slot_y - pt / 2, slot_z0(lean, floor_min)]) rotate([-lean, 0, 0]) remote_pocket(400);
}

// Turns any desk-standing body into one that sits on a slightly inset
// plinth. This gives a thin shadow line where it meets the desk, plus
// four recesses for 8 mm stick-on rubber feet.
plinth_h = 1.6;
plinth_inset = 1.0;
foot_d = 8.6;
foot_depth = 1.0;

module floating_plinth(feet = []) {
    difference() {
        union() {
            intersection() {
                children();
                translate([-500, -500, plinth_h]) cube(1000);
            }
            linear_extrude(plinth_h + 0.01)
                offset(r = -plinth_inset)
                    projection(cut = true)
                        translate([0, 0, -plinth_h - 0.05]) children();
        }
        for (p = feet) translate([p.x, p.y, -0.01]) cylinder(d = foot_d, h = foot_depth + 0.01);
    }
}
