// ============================================================================
// Ultralight Spacerless Gridfinity Baseplate
// ============================================================================
// A parametric, MakerWorld-compatible OpenSCAD script that generates
// ultra-lightweight Gridfinity baseplates that auto-fit your drawer
// dimensions with zero wasted space.
//
// Features:
//   - Spacerless auto-fit: input drawer dimensions, get a perfect fit
//   - Three styles: Ultralight (skeleton), Standard (thin floor), Solid
//   - Optional magnet and screw holes
//   - MakerWorld Customizer compatible
//
// Author: Julian (generated with AI assistance)
// License: CC BY-SA 4.0
// ============================================================================

// ---- Gridfinity Standard Constants ----
// These define the Gridfinity standard. Do not change unless you
// understand the Gridfinity specification.
GRID_PITCH     = 42;      // mm - standard grid unit size
TOLERANCE      = 0.25;    // mm - clearance per side (bin-to-baseplate)
WALL_MIN       = 1.2;     // mm - minimum wall thickness (3 × 0.4mm)
MAGNET_D       = 6.0;     // mm - magnet hole diameter
MAGNET_H       = 2.4;     // mm - magnet hole depth
SCREW_D        = 3.2;     // mm - M3 screw hole diameter

// Gridfinity baseplate pocket profile (cross-section, bottom to top):
//   Layer 1: 45° chamfer inward  — 0.8mm tall, narrows 0.8mm per side
//   Layer 2: Vertical wall       — 1.8mm tall, straight
//   Layer 3: 45° chamfer outward — 2.15mm tall, widens 2.15mm per side
CHAMFER_BOT_H = 0.8;
WALL_VERT_H   = 1.8;
CHAMFER_TOP_H = 2.15;
PROFILE_H     = CHAMFER_BOT_H + WALL_VERT_H + CHAMFER_TOP_H; // ≈ 4.75mm

// Pocket dimensions (the void bins sit in)
// At the TOP of the pocket, the opening is the full cell minus tolerance
POCKET_TOP = GRID_PITCH - 2 * TOLERANCE;  // 41.5mm
// The mid-section (after top chamfer, before bottom chamfer)
POCKET_MID = POCKET_TOP - 2 * CHAMFER_TOP_H;  // 37.2mm
// At the BOTTOM, it narrows further
POCKET_BOT = POCKET_MID - 2 * CHAMFER_BOT_H;  // 35.6mm

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

/* [03 — Baseplate Style] */
// 0=Super Light (Flat grid, no overhangs), 1=Standard (thin floor), 2=Solid (thick floor)
style = 0; // [0:Super Light, 1:Standard, 2:Solid]

/* [04 — Extension Distribution] */
// How to distribute leftover space on each axis
// 0=Split evenly both sides, 1=Right/Back only, 2=Left/Front only
extension_mode = 0; // [0:Even Split, 1:Right-Back Only, 2:Left-Front Only]

/* [05 — Options] */
// Add 6mm x 2.4mm magnet holes at grid intersections
magnet_holes = false;
// Add M3 screw holes at grid intersections
screw_holes = false;

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
$fn = 40;

// ============================================================================
// Auto-Fit Calculation
// ============================================================================

_usable_w = drawer_width_mm - 2 * clearance_per_side;
_usable_d = drawer_depth_mm - 2 * clearance_per_side;

_auto_gx = max(1, floor(_usable_w / GRID_PITCH));
_auto_gy = max(1, floor(_usable_d / GRID_PITCH));

_left_x = _usable_w - _auto_gx * GRID_PITCH;
_left_y = _usable_d - _auto_gy * GRID_PITCH;

gx = use_auto_fit ? _auto_gx : manual_grid_x;
gy = use_auto_fit ? _auto_gy : manual_grid_y;

ext_tx = use_auto_fit ? max(0, _left_x) : 0;
ext_ty = use_auto_fit ? max(0, _left_y) : 0;

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
// We reserve margin for the physical bed edge + ~15mm for puzzle joints & frame extensions
cells_per_tile_x = tiling_mode ? max(1, floor((bed_x_mm - 2 * bed_safe_margin_mm - 15) / GRID_PITCH)) : gx;
cells_per_tile_y = tiling_mode ? max(1, floor((bed_y_mm - 2 * bed_safe_margin_mm - 15) / GRID_PITCH)) : gy;

tiles_x = tiling_mode ? ceil(gx / cells_per_tile_x) : 1;
tiles_y = tiling_mode ? ceil(gy / cells_per_tile_y) : 1;

// Debug output
echo(str("=== Ultralight Spacerless Gridfinity ==="));
echo(str("Grid: ", gx, " x ", gy));
echo(str("Extensions — L:", ext_L, " R:", ext_R, " F:", ext_F, " B:", ext_B, " mm"));
echo(str("Total: ", total_w, " x ", total_d, " mm"));
echo(str("Style: ", style == 0 ? "Ultralight" : style == 1 ? "Standard" : "Solid"));
echo(str("Tiling: ", tiles_x, " x ", tiles_y, " tiles (", cells_per_tile_x, "x", cells_per_tile_y, " max cells per tile)"));

// ============================================================================
// Modules — Profile Geometry
// ============================================================================

module pocket() {
    if (style == 0) {
        // Style 0: Flat-walled pocket with stacking lip recess
        // This creates uniform wall thickness and the stepped underside flange.
        
        // Main through-cut: uniform 41.5mm opening from lip_depth to top
        translate([0, 0, CHAMFER_BOT_H])
            rounded_centered_rect(POCKET_TOP, POCKET_TOP, PROFILE_H - CHAMFER_BOT_H + 1, r=4);
        
        // Stacking lip: chamfered recess at the very bottom
        hull() {
            translate([0, 0, -0.01])
                rounded_centered_rect(POCKET_TOP + 2 * CHAMFER_BOT_H, POCKET_TOP + 2 * CHAMFER_BOT_H, 0.01, r=4 + CHAMFER_BOT_H);
            translate([0, 0, CHAMFER_BOT_H])
                rounded_centered_rect(POCKET_TOP, POCKET_TOP, 0.01, r=4);
        }
    } else {
        // Standard Gridfinity 3-layer pocket profile
        hull() {
            translate([0, 0, 0])
                rounded_centered_rect(POCKET_BOT, POCKET_BOT, 0.01, r=1.05);
            translate([0, 0, CHAMFER_BOT_H])
                rounded_centered_rect(POCKET_MID, POCKET_MID, 0.01, r=1.85);
        }
        
        translate([0, 0, CHAMFER_BOT_H])
            rounded_centered_rect(POCKET_MID, POCKET_MID, WALL_VERT_H, r=1.85);
        
        hull() {
            translate([0, 0, CHAMFER_BOT_H + WALL_VERT_H])
                rounded_centered_rect(POCKET_MID, POCKET_MID, 0.01, r=1.85);
            translate([0, 0, PROFILE_H])
                rounded_centered_rect(POCKET_TOP, POCKET_TOP, 0.01, r=4);
        }
        
        translate([0, 0, PROFILE_H])
            rounded_centered_rect(POCKET_TOP, POCKET_TOP, 1, r=4);
    }
}

// Helper: rounded centered rectangle (matching standard 4mm Gridfinity corner radius at top opening)
module rounded_centered_rect(w, d, h, r=-1) {
    // If r is not provided (-1), calculate the correct corner radius based on Gridfinity standard
    base_r = (r == -1) ? max(0.1, 4 - (POCKET_TOP - w)/2) : r;
    eff_r = min(base_r, w/2, d/2);
    hull() {
        for (x = [-w/2 + eff_r, w/2 - eff_r]) {
            for (y = [-d/2 + eff_r, d/2 - eff_r]) {
                translate([x, y, 0])
                    cylinder(r=eff_r, h=h);
            }
        }
    }
}

// ============================================================================
// Modules — Baseplate Structure
// ============================================================================

// Solid block covering the entire grid area at profile height
module solid_base() {
    cube([total_w, total_d, PROFILE_H]);
}

module custom_ring(w, d, h) {
    if (w >= 0.1 && d >= 0.1) {
        difference() {
            // Outer shape (solid boundary). For standard Gridfinity styling with uniform walls
            // and mathematically perfect chamfered diamond holes, outer radius is 4.25.
            rounded_centered_rect(w, d, h, r=min(4.25, w/2, d/2));
            
            // Inner void (ONLY hollow out if it's an extension, i.e., smaller than a full cell)
            // Standard cells will be hollowed out by the 3D pocket() chamfers.
            if ((w < GRID_PITCH - 0.1 || d < GRID_PITCH - 0.1) && w > 4.8 && d > 4.8) {
                translate([0, 0, -1])
                    rounded_centered_rect(w - 4.8, d - 4.8, h + 2, r=min(1.85, (w - 4.8)/2, (d - 4.8)/2));
            }
        }
    }
}

// Ultralight skeleton: thin walls with thick intersection hubs
module skeleton_base() {
    if (style == 0) {
        // "Lightest Baseplate" style: Use offset rings that perfectly merge
        // on the straights (forming 4.8mm walls) and pull away at the corners
        // (forming diamond holes). The outer boundary naturally has r=6.4 corners.
        // Extensions are drawn using custom-sized hollow rings to match the style.
        h = PROFILE_H; // Use full height to allow 3D chamfers
        
        for (ix = [-1 : gx]) {
            for (iy = [-1 : gy]) {
                // Determine width and center X for this cell/extension
                w = (ix == -1) ? ext_L : ((ix == gx) ? ext_R : GRID_PITCH);
                x = (ix == -1) ? (ext_L / 2) : ((ix == gx) ? (ext_L + gx * GRID_PITCH + ext_R / 2) : (ext_L + ix * GRID_PITCH + GRID_PITCH / 2));
                
                // Determine depth and center Y for this cell/extension
                d = (iy == -1) ? ext_F : ((iy == gy) ? ext_B : GRID_PITCH);
                y = (iy == -1) ? (ext_F / 2) : ((iy == gy) ? (ext_F + gy * GRID_PITCH + ext_B / 2) : (ext_F + iy * GRID_PITCH + GRID_PITCH / 2));
                
                if (w > 0.01 && d > 0.01) {
                    translate([x, y, 0])
                        custom_ring(w, d, h);
                }
            }
        }
    } else {
        wt = WALL_MIN;
        h = PROFILE_H;
        wt_cut = max(wt, 8); // Thicker wall for tile cut boundaries
        
        // Walls along Y (vertical lines of the grid)
        for (ix = [0:gx]) {
            is_cut = tiling_mode && ix > 0 && ix < gx && (ix % cells_per_tile_x == 0);
            cur_wt = is_cut ? wt_cut : wt;
            
            x = ext_L + ix * GRID_PITCH;
            wx = max(0, min(x - cur_wt/2, total_w - cur_wt));
            translate([wx, 0, 0]) cube([cur_wt, total_d, h]);
        }
        
        // Walls along X (horizontal lines of the grid)
        for (iy = [0:gy]) {
            is_cut = tiling_mode && iy > 0 && iy < gy && (iy % cells_per_tile_y == 0);
            cur_wt = is_cut ? wt_cut : wt;
            
            y = ext_F + iy * GRID_PITCH;
            wy = max(0, min(y - cur_wt/2, total_d - cur_wt));
            translate([0, wy, 0]) cube([total_w, cur_wt, h]);
        }
        
        // Reinforcement hubs at every intersection
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
    
    // Extension areas — lightweight perimeter + cross-brace ribs
    // Left extension: perimeter wall + horizontal ribs
    if (ext_L > 0.01) {
        cube([wt, total_d, h]);
        for (iy = [0:gy]) {
            y = ext_F + iy * GRID_PITCH;
            wy = max(0, min(y - wt/2, total_d - wt));
            translate([0, wy, 0]) cube([ext_L, wt, h]);
        }
    }
    // Right extension
    if (ext_R > 0.01) {
        translate([total_w - wt, 0, 0]) cube([wt, total_d, h]);
        for (iy = [0:gy]) {
            y = ext_F + iy * GRID_PITCH;
            wy = max(0, min(y - wt/2, total_d - wt));
            translate([total_w - ext_R, wy, 0]) cube([ext_R, wt, h]);
        }
    }
    // Front extension
    if (ext_F > 0.01) {
        cube([total_w, wt, h]);
        for (ix = [0:gx]) {
            x = ext_L + ix * GRID_PITCH;
            wx = max(0, min(x - wt/2, total_w - wt));
            translate([wx, 0, 0]) cube([wt, ext_F, h]);
        }
    }
        // Back extension
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

// Standard base: skeleton + thin floor
module standard_base() {
    skeleton_base();
    // Thin floor plate (0.4mm — single nozzle layer)
    translate([0, 0, -0.4])
        cube([total_w, total_d, 0.4]);
}

// Solid base with thick floor
module solid_full_base() {
    solid_base();
    // Thick floor plate (1.2mm — 3 layers)
    translate([0, 0, -1.2])
        cube([total_w, total_d, 1.2]);
}

// ============================================================================
// Modules — Holes
// ============================================================================

// Place magnet/screw holes at all grid intersection points
module all_holes() {
    for (ix = [0:gx]) {
        for (iy = [0:gy]) {
            x = ext_L + ix * GRID_PITCH;
            y = ext_F + iy * GRID_PITCH;
            
            if (magnet_holes) {
                // Magnet hole from bottom
                translate([x, y, -0.01])
                    cylinder(d=MAGNET_D, h=MAGNET_H + 0.01, $fn=30);
            }
            if (screw_holes) {
                // Screw hole all the way through
                translate([x, y, -1.5])
                    cylinder(d=SCREW_D, h=PROFILE_H + 3, $fn=20);
            }
        }
    }
}

// ============================================================================
// Main Assembly
// ============================================================================

module ultralight_spacerless_baseplate() {
    difference() {
        // Positive geometry (choose style)
        if (style == 0)
            skeleton_base();
        else if (style == 1)
            standard_base();
        else
            solid_full_base();
        
        // Subtract pockets for every grid cell (for ALL styles, including style 0)
        for (cx = [0:gx-1]) {
            for (cy = [0:gy-1]) {
                x = ext_L + cx * GRID_PITCH + GRID_PITCH / 2;
                y = ext_F + cy * GRID_PITCH + GRID_PITCH / 2;
                translate([x, y, -0.01])
                    pocket();
            }
        }
        
        // Subtract magnet/screw holes
        if (magnet_holes || screw_holes)
            all_holes();
    }
}

// ============================================================================
// Tile Masking & Dovetails
// ============================================================================

module puzzle_tab(clearance=0) {
    // Connects from X=0 to X=4, circle at X=4
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
            // Main bounding box for this tile
            translate([x_min, y_min, -2])
                cube([w, d, PROFILE_H + 4]);
                
            if (style != 0) {
                // Add tabs on the right edge (if not last tile)
                if (tx < tiles_x - 1) {
                    for (cy = [start_cy : end_cy - 1]) {
                        y = ext_F + cy * GRID_PITCH + GRID_PITCH/2;
                        translate([x_max, y, PROFILE_H/2 - 1])
                            puzzle_tab(0);
                    }
                }
                
                // Add tabs on the top edge (if not last tile)
                if (ty < tiles_y - 1) {
                    for (cx = [start_cx : end_cx - 1]) {
                        x = ext_L + cx * GRID_PITCH + GRID_PITCH/2;
                        translate([x, y_max, PROFILE_H/2 - 1])
                            rotate([0, 0, 90]) puzzle_tab(0);
                    }
                }
            }
        }
        
        if (style != 0) {
            // Subtract tabs on the left edge (if not first tile)
            if (tx > 0) {
                for (cy = [start_cy : end_cy - 1]) {
                    y = ext_F + cy * GRID_PITCH + GRID_PITCH/2;
                    translate([x_min, y, PROFILE_H/2 - 1])
                        puzzle_tab(0.2); // 0.2mm clearance for easy fit
                }
            }
            
            // Subtract tabs on the bottom edge (if not first tile)
            if (ty > 0) {
                for (cx = [start_cx : end_cx - 1]) {
                    x = ext_L + cx * GRID_PITCH + GRID_PITCH/2;
                    translate([x, y_min, PROFILE_H/2 - 1])
                        rotate([0, 0, 90]) puzzle_tab(0.2); // 0.2mm clearance
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
            // Thin floor
            translate([0, 0, 0.4]) cube([POCKET_BOT, POCKET_BOT, 0.8], center=true);
            // Cut text through it
            translate([0, 0, -1]) linear_extrude(3)
                text(str(tx+1, "/", ty+1), size=8, halign="center", valign="center");
        }
    }
}

// ============================================================================
// Render
// ============================================================================

if (!tiling_mode) {
    ultralight_spacerless_baseplate();
} else {
    // Exploded View or specific tile
    for (tx = [0 : tiles_x - 1]) {
        for (ty = [0 : tiles_y - 1]) {
            tile_index = 1 + tx + ty * tiles_x;
            
            if (part_to_render == 0 || part_to_render == tile_index) {
                
                // Explode translation
                offset_x = (part_to_render == 0) ? tx * tile_gap_mm : 0;
                offset_y = (part_to_render == 0) ? ty * tile_gap_mm : 0;
                
                // Center specific tile for export, or center entire exploded assembly
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
