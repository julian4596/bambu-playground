# Gridfinity Design & Customization Template

This reference document serves as a master template and cheat sheet for designing, tweaking, and troubleshooting Gridfinity baseplates and bins.

---

## 1. Official Gridfinity Core Dimensions

All standard Gridfinity designs rely on these exact dimensions. **Never change the pitch**, as bins from any designer rely on this standard.

| Dimension | Value | Description |
| :--- | :--- | :--- |
| **Grid Pitch** | **42.0 mm** | Center-to-center spacing of every cell. |
| **Tolerance / Clearance** | **0.25 mm** | Gap per side between bin and pocket (`0.5 mm` total). |
| **Pocket Top Opening** | **41.5 mm** | Widest opening of the pocket mouth (`42.0 - 2 × 0.25`). |
| **Pocket Mid Waist** | **37.2 mm** | Straight vertical section of the bin foot. |
| **Pocket Bottom** | **35.6 mm** | Lowest flat foot of the bin. |
| **Profile Height** | **4.75 mm** | Total height of the socket profile (`0.8 + 1.8 + 2.15`). |
| **Corner Radius (Top)** | **4.0 mm** | Radius of the 4 rounded corners at the mouth. |

---

## 2. Vertical Profile Breakdown

```text
                  ◄─── 42.0 mm (Grid Pitch / Cell Unit) ───►
                  
Top Rim Lip ──►  ┌─┐                                     ┌─┐
                 │ └─────────┐                 ┌─────────┘ │  ◄── Top Chamfer (2.15 mm @ 45°)
Vertical Wall ─► │           │                 │           │  ◄── Straight Pocket Wall (1.8 mm)
Bottom Lip ────► │         ┌─┘                 └─┐         │  ◄── Bottom Chamfer (0.8 mm @ 45°)
Floor / Base ──► └─────────┴─────────────────────┴─────────┘  ◄── Floor (0mm for skeleton, 0.4-1.2mm solid)
                 ▲                                         ▲
                 └──────── Pocket Void (35.6 - 41.5 mm) ───┘
```

---

## 3. Divider Wall Thickness Guidelines (0.4 mm Nozzle)

When tuning the horizontal rib / divider wall between bins:

| Wall Thickness | Perimeters (0.4mm nozzle) | Strength / Feel | Best Used For |
| :--- | :--- | :--- | :--- |
| **0.5 mm** | 1 perimeter | ⚠️ Flimsy, bends like paper, tears easily | *Not recommended* |
| **1.2 mm** | 3 perimeters | Flexible, lightweight, holds shape | Ultra-lightweight minimal trays |
| **1.6 mm** | 4 perimeters | Moderate stiffness | Light-duty small drawers |
| **2.4 mm** | **6 perimeters** | **Rigid, durable, 100% solid, zero flex** | **Recommended sweet spot** |
| **3.2 mm** | 8 perimeters | Very strong, heavy duty | Toolboxes, heavy hardware |
| **4.8 mm** | Full solid Gridfinity | Rock solid, original spec | Heavy shop drawers |

---

## 4. OpenSCAD Boilerplate Parameters

Use this standard parameter block at the top of your OpenSCAD scripts for MakerWorld Customizer compatibility:

```openscad
// ============================================================================
// MakerWorld Customizer Parameters
// ============================================================================

/* [01 — Drawer Dimensions] */
// Inner width of drawer in mm
drawer_width_mm    = 400;   // [50:1:1000]
// Inner depth of drawer in mm
drawer_depth_mm    = 500;   // [50:1:1000]
// Clearance per side in mm (0.5 mm recommended)
clearance_per_side = 0.5;   // [0:0.1:2]

/* [02 — Grid Override] */
// Auto-fit grid units from drawer size
use_auto_fit  = true;
// Manual grid units (if auto-fit is false)
manual_grid_x = 4;          // [1:1:20]
manual_grid_y = 4;          // [1:1:20]

/* [03 — Baseplate Geometry] */
// 0=Ultralight Skeleton, 1=Standard (0.4mm floor), 2=Solid (1.2mm floor)
style                  = 0;    // [0:Ultralight Skeleton, 1:Standard, 2:Solid]
// Thickness of divider wall between bins (mm)
divider_wall_thickness = 2.4;  // [1.2:0.2:4.8]

/* [04 — Extension Distribution] */
// Leftover space distribution
// 0=Even Split, 1=Right/Back Only, 2=Left/Front Only
extension_mode = 0;         // [0:Even Split, 1:Right/Back Only, 2:Left/Front Only]

/* [05 — Print Bed Tiling] */
tiling_mode        = true;
bed_x_mm           = 256.0; // [100:0.1:500]
bed_y_mm           = 256.0; // [100:0.1:500]
bed_safe_margin_mm = 2.0;   // [0:0.1:20]
tile_gap_mm        = 10.0;  // [0:0.1:50]
enable_labels      = true;
part_to_render     = 0;     // [0:All (Exploded), 1:Tile 1/1, 2:Tile 2/1, ...]
```

---

## 5. Troubleshooting & Adjustment Checklist

| Symptom | Cause | Solution |
| :--- | :--- | :--- |
| **Bins will not drop into pocket** | Pocket opening too small or missing top chamfer | Ensure pocket top opening is `41.5 mm` with a 45° chamfer lead-in. |
| **Walls bend, flex, or snap** | Divider wall too thin (< 1.2 mm) or too few slicer wall loops | Increase `divider_wall_thickness` to `2.0 - 2.4 mm`; set slicer perimeters to at least 3. |
| **Baseplate too tight in drawer** | Drawer clearance too small | Increase `clearance_per_side` to `0.8 - 1.0 mm`. |
| **Baseplate slides inside drawer** | Drawer clearance too large | Reduce `clearance_per_side` to `0.3 - 0.5 mm` or add adhesive rubber feet. |
| **Tiles won't snap together** | Dovetail / puzzle joint clearance too tight | Increase `puzzle_tab(clearance)` from `0.2 mm` to `0.25 - 0.3 mm`. |
| **Corners warp / lift off bed** | Large flat footprint cooling unevenly | Use a 3-5 mm brim in slicer, clean bed with dish soap/alcohol, or enable bed tiling mode. |
