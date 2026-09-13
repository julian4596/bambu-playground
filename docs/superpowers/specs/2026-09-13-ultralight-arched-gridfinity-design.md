# Ultralight Arched Doorway Gridfinity Baseplate Design Spec

## Overview
This specification details the design for a new, independent OpenSCAD model: `Ultralight_Arched_Gridfinity.scad`. 

This design implements a **skeletonized arched truss / doorway profile** for Gridfinity baseplates. Instead of solid divider walls spanning between bin pockets, the central span of each divider wall is cut away as an archway ("doorway") that extends all the way down to the table surface ($Z = 0$).

This achieves maximum filament and print-time savings while preserving:
1. **Accurate Bin Retention:** Solid corner pillars with diamond cutouts align and hold bin feet firmly in place.
2. **Smooth Bin Insertion:** A continuous top rim with a 45° chamfer funnel (opening to 41.5 mm) prevents bins from snagging.
3. **Clean Drawer Fit:** A solid outer boundary seals the drawer perimeter against dust and debris.
4. **Independent File:** Existing scripts (such as `Ultralight_Gridfinity.scad`) remain completely untouched.

---

## Key Dimensions & Geometric Standards

| Dimension | Value | Description |
| :--- | :--- | :--- |
| **Grid Pitch (`GRID_PITCH`)** | **42.0 mm** | Center-to-center cell spacing (official standard). |
| **Profile Height (`PROFILE_H`)** | **4.75 mm** | Total height of the baseplate socket. |
| **Top Pocket Mouth (`POCKET_TOP`)** | **41.5 mm** | 42.0 mm minus $2 \times 0.25\text{ mm}$ bin clearance tolerance. |
| **Top Pocket Corner Radius** | **4.0 mm** | Matches standard Gridfinity bin corner fillets. |
| **Top Chamfer Funnel Height** | **1.25 mm** | 45° slope from 41.5 mm down to 39.0 mm at $Z = 3.5\text{ mm}$. |
| **Doorway Arch Width (`DOORWAY_W`)** | **24.0 mm** | Horizontal span of the cutout centered along each 42 mm cell wall. |
| **Doorway Arch Height (`DOORWAY_H`)** | **3.5 mm** | Vertical height of the cutout from table level ($Z = 0$) to top arch. |
| **Doorway Arch Corner Radius** | **4.0 mm** | Fillet at top corners of the doorway for smooth printability. |
| **Corner Pillar Width** | **~9.0 mm** | Remaining solid pillar at each corner to seat and guide the bin. |
| **Floor Thickness** | **0.0 mm** | Open bottom / bottomless inside each cell. |

---

## Structural Architecture

### Vertical Cross-Section (Through Divider Wall)

```text
               ◄──────── 42.0 mm (Pitch) ────────►
               
Top Chamfer ──► ┌─┐                             ┌─┐
(41.5mm mouth)  │  \                           /  │  ◄── 45° Lead-in Funnel (Z = 3.5 to 4.75 mm)
                │   │                         │   │
                │   └─────┐             ┌─────┘   │  ◄── Arched Top (r = 4.0 mm, Z = 3.5 mm)
Doorway Arch ─► │         │             │         │
(24.0 mm wide)  │         │  OPEN AIR   │         │  ◄── Cutout extends to table (Z = 0)
                │         │  (Doorway)  │         │
Table Surface ─►└───┘     │             │     └───┘  ◄── Corner Feet rest on bed
                ▲         ◄─────────────►         ▲
             Corner Leg     24.0 mm Span       Corner Leg
             (~9.0 mm)                         (~9.0 mm)
```

### Plan View (Looking Down onto 1 Cell)
* Four corner pillars located at the cell corners, shaped to receive the 4 mm rounded bin foot.
* Four 24.0 mm wide arched openings centered on the North, South, East, and West divider walls.
* Central through-hole at the cell floor (open to drawer surface).
* Central diamond void at each 4-way intersection between cells.

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

/* [03 — Arch Geometry] */
doorway_width  = 24.0;      // [16:1:32]
doorway_height = 3.5;       // [2.0:0.1:4.0]

/* [04 — Extension Distribution] */
extension_mode = 0;         // [0:Even Split, 1:Right-Back Only, 2:Left-Front Only]

/* [05 — Print Bed Tiling] */
tiling_mode        = true;
bed_x_mm           = 256.0; // [100:0.1:500]
bed_y_mm           = 256.0; // [100:0.1:500]
bed_safe_margin_mm = 2.0;   // [0:0.1:20]
tile_gap_mm        = 10.0;  // [0:0.1:50]
enable_labels      = true;
part_to_render     = 0;     // [0:All (Exploded), 1:Tile 1/1, ...]
```

---

## Verification Plan

### Automated OpenSCAD CLI Checks
1. Compile `Ultralight_Arched_Gridfinity.scad` across default parameters (`doorway_width = 24.0`, `doorway_height = 3.5`). Verify exit code 0 and valid manifold CSG.
2. Compile boundary limits:
   - Narrow doorway: `doorway_width = 16.0`.
   - Wide doorway: `doorway_width = 30.0`.
   - Low arch: `doorway_height = 2.5`.
   - High arch: `doorway_height = 4.0`.

### Visual Inspection
1. Render high-resolution 3D perspective, top-down, and close-up views using OpenSCAD headless CLI.
2. Verify:
   - Doorway arches cut cleanly all the way down to table level ($Z = 0$).
   - Top chamfer rim remains continuous and smooth to guide bins.
   - Corner pillars provide robust contact points.
   - Outer frame is solid along drawer margins.
