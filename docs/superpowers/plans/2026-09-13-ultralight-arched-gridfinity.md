# Ultralight Arched Doorway Gridfinity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a new parametric OpenSCAD script `Ultralight_Arched_Gridfinity.scad` implementing a skeletonized arched doorway profile that cuts all the way down to table level ($Z = 0$) while preserving solid corner pillars, 45° top guide funnels, and a solid outer drawer perimeter.

**Architecture:** 
- Keep `Ultralight_Gridfinity.scad` completely untouched.
- Create `Ultralight_Arched_Gridfinity.scad` based on official Gridfinity standard dimensions ($42.0\text{ mm}$ pitch, $41.5\text{ mm}$ top opening).
- Implement an arched doorway cutout module (`doorway_cutout()`) spanning $24.0\text{ mm}$ wide and $3.5\text{ mm}$ high with $r = 4.0\text{ mm}$ top rounded fillets, subtracting across every inner grid wall along X and Y axes down to $Z = 0$.
- Ensure outer drawer frame walls remain solid to prevent dust and hardware from slipping underneath.
- Validate via OpenSCAD headless CLI compilation and high-resolution 3D visual renders.

**Tech Stack:** OpenSCAD 2021.01+ (located at `C:\Program Files\OpenSCAD\openscad.exe`), Git Bash.

## Global Constraints

- Do NOT edit or overwrite `Ultralight_Gridfinity.scad`.
- Standard Gridfinity pitch MUST remain strictly $42.0\text{ mm}$.
- Top mouth opening MUST reach $41.5\text{ mm}$ with $r = 4.0\text{ mm}$ corner radius.
- Doorway cutouts MUST extend all the way down to table surface ($Z = 0$).
- Outer frame perimeter contacting the drawer walls MUST remain solid.
- Compatible with MakerWorld Customizer syntax (`/* [Section] */` and `parameter = default; // [min:step:max]`).

---

### Task 1: Create `Ultralight_Arched_Gridfinity.scad`

**Files:**
- Create: `Ultralight_Arched_Gridfinity.scad`

**Interfaces:**
- Produces: Complete parametric script with drawer auto-fit, doorway arch cutouts, top guide chamfers, corner pillars, bed-tiling, and MakerWorld Customizer support.

- [ ] **Step 1: Write `Ultralight_Arched_Gridfinity.scad` with parameter headers and auto-fit math**

```openscad
// ============================================================================
// Ultralight Arched Doorway Gridfinity Baseplate
// ============================================================================
// Parametric, MakerWorld-compatible Gridfinity baseplate with arched doorway
// cutouts for maximum weight and filament savings.
// ============================================================================

GRID_PITCH  = 42.0;
TOLERANCE   = 0.25;
POCKET_TOP  = GRID_PITCH - 2 * TOLERANCE; // 41.5mm
PROFILE_H   = 4.75;

/* [01 — Drawer Dimensions] */
drawer_width_mm    = 400; // [50:1:1000]
drawer_depth_mm    = 500; // [50:1:1000]
clearance_per_side = 0.5; // [0:0.1:2]

/* [02 — Grid Override (Optional)] */
use_auto_fit  = true;
manual_grid_x = 4;        // [1:1:20]
manual_grid_y = 4;        // [1:1:20]

/* [03 — Arch Geometry] */
doorway_width  = 24.0;    // [16:1:32]
doorway_height = 3.5;     // [2.0:0.1:4.0]

/* [04 — Extension Distribution] */
extension_mode = 0;       // [0:Even Split, 1:Right-Back Only, 2:Left-Front Only]

/* [05 — Print Bed Tiling] */
tiling_mode        = true;
bed_x_mm           = 256.0; // [100:0.1:500]
bed_y_mm           = 256.0; // [100:0.1:500]
bed_safe_margin_mm = 2.0;   // [0:0.1:20]
tile_gap_mm        = 10.0;  // [0:0.1:50]
enable_labels      = true;
part_to_render     = 0;     // [0:All (Exploded), 1:Tile 1/1, 2:Tile 2/1, 3:Tile 1/2, 4:Tile 2/2]

/* [Hidden] */
$fn = 40;
```

- [ ] **Step 2: Implement geometry modules (`pocket()`, `doorway_cutout()`, and grid frame)**

- Implement `pocket()` with $41.5\text{ mm}$ mouth, $45^\circ$ funnel, and through-cut.
- Implement `doorway_cutout(w, h)` forming the rounded archway through the divider walls.
- Implement `arched_baseplate()` assembling the corner pillars, top rim, doorway cutouts, and solid outer drawer perimeter.

- [ ] **Step 3: Test compile initial model**

Run:
```bash
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' -o 'scratch/test_arched_init.csg' 'Ultralight_Arched_Gridfinity.scad'"
```
Expected: PASS with 0 errors.

- [ ] **Step 4: Commit new file to git**

Run:
```bash
git add Ultralight_Arched_Gridfinity.scad
git commit -m "feat: create Ultralight_Arched_Gridfinity.scad with arched doorway profile"
```

---

### Task 2: Automated Verification and Parameter Bounds Testing

**Files:**
- Test: OpenSCAD CLI execution against `Ultralight_Arched_Gridfinity.scad`

- [ ] **Step 1: Test compile default parameters**

Run:
```bash
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' -o 'scratch/test_arched_default.csg' 'Ultralight_Arched_Gridfinity.scad'"
```
Expected: PASS with exit code 0.

- [ ] **Step 2: Test compile doorway dimension boundaries**

Run:
```bash
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' -D 'doorway_width=16;doorway_height=2.5' -o 'scratch/test_arched_narrow.csg' 'Ultralight_Arched_Gridfinity.scad'"
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' -D 'doorway_width=30;doorway_height=4.0' -o 'scratch/test_arched_wide.csg' 'Ultralight_Arched_Gridfinity.scad'"
```
Expected: PASS with valid manifold CSG.

- [ ] **Step 3: Test compile with tiling disabled and enabled**

Run:
```bash
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' -D 'tiling_mode=false' -o 'scratch/test_arched_notile.csg' 'Ultralight_Arched_Gridfinity.scad'"
```
Expected: PASS.

---

### Task 3: Visual Verification & Image Generation

**Files:**
- Render: `scratch/preview_arched_angle.png`, `scratch/preview_arched_top.png`, `scratch/preview_arched_tunnel.png`

- [ ] **Step 1: Render 3D preview images using OpenSCAD headless renderer**

Render angle perspective and eye-level tunnel view showing the arches:
```bash
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' --colorscheme 'Tomorrow Night' --imgsize 1280,960 --camera 0,0,10,60,0,30,300 -o 'scratch/preview_arched_angle.png' 'Ultralight_Arched_Gridfinity.scad'"
& "C:\Program Files\Git\bin\bash.exe" -c "'/c/Program Files/OpenSCAD/openscad.exe' --colorscheme 'Tomorrow Night' --imgsize 1280,960 --camera 0,0,3,80,0,45,150 -o 'scratch/preview_arched_tunnel.png' 'Ultralight_Arched_Gridfinity.scad'"
```
Expected: Images show clear arched doorways cutting down to bed level with intact corner pillars and top chamfer rims.

- [ ] **Step 2: Inspect generated images and verify visual conformity**

Confirm doorway arch extends to $Z = 0$, top rim is unbroken, and outer perimeter is sealed.
