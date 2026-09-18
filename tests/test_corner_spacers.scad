// ============================================================================
// Test Suite: Ultralight Corner Spacers Gridfinity Baseplate
// ============================================================================
// Simulates a 6x7 drawer setup matching the reference photo

_override_use_auto_fit = false;
_override_manual_grid_x = 6;
_override_manual_grid_y = 7;
_override_style = 0; // Ultralight Skeleton
_override_chamfer_ledge = true;
_override_wall_cutout_mode = 0;
_override_corner_holes = 0;
_override_tiling_mode = false;

// Manual extension reach to test dual-window bumper tabs
_override_ext_L = 20.0;
_override_ext_R = 20.0;
_override_ext_F = 20.0;
_override_ext_B = 20.0;

include <../Ultralight_Corner_Spacers_Gridfinity.scad>
