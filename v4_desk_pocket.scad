// =====================================================================
//  V4 "Holster": screw-on pocket for the side or underside of the desk
//  A slim sleeve on a mounting plate. On the side of the desk, mount it
//  with the open end up. Under the desk, point the open end toward you.
//  Two countersunk screws (M4 / #8 wood screws) or strong double-sided tape.
//
//  Print: export as-is. It is laid on its side (print_flat = true) so every
//  wall prints without supports. 0.2 mm, 3 walls, 20% infill.
// =====================================================================
include <remote_dims.scad>

wall      = 2.6;
end_t     = 5;      // closed end (port relief comes out of this)
plate_t   = 4;      // mounting plate under the remote
top_t     = 2.4;    // face panel over the buttons
sleeve_len = 0.62 * remote_l; // how much of the remote it covers
tab_len   = 14;     // screw tab beyond each end
screw_d   = 4.5;
head_d    = 9;
window_w  = pw - 16;
print_flat = true;  // false = show it the way it mounts

sx = pw / 2 + wall;
sz = plate_t + pt + top_t;

module holster() {
    difference() {
        union() {
            // sleeve
            translate([-sx, -end_t, 0]) rbox([2 * sx, sleeve_len + end_t, sz], 1.2);
            // mounting plate with a tab at each end
            translate([-sx, -end_t - tab_len, 0]) rbox([2 * sx, sleeve_len + end_t + 2 * tab_len, plate_t], 2);
        }
        // remote cavity: lying flat, buttons up (+z), port end at y = 0
        translate([0, 0, plate_t + pt]) rotate([-90, 0, 0]) remote_pocket(400);
        // window in the face panel. It stays closed 8 mm short of the mouth,
        // so when printed on its side the rail above it is a short bridge,
        // not a free cantilever.
        translate([0, 10, sz + 1]) rotate([-90, 0, 0]) stadium(window_w, sleeve_len - 18, top_t + 2);
        // countersunk screw holes in the tabs
        for (y = [-end_t - tab_len / 2, sleeve_len + tab_len / 2])
            translate([0, y, -1]) {
                cylinder(d = screw_d, h = 20);
                translate([0, 0, plate_t + 1 - (head_d - screw_d) / 2]) cylinder(d1 = screw_d, d2 = head_d, h = (head_d - screw_d) / 2 + 0.01);
                translate([0, 0, plate_t + 1]) cylinder(d = head_d, h = 20);
            }
    }
}

if (print_flat) translate([0, 0, sx]) rotate([0, -90, 0]) holster();
else holster();
