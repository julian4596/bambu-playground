// ============================================================================
// Ultralight Arched Doorway Gridfinity Baseplate
// ============================================================================
// A parametric, MakerWorld-compatible OpenSCAD script that generates
// ultra-lightweight Gridfinity baseplates featuring an arched doorway profile.
//
// Features:
//   - Arched doorway cutouts through divider walls extending to bed (Z = 0)
//   - Continuous 45° top lead-in funnel rim for smooth bin insertion
//   - Sturdy corner pillars with central diamond voids at cell intersections
//   - Solid outer drawer frame perimeter to prevent dust/debris ingress
//   - Spacerless auto-fit to drawer dimensions with zero wasted space
//   - Built-in bed tiling and exploded scene preview with tile labels
//   - MakerWorld Customizer compatible
//
// Author: Julian (generated with AI assistance)
// License: CC BY-SA 4.0
// ============================================================================

// ---- Gridfinity Standard Constants ----
GRID_PITCH  = 42.0;                         // mm - standard grid unit size
TOLERANCE   = 0.25;                         // mm - clearance per side (bin-to-baseplate)
POCKET_TOP  = GRID_PITCH - 2 * TOLERANCE;   // 41.5mm - mouth opening at top
PROFILE_H   = 4.75;                         // mm - standard Gridfinity baseplate height
CHAMFER_H   = 1.25;                         // mm - 45° top guide chamfer height
POCKET_MID  = POCKET_TOP - 2 * CHAMFER_H;   // 39.0mm - lower pocket opening at Z = 3.5mm

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
cells_per_tile_x = tiling_mode ? max(1, floor((bed_x_mm - 2 * bed_safe_margin_mm - 15) / GRID_PITCH)) : gx;
cells_per_tile_y = tiling_mode ? max(1, floor((bed_y_mm - 2 * bed_safe_margin_mm - 15) / GRID_PITCH)) : gy;

tiles_x = tiling_mode ? ceil(gx / cells_per_tile_x) : 1;
tiles_y = tiling_mode ? ceil(gy / cells_per_tile_y) : 1;

// Debug output
echo(str("=== Ultralight Arched Doorway Gridfinity ==="));
echo(str("Grid: ", gx, " x ", gy));
echo(str("Extensions — L:", ext_L, " R:", ext_R, " F:", ext_F, " B:", ext_B, " mm"));
echo(str("Total: ", total_w, " x ", total_d, " mm"));
echo(str("Doorway: ", doorway_width, " x ", doorway_height, " mm"));
echo(str("Tiling: ", tiles_x, " x ", tiles_y, " tiles (", cells_per_tile_x, "x", cells_per_tile_y, " max cells per tile)"));

// ============================================================================
// Helper Geometry Modules
// ============================================================================

// Helper: centered rectangle with rounded corners
module rounded_centered_rect(w, d, h, r=4.0) {
    eff_r = min(r, w/2, d/2);
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

// Pocket cutout: 45° top lead-in funnel and through-cut down to table surface
module pocket() {
    // 45° top guide funnel from Z = PROFILE_H - CHAMFER_H up to PROFILE_H
    hull() {
        translate([0, 0, PROFILE_H - CHAMFER_H])
            rounded_centered_rect(POCKET_MID, POCKET_MID, 0.01, r=4.0 - CHAMFER_H);
        translate([0, 0, PROFILE_H])
            rounded_centered_rect(POCKET_TOP, POCKET_TOP, 0.01, r=4.0);
    }
    // Clean upper clearance cut
    translate([0, 0, PROFILE_H])
        rounded_centered_rect(POCKET_TOP, POCKET_TOP, 1.0, r=4.0);

    // Through-cut body down to table surface (Z = 0, extended to Z = -1 for clean difference)
    translate([0, 0, -1.0])
        rounded_centered_rect(POCKET_MID, POCKET_MID, PROFILE_H - CHAMFER_H + 1.01, r=4.0 - CHAMFER_H);
}

// 2D profile of arched doorway with top corner fillets
module doorway_profile_2d(w, h, r=4.0) {
    eff_r = min(r, w/2, h);
    hull() {
        // Extend below Z = 0 for clean difference cut
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
module diamond_cutout(r=4.25, h=PROFILE_H) {
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

        // Subtract bin pockets for each cell
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
                cube([POCKET_MID + 2.0, POCKET_MID + 2.0, 0.8], center=true);
            translate([0, 0, -1.0])
                linear_extrude(3.0)
                    text(str(tx + 1, "/", ty + 1), size=8, halign="center", valign="center");
        }
    }
}

// ============================================================================
// Final Render Assembly
// ============================================================================

if (!tiling_mode) {
    arched_baseplate();
} else {
    for (tx = [0 : tiles_x - 1]) {
        for (ty = [0 : tiles_y - 1]) {
            tile_index = 1 + tx + ty * tiles_x;
            
            if (part_to_render == 0 || part_to_render == tile_index) {
                // Explode translation for scene overview
                offset_x = (part_to_render == 0) ? tx * tile_gap_mm : 0;
                offset_y = (part_to_render == 0) ? ty * tile_gap_mm : 0;
                
                // Center specific tile on origin for single-part export, or center full exploded assembly
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
