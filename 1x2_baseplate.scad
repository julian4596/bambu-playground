// 1x2 Gridfinity Baseplate
// ------------------------
// This script overrides the MakerWorld customizer parameters 
// to explicitly generate an official-compliant 1x2 baseplate.

_override_use_auto_fit = false;
_override_manual_grid_x = 1;
_override_manual_grid_y = 2;
_override_clearance = 0;
_override_style = 1; // Standard (0.4mm floor)
_override_tiling_mode = false;

use_auto_fit = false;
manual_grid_x = 1;
manual_grid_y = 2;
clearance_per_side = 0;
style = 1;
tiling_mode = false;

// Include the main script (make sure it's in the same directory)
include <Ultralight_Gridfinity.scad>
