// =====================================================================
//  V5 "Pedestal": minimal slab stand
//  A low square slab with soft corners. The remote drops into a slot and
//  leans back slightly, like a phone on a dock.
//  Print: as exported, no supports. 0.2 mm, 4 walls, 60-100% infill. The
//  slab's weight is what stops it tipping when you press a top button.
// =====================================================================
include <remote_dims.scad>

base_w  = pw + 26;   // slab width (scales with the remote)
base_d  = max(72, 0.8 * remote_l);  // slab depth (scales with the remote)
lean    = 15;        // degrees back from vertical
base_h  = slab_top(lean, slot_engage);  // ~18 mm: gives the remote a 12 mm grip
corner_r = 12;       // plan corner radius
edge_r  = 3;         // top edge roundover
slot_y  = -0.1 * base_d;        // slot sits a little forward so the leaning remote balances over the middle

module body() rslab([base_w, base_d, base_h], corner_r, edge_r);

feet = [for (x = [-1, 1], y = [-1, 1]) [x * (base_w / 2 - 9), y * (base_d / 2 - 9)]];

floating_plinth(feet) difference() { body(); lean_slot(lean, slot_y); }

%lean_remote(lean, slot_y);   // ghost remote: preview only, not exported
