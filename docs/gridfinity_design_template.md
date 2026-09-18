# Gridfinity Design & Customization Template

This reference document serves as a master template and cheat sheet for designing, tweaking, and troubleshooting Gridfinity baseplates and bins.

---

## 1. Official Gridfinity Core Dimensions

All standard Gridfinity designs rely on these exact dimensions from [gridfinity.xyz/specification/](https://gridfinity.xyz/specification/) and [PaulBone/gfthings](https://github.com/PaulBone/gfthings). **Never change the pitch**, as bins from any designer rely on this standard.

### Bin Foot vs. Baseplate Socket

| Feature | Bin Foot Dimension | Baseplate Socket Dimension | Description |
| :--- | :--- | :--- | :--- |
| **Grid Pitch** | **42.0 mm** | **42.0 mm** | Center-to-center cell spacing. |
| **Tolerance / Clearance** | `0.0 mm` (datum) | **0.25 mm per side** | `0.5 mm` total clearance gap. |
| **Top Mouth Opening** | **41.5 mm** | **42.0 mm** | Baseplate socket chamfer opens to full pitch. |
| **Top Chamfer** | 2.15 mm @ 45° | **2.15 mm @ 45°** | Funnel lead-in for smooth drop-in. |
| **Vertical Waist** | **37.2 mm** (1.8mm tall) | **37.7 mm** (1.8mm tall) | Straight vertical guide section. |
| **Bottom Chamfer / Ledge**| 0.8 mm @ 45° | **0.7 mm @ 45°** | Socket chamfer is 0.7mm tall, leaving 0.1mm bottom clearance relief. |
| **Bottom Opening** | **35.6 mm** (flat face) | **36.3 mm** (open mouth) | Void through-cut in Ultralight style. |
| **Profile Depth** | **4.75 mm** | **4.65 mm** | Bin foot sits properly supported without bottoming out. |
| **Corner Radii** | Top: `3.75 mm` (7.5Ø)<br>Waist: `1.60 mm` (3.2Ø)<br>Bottom: `0.80 mm` (1.6Ø) | Top: **4.00 mm** (8.0Ø)<br>Waist: **1.85 mm** (3.7Ø)<br>Bottom: **1.15 mm** (2.3Ø) | Concentric fillets at all elevations. |
| **Mounting Holes** | 6.5Ø counterbore / 3.0Ø hole | **6.2Ø press fit / 3.2Ø M3 hole** | Located at $(\pm 13.0, \pm 13.0)\text{ mm}$ ($26.0\text{ mm}$ square). |

---

## 2. Vertical Profile Breakdown

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

---

## 3. Baseplate Style Guidelines

| Style | Floor Construction | Bin Bottom Support | Recommended Use |
| :--- | :--- | :--- | :--- |
| **0: Ultralight Skeleton** | **0.0 mm (Open)** | **0.7 mm Chamfered Ledge** | **Default / Recommended**: 60-75% filament savings, rigid corner pillars. |
| **1: Standard** | 0.4 mm (1 layer) | Full floor | Lightweight trays needing dust barrier under bins. |
| **2: Solid** | 1.2 mm (3 layers) | Full floor | Heavy-duty workshop toolboxes and machinery mounts. |

### Extension & Spacer Variants
- **Full-Perimeter Extensions (`Ultralight_Gridfinity.scad`)**: Generates continuous outer boundary walls around all 4 sides of the drawer.
- **Corner Bumper Tabs (`Ultralight_Corner_Spacers_Gridfinity.scad`)**: Generates discrete dual-window standoff tabs at cell 2 and cell $N-1$ on each edge, eliminating perimeter plastic between corners while rigidly bracing against drawer sliding.

---

## 4. OpenSCAD Boilerplate Parameters

Use this standard parameter block at the top of your OpenSCAD scripts for MakerWorld Customizer compatibility:

```openscad
// ============================================================================
// MakerWorld Customizer Parameters
// ============================================================================

/* [01 — Drawer Dimensions] */
drawer_width_mm    = 400;   // [50:1:1000]
drawer_depth_mm    = 500;   // [50:1:1000]
clearance_per_side = 0.5;   // [0:0.1:2]

/* [02 — Grid Override (Optional)] */
use_auto_fit  = true;
manual_grid_x = 4;          // [1:1:20]
manual_grid_y = 4;          // [1:1:20]

/* [03 — Baseplate Style & Bottom Support] */
// 0=Ultralight Skeleton, 1=Standard (0.4mm floor), 2=Solid (1.2mm floor)
style                = 0;    // [0:Ultralight Skeleton, 1:Standard, 2:Solid]
// In Ultralight mode: keep 0.7mm chamfer ledge to support bin foot
chamfer_bottom_ledge = true;
// Wall cutout mode: 0=Continuous walls, 1=Arched doorways, 2=Trapezoid edge cuts
wall_cutout_mode     = 0;    // [0:Continuous, 1:Arched Doorways, 2:Edge Cuts]
// Thickness of divider wall between bins (mm)
divider_wall_thickness = 2.4;  // [1.2:0.2:4.8]

/* [04 — Magnet & Screw Holes] */
// Corner holes per cell: 0=None, 2=Two opposite corners, 4=All 4 corners (26mm spacing)
corner_holes_per_cell = 0;   // [0:None, 2:Two Corners, 4:Four Corners]
magnet_diameter       = 6.2; // [6.0:0.1:6.5]
screw_diameter        = 3.2; // [2.5:0.1:4.0]

/* [05 — Extension Distribution] */
extension_mode = 0;         // [0:Even Split, 1:Right-Back Only, 2:Left-Front Only]

/* [06 — Print Bed Tiling] */
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
| **Bins will not drop into pocket** | Pocket opening too small or missing clearance | Ensure pocket top opening is `42.0 mm` with $2.15\text{ mm}$ top chamfer and $37.7\text{ mm}$ waist. |
| **Bins wobble excessively** | Pocket waist too wide | Verify socket vertical waist is strictly $37.7\text{ mm}$ ($37.2\text{ mm} + 2 \times 0.25\text{ mm}$). |
| **Bin rocks on bottom flat** | Bottom socket chamfer too tall | Ensure socket bottom chamfer is $0.7\text{ mm}$ tall (leaves $0.1\text{ mm}$ clearance relief for bin's $0.8\text{ mm}$ chamfer). |
| **Baseplate too tight in drawer** | Drawer clearance too small | Increase `clearance_per_side` to `0.8 - 1.0 mm`. |
| **Baseplate slides inside drawer** | Drawer clearance too large | Reduce `clearance_per_side` to `0.3 - 0.5 mm` or add adhesive rubber feet. |
| **Tiles won't snap together** | Dovetail / puzzle joint clearance too tight | Increase `puzzle_tab(clearance)` from `0.2 mm` to `0.25 - 0.3 mm`. |
| **Corners warp / lift off bed** | Large flat footprint cooling unevenly | Use a 3-5 mm brim in slicer, clean bed with dish soap/alcohol, or enable bed tiling mode. |
