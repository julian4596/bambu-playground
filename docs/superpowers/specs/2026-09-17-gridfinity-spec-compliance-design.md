# Gridfinity Official Specification Compliance Design Spec

**Date:** 2026-09-17  
**Status:** Approved by User  
**References:** 
- [Gridfinity Specification v5](https://gridfinity.xyz/specification/) (by willtree8 / Zack Freedman)
- [gfthings Repository](https://github.com/PaulBone/gfthings) (by Paul Bone / CC BY-NC-SA 4.0)
- [Printables Model #608500](https://www.printables.com/model/608500-gridfinity-base-light-magnetic-connectable-paramet)

---

## 1. Executive Summary

This design specification formalizes the transformation of all Gridfinity baseplate generators in the repository to strictly adhere to the official Gridfinity specification published at `https://gridfinity.xyz/specification/` and incorporate proven ultralight architectural patterns from `PaulBone/gfthings`.

### Core Problems Resolved:
1. **Pocket vs. Bin Foot Inversion**: Previous iterations mistakenly used external bin dimensions ($41.5\text{ mm}$ top mouth, $37.2\text{ mm}$ waist, $35.6\text{ mm}$ bottom) as pocket cutouts, eliminating clearance tolerance and causing bins to jam or wobble.
2. **Loss of Profile in Skeleton Styles**: In `Ultralight_Gridfinity.scad` (Style 0), the pocket was previously simplified to an arbitrary single chamfer down to $42 - \text{divider\_wall\_thickness}$ (e.g. $39.6\text{ mm}$), abandoning the 3-layer stepped profile and lateral alignment.
3. **Misplaced Magnet/Screw Holes**: Holes were previously placed at grid line intersections $(X \times 42, Y \times 42)$ rather than standard 4-corner cell positions matching Gridfinity bins ($26.0 \times 26.0\text{ mm}$ square spacing).
4. **Knowledge Base Inaccuracies**: Existing documentation in `docs/gridfinity_design_template.md` listed bin dimensions under baseplate pocket labels without clearance offsets.

---

## 2. Geometric Specifications & Standards

All baseplate models and modules in this workspace are bound to the following mathematical dimensions:

### 2.1 Standard Pitch & Clearances
* **Grid Pitch (`GRID_PITCH`)**: Exactly $42.0\text{ mm}$ center-to-center.
* **Tolerance (`TOLERANCE`)**: $0.25\text{ mm}$ clearance per side ($0.5\text{ mm}$ total per cell).

### 2.2 Bin Foot Profile vs. Baseplate Socket Profile

| Feature | Bin Foot Dimension | Baseplate Socket Dimension | Vertical Height | Angle / Radius |
| :--- | :--- | :--- | :--- | :--- |
| **Top Rim Opening** | $41.50\text{ mm}$ | **$42.00\text{ mm}$** | — | $r_{\text{bin}} = 3.75\text{ mm}$ ($7.5\text{ mm} \oslash$)<br>$r_{\text{socket}} = 4.00\text{ mm}$ ($8.0\text{ mm} \oslash$) |
| **Top Chamfer** | Inward $45^\circ$ slope | **Inward $45^\circ$ slope** | $2.15\text{ mm}$ | $45^\circ$ slope |
| **Mid Waist Wall** | $37.20\text{ mm}$ | **$37.70\text{ mm}$** | $1.80\text{ mm}$ | Vertical ($90^\circ$)<br>$r_{\text{bin}} = 1.60\text{ mm}$ ($3.2\text{ mm} \oslash$)<br>$r_{\text{socket}} = 1.85\text{ mm}$ ($3.7\text{ mm} \oslash$) |
| **Bottom Chamfer / Ledge** | Inward $45^\circ$ slope | **Inward $45^\circ$ slope** | $h_{\text{bin}} = 0.80\text{ mm}$<br>**$h_{\text{socket}} = 0.70\text{ mm}$** | $45^\circ$ slope |
| **Bottom Opening** | $35.60\text{ mm}$ flat | **$36.30\text{ mm}$ open mouth** | — | $r_{\text{bin}} = 0.80\text{ mm}$ ($1.6\text{ mm} \oslash$)<br>$r_{\text{socket}} = 1.15\text{ mm}$ ($2.3\text{ mm} \oslash$) |
| **Total Profile Depth** | $4.75\text{ mm}$ | **$4.65\text{ mm}$** | — | Provides $0.10\text{ mm}$ bottom clearance relief |

### 2.3 Cross-Section Vertical Alignment

```text
                            ◄───────────── 42.0 mm (Cell Pitch) ─────────────►
                            
Baseplate Top Rim ────────► ┌─┐                                             ┌─┐
(Z = 4.65 to 4.75 mm)       │  \   0.25 mm Gap                       0.25 mm Gap   /  │  ◄── Top Chamfer (45°, 2.15 mm)
                            │   \ ┌─────────────────────────────────────┐ /   │
                            │    \│              BIN BODY               │/    │
Vertical Waist   ─────────► │     │                                     │     │  ◄── Straight Pocket Wall (1.8 mm)
(Z = 0.70 to 2.50 mm)       │     │  Bin Waist: 37.2 mm                 │     │      Baseplate Pocket Waist: 37.7 mm
                            │     │                                     │     │      (0.25 mm clearance per side)
                            │   ┌─┘                                     └─┐   │
Chamfered Bottom Ledge ───► │  /  ◄── 0.7 mm Ledge (45°)                   \  │  ◄── Bottom Chamfer (45°, 0.7 mm)
(Z = 0.00 to 0.70 mm)       │ /   ┌─────────────────────────────────────┐   \ │      (Bin bottom chamfer is 0.8 mm)
                            └─┘   │     Bin Flat Bottom: 35.6 mm        │    └─┘
                                  │                                     │
Table / Drawer Surface ───────────┴─────────────────────────────────────┴─────────── (Z = 0.0 mm)
                                  ▲                                     ▲
                                  └──── Open Center Hole: 36.3 mm ──────┘
                                        (Void to drawer surface)
```

### 2.4 Corner Radii Math
At every elevation, the socket corner fillet radius preserves concentric alignment with the outer $42\text{ mm}$ boundary ($r = 4.0\text{ mm}$):
* $Z = 4.65\text{ mm}$ (Top Rim): $r = 4.00\text{ mm}$ ($8.0\text{ mm}$ diameter).
* $Z = 2.50\text{ mm}$ (Waist): $r = 4.00 - 2.15 = 1.85\text{ mm}$ ($3.7\text{ mm}$ diameter).
* $Z = 0.70\text{ mm}$ to $0.00\text{ mm}$ (Bottom Ledge): $r = 1.85 - 0.70 = 1.15\text{ mm}$ ($2.3\text{ mm}$ diameter).

### 2.5 Official Magnet & Screw Hole Pattern
* Each $42.0\text{ mm}$ grid cell supports up to 4 corner mounting points.
* **Hole Center Offset**: $13.0\text{ mm}$ from cell center along X and Y ($8.0\text{ mm}$ from cell boundary).
* **Pattern Spacing**: Exactly $26.0 \times 26.0\text{ mm}$ center-to-center square.
* **Magnet Counterbore**: Diameter $6.2\text{ mm}$ (press fit for $6.0\text{ mm}$ magnets), depth $2.2\text{ mm}$ (or $2.4\text{ mm}$).
* **Screw Hole**: Diameter $3.2\text{ mm}$ clearance (or $3.0\text{ mm}$ pilot) through-hole for M3 hardware.

---

## 3. System Architecture & Modules

### 3.1 Shared Core Engine: `gridfinity_core.scad`
A standalone, dependency-free core library providing shared constants, primitives, and socket modules:
* `gf_socket_profile()`: Generates the true 3-tier subtractive pocket with parametric options:
  - `open_bottom`: When `true` (Style 0), cuts the center through to $Z = 0$, retaining the $0.7\text{ mm}$ 45° chamfered bottom ledge. When `false` (Style 1/2), closes the pocket floor.
  - `chamfer_ledge`: When `false`, cuts the vertical waist ($37.7\text{ mm}$) straight to $Z = 0$.
* `gf_cell_ring(w, d, h)`: Generates the external cell envelope ($42.0 \times 42.0\text{ mm}$) with $r = 4.0\text{ mm}$ corners, producing natural diamond voids at 4-way grid junctions.
* `gf_corner_holes(count, magnet_d, magnet_h, screw_d)`: Places 0, 2 (diagonal), or 4 corner holes at the official $(\pm 13.0, \pm 13.0)\text{ mm}$ coordinates.
* `gf_edge_cut(length, height)`: Implements the `gfthings` trapezoidal wall cutout along cell dividers.

### 3.2 Script Implementations
1. **`Ultralight_Gridfinity.scad`**:
   - Includes `gridfinity_core.scad`.
   - Supports:
     - `style = 0`: Ultralight Skeleton (open bottom floor + $0.7\text{ mm}$ chamfered bottom ledge + diamond intersections).
     - `style = 1`: Standard ($0.4\text{ mm}$ floor).
     - `style = 2`: Solid ($1.2\text{ mm}$ floor).
     - `chamfer_bottom_ledge = true/false`: Toggleable parametric support.
     - `wall_cutout_mode = 0 (solid), 1 (arched doorway), 2 (edge cut)`.
     - `corner_holes_per_cell = 0, 2, 4`.
     - Drawer auto-fit calculations, bed tiling, puzzle dovetail tabs, and tile coordinate labels.
2. **`Ultralight_Arched_Gridfinity.scad`**:
   - Refactored to utilize `gridfinity_core.scad`.
   - Corner pillars feature the exact 3-layer socket profile ($42.0\text{ mm}$ lead-in, $37.7\text{ mm}$ waist, $0.7\text{ mm}$ chamfered ledge) with centered arched cutouts extending to table level.
3. **`Ultralight_Spacerless_Gridfinity.scad` & `1x2_baseplate.scad`**:
   - Brought into complete alignment with `gridfinity_core.scad`.

---

## 4. Knowledge Base Documentation Plan

### 4.1 Update `docs/gridfinity_design_template.md`
* Correct the Core Dimensions table: clearly separate Bin Foot dimensions from Baseplate Pocket dimensions.
* Clarify the $+0.25\text{ mm}$ clearance offset standard.
* Update vertical breakdown ASCII art to match the official v5 specification.
* Update OpenSCAD boilerplate parameters to include `chamfer_bottom_ledge`, `wall_cutout_mode`, and `corner_holes_per_cell`.

### 4.2 Create `docs/gridfinity_specification_reference.md`
* Comprehensive reference manual serving as the repository's permanent knowledge base.
* Detailed section-by-section breakdown of:
  - Bin foot dimensions, stacking lip dimensions, and baseplate socket profiles.
  - Height units ($1u = 7\text{ mm}$, stacking lip $+4.4\text{ mm}$).
  - Exact formulas for corner radii and clearance offsets.
  - Magnet and screw hole engineering standards ($26\text{ mm}$ square, $13\text{ mm}$ center offset).
  - Architectural patterns from `PaulBone/gfthings` (corner pillars, edge cuts, open floors).

---

## 5. Verification & Visual Testing Plan

### 5.1 Automated Geometry & Manifold Verification
Using OpenSCAD headless CLI (`openscad.exe`):
1. **Compilation & CSG Validity**:
   - Compile `Ultralight_Gridfinity.scad` across all styles (`style = 0, 1, 2`).
   - Compile with `chamfer_bottom_ledge = true` and `false`.
   - Compile with `corner_holes_per_cell = 0, 2, 4`.
   - Compile `Ultralight_Arched_Gridfinity.scad` and `1x2_baseplate.scad`.
   - Verify exit code 0 and zero non-manifold warnings.
2. **Dimensional Assertions**:
   - Verify top opening is $42.0\text{ mm}$.
   - Verify vertical waist is $37.7\text{ mm}$.
   - Verify bottom opening is $36.3\text{ mm}$ (when ledge is enabled).
   - Verify corner hole centers are at $(\pm 13.0, \pm 13.0)\text{ mm}$ from cell center.

### 5.2 Visual Inspection & Renders
In accordance with the project's UI Testing Rule:
* Generate high-resolution 3D perspective and cross-sectional render images using OpenSCAD CLI:
  - `render_style0_skeleton.png`: Showing open floor, chamfered bottom ledge, and intersection diamond voids.
  - `render_style0_with_holes.png`: Showing corner magnet/screw bosses.
  - `render_arched_gridfinity.png`: Showing arched doorways with official corner pillars.
  - `render_1x2_baseplate.png`: Showing 1x2 configuration.
* Inspect images visually using `view_file` to confirm clean geometry and aesthetic quality.
