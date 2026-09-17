// ============================================================================
// Gridfinity Core Geometry Engine
// ============================================================================
// Standard constants, modules, and calculations derived strictly from:
//   - Official Gridfinity Specification v5: https://gridfinity.xyz/specification/
//   - Paul Bone's gfthings: https://github.com/PaulBone/gfthings
//
// Key standards:
//   - Pitch: 42.0 mm center-to-center
//   - Tolerance: 0.25 mm clearance per side (0.5 mm total)
//   - Socket Mouth: 42.0 mm (r = 4.0 mm)
//   - Top Chamfer: 2.15 mm @ 45°
//   - Vertical Waist: 1.80 mm @ 37.7 mm width (r = 1.85 mm)
//   - Bottom Chamfer / Ledge: 0.70 mm @ 45° down to 36.3 mm (r = 1.15 mm)
//   - Socket Depth: 4.65 mm (leaves 0.1 mm clearance relief below 4.75 mm bin foot)
//   - Hole Spacing: 26.0 mm square (13.0 mm from cell center)
// ============================================================================

$fn = 32;

// ---- Grid Pitch & Tolerance ----
GF_PITCH            = 42.0;   // Standard cell spacing (mm)
GF_TOLERANCE        = 0.25;   // Clearance per side (mm)

// ---- Bin Foot Dimensions (Reference) ----
GF_BIN_TOP_W        = 41.50;  // 42.0 - 2 * 0.25
GF_BIN_WAIST_W      = 37.20;  // 41.5 - 2 * 2.15
GF_BIN_BOT_W        = 35.60;  // 37.2 - 2 * 0.80
GF_BIN_TOP_CHAMFER  = 2.15;
GF_BIN_VERT_WAIST   = 1.80;
GF_BIN_BOT_CHAMFER  = 0.80;
GF_BIN_PROFILE_H    = 4.75;   // 2.15 + 1.80 + 0.80
GF_BIN_TOP_R        = 3.75;   // 7.5mm dia
GF_BIN_WAIST_R      = 1.60;   // 3.75 - 2.15
GF_BIN_BOT_R        = 0.80;   // 1.60 - 0.80

// ---- Baseplate Socket Dimensions (+0.25mm Clearance Offset) ----
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

// ---- Mounting Holes (Magnets & Screws) ----
GF_HOLE_OFFSET      = 13.0;   // Offset from cell center along X & Y (mm)
GF_HOLE_SPACING     = 26.0;   // Center-to-center hole distance (mm)
GF_MAGNET_D         = 6.2;    // Magnet hole diameter (mm, press fit for 6.0mm)
GF_MAGNET_H         = 2.2;    // Magnet hole depth (mm)
GF_SCREW_D          = 3.2;    // Screw hole diameter (mm, clearance for M3)

// ---- Geometry Helper Modules ----

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
        // 2 holes at opposite diagonal corners (matching gfthings default)
        _gf_single_corner_hole(-GF_HOLE_OFFSET, -GF_HOLE_OFFSET, magnet_d, magnet_h, screw_d, h);
        _gf_single_corner_hole( GF_HOLE_OFFSET,  GF_HOLE_OFFSET, magnet_d, magnet_h, screw_d, h);
    } else if (count >= 4) {
        // 4 holes in all 4 corners
        for (sx = [-1, 1]) {
            for (sy = [-1, 1]) {
                _gf_single_corner_hole(sx * GF_HOLE_OFFSET, sy * GF_HOLE_OFFSET, magnet_d, magnet_h, screw_d, h);
            }
        }
    }
}

// Helper for a single corner hole (magnet counterbore from bottom + through screw hole)
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
