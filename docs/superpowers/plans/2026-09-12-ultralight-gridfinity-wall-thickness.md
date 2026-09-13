# Ultralight Gridfinity Configurable Wall Thickness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the pocket profile and divider walls in `Ultralight_Gridfinity.scad` to provide configurable wall thickness (default 2.4 mm) with a 45° chamfered funnel, preventing flimsy ribbon walls while ensuring Gridfinity bins drop in freely.

**Architecture:** 
- Add `divider_wall_thickness` slider to MakerWorld Customizer parameters.
- Dynamically calculate the mid-pocket boundary (`pocket_mid = GRID_PITCH - divider_wall_thickness`) and chamfer transition height (`chamfer_h = (POCKET_TOP - pocket_mid) / 2`).
- Update `pocket()` and `skeleton_base()` to generate smooth self-locating top chamfers down to the solid divider walls with open bottoms for Style 0.
- Validate via OpenSCAD headless CLI compilation and visual image renders.

**Tech Stack:** OpenSCAD 2021.01+ (CLI located at `C:\Program Files\OpenSCAD\openscad.exe`), Git Bash.

## Global Constraints

- Standard Gridfinity pitch MUST remain strictly 42.0 mm.
- Top mouth opening MUST reach 41.5 mm (42.0 mm minus 2 × 0.25 mm tolerance) with 4.0 mm corner radius.
- Style 0 MUST remain ultralight and bottomless (0 mm floor beneath bins).
- Compatible with MakerWorld Customizer syntax (`/* [Section] */` and `parameter = default; // [min:step:max]`).

---

### Task 1: Update Parameters and Geometry in `Ultralight_Gridfinity.scad`

**Files:**
- Modify: `Ultralight_Gridfinity.scad`

**Interfaces:**
- Consumes: Standard Gridfinity constants (`GRID_PITCH = 42`, `TOLERANCE = 0.25`, `POCKET_TOP = 41.5`).
- Produces: `divider_wall_thickness` parameter, updated `pocket()` module with 45° self-guiding top chamfer and dynamic rib thickness.

- [ ] **Step 1: Add `divider_wall_thickness` Customizer parameter**

In `Ultralight_Gridfinity.scad`, update Section 03 parameters:
```openscad
/* [03 — Baseplate Style & Wall Thickness] */
// 0=Super Light (Skeleton), 1=Standard (0.4mm floor), 2=Solid (1.2mm floor)
style = 0; // [0:Super Light, 1:Standard, 2:Solid]
// Thickness of divider walls between bins in mm (2.4mm = 6 solid perimeters)
divider_wall_thickness = 2.4; // [1.2:0.2:4.8]
```

- [ ] **Step 2: Add dynamic pocket calculations**

Below parameter declarations, add:
```openscad
// Dynamic pocket profile based on wall thickness
_safe_wall = max(0.8, min(divider_wall_thickness, 4.8));
POCKET_WALL_MID = GRID_PITCH - _safe_wall; // e.g. 42 - 2.4 = 39.6mm
CHAMFER_H = max(0.1, (POCKET_TOP - POCKET_WALL_MID) / 2); // 45-degree slope height
```

- [ ] **Step 3: Update `pocket()` and `custom_ring()` modules**

Ensure `pocket()` creates a top 45° funnel down to `POCKET_WALL_MID` and `skeleton_base()` correctly produces the desired `divider_wall_thickness` while cutting out the through-hole:
```openscad
module pocket() {
    if (style == 0) {
        // Funnel top chamfer: 45° from POCKET_WALL_MID up to POCKET_TOP
        hull() {
            translate([0, 0, PROFILE_H - CHAMFER_H])
                rounded_centered_rect(POCKET_WALL_MID, POCKET_WALL_MID, 0.01, r=max(0.5, 4 - CHAMFER_H));
            translate([0, 0, PROFILE_H])
                rounded_centered_rect(POCKET_TOP, POCKET_TOP, 0.01, r=4);
        }
        // Extend above top for clean difference cut
        translate([0, 0, PROFILE_H])
            rounded_centered_rect(POCKET_TOP, POCKET_TOP, 1, r=4);

        // Through-cut body down to bed
        translate([0, 0, -1])
            rounded_centered_rect(POCKET_WALL_MID, POCKET_WALL_MID, PROFILE_H - CHAMFER_H + 1.01, r=max(0.5, 4 - CHAMFER_H));
    } else {
        // Standard Gridfinity 3-layer pocket profile for Styles 1 & 2
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
```

---

### Task 2: Automated Verification and Compilation

**Files:**
- Test: OpenSCAD CLI execution against `Ultralight_Gridfinity.scad`

- [ ] **Step 1: Test compile default parameters (2.4 mm wall, style 0)**

Run:
```bash
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' -o 'scratch/test_default.csg' 'Ultralight_Gridfinity.scad'"
```
Expected: PASS with no syntax errors.

- [ ] **Step 2: Test compile boundary wall thicknesses (1.2 mm and 4.8 mm)**

Run:
```bash
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' -D 'divider_wall_thickness=1.2' -o 'scratch/test_min.csg' 'Ultralight_Gridfinity.scad'"
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' -D 'divider_wall_thickness=4.8' -o 'scratch/test_max.csg' 'Ultralight_Gridfinity.scad'"
```
Expected: PASS with valid CSG.

- [ ] **Step 3: Test compile with styles 1 and 2**

Run:
```bash
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' -D 'style=1' -o 'scratch/test_style1.csg' 'Ultralight_Gridfinity.scad'"
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' -D 'style=2' -o 'scratch/test_style2.csg' 'Ultralight_Gridfinity.scad'"
```
Expected: PASS.

---

### Task 3: Visual Verification & Image Generation

**Files:**
- Render: `scratch/preview_top.png`, `scratch/preview_angle.png`

- [ ] **Step 1: Render 3D preview images using OpenSCAD headless renderer**

Run:
```bash
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' --colorscheme 'Tomorrow Night' --imgsize 1280,960 --camera 0,0,10,60,0,30,300 -o 'scratch/preview_angle.png' 'Ultralight_Gridfinity.scad'"
```
Expected: High-resolution PNG image showing clean 2.4 mm walls, smooth chamfers, and corner gussets.

- [ ] **Step 2: Review generated renders**

Verify that walls are visibly substantial (no single-filament ribbons) and chamfer lead-in funnel is clearly present.
