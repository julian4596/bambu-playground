// ============================================================================
// Ultralight Spacerless Gridfinity Baseplate
// ============================================================================
// A parametric, MakerWorld-compatible OpenSCAD script that generates
// ultra-lightweight Gridfinity baseplates strictly adhering to the official
// Gridfinity specification (https://gridfinity.xyz/specification/) and
// inspired by Paul Bone's gfthings (https://github.com/PaulBone/gfthings).
//
// Features:
//   - Strictly compliant with Gridfinity v5 standards
//   - Three styles:
//       0 = Ultralight Skeleton (open floor with 0.7mm chamfered bottom ledge)
//       1 = Standard (0.4mm floor)
//       2 = Solid (1.2mm floor)
//   - Optional arched doorways or trapezoidal edge cutouts along divider walls
//   - Standard 4-corner magnet and screw holes per cell (26mm square spacing)
//   - Spacerless auto-fit to drawer dimensions with zero wasted space
//   - Built-in bed tiling, puzzle dovetail joints, and coordinate labels
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
drawer_width_mm = 400; // [50:1:1000]
// Inner depth of your drawer in mm
drawer_depth_mm = 500; // [50:1:1000]
// Clearance per side in mm (0.5 recommended)
clearance_per_side = 0.5; // [0:0.1:2]

/* [02 — Grid Override (Optional)] */
// Use auto-fit from drawer dimensions?
use_auto_fit = true;
// Manual grid units in X (only used if auto-fit is OFF)
manual_grid_x = 4; // [1:1:20]
// Manual grid units in Y (only used if auto-fit is OFF)
manual_grid_y = 4; // [1:1:20]

/* [03 — Baseplate Style & Bottom Support] */
// 0=Ultralight Skeleton, 1=Standard (0.4mm floor), 2=Solid (1.2mm floor)
style = 0; // [0:Ultralight Skeleton, 1:Standard, 2:Solid]
// In Ultralight mode: keep 0.7mm chamfer ledge to support bin foot
chamfer_bottom_ledge = true;
// Wall cutout mode: 0=Continuous walls, 1=Arched doorways, 2=Trapezoid edge cuts
wall_cutout_mode = 0; // [0:Continuous, 1:Arched Doorways, 2:Edge Cuts]
// Thickness of divider walls between bins in mm (for custom ring spacing)
divider_wall_thickness = 2.4; // [1.2:0.2:4.8]

/* [04 — Extension Distribution] */
// How to distribute leftover space on each axis
// 0=Split evenly both sides, 1=Right/Back only, 2=Left/Front only
extension_mode = 0; // [0:Even Split, 1:Right-Back Only, 2:Left-Front Only]

/* [05 — Magnet & Screw Holes] */
// Number of corner holes per cell: 0=None, 2=Two opposite corners, 4=All 4 corners
corner_holes_per_cell = 0; // [0:None, 2:Two Corners, 4:Four Corners]
// Magnet hole diameter in mm (6.2mm press fit for 6mm magnets)
magnet_diameter = 6.2; // [6.0:0.1:6.5]
// M3 screw clearance hole diameter in mm
screw_diameter = 3.2; // [2.5:0.1:4.0]

/* [06 — Print Bed Tiling] */
// Splitcut the generated plate (manual or auto-fit) into bed-sized tiles.
tiling_mode = true;
// Bed width in mm (tiling only).
bed_x_mm = 256.0; // [100:0.1:500]
// Bed depth in mm (tiling only).
bed_y_mm = 256.0; // [100:0.1:500]
// Reserved margin per bed edge in mm (tiling only).
bed_safe_margin_mm = 2.0; // [0:0.1:20]
// Gap between tiles in mm (scene only).
tile_gap_mm = 10.0; // [0:0.1:50]
// Add tile coordinate labels (tiling only).
enable_labels = true;
// Which part to render? 0=All (Exploded View), 1=Tile 1/1, etc.
part_to_render = 0; // [0:All (Exploded), 1:Tile 1/1, 2:Tile 2/1, 3:Tile 1/2, 4:Tile 2/2, 5:Tile 3/1, 6:Tile 3/2, 7:Tile 3/3, 8:Tile 4/1, 9:Tile 4/2, 10:Tile 4/3]

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

// Mounting Holes (Magnets & Screws)
GF_HOLE_OFFSET      = 13.0;   // Offset from cell center along X & Y (mm)
GF_HOLE_SPACING     = 26.0;   // Center-to-center hole distance (mm)
GF_MAGNET_D         = 6.2;    // Magnet hole diameter (mm, press fit for 6.0mm)
GF_MAGNET_H         = 2.2;    // Magnet hole depth (mm)
GF_SCREW_D          = 3.2;    // Screw hole diameter (mm, clearance for M3)

GRID_PITCH          = GF_PITCH;
TOLERANCE           = GF_TOLERANCE;
PROFILE_H           = GF_PROFILE_H;
POCKET_TOP          = GF_SOCKET_TOP_W;
POCKET_MID          = GF_SOCKET_WAIST_W;
POCKET_BOT          = GF_SOCKET_BOT_W;

// Allow override from parent scripts
_act_use_auto_fit = is_undef(_override_use_auto_fit) ? use_auto_fit : _override_use_auto_fit;
_act_grid_x       = is_undef(_override_manual_grid_x) ? manual_grid_x : _override_manual_grid_x;
_act_grid_y       = is_undef(_override_manual_grid_y) ? manual_grid_y : _override_manual_grid_y;
_act_style        = is_undef(_override_style) ? style : _override_style;
_act_clearance    = is_undef(_override_clearance) ? clearance_per_side : _override_clearance;
_act_tiling       = is_undef(_override_tiling_mode) ? tiling_mode : _override_tiling_mode;
_act_ledge        = is_undef(_override_chamfer_ledge) ? chamfer_bottom_ledge : _override_chamfer_ledge;
_act_holes        = is_undef(_override_corner_holes) ? corner_holes_per_cell : _override_corner_holes;
_act_wall_mode    = is_undef(_override_wall_cutout_mode) ? wall_cutout_mode : _override_wall_cutout_mode;

_safe_wall = max(0.8, min(divider_wall_thickness, 4.8));

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
echo(str("=== Official Spec Gridfinity Baseplate ==="));
echo(str("Grid: ", gx, " x ", gy, " cells"));
echo(str("Dimensions: ", total_w, " x ", total_d, " mm (Extensions — L:", ext_L, " R:", ext_R, " F:", ext_F, " B:", ext_B, " mm)"));
echo(str("Style: ", _act_style == 0 ? "Ultralight Skeleton" : _act_style == 1 ? "Standard (0.4mm floor)" : "Solid (1.2mm floor)"));
echo(str("Socket Dimensions — Mouth: ", POCKET_TOP, " mm, Waist: ", POCKET_MID, " mm, Bottom Ledge: ", POCKET_BOT, " mm"));
echo(str("Corner Holes per Cell: ", _act_holes, " (26mm spacing)"));

// ============================================================================
// Modules — Core Specification Geometry (Self-Contained for MakerWorld)
// ============================================================================

// Centered rounded rectangle extruded to height h
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

// Subtractive pocket socket conforming strictly to gridfinity.xyz v5
module gf_socket_pocket(open_bottom=true, chamfer_ledge=true, clearance=0, extra_top=1.0, corner_holes=0) {
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
    
    // Layer 3: Top 45° Chamfer (from waist_w up to top_w)
    hull() {
        translate([0, 0, z_waist_top])
            gf_rounded_rect(waist_w, waist_w, 0.01, r=waist_r);
        translate([0, 0, z_top])
            gf_rounded_rect(top_w, top_w, 0.01, r=top_r);
    }
    
    // Extra top extension for clean difference cut through top surface
    if (extra_top > 0) {
        translate([0, 0, z_top])
            gf_rounded_rect(top_w, top_w, extra_top, r=top_r);
    }
    
    // Layer 2: Straight vertical waist
    translate([0, 0, z_waist_bot])
        gf_rounded_rect(waist_w, waist_w, GF_VERT_WAIST_H + 0.01, r=waist_r);
    
    // Layer 1: Bottom chamfer / ledge
    if (chamfer_ledge) {
        hull() {
            translate([0, 0, z_bot])
                gf_rounded_rect(bot_w, bot_w, 0.01, r=bot_r);
            translate([0, 0, z_waist_bot])
                gf_rounded_rect(waist_w, waist_w, 0.01, r=waist_r);
        }
        // If bottom is open (Style 0 Ultralight), through-cut the center hole down past Z=0
        if (open_bottom) {
            translate([0, 0, -2]) {
                if (corner_holes > 0) {
                    difference() {
                        gf_rounded_rect(bot_w, bot_w, 2.01, r=bot_r);
                        gf_corner_boss_pads(count=corner_holes, h=4);
                    }
                } else {
                    gf_rounded_rect(bot_w, bot_w, 2.01, r=bot_r);
                }
            }
        }
    } else {
        // If chamfer_ledge is false, cut the waist width straight to bottom
        translate([0, 0, open_bottom ? -2 : 0]) {
            if (open_bottom && corner_holes > 0) {
                difference() {
                    gf_rounded_rect(waist_w, waist_w, 2 + z_waist_bot + 0.01, r=waist_r);
                    gf_corner_boss_pads(count=corner_holes, h=4 + z_waist_bot);
                }
            } else {
                gf_rounded_rect(waist_w, waist_w, (open_bottom ? 2 : 0) + z_waist_bot + 0.01, r=waist_r);
            }
        }
    }
}

// Positive cell outer envelope (standard 42x42 with r=4.0 corners)
module gf_cell_envelope(w=GF_PITCH, d=GF_PITCH, h=GF_PROFILE_H) {
    gf_rounded_rect(w, d, h, r=min(GF_SOCKET_TOP_R, w/2, d/2));
}

// Corner magnet and screw holes per cell (0, 2 diagonal, or 4 corners)
module gf_corner_holes(count=0, magnet_d=GF_MAGNET_D, magnet_h=GF_MAGNET_H, screw_d=GF_SCREW_D, h=GF_PROFILE_H) {
    if (count == 2) {
        _gf_single_corner_hole(-GF_HOLE_OFFSET, -GF_HOLE_OFFSET, magnet_d, magnet_h, screw_d, h);
        _gf_single_corner_hole( GF_HOLE_OFFSET,  GF_HOLE_OFFSET, magnet_d, magnet_h, screw_d, h);
    } else if (count >= 4) {
        for (sx = [-1, 1]) {
            for (sy = [-1, 1]) {
                _gf_single_corner_hole(sx * GF_HOLE_OFFSET, sy * GF_HOLE_OFFSET, magnet_d, magnet_h, screw_d, h);
            }
        }
    }
}

module _gf_single_corner_hole(x, y, magnet_d, magnet_h, screw_d, h) {
    translate([x, y, 0]) {
        if (magnet_d > 0 && magnet_h > 0) {
            translate([0, 0, -0.01])
                cylinder(d=magnet_d, h=magnet_h + 0.01, $fn=30);
        }
        if (screw_d > 0) {
            translate([0, 0, -1])
                cylinder(d=screw_d, h=h + 2, $fn=24);
        }
    }
}

// Trapezoidal edge cutout along cell walls (inspired by gfthings EdgeCut)
module gf_edge_cut(cut_len=26.0, cut_h=GF_PROFILE_H) {
    tri_w = tan(30) * cut_h;
    short_len = max(0.1, cut_len - 2 * tri_w);
    hull() {
        translate([-short_len/2, -1, 0]) cube([short_len, 2, cut_h]);
        translate([-cut_len/2, -1, cut_h]) cube([cut_len, 2, 0.01]);
    }
}

// Solid corner boss pads for screw/magnet retention in skeleton (open floor) baseplates
module gf_corner_boss_pads(count=0, pad_r=5.5, h=GF_PROFILE_H) {
    if (count == 2) {
        _gf_single_boss_pad(-GF_HOLE_OFFSET, -GF_HOLE_OFFSET, pad_r, h);
        _gf_single_boss_pad( GF_HOLE_OFFSET,  GF_HOLE_OFFSET, pad_r, h);
    } else if (count >= 4) {
        for (sx = [-1, 1]) {
            for (sy = [-1, 1]) {
                _gf_single_boss_pad(sx * GF_HOLE_OFFSET, sy * GF_HOLE_OFFSET, pad_r, h);
            }
        }
    }
}

module _gf_single_boss_pad(x, y, pad_r=5.5, h=GF_PROFILE_H) {
    sx = sign(x);
    sy = sign(y);
    corner_x = sx * (GF_PITCH / 2);
    corner_y = sy * (GF_PITCH / 2);
    hull() {
        translate([x, y, 0])
            cylinder(r=pad_r, h=h);
        translate([corner_x - sx * 4.0, corner_y - sy * 4.0, 0])
            cylinder(r=4.0, h=h);
        translate([corner_x - sx * 4.0, y, 0])
            cylinder(r=3.0, h=h);
        translate([x, corner_y - sy * 4.0, 0])
            cylinder(r=3.0, h=h);
    }
}

module pocket() {
    gf_socket_pocket(open_bottom=(_act_style == 0), chamfer_ledge=_act_ledge, corner_holes=_act_holes);
}

// ============================================================================
// Modules — Baseplate Structure
// ============================================================================

module solid_base() {
    cube([total_w, total_d, PROFILE_H]);
}

module custom_cell_envelope(w, d, h) {
    if (w >= 0.1 && d >= 0.1) {
        difference() {
            // Concentric outer boundary (r=4.0mm) yielding diamond voids at intersections
            gf_cell_envelope(w, d, h);
            
            // If this is a partial extension tile, hollow out inner area
            if ((w < GRID_PITCH - 0.1 || d < GRID_PITCH - 0.1) && w > _safe_wall + 0.1 && d > _safe_wall + 0.1) {
                translate([0, 0, -1])
                    gf_rounded_rect(w - _safe_wall, d - _safe_wall, h + 2, r=min(GF_SOCKET_WAIST_R, (w - _safe_wall)/2, (d - _safe_wall)/2));
            }
        }
    }
}

module skeleton_base() {
    if (_act_style == 0) {
        // Ultralight skeleton: envelope rings that merge on straights and form corner diamonds
        for (ix = [-1 : gx]) {
            for (iy = [-1 : gy]) {
                w = (ix == -1) ? ext_L : ((ix == gx) ? ext_R : GRID_PITCH);
                x = (ix == -1) ? (ext_L / 2) : ((ix == gx) ? (ext_L + gx * GRID_PITCH + ext_R / 2) : (ext_L + ix * GRID_PITCH + GRID_PITCH / 2));
                
                d = (iy == -1) ? ext_F : ((iy == gy) ? ext_B : GRID_PITCH);
                y = (iy == -1) ? (ext_F / 2) : ((iy == gy) ? (ext_F + gy * GRID_PITCH + ext_B / 2) : (ext_F + iy * GRID_PITCH + GRID_PITCH / 2));
                
                if (w > 0.01 && d > 0.01) {
                    translate([x, y, 0])
                        custom_cell_envelope(w, d, PROFILE_H);
                }
            }
        }
        // If corner holes are enabled, add corner mounting pads to hold magnets/screws
        if (_act_holes > 0) {
            pad_h = _act_ledge ? GF_BOT_CHAMFER_H : (GF_BOT_CHAMFER_H + GF_VERT_WAIST_H);
            for (cx = [0 : gx - 1]) {
                for (cy = [0 : gy - 1]) {
                    x = ext_L + cx * GRID_PITCH + GRID_PITCH / 2;
                    y = ext_F + cy * GRID_PITCH + GRID_PITCH / 2;
                    translate([x, y, 0])
                        gf_corner_boss_pads(count=_act_holes, h=pad_h);
                }
            }
        }
    } else {
        // Styles 1 & 2: Solid outer boundaries with solid ribs
        wt = 1.2;
        h = PROFILE_H;
        wt_cut = max(wt, 8);
        
        for (ix = [0:gx]) {
            is_cut = _act_tiling && ix > 0 && ix < gx && (ix % cells_per_tile_x == 0);
            cur_wt = is_cut ? wt_cut : wt;
            x = ext_L + ix * GRID_PITCH;
            wx = max(0, min(x - cur_wt/2, total_w - cur_wt));
            translate([wx, 0, 0]) cube([cur_wt, total_d, h]);
        }
        
        for (iy = [0:gy]) {
            is_cut = _act_tiling && iy > 0 && iy < gy && (iy % cells_per_tile_y == 0);
            cur_wt = is_cut ? wt_cut : wt;
            y = ext_F + iy * GRID_PITCH;
            wy = max(0, min(y - cur_wt/2, total_d - cur_wt));
            translate([0, wy, 0]) cube([total_w, cur_wt, h]);
        }
        
        // Hubs at intersections
        ps = wt * 2.5; 
        for (ix = [0:gx]) {
            for (iy = [0:gy]) {
                x = ext_L + ix * GRID_PITCH;
                y = ext_F + iy * GRID_PITCH;
                px = max(0, min(x - ps/2, total_w - ps));
                py = max(0, min(y - ps/2, total_d - ps));
                translate([px, py, 0]) cube([ps, ps, h]);
            }
        }
        
        // Extensions
        if (ext_L > 0.01) {
            cube([wt, total_d, h]);
            for (iy = [0:gy]) {
                y = ext_F + iy * GRID_PITCH;
                wy = max(0, min(y - wt/2, total_d - wt));
                translate([0, wy, 0]) cube([ext_L, wt, h]);
            }
        }
        if (ext_R > 0.01) {
            translate([total_w - wt, 0, 0]) cube([wt, total_d, h]);
            for (iy = [0:gy]) {
                y = ext_F + iy * GRID_PITCH;
                wy = max(0, min(y - wt/2, total_d - wt));
                translate([total_w - ext_R, wy, 0]) cube([ext_R, wt, h]);
            }
        }
        if (ext_F > 0.01) {
            cube([total_w, wt, h]);
            for (ix = [0:gx]) {
                x = ext_L + ix * GRID_PITCH;
                wx = max(0, min(x - wt/2, total_w - wt));
                translate([wx, 0, 0]) cube([wt, ext_F, h]);
            }
        }
        if (ext_B > 0.01) {
            translate([0, total_d - wt, 0]) cube([total_w, wt, h]);
            for (ix = [0:gx]) {
                x = ext_L + ix * GRID_PITCH;
                wx = max(0, min(x - wt/2, total_w - wt));
                translate([wx, total_d - ext_B, 0]) cube([wt, ext_B, h]);
            }
        }
    }
}

module standard_base() {
    skeleton_base();
    translate([0, 0, -0.4]) cube([total_w, total_d, 0.4]);
}

module solid_full_base() {
    solid_base();
    translate([0, 0, -1.2]) cube([total_w, total_d, 1.2]);
}

// ============================================================================
// Modules — Wall Cutouts (Arched Doorways / Edge Cuts)
// ============================================================================

module divider_cutouts() {
    if (_act_wall_mode == 1) {
        // Mode 1: Arched Doorways through divider walls
        arch_w = 24.0;
        arch_h = 3.5;
        // X-divider walls (between cells along X)
        if (gx > 1) {
            for (cx = [1 : gx - 1]) {
                for (cy = [0 : gy - 1]) {
                    x = ext_L + cx * GRID_PITCH;
                    y = ext_F + cy * GRID_PITCH + GRID_PITCH / 2;
                    translate([x, y, 0])
                        rotate([0, 0, 90])
                            _doorway_arch(arch_w, arch_h, 6.0);
                }
            }
        }
        // Y-divider walls (between cells along Y)
        if (gy > 1) {
            for (cx = [0 : gx - 1]) {
                for (cy = [1 : gy - 1]) {
                    x = ext_L + cx * GRID_PITCH + GRID_PITCH / 2;
                    y = ext_F + cy * GRID_PITCH;
                    translate([x, y, 0])
                        _doorway_arch(arch_w, arch_h, 6.0);
                }
            }
        }
    } else if (_act_wall_mode == 2) {
        // Mode 2: Trapezoid Edge Cuts (gfthings style)
        if (gx > 1) {
            for (cx = [1 : gx - 1]) {
                for (cy = [0 : gy - 1]) {
                    x = ext_L + cx * GRID_PITCH;
                    y = ext_F + cy * GRID_PITCH + GRID_PITCH / 2;
                    translate([x, y, 0])
                        rotate([0, 0, 90])
                            gf_edge_cut(26.0, PROFILE_H);
                }
            }
        }
        if (gy > 1) {
            for (cx = [0 : gx - 1]) {
                for (cy = [1 : gy - 1]) {
                    x = ext_L + cx * GRID_PITCH + GRID_PITCH / 2;
                    y = ext_F + cy * GRID_PITCH;
                    translate([x, y, 0])
                        gf_edge_cut(26.0, PROFILE_H);
                }
            }
        }
    }
}

module _doorway_arch(w, h, depth) {
    eff_r = min(4.0, w/2, h);
    translate([0, 0, 0]) {
        hull() {
            translate([-w/2 + eff_r, -depth/2, h - eff_r])
                rotate([-90, 0, 0]) cylinder(r=eff_r, h=depth);
            translate([w/2 - eff_r, -depth/2, h - eff_r])
                rotate([-90, 0, 0]) cylinder(r=eff_r, h=depth);
            translate([-w/2, -depth/2, 0])
                cube([w, depth, 0.01]);
        }
    }
}

// ============================================================================
// Modules — Holes
// ============================================================================

module all_holes() {
    if (_act_holes > 0) {
        for (cx = [0 : gx - 1]) {
            for (cy = [0 : gy - 1]) {
                x = ext_L + cx * GRID_PITCH + GRID_PITCH / 2;
                y = ext_F + cy * GRID_PITCH + GRID_PITCH / 2;
                translate([x, y, 0])
                    gf_corner_holes(count=_act_holes, magnet_d=magnet_diameter, magnet_h=GF_MAGNET_H, screw_d=screw_diameter, h=PROFILE_H);
            }
        }
    }
}

// ============================================================================
// Main Assembly
// ============================================================================

module ultralight_spacerless_baseplate() {
    difference() {
        // Positive geometry
        if (_act_style == 0)
            skeleton_base();
        else if (_act_style == 1)
            standard_base();
        else
            solid_full_base();
        
        // Subtract official pocket sockets for every grid cell
        for (cx = [0 : gx - 1]) {
            for (cy = [0 : gy - 1]) {
                x = ext_L + cx * GRID_PITCH + GRID_PITCH / 2;
                y = ext_F + cy * GRID_PITCH + GRID_PITCH / 2;
                translate([x, y, 0])
                    pocket();
            }
        }
        
        // Subtract optional wall cutouts (arches or edge cuts)
        divider_cutouts();
        
        // Subtract standard corner magnet/screw holes
        all_holes();
    }
}

// ============================================================================
// Tile Masking & Dovetails
// ============================================================================

module puzzle_tab(clearance=0) {
    translate([4, 0, 0]) cylinder(d=8 + clearance, h=PROFILE_H+4, center=true);
    translate([2, 0, 0]) cube([4 + clearance, 4 + clearance, PROFILE_H+4], center=true);
}

module tile_mask(tx, ty) {
    start_cx = tx * cells_per_tile_x;
    end_cx = min(gx, (tx + 1) * cells_per_tile_x);
    
    start_cy = ty * cells_per_tile_y;
    end_cy = min(gy, (ty + 1) * cells_per_tile_y);
    
    x_min = (tx == 0) ? -50 : (ext_L + start_cx * GRID_PITCH);
    x_max = (tx == tiles_x - 1) ? total_w + 50 : (ext_L + end_cx * GRID_PITCH);
    
    y_min = (ty == 0) ? -50 : (ext_F + start_cy * GRID_PITCH);
    y_max = (ty == tiles_y - 1) ? total_d + 50 : (ext_F + end_cy * GRID_PITCH);
    
    w = x_max - x_min;
    d = y_max - y_min;
    
    difference() {
        union() {
            translate([x_min, y_min, -2])
                cube([w, d, PROFILE_H + 4]);
                
            if (_act_style != 0) {
                if (tx < tiles_x - 1) {
                    for (cy = [start_cy : end_cy - 1]) {
                        y = ext_F + cy * GRID_PITCH + GRID_PITCH/2;
                        translate([x_max, y, PROFILE_H/2 - 1])
                            puzzle_tab(0);
                    }
                }
                if (ty < tiles_y - 1) {
                    for (cx = [start_cx : end_cx - 1]) {
                        x = ext_L + cx * GRID_PITCH + GRID_PITCH/2;
                        translate([x, y_max, PROFILE_H/2 - 1])
                            rotate([0, 0, 90]) puzzle_tab(0);
                    }
                }
            }
        }
        
        if (_act_style != 0) {
            if (tx > 0) {
                for (cy = [start_cy : end_cy - 1]) {
                    y = ext_F + cy * GRID_PITCH + GRID_PITCH/2;
                    translate([x_min, y, PROFILE_H/2 - 1])
                        puzzle_tab(0.2);
                }
            }
            if (ty > 0) {
                for (cx = [start_cx : end_cx - 1]) {
                    x = ext_L + cx * GRID_PITCH + GRID_PITCH/2;
                    translate([x, y_min, PROFILE_H/2 - 1])
                        rotate([0, 0, 90]) puzzle_tab(0.2);
                }
            }
        }
    }
}

module tile_label(tx, ty) {
    start_cx = tx * cells_per_tile_x;
    start_cy = ty * cells_per_tile_y;
    x = ext_L + start_cx * GRID_PITCH + GRID_PITCH/2;
    y = ext_F + start_cy * GRID_PITCH + GRID_PITCH/2;
    
    translate([x, y, 0]) {
        difference() {
            translate([0, 0, 0.4]) cube([POCKET_BOT, POCKET_BOT, 0.8], center=true);
            translate([0, 0, -1]) linear_extrude(3)
                text(str(tx+1, "/", ty+1), size=8, halign="center", valign="center");
        }
    }
}

// ============================================================================
// Render
// ============================================================================

if (!_act_tiling) {
    ultralight_spacerless_baseplate();
} else {
    for (tx = [0 : tiles_x - 1]) {
        for (ty = [0 : tiles_y - 1]) {
            tile_index = 1 + tx + ty * tiles_x;
            
            if (part_to_render == 0 || part_to_render == tile_index) {
                offset_x = (part_to_render == 0) ? tx * tile_gap_mm : 0;
                offset_y = (part_to_render == 0) ? ty * tile_gap_mm : 0;
                
                center_x = (part_to_render > 0) ? -(ext_L + tx * cells_per_tile_x * GRID_PITCH + (cells_per_tile_x * GRID_PITCH)/2) : -(total_w + (tiles_x-1)*tile_gap_mm)/2;
                center_y = (part_to_render > 0) ? -(ext_F + ty * cells_per_tile_y * GRID_PITCH + (cells_per_tile_y * GRID_PITCH)/2) : -(total_d + (tiles_y-1)*tile_gap_mm)/2;
                
                translate([offset_x + center_x, offset_y + center_y, 0]) {
                    union() {
                        intersection() {
                            ultralight_spacerless_baseplate();
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