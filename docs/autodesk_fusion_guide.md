# Autodesk Fusion 360 Guide for Gridfinity Baseplates

This workspace provides two powerful ways to use Autodesk Fusion 360 with official-specification Gridfinity baseplates:

---

## Method 1: Native Autodesk Fusion 360 Script (Recommended)

A dedicated Python script has been created and installed directly into your local Autodesk Fusion 360 environment:
`%APPDATA%\Autodesk\Autodesk Fusion 360\API\Scripts\GridfinityBaseplateGenerator\`

### How to Use It in Fusion 360:
1. Open **Autodesk Fusion**.
2. Press **`Shift + S`** (or go to **Utilities** tab $\rightarrow$ **Add-Ins** $\rightarrow$ **Scripts and Add-Ins**).
3. Under the **My Scripts** section, select **`GridfinityBaseplateGenerator`**.
4. Click **Run**.
5. A prompt will ask for:
   * **Grid Units in X** (e.g. `2`)
   * **Grid Units in Y** (e.g. `2`)
   * **Style**: `0` (Ultralight Skeleton with $0.7\text{ mm}$ bottom ledge), `1` (Standard $0.4\text{ mm}$ floor), or `2` (Solid $1.2\text{ mm}$ floor)
   * **Corner Holes**: `0` (None), `2` (Diagonal corners), or `4` (All 4 corners at $26\text{ mm}$ spacing)
6. Fusion generates a clean B-Rep component with native **User Parameters** (`GF_Pitch`, `GF_Socket_Top`, `GF_Socket_Waist`, `GF_Socket_Bot`, `GF_Profile_Height`, `GF_Hole_Spacing`) in your design timeline!

---

## Method 2: Direct STEP B-Rep Export to Fusion 360

If you want immediate solid models that you can open or import into any Fusion assembly without running a script, pre-generated STEP files are located in:
[`export/step/`](file:///c:/Users/Julian/Documents/Bambu%20Lab%20Maker/export/step/)

### Ready-to-Open STEP Files:
* [`gridfinity_base_1x2.step`](file:///c:/Users/Julian/Documents/Bambu%20Lab%20Maker/export/step/gridfinity_base_1x2.step)
* [`gridfinity_base_2x2.step`](file:///c:/Users/Julian/Documents/Bambu%20Lab%20Maker/export/step/gridfinity_base_2x2.step)
* [`gridfinity_base_2x3.step`](file:///c:/Users/Julian/Documents/Bambu%20Lab%20Maker/export/step/gridfinity_base_2x3.step)

### How to Open in Fusion:
1. In Fusion 360, click **File** $\rightarrow$ **Open...** (or **Insert** $\rightarrow$ **Insert Derive / Insert STEP**).
2. Select any `.step` file from `export/step/`.
3. You will have exact solid geometry with true B-Rep edges, faces, and fillets.

### Exporting Any Size on Demand:
To generate any custom size (e.g. $3 \times 4$ cells), run this command from the project root:
```bash
bash -c "cd scratch/gfthings && uv run python ../../scripts/export_fusion_step.py -x 3 -y 4 -o ../../export/step/gridfinity_base_3x4.step"
```
Options available:
* `-x <units>`: Number of columns
* `-y <units>`: Number of rows
* `--screw-holes <0|2|4>`: Corner holes per cell
* `--short`: Ultra-lightweight variant without screw bosses
