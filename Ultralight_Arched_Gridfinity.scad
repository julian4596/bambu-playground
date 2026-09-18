// ============================================================================
// Ultralight Arched Doorway Gridfinity Baseplate
// ============================================================================
// A parametric, MakerWorld-compatible OpenSCAD script that generates
// ultra-lightweight Gridfinity baseplates featuring an arched doorway profile,
// strictly adhering to the official Gridfinity specification (https://gridfinity.xyz/specification/)
// and inspired by Paul Bone's gfthings (https://github.com/PaulBone/gfthings).
//
// Features:
//   - Strictly compliant with Gridfinity v5 standards
//   - Official 3-tier pocket profile on corner pillars (42.0mm top lead-in,
//     37.7mm waist, 0.7mm chamfered bottom ledge)
//   - Arched doorway cutouts through divider walls extending to table (Z = 0)
//   - Sturdy corner pillars with central diamond voids at cell intersections
//   - Solid outer drawer frame perimeter to prevent dust/debris ingress
//   - Spacerless auto-fit to drawer dimensions with zero wasted space
//   - Built-in bed tiling and exploded scene preview with tile labels
//   - MakerWorld Customizer compatible
//
// Author: Julian (generated with AI assistance)
// License: CC BY-SA 4.0
// ============================================================================


// ============================================================================
// MakerWorld Customizer Parameters
// ============================================================================

/* [01 — Drawer Dimensions] */
// Inner width of your drawer in mm
drawer_width_mm    = 400;   // [50:1:1000]
// Inner depth of your drawer in mm
drawer_depth_mm    = 500;   // [50:1:1000]
// Clearance per side in mm (0.5 recommended)
clearance_per_side = 0.5;   // [0:0.1:2]

/* [02 — Grid Override (Optional)] */
// Use auto-fit from drawer dimensions?
use_auto_fit  = true;
// Manual grid units in X (only used if auto-fit is OFF)
manual_grid_x = 4;          // [1:1:20]
// Manual grid units in Y (only used if auto-fit is OFF)
manual_grid_y = 4;          // [1:1:20]

/* [03 — Arch Geometry] */
// Width of the arched doorway cutout in mm
doorway_width  = 24.0;      // [16:1:32]
// Height of the arch from table level in mm
doorway_height = 3.5;       // [2.0:0.1:4.0]

/* [04 — Extension Distribution] */
// How to distribute leftover space on each axis
// 0=Split evenly both sides, 1=Right/Back only, 2=Left/Front only
extension_mode = 0;         // [0:Even Split, 1:Right-Back Only, 2:Left-Front Only]

/* [05 — Print Bed Tiling] */
// Split the plate into bed-sized tiles
tiling_mode        = true;
// Bed width in mm (tiling only)
bed_x_mm           = 256.0; // [100:0.1:500]
// Bed depth in mm (tiling only)
bed_y_mm           = 256.0; // [100:0.1:500]
// Reserved margin per bed edge in mm (tiling only)
bed_safe_margin_mm = 2.0;   // [0:0.1:20]
// Gap between tiles in mm (scene preview only)
tile_gap_mm        = 10.0;  // [0:0.1:50]
// Add tile coordinate labels
enable_labels      = true;
// Which part to render? 0=All (Exploded View), 1=Tile 1/1, etc.
part_to_render     = 0;     // [0:All (Exploded), 1:Tile 1/1, 2:Tile 2/1, 3:Tile 1/2, 4:Tile 2/2, 5:Tile 3/1, 6:Tile 3/2, 7:Tile 3/3, 8:Tile 4/1, 9:Tile 4/2, 10:Tile 4/3]

/* [Hidden] */
$fn = 32;

// ---- Official Gridfinity v5 Constants (gridfinity.xyz) ----
GF_PITCH            = 42.0;   // Standard cell spacing (mm)
GF_TOLERANCE        = 0.25;   // Clearance per side (mm)

// Baseplate Socket Dimensions (+0.25mm Clearance Offset)
GF_SOCKET_TOP_W     = 42.00;  // Top mouth opening (mm)
GF_SOCKET_WAIST_W   = 37.70;  // 37.2 + 2 * 0.25 (mm)
GF_SOCKET_BOT_W     = 36.30;  // 37.7 - 2 * 0.70 (mm)

GF_TOP_CHAMFER_H    = 2.15;   // Top lead-in chamfer height (mm)
GF_VERT_WAIST_H     = 1.80;   // Straight vertical waist height (mm)
GF_BOT_CHAMFER_H    = 0.70;   // Bottom seating chamfer height (mm)
GF_PROFILE_H        = GF_TOP_CHAMFER_H + GF_VERT_WAIST_H + GF_BOT_CHAMFER_H; // 4.65 mm

// Corner Radii (Concentric with 4.0mm outer envelope)
GF_SOCKET_TOP_R     = 4.00;   // 8.0mm dia
GF_SOCKET_WAIST_R   = GF_SOCKET_TOP_R - GF_TOP_CHAMFER_H; // 1.85 mm (3.7mm dia)
GF_SOCKET_BOT_R     = GF_SOCKET_WAIST_R - GF_BOT_CHAMFER_H; // 1.15 mm (2.3mm dia)

GRID_PITCH          = GF_PITCH;
TOLERANCE           = GF_TOLERANCE;
PROFILE_H           = GF_PROFILE_H;
POCKET_TOP          = GF_SOCKET_TOP_W;
POCKET_MID          = GF_SOCKET_WAIST_W;
POCKET_BOT          = GF_SOCKET_BOT_W;

// Allow override from parent scripts / tests
_act_use_auto_fit = is_undef(_override_use_auto_fit) ? use_auto_fit : _override_use_auto_fit;
_act_grid_x       = is_undef(_override_manual_grid_x) ? manual_grid_x : _override_manual_grid_x;
_act_grid_y       = is_undef(_override_manual_grid_y) ? manual_grid_y : _override_manual_grid_y;
_act_clearance    = is_undef(_override_clearance) ? clearance_per_side : _override_clearance;
_act_tiling       = is_undef(_override_tiling_mode) ? tiling_mode : _override_tiling_mode;

// ============================================================================
// Auto-Fit Calculation
// ============================================================================

_usable_w = drawer_width_mm - 2 * _act_clearance;
_usable_d = drawer_depth_mm - 2 * _act_clearance;

_auto_gx = max(1, floor(_usable_w / GRID_PITCH));
_auto_gy = max(1, floor(_usable_d / GRID_PITCH));

_left_x = _usable_w - _auto_gx * GRID_PITCH;
_left_y = _usable_d - _auto_gy * GRID_PITCH;

gx = _act_use_auto_fit ? _auto_gx : _act_grid_x;
gy = _act_use_auto_fit ? _auto_gy : _act_grid_y;

ext_tx = _act_use_auto_fit ? max(0, _left_x) : 0;
ext_ty = _act_use_auto_fit ? max(0, _left_y) : 0;

// Extension distribution
ext_L = (extension_mode == 0) ? floor(ext_tx / 2) :
        (extension_mode == 2) ? ext_tx : 0;
ext_R = (extension_mode == 0) ? ext_tx - floor(ext_tx / 2) :
        (extension_mode == 1) ? ext_tx : 0;
ext_F = (extension_mode == 0) ? floor(ext_ty / 2) :
        (extension_mode == 2) ? ext_ty : 0;
ext_B = (extension_mode == 0) ? ext_ty - floor(ext_ty / 2) :
        (extension_mode == 1) ? ext_ty : 0;

total_w = gx * GRID_PITCH + ext_L + ext_R;
total_d = gy * GRID_PITCH + ext_F + ext_B;

// Tiling calculations
cells_per_tile_x = _act_tiling ? max(1, floor((bed_x_mm - 2 * bed_safe_margin_mm - 15) / GRID_PITCH)) : gx;
cells_per_tile_y = _act_tiling ? max(1, floor((bed_y_mm - 2 * bed_safe_margin_mm - 15) / GRID_PITCH)) : gy;

tiles_x = _act_tiling ? ceil(gx / cells_per_tile_x) : 1;
tiles_y = _act_tiling ? ceil(gy / cells_per_tile_y) : 1;

// Debug output
echo(str("=== Ultralight Arched Doorway Gridfinity ==="));
echo(str("Grid: ", gx, " x ", gy, " cells"));
echo(str("Total Dimensions: ", total_w, " x ", total_d, " mm (Extensions — L:", ext_L, " R:", ext_R, " F:", ext_F, " B:", ext_B, " mm)"));
echo(str("Doorway Cutout: ", doorway_width, " x ", doorway_height, " mm"));
echo(str("Socket Dimensions — Mouth: ", POCKET_TOP, " mm, Waist: ", POCKET_MID, " mm, Bottom Ledge: ", POCKET_BOT, " mm"));

// ============================================================================
// Helper Geometry Modules (Self-Contained for MakerWorld)
// ============================================================================

module gf_rounded_rect(w, d, h, r=4) {
    eff_r = min(r, w/2 - 0.01, d/2 - 0.01);
    if (eff_r > 0.01) {
        hull() {
            for (x = [-w/2 + eff_r, w/2 - eff_r]) {
                for (y = [-d/2 + eff_r, d/2 - eff_r]) {
                    translate([x, y, 0])
                        cylinder(r=eff_r, h=h);
                }
            }
        }
    } else {
        translate([-w/2, -d/2, 0])
            cube([w, d, h]);
    }
}

module gf_socket_pocket(open_bottom=true, chamfer_ledge=true, clearance=0, extra_top=1.0) {
    top_w   = GF_SOCKET_TOP_W + 2 * clearance;
    waist_w = GF_SOCKET_WAIST_W + 2 * clearance;
    bot_w   = GF_SOCKET_BOT_W + 2 * clearance;
    
    top_r   = max(0.1, GF_SOCKET_TOP_R + clearance);
    waist_r = max(0.1, GF_SOCKET_WAIST_R + clearance);
    bot_r   = max(0.1, GF_SOCKET_BOT_R + clearance);
    
    z_bot = 0;
    z_waist_bot = GF_BOT_CHAMFER_H;
    z_waist_top = GF_BOT_CHAMFER_H + GF_VERT_WAIST_H;
    z_top = GF_PROFILE_H;
    
    hull() {
        translate([0, 0, z_waist_top])
            gf_rounded_rect(waist_w, waist_w, 0.01, r=waist_r);
        translate([0, 0, z_top])
            gf_rounded_rect(top_w, top_w, 0.01, r=top_r);
    }
    
    if (extra_top > 0) {
        translate([0, 0, z_top])
            gf_rounded_rect(top_w, top_w, extra_top, r=top_r);
    }
    
    translate([0, 0, z_waist_bot])
        gf_rounded_rect(waist_w, waist_w, GF_VERT_WAIST_H + 0.01, r=waist_r);
    
    if (chamfer_ledge) {
        hull() {
            translate([0, 0, z_bot])
                gf_rounded_rect(bot_w, bot_w, 0.01, r=bot_r);
            translate([0, 0, z_waist_bot])
                gf_rounded_rect(waist_w, waist_w, 0.01, r=waist_r);
        }
        if (open_bottom) {
            translate([0, 0, -2])
                gf_rounded_rect(bot_w, bot_w, 2.01, r=bot_r);
        }
    } else {
        translate([0, 0, open_bottom ? -2 : 0])
            gf_rounded_rect(waist_w, waist_w, (open_bottom ? 2 : 0) + z_waist_bot + 0.01, r=waist_r);
    }
}

module gf_cell_envelope(w=GF_PITCH, d=GF_PITCH, h=GF_PROFILE_H) {
    gf_rounded_rect(w, d, h, r=min(GF_SOCKET_TOP_R, w/2, d/2));
}

// Pocket cutout: official 3-tier pocket socket with open bottom & chamfered ledge
module pocket() {
    gf_socket_pocket(open_bottom=true, chamfer_ledge=true);
}

// 2D profile of arched doorway with top corner fillets
module doorway_profile_2d(w, h, r=4.0) {
    eff_r = min(r, w/2, h);
    hull() {
        translate([-w/2, -1.0])
            square([w, 1.01]);
        if (eff_r > 0.01) {
            translate([-w/2 + eff_r, h - eff_r])
                circle(r=eff_r);
            translate([w/2 - eff_r, h - eff_r])
                circle(r=eff_r);
        } else {
            translate([-w/2, h - 0.01])
                square([w, 0.01]);
        }
    }
}

// 3D arched doorway cutout spanning through divider walls down to table level
module doorway_cutout(w=doorway_width, h=doorway_height, r=4.0, depth=10.0) {
    rotate([90, 0, 0])
        linear_extrude(height=depth, center=true)
            doorway_profile_2d(w, h, r);
}

// Central diamond cutout void at 4-way cell intersections
module diamond_cutout(r=GF_SOCKET_TOP_R, h=PROFILE_H) {
    translate([0, 0, -1.0])
        linear_extrude(height=h + 2.0)
            difference() {
                square([2*r, 2*r], center=true);
                for (sx = [-1, 1]) {
                    for (sy = [-1, 1]) {
                        translate([sx * r, sy * r])
                            circle(r=r);
                    }
                }
            }
}

// ============================================================================
// Baseplate Assembly
// ============================================================================

module arched_baseplate() {
    difference() {
        // Solid outer frame perimeter and base volume
        cube([total_w, total_d, PROFILE_H]);

        // Subtract official bin pockets for each cell
        for (cx = [0 : gx - 1]) {
            for (cy = [0 : gy - 1]) {
                x = ext_L + cx * GRID_PITCH + GRID_PITCH / 2;
                y = ext_F + cy * GRID_PITCH + GRID_PITCH / 2;
                translate([x, y, 0])
                    pocket();
            }
        }

        // Subtract central diamond voids at inner 4-way intersections
        if (gx > 1 && gy > 1) {
            for (ix = [1 : gx - 1]) {
                for (iy = [1 : gy - 1]) {
                    x = ext_L + ix * GRID_PITCH;
                    y = ext_F + iy * GRID_PITCH;
                    translate([x, y, 0])
                        diamond_cutout();
                }
            }
        }

        // Subtract doorway cutouts across inner vertical divider walls (along Y)
        if (gx > 1) {
            for (ix = [1 : gx - 1]) {
                for (cy = [0 : gy - 1]) {
                    x = ext_L + ix * GRID_PITCH;
                    y = ext_F + cy * GRID_PITCH + GRID_PITCH / 2;
                    translate([x, y, 0])
                        rotate([0, 0, 90])
                            doorway_cutout(w=doorway_width, h=doorway_height);
                }
            }
        }

        // Subtract doorway cutouts across inner horizontal divider walls (along X)
        if (gy > 1) {
            for (iy = [1 : gy - 1]) {
                for (cx = [0 : gx - 1]) {
                    x = ext_L + cx * GRID_PITCH + GRID_PITCH / 2;
                    y = ext_F + iy * GRID_PITCH;
                    translate([x, y, 0])
                        doorway_cutout(w=doorway_width, h=doorway_height);
                }
            }
        }
    }
}

// ============================================================================
// Print Bed Tiling & Labeling
// ============================================================================

module tile_mask(tx, ty) {
    start_cx = tx * cells_per_tile_x;
    end_cx   = min(gx, (tx + 1) * cells_per_tile_x);
    
    start_cy = ty * cells_per_tile_y;
    end_cy   = min(gy, (ty + 1) * cells_per_tile_y);
    
    x_min = (tx == 0) ? -50 : (ext_L + start_cx * GRID_PITCH);
    x_max = (tx == tiles_x - 1) ? total_w + 50 : (ext_L + end_cx * GRID_PITCH);
    
    y_min = (ty == 0) ? -50 : (ext_F + start_cy * GRID_PITCH);
    y_max = (ty == tiles_y - 1) ? total_d + 50 : (ext_F + end_cy * GRID_PITCH);
    
    w = x_max - x_min;
    d = y_max - y_min;
    
    translate([x_min, y_min, -2])
        cube([w, d, PROFILE_H + 4]);
}

module tile_label(tx, ty) {
    start_cx = tx * cells_per_tile_x;
    start_cy = ty * cells_per_tile_y;
    x = ext_L + start_cx * GRID_PITCH + GRID_PITCH / 2;
    y = ext_F + start_cy * GRID_PITCH + GRID_PITCH / 2;
    
    translate([x, y, 0]) {
        difference() {
            translate([0, 0, 0.4])
                cube([POCKET_BOT, POCKET_BOT, 0.8], center=true);
            translate([0, 0, -1.0])
                linear_extrude(3.0)
                    text(str(tx + 1, "/", ty + 1), size=8, halign="center", valign="center");
        }
    }
}

// ============================================================================
// Final Render Assembly
// ============================================================================

if (!_act_tiling) {
    arched_baseplate();
} else {
    for (tx = [0 : tiles_x - 1]) {
        for (ty = [0 : tiles_y - 1]) {
            tile_index = 1 + tx + ty * tiles_x;
            
            if (part_to_render == 0 || part_to_render == tile_index) {
                offset_x = (part_to_render == 0) ? tx * tile_gap_mm : 0;
                offset_y = (part_to_render == 0) ? ty * tile_gap_mm : 0;
                
                center_x = (part_to_render > 0) ? -(ext_L + tx * cells_per_tile_x * GRID_PITCH + (cells_per_tile_x * GRID_PITCH) / 2) : -(total_w + (tiles_x - 1) * tile_gap_mm) / 2;
                center_y = (part_to_render > 0) ? -(ext_F + ty * cells_per_tile_y * GRID_PITCH + (cells_per_tile_y * GRID_PITCH) / 2) : -(total_d + (tiles_y - 1) * tile_gap_mm) / 2;
                
                translate([offset_x + center_x, offset_y + center_y, 0]) {
                    union() {
                        intersection() {
                            arched_baseplate();
                            tile_mask(tx, ty);
                        }
                        if (enable_labels) {
                            tile_label(tx, ty);
                        }
                    }
                }
            }
        }
    }
}
