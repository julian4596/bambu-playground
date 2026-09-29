# Ultralight Spacerless Gridfinity

Open `Ultralight_Spacerless_Gridfinity.scad` in OpenSCAD. Style 0 generates
open-bottom, rounded rings with chamfered seating faces and diamond-shaped
gaps where four cells meet. Drawer fitting and print-bed tiling remain available.

## Reference dimensions and reconstruction

The supplied reference screenshots measure a 2×2 plate at **84×84×4.25 mm**.
Their close-ups show sloped inner faces and a small lower transition, rather
than the previous flat opening and outward underside recess.

Paul Bone's [parameters.py](https://github.com/PaulBone/gfthings/blob/main/src/gfthings/parameters.py)
defines a 42 mm pitch and profile stages of 0.8, 1.8, and 2.15 mm.
[GFProfile.py](https://github.com/PaulBone/gfthings/blob/main/src/gfthings/GFProfile.py)
uses those stages for the chamfered profile. This is useful dimensional
reference, but its baseplate is not established as the model in the screenshots.
The local `gridfinity-rebuilt-openscad/src/core/gridfinity-baseplate.scad`
uses a related profile with a 0.7 mm lower chamfer and a 5 mm overall plate.
Neither source proves the exact 4.25 mm reference cross-section.

Style 0 therefore uses an explicit assumption: trim 0.5 mm from the bottom of
the 4.75 mm profile, retaining 0.3 mm of lower chamfer, 1.8 mm of straight wall,
and 2.15 mm of upper chamfer. The top opening remains 41.5 mm with 4 mm corner
radius; each cell's outer outline remains 42 mm with 4.25 mm corner radius.
The corresponding straight opening at the bottom is 36.6 mm, and at the middle
it is 37.2 mm. Straight outer rails are 0.25 mm at the top, 2.4 mm in the middle,
and 2.7 mm at the bottom; interior dividers have twice those widths.
These are derived candidate dimensions, not measurements of the reference.

Later underside close-ups show a recessed channel under each rail with a
sloping interior and narrow edge rims. Style 0 now subtracts a tapered rounded
annular channel under each cell, including around corners. The candidate defaults
are a 1.8 mm depth, 0.4 mm rims at the mouth, and a 0.3 mm wide channel roof.
The resulting mouth is approximately 1.9 mm wide along straight rails. Adjacent
cells retain a central rib between their channels. These relief dimensions are
visual estimates, not source-derived dimensions; `underside_relief_depth` and
`underside_relief_rim` expose the estimates for adjustment. `underside_relief`
can disable the channel. The earlier 2.7 mm bottom rail width describes the
envelope before this channel is subtracted.

Styles 1 and 2 retain the full 4.75 mm profile. This source is implemented in
OpenSCAD; the downloaded Python files under `reference/gfthings` are reference
material only and retain their original copyright and license notices.

## Comparison sample

`render_2x2.scad` selects a manual 2×2, style-0, untiled sample. Render it to
compare the candidate with the screenshots. Rendered artifacts are placed in
`output/reference-match/`. Dimensional and mesh checks do not establish printed
fit; the shortened underside profile remains a reconstruction assumption.
