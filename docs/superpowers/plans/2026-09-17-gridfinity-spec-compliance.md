# Gridfinity Official Specification Compliance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor all Gridfinity baseplate designs in the repository into strict compliance with the official `https://gridfinity.xyz/specification/` standard and `PaulBone/gfthings`, providing parametric chamfered bottom ledges, official pocket profiles, standard 26mm corner magnet/screw holes, and a complete knowledge base.

**Architecture:** Create a shared core library `gridfinity_core.scad` providing true socket geometry and modules. Refactor `Ultralight_Gridfinity.scad`, `Ultralight_Arched_Gridfinity.scad`, and auxiliary baseplates to consume this core. Update knowledge base documentation in `docs/`.

**Tech Stack:** OpenSCAD (v2021.01), Git Bash, GitHub CLI.

## Global Constraints
- Grid Pitch: exactly $42.0\text{ mm}$ center-to-center.
- Socket Mouth: $42.0\text{ mm}$ opening with $r = 4.0\text{ mm}$ fillet.
- Socket Top Chamfer: $45^\circ$, $2.15\text{ mm}$ vertical height down to $37.7\text{ mm}$ waist ($r = 1.85\text{ mm}$).
- Socket Waist: $1.80\text{ mm}$ vertical straight wall at $37.7\text{ mm}$.
- Socket Bottom Chamfer / Ledge: $45^\circ$, $0.70\text{ mm}$ vertical height down to $36.3\text{ mm}$ opening ($r = 1.15\text{ mm}$).
- Magnet/Screw Holes: Located at $(\pm 13.0, \pm 13.0)\text{ mm}$ from cell center ($26.0\text{ mm}$ center-to-center spacing).
- Terminal commands: ALWAYS executed via Git Bash (`bash -c "..."`).
- UI/3D verification: Generate high-resolution visual renders and review them.

---

### Task 1: Core Geometry Engine (`gridfinity_core.scad`)

**Files:**
- Create: `gridfinity_core.scad`
- Test: `tests/test_gridfinity_core.scad`

**Interfaces:**
- Produces:
  - Constants: `GF_PITCH`, `GF_TOLERANCE`, `GF_SOCKET_TOP_W`, `GF_SOCKET_WAIST_W`, `GF_SOCKET_BOT_W`, `GF_TOP_CHAMFER_H`, `GF_VERT_WAIST_H`, `GF_BOT_CHAMFER_H`, `GF_PROFILE_H`, `GF_HOLE_SPACING`, `GF_HOLE_OFFSET`.
  - Modules:
    - `gf_socket_pocket(open_bottom=true, chamfer_ledge=true, clearance=0)`
    - `gf_cell_envelope(w=42, d=42, h=4.65, r=4.0)`
    - `gf_corner_holes(count=0, magnet_d=6.2, magnet_h=2.2, screw_d=3.2, h=4.65)`
    - `gf_edge_cut(cut_len=26.0, cut_h=4.65)`

- [ ] **Step 1: Write test script `tests/test_gridfinity_core.scad`**

```openscad
// Test script for gridfinity_core.scad
include <../gridfinity_core.scad>

assert(GF_PITCH == 42.0, "GF_PITCH must be 42.0");
assert(GF_SOCKET_TOP_W == 42.0, "GF_SOCKET_TOP_W must be 42.0");
assert(GF_SOCKET_WAIST_W == 37.7, "GF_SOCKET_WAIST_W must be 37.7");
assert(GF_SOCKET_BOT_W == 36.3, "GF_SOCKET_BOT_W must be 36.3");
assert(GF_TOP_CHAMFER_H == 2.15, "GF_TOP_CHAMFER_H must be 2.15");
assert(GF_VERT_WAIST_H == 1.80, "GF_VERT_WAIST_H must be 1.80");
assert(GF_BOT_CHAMFER_H == 0.70, "GF_BOT_CHAMFER_H must be 0.70");
assert(GF_PROFILE_H == 4.65, "GF_PROFILE_H must be 4.65");
assert(GF_HOLE_SPACING == 26.0, "GF_HOLE_SPACING must be 26.0");
assert(GF_HOLE_OFFSET == 13.0, "GF_HOLE_OFFSET must be 13.0");

// Test CSG compilation
difference() {
    gf_cell_envelope(GF_PITCH, GF_PITCH, GF_PROFILE_H);
    gf_socket_pocket(open_bottom=true, chamfer_ledge=true);
}
```

- [ ] **Step 2: Run test to verify it fails (missing core file)**

Run: `bash -c "'/c/Program Files/OpenSCAD/openscad.exe' -o tests/test_core.stl tests/test_gridfinity_core.scad"`
Expected: FAIL (file not found or assertions fail).

- [ ] **Step 3: Implement `gridfinity_core.scad`**

Write the complete `gridfinity_core.scad` implementation featuring:
- Exact constants from `gridfinity.xyz/specification/` v5.
- `gf_rounded_rect(w, d, h, r)` helper.
- `gf_socket_pocket()` implementing the 3-tier pocket (top chamfer $2.15\text{ mm}$, vertical waist $1.80\text{ mm}$, bottom chamfer $0.70\text{ mm}$) with `open_bottom` and `chamfer_ledge` toggles.
- `gf_cell_envelope()` with concentric $r = 4.0\text{ mm}$ corners.
- `gf_corner_holes()` for 0, 2, or 4 corner holes at $(\pm 13.0, \pm 13.0)\text{ mm}$.
- `gf_edge_cut()` for wall weight-reduction slots.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash -c "'/c/Program Files/OpenSCAD/openscad.exe' -o tests/test_core.stl tests/test_gridfinity_core.scad"`
Expected: PASS (exit code 0, assertions valid).

- [ ] **Step 5: Commit**

```bash
git add gridfinity_core.scad tests/test_gridfinity_core.scad
git commit -m "feat: implement official Gridfinity core geometry engine"
```

---

### Task 2: Main Baseplate Refactor (`Ultralight_Gridfinity.scad`)

**Files:**
- Modify: `Ultralight_Gridfinity.scad`
- Test: `tests/test_ultralight_gridfinity.scad`

**Interfaces:**
- Consumes: `gridfinity_core.scad`
- Produces: Complete parametric baseplate with MakerWorld Customizer parameters:
  - `style = 0, 1, 2` (0: Ultralight Skeleton with open floor, 1: Standard, 2: Solid)
  - `chamfer_bottom_ledge = true/false`
  - `wall_cutout_mode = 0, 1, 2`
  - `corner_holes_per_cell = 0, 2, 4`
  - Drawer auto-fit, tiling, puzzle tabs, labels

- [ ] **Step 1: Write test script `tests/test_ultralight_gridfinity.scad`**

Test compilation of `Ultralight_Gridfinity.scad` across:
- `style = 0` (Skeleton with chamfered bottom ledge)
- `style = 1` (Standard with floor)
- `style = 2` (Solid)
- `corner_holes_per_cell = 4`

- [ ] **Step 2: Run test to observe baseline state**

Run: `bash -c "'/c/Program Files/OpenSCAD/openscad.exe' -o tests/test_base.stl tests/test_ultralight_gridfinity.scad"`

- [ ] **Step 3: Refactor `Ultralight_Gridfinity.scad`**

- Include `gridfinity_core.scad`.
- Replace legacy constants with core constants.
- Update `pocket()` to call `gf_socket_pocket(open_bottom=(style==0), chamfer_ledge=chamfer_bottom_ledge)`.
- Update `skeleton_base()` to use `gf_cell_envelope()`, creating diamond voids at cell intersections.
- Update `all_holes()` to place holes at the official 4-corner positions per cell ($(\pm 13.0, \pm 13.0)\text{ mm}$) based on `corner_holes_per_cell`.
- Wire `wall_cutout_mode` for optional doorway arches or trapezoid edge cuts.

- [ ] **Step 4: Run test to verify all configurations compile**

Run: `bash -c "'/c/Program Files/OpenSCAD/openscad.exe' -o tests/test_base.stl tests/test_ultralight_gridfinity.scad"`
Expected: PASS (exit code 0).

- [ ] **Step 5: Commit**

```bash
git add Ultralight_Gridfinity.scad tests/test_ultralight_gridfinity.scad
git commit -m "feat: align Ultralight_Gridfinity.scad with official specification"
```

---

### Task 3: Arched Baseplate & Auxiliary Models

**Files:**
- Modify: `Ultralight_Arched_Gridfinity.scad`
- Modify: `1x2_baseplate.scad`
- Modify: `Ultralight_Spacerless_Gridfinity.scad`

**Interfaces:**
- Consumes: `gridfinity_core.scad`

- [ ] **Step 1: Refactor `Ultralight_Arched_Gridfinity.scad`**
- Include `gridfinity_core.scad`.
- Ensure corner pillars retain the exact 3-layer pocket profile (top 45° chamfer, 1.8mm vertical waist at 37.7mm, 0.7mm chamfered ledge at 36.3mm).
- Ensure central doorway arches cut cleanly to bed level ($Z = 0$).

- [ ] **Step 2: Update `1x2_baseplate.scad` & `Ultralight_Spacerless_Gridfinity.scad`**
- Verify `1x2_baseplate.scad` properly includes the updated `Ultralight_Gridfinity.scad`.
- Align `Ultralight_Spacerless_Gridfinity.scad` with the official core standard.

- [ ] **Step 3: Verify compilation of all baseplates**

Run: `bash -c "'/c/Program Files/OpenSCAD/openscad.exe' -o tests/test_arched.stl Ultralight_Arched_Gridfinity.scad"`
Run: `bash -c "'/c/Program Files/OpenSCAD/openscad.exe' -o tests/test_1x2.stl 1x2_baseplate.scad"`
Expected: PASS (exit code 0).

- [ ] **Step 4: Commit**

```bash
git add Ultralight_Arched_Gridfinity.scad 1x2_baseplate.scad Ultralight_Spacerless_Gridfinity.scad
git commit -m "feat: update arched baseplate and auxiliary models to official specification"
```

---

### Task 4: Knowledge Base Documentation

**Files:**
- Modify: `docs/gridfinity_design_template.md`
- Create: `docs/gridfinity_specification_reference.md`

- [ ] **Step 1: Update `docs/gridfinity_design_template.md`**
- Fix dimension table: distinguish between external bin foot dimensions and baseplate pocket dimensions.
- Document the $+0.25\text{ mm}$ clearance offset rule.
- Update vertical profile diagram with exact heights ($2.15\text{ mm}$, $1.80\text{ mm}$, $0.70\text{ mm}$).
- Update OpenSCAD boilerplate parameters with new customizer options.

- [ ] **Step 2: Create `docs/gridfinity_specification_reference.md`**
- Document full v5 specifications from `gridfinity.xyz/specification/`.
- Document bin foot, baseplate socket, and stacking lip profiles.
- Document corner radius progression ($4.0\text{ mm} \rightarrow 1.85\text{ mm} \rightarrow 1.15\text{ mm}$).
- Document $26.0 \times 26.0\text{ mm}$ magnet/screw hole standards.
- Document architectural patterns from `PaulBone/gfthings`.

- [ ] **Step 3: Commit**

```bash
git add docs/gridfinity_design_template.md docs/gridfinity_specification_reference.md
git commit -m "docs: create comprehensive Gridfinity knowledge base and update template"
```

---

### Task 5: Visual Verification & Final Renders

**Files:**
- Generate: `docs/renders/render_style0_skeleton.png`
- Generate: `docs/renders/render_style0_with_holes.png`
- Generate: `docs/renders/render_arched_gridfinity.png`
- Generate: `docs/renders/render_1x2_baseplate.png`

- [ ] **Step 1: Generate high-resolution PNG renders via OpenSCAD CLI**

```bash
bash -c "mkdir -p docs/renders"
bash -c "'/c/Program Files/OpenSCAD/openscad.exe' -o docs/renders/render_style0_skeleton.png --imgsize=1200,900 --camera=0,0,10,60,0,320,250 -D 'style=0' -D 'manual_grid_x=2' -D 'manual_grid_y=2' -D 'use_auto_fit=false' -D 'tiling_mode=false' Ultralight_Gridfinity.scad"
bash -c "'/c/Program Files/OpenSCAD/openscad.exe' -o docs/renders/render_style0_with_holes.png --imgsize=1200,900 --camera=0,0,10,60,0,320,250 -D 'style=0' -D 'corner_holes_per_cell=4' -D 'manual_grid_x=2' -D 'manual_grid_y=2' -D 'use_auto_fit=false' -D 'tiling_mode=false' Ultralight_Gridfinity.scad"
bash -c "'/c/Program Files/OpenSCAD/openscad.exe' -o docs/renders/render_arched_gridfinity.png --imgsize=1200,900 --camera=0,0,10,60,0,320,250 -D 'manual_grid_x=2' -D 'manual_grid_y=2' -D 'use_auto_fit=false' -D 'tiling_mode=false' Ultralight_Arched_Gridfinity.scad"
bash -c "'/c/Program Files/OpenSCAD/openscad.exe' -o docs/renders/render_1x2_baseplate.png --imgsize=1200,900 --camera=0,0,10,60,0,320,200 1x2_baseplate.scad"
```

- [ ] **Step 2: Inspect renders visually with `view_file` to confirm clean geometry**
- Verify open floors, chamfered bottom ledges, corner pillars, and diamond intersection cutouts.

- [ ] **Step 3: Clean up temporary test files & commit renders**

```bash
bash -c "rm -rf tests"
git add docs/renders/
git commit -m "docs: add 3D visual verification renders of official-compliant baseplates"
```
