// =====================================================================
//  V1 "Lectern": angled desk cradle
//  The remote leans back so its buttons face you. A low scalloped lip
//  holds the bottom end, and side cheeks hug its edges.
//  Print: as exported, flat side down, no supports. 0.2 mm, 3 walls, 15% infill.
// =====================================================================
include <remote_dims.scad>

lean       = 22;  // tilt back from vertical, degrees
wall       = 3.2; // side cheek thickness
back       = 4.5; // back plate thickness
floor_t    = 5;   // material under the remote (port relief comes out of this)
lip_h      = 14;  // front lip height, measured along the remote
support_h  = 0.58 * remote_l; // how far up the remote the back plate reaches
notch_d    = 24;  // finger scallop in the front lip
base_h     = 7;   // base slab height
base_extra = 5;   // how far the base flares out beyond the cradle

bw = pw + 2 * wall;               // cradle width
z0 = pt * sin(lean) + floor_t;    // lift so the pocket clears the desk

// Parts are drawn in the "remote frame" (front face y = 0, bottom z = 0)
// and this places them on the desk.
module in_remote_frame() translate([0, 0, z0]) rotate([-lean, 0, 0]) children();

y_front = -wall * cos(lean) - base_extra;
y_back  = (pt + back) / cos(lean) + 0.5 * support_h * sin(lean) + 6;

module body() {
    intersection() {
        hull() {
            translate([-bw / 2 - base_extra, y_front, 0])
                rbox([bw + 2 * base_extra, y_back - y_front, base_h], 3);
            in_remote_frame()
                translate([-bw / 2, -wall, -floor_t])
                    rbox([bw, pt + wall + back, support_h + floor_t], 1.2);
        }
        translate([-500, -500, 0]) cube(1000);
    }
}

module cuts() {
    in_remote_frame() {
        remote_pocket(400);                                       // the remote, open at the top
        translate([-250, -100, lip_h]) cube([500, 100.01, 400]);  // open face above the lip
        translate([0, -50, lip_h]) rotate([-90, 0, 0])            // finger scallop (front only)
            cylinder(d = notch_d, h = 50);
        // Curved sweep on the cheeks: a circle through the lip's front-top
        // edge that meets the back plate's face tangentially at sweep_z.
        translate([-250, sweep_yc, sweep_z]) rotate([0, 90, 0]) cylinder(r = sweep_r, h = 500, $fn = 160);
        translate([-250, -100, sweep_z]) cube([500, 100 + pt, 400]);
    }
}

sweep_z  = support_h - 6;
sweep_k  = pt + wall + 1;
sweep_dz = sweep_z - lip_h;
sweep_r  = (sweep_k * sweep_k + sweep_dz * sweep_dz) / (2 * sweep_k);
sweep_yc = pt - sweep_r;

fx = bw / 2 + base_extra - 7;
feet = [[-fx, y_front + 7], [fx, y_front + 7], [-fx, y_back - 7], [fx, y_back - 7]];

floating_plinth(feet) difference() { body(); cuts(); }

%in_remote_frame() remote_body();   // ghost remote: preview only, not exported
