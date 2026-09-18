// Test script for gridfinity_core.scad
include <../gridfinity_core.scad>

// Official v5 specification assertions
echo("Checking constants...");
echo(str("GF_PITCH = ", GF_PITCH));
echo(str("GF_SOCKET_TOP_W = ", GF_SOCKET_TOP_W));
echo(str("GF_SOCKET_WAIST_W = ", GF_SOCKET_WAIST_W));
echo(str("GF_SOCKET_BOT_W = ", GF_SOCKET_BOT_W));

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
