#!/usr/bin/env python3
"""
Official Gridfinity STEP Export Utility for Autodesk Fusion 360
----------------------------------------------------------------
Generates official-specification B-Rep STEP solid files compatible with
Autodesk Fusion, conforming strictly to https://gridfinity.xyz/specification/.

Usage:
    uv run python scripts/export_fusion_step.py -x 2 -y 2 -o export/step/my_plate.step
"""

import sys
import argparse
from pathlib import Path

# Add scratch/gfthings/src to sys.path
gfthings_path = Path(__file__).resolve().parent.parent / "scratch" / "gfthings" / "src"
if gfthings_path.exists():
    sys.path.insert(0, str(gfthings_path))

try:
    from gfthings.Base import BaseGrid
    from build123d import export_step
except ImportError:
    print("Error: build123d not found. Please run with: uv run python scripts/export_fusion_step.py ...")
    sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description="Export official Gridfinity baseplate to STEP for Autodesk Fusion.")
    parser.add_argument("-x", "--grid-x", type=int, default=2, help="Grid units in X (default: 2)")
    parser.add_argument("-y", "--grid-y", type=int, default=2, help="Grid units in Y (default: 2)")
    parser.add_argument("-o", "--output", type=str, default="export/step/gridfinity_base.step", help="Output STEP filepath")
    parser.add_argument("--screw-holes", type=int, default=2, choices=[0, 2, 4], help="Screw/magnet holes per cell (0, 2, 4)")
    parser.add_argument("--short", action="store_true", help="Generate ultra-short skeleton variant without screw bosses")

    args = parser.parse_args()

    out_file = Path(args.output)
    out_file.parent.mkdir(parents=True, exist_ok=True)

    print(f"Generating official Gridfinity {args.grid_x}x{args.grid_y} baseplate...")
    base = BaseGrid(
        x_num=args.grid_x,
        y_num=args.grid_y,
        screw_hole_count=args.screw_holes,
        short=args.short
    )

    print(f"Exporting STEP solid to: {out_file}")
    export_step(base, str(out_file))
    print("Export complete! You can now open this file directly in Autodesk Fusion.")

if __name__ == "__main__":
    main()
