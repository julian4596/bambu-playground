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
// 0=Ultralight (walls only), 1=Standard (thin floor), 2=Solid (thick floor)
style = 0; // [0:Ultralight, 1:Standard, 2:Solid]

/* [04 — Extension Distribution] */
// How to distribute leftover space on each axis
// 0=Split evenly both sides, 1=Right/Back only, 2=Left/Front only
extension_mode = 0; // [0:Even Split, 1:Right-Back Only, 2:Left-Front Only]

/* [05 — Options] */
// Add 6mm x 2.4mm magnet holes at grid intersections
magnet_holes = false;
// Add M3 screw holes at grid intersections
screw_holes = false;

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

// Debug output
echo(str("=== Ultralight Spacerless Gridfinity ==="));
echo(str("Grid: ", gx, " x ", gy));
echo(str("Extensions — L:", ext_L, " R:", ext_R, " F:", ext_F, " B:", ext_B, " mm"));
echo(str("Total: ", total_w, " x ", total_d, " mm"));
echo(str("Style: ", style == 0 ? "Ultralight" : style == 1 ? "Standard" : "Solid"));

// ============================================================================
// Modules — Profile Geometry
// ============================================================================

// Creates the pocket void for one grid cell.
// Origin at center XY, bottom at Z=0.
// The pocket is built as three hull() sections representing the
// stepped/chamfered Gridfinity profile.
module pocket() {
    // Bottom chamfer: 45° from POCKET_BOT up to POCKET_MID
    hull() {
        translate([0, 0, 0])
            centered_rect(POCKET_BOT, POCKET_BOT, 0.01);
        translate([0, 0, CHAMFER_BOT_H])
            centered_rect(POCKET_MID, POCKET_MID, 0.01);
    }
    
    // Vertical wall section
    translate([0, 0, CHAMFER_BOT_H])
        centered_rect(POCKET_MID, POCKET_MID, WALL_VERT_H);
    
    // Top chamfer: 45° from POCKET_MID up to POCKET_TOP
    hull() {
        translate([0, 0, CHAMFER_BOT_H + WALL_VERT_H])
            centered_rect(POCKET_MID, POCKET_MID, 0.01);
        translate([0, 0, PROFILE_H])
            centered_rect(POCKET_TOP, POCKET_TOP, 0.01);
    }
    
    // Extend pocket above profile to ensure clean cut
    translate([0, 0, PROFILE_H])
        centered_rect(POCKET_TOP, POCKET_TOP, 1);
}

// Helper: centered rectangle (cube centered on XY, bottom at current Z)
module centered_rect(w, d, h) {
    translate([-w/2, -d/2, 0])
        cube([w, d, h]);
}

// ============================================================================
// Modules — Baseplate Structure
// ============================================================================

// Solid block covering the entire grid area at profile height
module solid_base() {
    cube([total_w, total_d, PROFILE_H]);
}

// Ultralight skeleton: only grid-line walls + corner posts
module skeleton_base() {
    wt = WALL_MIN;
    
    // Walls along Y (vertical lines of the grid)
    for (ix = [0:gx]) {
        x = ext_L + ix * GRID_PITCH;
        // Center the wall on the grid line
        wx = max(0, min(x - wt/2, total_w - wt));
        translate([wx, 0, 0])
            cube([wt, total_d, PROFILE_H]);
    }
    
    // Walls along X (horizontal lines of the grid)
    for (iy = [0:gy]) {
        y = ext_F + iy * GRID_PITCH;
        wy = max(0, min(y - wt/2, total_d - wt));
        translate([0, wy, 0])
            cube([total_w, wt, PROFILE_H]);
    }
    
    // Reinforcement posts at every intersection
    ps = wt * 2.5;
    for (ix = [0:gx]) {
        for (iy = [0:gy]) {
            x = ext_L + ix * GRID_PITCH;
            y = ext_F + iy * GRID_PITCH;
            px = max(0, min(x - ps/2, total_w - ps));
            py = max(0, min(y - ps/2, total_d - ps));
            translate([px, py, 0])
                cube([ps, ps, PROFILE_H]);
        }
    }
    
    // Extension fill walls (solid fill for extension areas)
    // Left extension fill
    if (ext_L > 0.01)
        cube([ext_L, total_d, PROFILE_H]);
    // Right extension fill
    if (ext_R > 0.01)
        translate([total_w - ext_R, 0, 0])
            cube([ext_R, total_d, PROFILE_H]);
    // Front extension fill
    if (ext_F > 0.01)
        cube([total_w, ext_F, PROFILE_H]);
    // Back extension fill
    if (ext_B > 0.01)
        translate([0, total_d - ext_B, 0])
            cube([total_w, ext_B, PROFILE_H]);
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
        
        // Subtract pockets for every grid cell
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
// Render
// ============================================================================

ultralight_spacerless_baseplate();
