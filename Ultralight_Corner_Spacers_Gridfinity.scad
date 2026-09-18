// ============================================================================
// Ultralight Corner Spacers Gridfinity Baseplate
// ============================================================================
// A parametric, MakerWorld-compatible OpenSCAD script that generates
// ultra-lightweight Gridfinity baseplates strictly adhering to the official
// Gridfinity specification (https://gridfinity.xyz/specification/) with
// discrete dual-window corner bumper tabs (standoffs) instead of continuous
// full-perimeter drawer walls.
//
// Key Features:
//   - Strictly compliant with Gridfinity v5 standards (pitch 42mm, 0.7mm bottom ledge)
//   - Discrete Corner Bumper Tabs: Braces securely against drawer walls with
//     hollow dual-window truss tabs at cell 2 and cell N-1 on all 4 edges
//   - Maximum filament & print-time savings (zero plastic along intermediate edges)
//   - Three styles:
//       0 = Ultralight Skeleton (open floor with 0.7mm chamfered bottom ledge)
//       1 = Standard (0.4mm floor)
//       2 = Solid (1.2mm floor)
//   - Optional magnet and screw holes (26mm square pattern) with reinforced boss pads
//   - Spacerless auto-fit to drawer dimensions with zero wasted space
//   - Built-in bed tiling, puzzle dovetail joints, and coordinate labels
//   - 100% Self-Contained single script (MakerWorld Parametric Model Maker ready)
//
// Author: Julian (generated with AI assistance)
// License: CC BY-SA 4.0
// ============================================================================

// ============================================================================
// MakerWorld Customizer Parameters
// ============================================================================

/* [01 — Drawer Dimensions] */
// Inner width of your drawer in mm
drawer_width_mm = 300; // [50:1:1000]
// Inner depth of your drawer in mm
drawer_depth_mm = 350; // [50:1:1000]
// Clearance per side in mm (0.5 recommended)
clearance_per_side = 0.5; // [0:0.1:2]

/* [02 — Grid Override (Optional)] */
// Use auto-fit from drawer dimensions?
use_auto_fit = true;
// Manual grid units in X (only used if auto-fit is OFF)
manual_grid_x = 6; // [1:1:20]
// Manual grid units in Y (only used if auto-fit is OFF)
manual_grid_y = 7; // [1:1:20]

/* [03 — Baseplate Style & Bottom Support] */
// 0=Ultralight Skeleton, 1=Standard (0.4mm floor), 2=Solid (1.2mm floor)
style = 0; // [0:Ultralight Skeleton, 1:Standard, 2:Solid]
// In Ultralight mode: keep 0.7mm chamfer ledge to support bin foot
chamfer_bottom_ledge = true;
// Wall cutout mode: 0=Continuous walls, 1=Arched doorways, 2=Trapezoid edge cuts
wall_cutout_mode = 0; // [0:Continuous, 1:Arched Doorways, 2:Edge Cuts]
// Thickness of divider walls between bins in mm
divider_wall_thickness = 2.4; // [1.2:0.2:4.8]

/* [04 — Corner Bumper Tabs] */
// Position of bumper tabs along edges (1 = offset 1 cell in from corner, 0 = at outer corner)
tab_cell_offset = 1; // [0:At Outer Corners, 1:Offset 1 Cell From Corner]
// Cutout style for bumper tabs
tab_cutout_style = 0; // [0:Dual-Window Truss, 1:Single Window, 2:Solid]
// Wall thickness for bumper tabs in mm
tab_wall_thickness = 1.6; // [1.0:0.2:3.0]

/* [05 — Extension Distribution] */
// How to distribute leftover space on each axis
// 0=Split evenly both sides, 1=Right/Back only, 2=Left/Front only
extension_mode = 0; // [0:Even Split, 1:Right-Back Only, 2:Left-Front Only]

/* [06 — Magnet & Screw Holes] */
// Number of corner holes per cell: 0=None, 2=Two opposite corners, 4=All 4 corners
corner_holes_per_cell = 0; // [0:None, 2:Two Corners, 4:Four Corners]
// Magnet hole diameter in mm (6.2mm press fit for 6mm magnets)
magnet_diameter = 6.2; // [6.0:0.1:6.5]
// M3 screw clearance hole diameter in mm
screw_diameter = 3.2; // [2.5:0.1:4.0]

/* [07 — Print Bed Tiling] */
// Splitcut the generated plate (manual or auto-fit) into bed-sized tiles.
tiling_mode = false;
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
_act_tab_offset   = is_undef(_override_tab_cell_offset) ? tab_cell_offset : _override_tab_cell_offset;
_act_tab_style    = is_undef(_override_tab_cutout_style) ? tab_cutout_style : _override_tab_cutout_style;

_safe_wall        = max(0.8, min(divider_wall_thickness, 4.8));
_tab_wt           = max(1.0, min(tab_wall_thickness, 3.0));

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

ext_tx = is_undef(_override_ext_L) ? (_act_use_auto_fit ? max(0, _left_x) : 0) : (_override_ext_L + _override_ext_R);
ext_ty = is_undef(_override_ext_F) ? (_act_use_auto_fit ? max(0, _left_y) : 0) : (_override_ext_F + _override_ext_B);

// Extension distribution
ext_L = is_undef(_override_ext_L) ? ((extension_mode == 0) ? floor(ext_tx / 2) : ((extension_mode == 2) ? ext_tx : 0)) : _override_ext_L;
ext_R = is_undef(_override_ext_R) ? ((extension_mode == 0) ? ext_tx - floor(ext_tx / 2) : ((extension_mode == 1) ? ext_tx : 0)) : _override_ext_R;
ext_F = is_undef(_override_ext_F) ? ((extension_mode == 0) ? floor(ext_ty / 2) : ((extension_mode == 2) ? ext_ty : 0)) : _override_ext_F;
ext_B = is_undef(_override_ext_B) ? ((extension_mode == 0) ? ext_ty - floor(ext_ty / 2) : ((extension_mode == 1) ? ext_ty : 0)) : _override_ext_B;

total_w = gx * GRID_PITCH + ext_L + ext_R;
total_d = gy * GRID_PITCH + ext_F + ext_B;

// Tiling calculations
cells_per_tile_x = _act_tiling ? max(1, floor((bed_x_mm - 2 * bed_safe_margin_mm - 15) / GRID_PITCH)) : gx;
cells_per_tile_y = _act_tiling ? max(1, floor((bed_y_mm - 2 * bed_safe_margin_mm - 15) / GRID_PITCH)) : gy;

tiles_x = _act_tiling ? ceil(gx / cells_per_tile_x) : 1;
tiles_y = _act_tiling ? ceil(gy / cells_per_tile_y) : 1;

// Debug output
echo(str("=== Official Spec Ultralight Corner Spacers Baseplate ==="));
echo(str("Grid: ", gx, " x ", gy, " cells"));
echo(str("Dimensions: ", total_w, " x ", total_d, " mm (Extensions — L:", ext_L, " R:", ext_R, " F:", ext_F, " B:", ext_B, " mm)"));
echo(str("Bumper Tab Offset: ", _act_tab_offset, " cells from corner"));

// ============================================================================
// Modules — Core Specification Geometry (Self-Contained for MakerWorld)
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
    
    // Layer 3: Top 45° Chamfer
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

module gf_cell_envelope(w=GF_PITCH, d=GF_PITCH, h=GF_PROFILE_H) {
    gf_rounded_rect(w, d, h, r=min(GF_SOCKET_TOP_R, w/2, d/2));
}

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

module gf_edge_cut(cut_len=26.0, cut_h=GF_PROFILE_H) {
    tri_w = tan(30) * cut_h;
    short_len = max(0.1, cut_len - 2 * tri_w);
    hull() {
        translate([-short_len/2, -1, 0]) cube([short_len, 2, cut_h]);
        translate([-cut_len/2, -1, cut_h]) cube([cut_len, 2, 0.01]);
    }
}

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
// Modules — Corner Bumper Standoff Tabs (Dual-Window Truss)
// ============================================================================

// Single bumper tab extending in +Y by reach distance, width tab_w along X
module single_bumper_tab(reach, tab_w=34.0, h=PROFILE_H, wt=_tab_wt, style_mode=_act_tab_style) {
    if (reach > 0.1 && tab_w > 0.1) {
        difference() {
            // Solid outer envelope
            translate([-tab_w/2, 0, 0])
                cube([tab_w, reach, h]);
            
            // Hollow cutouts
            if (style_mode == 0 && reach >= 8.0) {
                // Dual-window truss with center reinforcing rib (matching reference photo)
                rib_t = wt;
                win_w = (tab_w - 2 * wt - rib_t) / 2;
                win_d = reach - wt;
                if (win_w > 1.0 && win_d > 1.0) {
                    // Window 1 (Left)
                    translate([-tab_w/2 + wt, -0.01, -0.01])
                        cube([win_w, win_d + 0.01, h + 0.02]);
                    // Window 2 (Right)
                    translate([tab_w/2 - wt - win_w, -0.01, -0.01])
                        cube([win_w, win_d + 0.01, h + 0.02]);
                }
            } else if (style_mode == 1 && reach >= 6.0) {
                // Single wide rectangular window
                win_w = tab_w - 2 * wt;
                win_d = reach - wt;
                if (win_w > 1.0 && win_d > 1.0) {
                    translate([-win_w/2, -0.01, -0.01])
                        cube([win_w, win_d + 0.01, h + 0.02]);
                }
            }
            // style_mode == 2 (Solid) leaves it solid
        }
    }
}

// Helper to determine active cell indices for bumper tabs along an edge of size count
function edge_tab_indices(count, offset) =
    (count >= 3) ? (
        (offset == 1) ? [1, count - 2] : [0, count - 1]
    ) : (
        (count == 2) ? [0, 1] : [0]
    );

// Assembles all bumper tabs around the perimeter of the active grid
module corner_bumper_tabs() {
    tab_w = 34.0; // Straight flat section of standard 42mm cell with r=4 corners
    
    // 1. Left Edge Bumper Tabs (extending along -X toward left drawer wall)
    if (ext_L > 0.1) {
        y_indices = edge_tab_indices(gy, _act_tab_offset);
        for (iy = y_indices) {
            y_center = ext_L_grid_base_y(iy);
            translate([ext_L, y_center, 0])
                rotate([0, 0, 90])
                    single_bumper_tab(reach=ext_L, tab_w=tab_w);
        }
    }
    
    // 2. Right Edge Bumper Tabs (extending along +X toward right drawer wall)
    if (ext_R > 0.1) {
        y_indices = edge_tab_indices(gy, _act_tab_offset);
        for (iy = y_indices) {
            y_center = ext_L_grid_base_y(iy);
            translate([ext_L + gx * GRID_PITCH, y_center, 0])
                rotate([0, 0, -90])
                    single_bumper_tab(reach=ext_R, tab_w=tab_w);
        }
    }
    
    // 3. Front Edge Bumper Tabs (extending along -Y toward front drawer wall)
    if (ext_F > 0.1) {
        x_indices = edge_tab_indices(gx, _act_tab_offset);
        for (ix = x_indices) {
            x_center = ext_L_grid_base_x(ix);
            translate([x_center, ext_F, 0])
                rotate([0, 0, 180])
                    single_bumper_tab(reach=ext_F, tab_w=tab_w);
        }
    }
    
    // 4. Back Edge Bumper Tabs (extending along +Y toward back drawer wall)
    if (ext_B > 0.1) {
        x_indices = edge_tab_indices(gx, _act_tab_offset);
        for (ix = x_indices) {
            x_center = ext_L_grid_base_x(ix);
            translate([x_center, ext_F + gy * GRID_PITCH, 0])
                rotate([0, 0, 0])
                    single_bumper_tab(reach=ext_B, tab_w=tab_w);
        }
    }
}

function ext_L_grid_base_x(ix) = ext_L + ix * GRID_PITCH + GRID_PITCH / 2;
function ext_L_grid_base_y(iy) = ext_F + iy * GRID_PITCH + GRID_PITCH / 2;

// ============================================================================
// Modules — Baseplate Structure
// ============================================================================

module solid_base() {
    // Only solid beneath the active grid cells + bumper tabs
    translate([ext_L, ext_F, 0])
        cube([gx * GRID_PITCH, gy * GRID_PITCH, PROFILE_H]);
    corner_bumper_tabs();
}

module custom_cell_envelope(w, d, h) {
    if (w >= 0.1 && d >= 0.1) {
        gf_cell_envelope(w, d, h);
    }
}

module skeleton_base() {
    if (_act_style == 0) {
        // Ultralight skeleton: envelope rings for the active cells forming corner diamonds
        for (ix = [0 : gx - 1]) {
            for (iy = [0 : gy - 1]) {
                x = ext_L + ix * GRID_PITCH + GRID_PITCH / 2;
                y = ext_F + iy * GRID_PITCH + GRID_PITCH / 2;
                translate([x, y, 0])
                    custom_cell_envelope(GRID_PITCH, GRID_PITCH, PROFILE_H);
            }
        }
        
        // Add corner bumper tabs
        corner_bumper_tabs();
        
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
        // Styles 1 & 2: Solid outer perimeter ribs around grid + bumper tabs
        wt = 1.2;
        h = PROFILE_H;
        
        // Internal grid divider walls
        if (gx > 1) {
            for (ix = [1:gx-1]) {
                translate([ext_L + ix * GRID_PITCH - wt/2, ext_F, 0])
                    cube([wt, gy * GRID_PITCH, h]);
            }
        }
        if (gy > 1) {
            for (iy = [1:gy-1]) {
                translate([ext_L, ext_F + iy * GRID_PITCH - wt/2, 0])
                    cube([gx * GRID_PITCH, wt, h]);
            }
        }
        
        // Outer perimeter of the active grid
        translate([ext_L, ext_F, 0]) {
            cube([gx * GRID_PITCH, wt, h]);
            translate([0, gy * GRID_PITCH - wt, 0]) cube([gx * GRID_PITCH, wt, h]);
            cube([wt, gy * GRID_PITCH, h]);
            translate([gx * GRID_PITCH - wt, 0, 0]) cube([wt, gy * GRID_PITCH, h]);
        }
        
        // Intersection reinforcement posts
        ps = wt * 2.5; 
        for (ix = [0:gx]) {
            for (iy = [0:gy]) {
                x = ext_L + ix * GRID_PITCH;
                y = ext_F + iy * GRID_PITCH;
                px = max(ext_L, min(x - ps/2, ext_L + gx * GRID_PITCH - ps));
                py = max(ext_F, min(y - ps/2, ext_F + gy * GRID_PITCH - ps));
                translate([px, py, 0]) cube([ps, ps, h]);
            }
        }
        
        // Add corner bumper tabs
        corner_bumper_tabs();
    }
}

module standard_base() {
    skeleton_base();
    translate([ext_L, ext_F, -0.4]) cube([gx * GRID_PITCH, gy * GRID_PITCH, 0.4]);
}

module solid_full_base() {
    solid_base();
    translate([ext_L, ext_F, -1.2]) cube([gx * GRID_PITCH, gy * GRID_PITCH, 1.2]);
}

// ============================================================================
// Modules — Wall Cutouts (Arched Doorways / Edge Cuts)
// ============================================================================

module divider_cutouts() {
    if (_act_wall_mode == 1) {
        // Mode 1: Arched Doorways through divider walls
        arch_w = 24.0;
        arch_h = 3.5;
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

module _doorway_arch(w, h, thk) {
    eff_w = min(w, GRID_PITCH - 8.0);
    eff_h = min(h, PROFILE_H - 0.6);
    r = eff_w / 2;
    straight_h = max(0, eff_h - r);
    translate([0, -thk/2, 0]) {
        rotate([-90, 0, 0]) {
            linear_extrude(height=thk) {
                hull() {
                    translate([-eff_w/2, 0]) square([eff_w, max(0.01, straight_h)]);
                    translate([0, straight_h]) circle(r=r, $fn=32);
                }
            }
        }
    }
}

// ============================================================================
// Assembly & Main Logic
// ============================================================================

module full_baseplate() {
    difference() {
        // Positive structure
        if (_act_style == 0) {
            skeleton_base();
        } else if (_act_style == 1) {
            standard_base();
        } else {
            solid_full_base();
        }
        
        // Pockets & mounting holes for all active grid cells
        for (ix = [0 : gx - 1]) {
            for (iy = [0 : gy - 1]) {
                x = ext_L + ix * GRID_PITCH + GRID_PITCH / 2;
                y = ext_F + iy * GRID_PITCH + GRID_PITCH / 2;
                translate([x, y, 0]) {
                    pocket();
                    if (_act_holes > 0) {
                        gf_corner_holes(count=_act_holes, magnet_d=magnet_diameter, screw_d=screw_diameter, h=PROFILE_H);
                    }
                }
            }
        }
        
        // Divider cutouts (arched doorways or edge cuts)
        divider_cutouts();
    }
}

// ============================================================================
// Print Bed Tiling & Assembly
// ============================================================================

module puzzle_tab(clearance=0) {
    tw = 8.0 + clearance;
    tl = 6.0;
    nw = 4.0 - clearance;
    linear_extrude(height=PROFILE_H) {
        polygon(points=[
            [-nw/2, 0],
            [-tw/2, tl],
            [ tw/2, tl],
            [ nw/2, 0]
        ]);
    }
}

module single_tile(tx, ty) {
    x_start_cell = tx * cells_per_tile_x;
    x_end_cell   = min(gx, (tx + 1) * cells_per_tile_x);
    y_start_cell = ty * cells_per_tile_y;
    y_end_cell   = min(gy, (ty + 1) * cells_per_tile_y);
    
    // Bounds in plate space
    tile_min_x = (tx == 0) ? 0 : (ext_L + x_start_cell * GRID_PITCH);
    tile_max_x = (tx == tiles_x - 1) ? total_w : (ext_L + x_end_cell * GRID_PITCH);
    tile_min_y = (ty == 0) ? 0 : (ext_F + y_start_cell * GRID_PITCH);
    tile_max_y = (ty == tiles_y - 1) ? total_d : (ext_F + y_end_cell * GRID_PITCH);
    
    tile_w = tile_max_x - tile_min_x;
    tile_d = tile_max_y - tile_min_y;
    
    difference() {
        union() {
            // Intersect full baseplate with tile bounding box
            intersection() {
                full_baseplate();
                translate([tile_min_x, tile_min_y, -2])
                    cube([tile_w, tile_d, PROFILE_H + 4]);
            }
            
            // Male puzzle tabs (East & North borders)
            if (tx < tiles_x - 1) {
                // East border
                for (iy = [y_start_cell : y_end_cell - 1]) {
                    y_pos = ext_F + iy * GRID_PITCH + GRID_PITCH / 2;
                    translate([tile_max_x, y_pos, 0])
                        rotate([0, 0, -90])
                            puzzle_tab(clearance=0);
                }
            }
            if (ty < tiles_y - 1) {
                // North border
                for (ix = [x_start_cell : x_end_cell - 1]) {
                    x_pos = ext_L + ix * GRID_PITCH + GRID_PITCH / 2;
                    translate([x_pos, tile_max_y, 0])
                        rotate([0, 0, 0])
                            puzzle_tab(clearance=0);
                }
            }
        }
        
        // Female puzzle sockets (West & South borders)
        if (tx > 0) {
            // West border
            for (iy = [y_start_cell : y_end_cell - 1]) {
                y_pos = ext_F + iy * GRID_PITCH + GRID_PITCH / 2;
                translate([tile_min_x, y_pos, -0.1])
                    rotate([0, 0, -90])
                        puzzle_tab(clearance=0.25);
            }
        }
        if (ty > 0) {
            // South border
            for (ix = [x_start_cell : x_end_cell - 1]) {
                x_pos = ext_L + ix * GRID_PITCH + GRID_PITCH / 2;
                translate([x_pos, tile_min_y, -0.1])
                    rotate([0, 0, 0])
                        puzzle_tab(clearance=0.25);
            }
        }
        
        // Coordinate label
        if (enable_labels && _act_tiling) {
            label_text = str(tx + 1, "/", ty + 1);
            translate([tile_min_x + 8, tile_min_y + 8, PROFILE_H - 0.4]) {
                linear_extrude(height=0.5) {
                    text(label_text, size=5, font="Liberation Sans:style=Bold", halign="center", valign="center");
                }
            }
        }
    }
}

// Scene rendering
if (!_act_tiling) {
    // Single monolithic plate (no tiling)
    full_baseplate();
} else {
    // Tiled mode
    if (part_to_render == 0) {
        // Exploded view of all tiles
        for (tx = [0 : tiles_x - 1]) {
            for (ty = [0 : tiles_y - 1]) {
                translate([tx * (bed_x_mm + tile_gap_mm), ty * (bed_y_mm + tile_gap_mm), 0])
                    single_tile(tx, ty);
            }
        }
    } else {
        // Render single selected tile
        target_idx = part_to_render - 1;
        target_tx = target_idx % tiles_x;
        target_ty = floor(target_idx / tiles_x);
        if (target_tx < tiles_x && target_ty < tiles_y) {
            single_tile(target_tx, target_ty);
        } else {
            echo(str("ERROR: part_to_render ", part_to_render, " is out of bounds (max ", tiles_x * tiles_y, ")"));
        }
    }
}
