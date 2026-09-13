// 1x2 Gridfinity Baseplate
// ------------------------
// This script overrides the MakerWorld customizer parameters 
// to explicitly generate a 1x2 baseplate.

// Disable auto-fit to use manual dimensions
use_auto_fit = false;

// Set manual grid size to 1x2
manual_grid_x = 1;
manual_grid_y = 2;

// Disable drawer clearance so we get a pure 1x2 without extension wings
clearance_per_side = 0;

// Set style (0 = Super Light, 1 = Standard, 2 = Solid)
style = 1; 

// Disable print bed tiling for small parts
tiling_mode = false;

// Include the main script (make sure it's in the same directory)
include <Ultralight_Gridfinity.scad>
