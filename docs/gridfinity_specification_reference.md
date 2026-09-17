# Gridfinity Engineering Specification & Knowledge Base Reference

**Standard:** Gridfinity Design Reference v5  
**Canonical Sources:** 
- [gridfinity.xyz/specification/](https://gridfinity.xyz/specification/) (by willtree8 / Zack Freedman)
- [PaulBone/gfthings](https://github.com/PaulBone/gfthings) (by Paul Bone)
- [Printables Model #608500](https://www.printables.com/model/608500-gridfinity-base-light-magnetic-connectable-paramet)

---

## 1. System Overview

Gridfinity is an open-source, modular storage system designed by Zack Freedman. The entire ecosystem relies on a strict $42.0\text{ mm}$ grid unit pitch. Every baseplate and bin must adhere to standard profile dimensions and tolerance offsets to ensure 100% interoperability across different designers, printers, and materials.

---

## 2. Core Geometric Standards

### 2.1 The 42.0 mm Pitch Rule
* Center-to-center spacing between any two adjacent Gridfinity cells is **strictly $42.0\text{ mm}$**.
* This dimension never changes regardless of baseplate style, nozzle diameter, or drawer dimensions.

### 2.2 Clearance & Tolerances
* **Standard Clearance Offset**: $0.25\text{ mm}$ per side ($0.50\text{ mm}$ total clearance across any cell axis).
* External bin footprints are undersized by $0.25\text{ mm}$ per side ($41.5 \times 41.5\text{ mm}$).
* Baseplate socket profiles are offset outward by $+0.25\text{ mm}$ per side from the bin foot profile.

---

## 3. Bin Foot vs. Baseplate Socket Engineering Profiles

### 3.1 Bin Foot Profile (External Male Interface)
Total vertical height of the foot: **$4.75\text{ mm}$**
* **$Z = 2.60\text{ mm}$ to $4.75\text{ mm}$ ($2.15\text{ mm}$ height)**: $45^\circ$ top chamfer widening outward from $37.20\text{ mm}$ to $41.50\text{ mm}$.
* **$Z = 0.80\text{ mm}$ to $2.60\text{ mm}$ ($1.80\text{ mm}$ height)**: Straight vertical waist at $37.20\text{ mm}$.
* **$Z = 0.00\text{ mm}$ to $0.80\text{ mm}$ ($0.80\text{ mm}$ height)**: $45^\circ$ bottom chamfer narrowing inward from $37.20\text{ mm}$ to $35.60\text{ mm}$.
* **$Z = 0.00\text{ mm}$**: Flat bottom face at $35.60\text{ mm}$.
* **Corner Fillet Radii**:
  - Top Rim ($41.50\text{ mm}$): $r = 3.75\text{ mm}$ ($7.5\text{ mm} \oslash$)
  - Mid Waist ($37.20\text{ mm}$): $r = 1.60\text{ mm}$ ($3.2\text{ mm} \oslash$)
  - Bottom Flat ($35.60\text{ mm}$): $r = 0.80\text{ mm}$ ($1.6\text{ mm} \oslash$)

### 3.2 Baseplate Socket Profile (Internal Female Interface)
Total vertical depth of the socket: **$4.65\text{ mm}$**
* **$Z = 2.50\text{ mm}$ to $4.65\text{ mm}$ ($2.15\text{ mm}$ height)**: $45^\circ$ top chamfer funnel expanding outward from $37.70\text{ mm}$ to $42.00\text{ mm}$.
* **$Z = 0.70\text{ mm}$ to $2.50\text{ mm}$ ($1.80\text{ mm}$ height)**: Straight vertical waist at $37.70\text{ mm}$ ($37.2 + 2 \times 0.25\text{ mm}$).
* **$Z = 0.00\text{ mm}$ to $0.70\text{ mm}$ ($0.70\text{ mm}$ height)**: $45^\circ$ bottom chamfer shelf narrowing inward from $37.70\text{ mm}$ to $36.30\text{ mm}$ ($37.7 - 2 \times 0.70\text{ mm}$).
* **Bottom Relief**: The baseplate bottom chamfer is $0.70\text{ mm}$ tall (compared to $0.80\text{ mm}$ on the bin). This provides **$0.10\text{ mm}$ vertical clearance**, preventing bins from bottoming out or rocking.
* **Corner Fillet Radii**:
  - Top Rim ($42.00\text{ mm}$): $r = 4.00\text{ mm}$ ($8.0\text{ mm} \oslash$)
  - Mid Waist ($37.70\text{ mm}$): $r = 1.85\text{ mm}$ ($3.7\text{ mm} \oslash$)
  - Bottom Opening ($36.30\text{ mm}$): $r = 1.15\text{ mm}$ ($2.3\text{ mm} \oslash$)

---

## 4. Vertical Interface Cross-Section

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

## 5. Mounting Holes Specification (Magnets & Screws)

Standard Gridfinity bins and baseplates place mounting holes at the corners of each unit cell:
* **Hole Center Position**: Located $13.0\text{ mm}$ from the cell center along both X and Y axes ($8.0\text{ mm}$ inward from the cell pitch boundary).
* **Pattern Spacing**: Exactly **$26.0 \times 26.0\text{ mm}$** center-to-center square.
* **Magnet Dimensions**:
  - Diameter: $6.2\text{ mm}$ press-fit for standard $6.0\text{ mm}$ neodymium magnets.
  - Depth: $2.2\text{ mm}$ (for $2.0\text{ mm}$ thick magnets).
* **Screw Dimensions**:
  - Diameter: $3.2\text{ mm}$ clearance (or $3.0\text{ mm}$ tap) for M3 hardware.

---

## 6. Height Units & Bin Stacking Lip

* **Height Unit ($1u$)**: $7.0\text{ mm}$.
* Bins are measured in units: $2u = 14\text{ mm}$, $3u = 21\text{ mm}$, $6u = 42\text{ mm}$.
* **Stacking Lip**: $+4.4\text{ mm}$ total addition above the nominal bin height:
  - Bottom chamfer: $0.70\text{ mm}$ @ $45^\circ$
  - Straight vertical: $1.80\text{ mm}$
  - Top chamfer: $1.90\text{ mm}$ @ $45^\circ$ (with $0.25\text{ mm}$ top offset)

---

## 7. Ultralight Baseplate Architecture (gfthings Patterns)

To achieve maximum filament savings while maintaining 100% standard compliance:
1. **Corner Pillars**: Retain the exact 3-layer socket profile in all 4 corners of each cell. Bins locate and seat perfectly.
2. **Chamfered Bottom Ledge**: Keep the $0.70\text{ mm}$ $45^\circ$ bottom chamfer shelf around the socket base. The bin foot rests securely on this angled ledge rather than dropping through.
3. **Open Floor**: Cut through the central $36.3 \times 36.3\text{ mm}$ void down to $Z = 0$, saving $60\text{--}75\%$ of baseplate plastic.
4. **Intersection Diamonds**: Outer boundary with $r = 4.0\text{ mm}$ corners creates natural diamond voids at 4-way cell junctions.
5. **Edge Cutouts**: Divider walls between corners can be cut away with arched doorways or trapezoidal slots (`gf_edge_cut`), reducing print time without sacrificing structural rigidity.

---

## 8. OpenSCAD Usage Reference

All OpenSCAD generators in this workspace utilize `gridfinity_core.scad`:

```openscad
include <gridfinity_core.scad>

// Subtract official pocket socket
difference() {
    gf_cell_envelope(42, 42, GF_PROFILE_H);
    gf_socket_pocket(open_bottom=true, chamfer_ledge=true);
    gf_corner_holes(count=4);
}
```
