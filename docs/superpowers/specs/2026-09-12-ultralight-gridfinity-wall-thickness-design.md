# Ultralight Gridfinity Baseplate Design Spec

## Overview
This specification details the geometry and parameter redesign for the Ultralight Spacerless Gridfinity Baseplate OpenSCAD script. The redesign resolves two opposing defects observed across previous iterations:
1. **Pockets too small** (`Ultralight_Gridfinity.scad`): A uniform 37.2 mm straight vertical cutout jammed bins that flared out toward the 41.5 mm waist.
2. **Walls too thin** (`Thinnest ever.scad`): A straight 41.5 mm through-cut reduced the divider walls between cells to 0.5 mm (a single fragile 0.4 mm nozzle bead) with zero material at rounded corners.

The solution provides a **configurable divider wall thickness** (`divider_wall_thickness`) with a default of **2.4 mm** (producing ~6 solid perimeters), while introducing a **45° top chamfer funnel** expanding to 41.5 mm so bins drop in freely without snagging.

---

## Key Terminology & Geometric Definitions

* **Grid Pitch (`GRID_PITCH` = 42.0 mm):** Center-to-center distance between adjacent Gridfinity cells. Locked to official standard; never changes.
* **Top Pocket Opening (`POCKET_TOP` = 41.5 mm):** The widest mouth of the pocket opening (42.0 mm minus 2 × 0.25 mm clearance tolerance).
* **Divider Wall Thickness (`divider_wall_thickness`):** The horizontal thickness of the upright rib separating two adjacent grid cells. Default is 2.4 mm, user-adjustable between 1.2 mm and 4.8 mm.
* **Mid Pocket Opening (`pocket_mid`):** Derived from `GRID_PITCH - divider_wall_thickness`. At 2.4 mm wall thickness, `pocket_mid = 39.6 mm`.
* **Chamfer Funnel (`CHAMFER_TOP_H`):** A 45° angled lead-in running from `POCKET_TOP` (41.5 mm) down to `pocket_mid` (39.6 mm) over a vertical height of `(POCKET_TOP - pocket_mid) / 2`. At 2.4 mm wall thickness, the chamfer height is `(41.5 - 39.6) / 2 = 0.95 mm`.
* **Skeleton Base (Style 0):** Bottomless frame (0 mm floor thickness) with hollow diamond cutouts at cell corner junctions for maximum filament and print-time savings.

---

## Pocket Profile Geometry

### Cross-Section (Vertical Profile)

```text
               ◄──────── 42.0 mm (Pitch) ────────►
               
Top Lip (0.5mm) ──► ┌─┐                             ┌─┐
                    │  \                           /  │  ◄── 45° Lead-in Chamfer (Top Funnel)
Vertical Rib    ──► │   │                         │   │  ◄── Straight Pocket Wall
(e.g., 2.4mm)       │   │                         │   │
Bottom Opening  ──► └───┘                         └───┘  ◄── Through-Cut / Open Bottom
                    ▲                                 ▲
                    └─────── Pocket Void ─────────────┘
```

1. **Top Mouth:** Starts at `POCKET_TOP` (41.5 mm) with corner radius `r = 4.0 mm`. Wall thickness at the very rim is 0.5 mm (`42.0 - 41.5`).
2. **Transition:** 45° slope inward from `POCKET_TOP` (41.5 mm) down to `pocket_mid` (`42.0 - divider_wall_thickness`).
3. **Mid & Lower Section:** Straight vertical wall at `pocket_mid` extending down to the base surface ($Z = 0$).
4. **Base/Floor:** Open through-cut in Style 0 (Ultralight Skeleton). No floor plastic under bins.

---

## MakerWorld Customizer Parameters

```openscad
/* [01 — Drawer Dimensions] */
drawer_width_mm    = 400;   // [50:1:1000]
drawer_depth_mm    = 500;   // [50:1:1000]
clearance_per_side = 0.5;   // [0:0.1:2]

/* [02 — Grid Override (Optional)] */
use_auto_fit  = true;
manual_grid_x = 4;          // [1:1:20]
manual_grid_y = 4;          // [1:1:20]

/* [03 — Baseplate Style & Wall Thickness] */
style                  = 0;    // [0:Super Light (Skeleton), 1:Standard (0.4mm floor), 2:Solid (1.2mm floor)]
divider_wall_thickness = 2.4;  // [1.2:0.2:4.8]

/* [04 — Extension Distribution] */
extension_mode = 0;         // [0:Even Split, 1:Right-Back Only, 2:Left-Front Only]

/* [05 — Options] */
magnet_holes = false;
screw_holes  = false;

/* [06 — Print Bed Tiling] */
tiling_mode        = true;
bed_x_mm           = 256.0; // [100:0.1:500]
bed_y_mm           = 256.0; // [100:0.1:500]
bed_safe_margin_mm = 2.0;   // [0:0.1:20]
tile_gap_mm        = 10.0;  // [0:0.1:50]
enable_labels      = true;
part_to_render     = 0;     // [0:All (Exploded), 1:Tile 1/1, ...]
```

---

## Corner Junctions & Rigidity

In `Thinnest ever.scad`, the 4-way intersections pinched down to tangential points, causing the tray to twist. In this design:
* At `divider_wall_thickness = 2.4 mm`, the intersection between adjacent cells forms a substantial corner gusset with a diamond opening in Style 0.
* For bed-split cuts (`tiling_mode = true`), cut borders maintain a minimum boundary thickness (`wt_cut = 8 mm`) so puzzle tabs hold securely.

---

## Verification Plan

### Automated OpenSCAD Geometry Checks
1. Compile with default values (`style = 0`, `divider_wall_thickness = 2.4`). Verify no CSG manifold or self-intersection errors.
2. Compile extreme boundaries:
   - Minimum wall thickness: `divider_wall_thickness = 1.2 mm`.
   - Maximum wall thickness: `divider_wall_thickness = 4.8 mm`.
   - Full styles: `style = 1` (Standard with floor) and `style = 2` (Solid).

### Fit & Dimension Checks
* Confirm total outer width equals `gx * 42.0 + ext_L + ext_R` exactly.
* Confirm bin clearance tolerance (0.25 mm per side) is preserved.
* Verify 45° chamfer funnel top dimension is exactly 41.5 mm.
