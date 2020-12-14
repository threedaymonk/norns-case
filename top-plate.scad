// make the curves smooth
$fs = 0.1;
$fa = 0.1;

// fudge amount to overlap solids to make the model manifold
$e = 0.001;

// dimensions of the original case
xsize = 92.5;
ysize = 87.5;

// centre line of top row of buttons/knobs
ctop = 12.8;

// centre line of top row of buttons/knobs
cbottom = ysize - ctop;

// radius of push button aperture
rbutton = 8 / 2;

// radius of knob aperture
// add about 1mm all round for it to spin freely: this is for
// 11mm diameter knobs.
rknob = 13 / 2;

// thickness of top plate
thickness = 3;

// window size
// calculated using actual position of screen; win_d allows
// a larger gap around the OLED itself to make the screen visible off-axis.
win_d = 2;
win_x = 14 - win_d;
win_y = 27 - win_d;
win_xsize = 66 + 2 * win_d;
win_ysize = 33 + 2 * win_d;

// vertical flat portion of window before chamfer
win_flat = 1;

// thickness of (existing) case wall
wall = 2;

// length of wall stabiliser bars
stab_l = 25;

module plate() {
  linear_extrude(height = thickness) {
    difference() {
      rotate([180, 0, 0]) {
        translate([xsize / 2, -ysize / 2]) {
          projection(cut=false) {
            import("norns-case.stl");

            // fill in the vents and micro SD cutout
            translate([-xsize / 2 + $e, -ysize / 4, 0])
              cube([xsize - $e, ysize / 2, 1]);
          }
        }
      }
      // button and knob centres are just hardcoded here
      union() {
        translate([61.1, ctop]) circle(rbutton);
        translate([76.3, ctop]) circle(rknob);
        translate([15.2, cbottom]) circle(rbutton);
        translate([30.4, cbottom]) circle(rbutton);
        translate([55.8, cbottom]) circle(rknob);
        translate([76.1, cbottom]) circle(rknob);
      }
    }
  }
  translate([(xsize - stab_l) / 2, 0, thickness - $e]) {
    translate([0, wall, 0]) cube([stab_l, wall, wall + $e]);
    translate([0, ysize - wall * 2, 0]) cube([stab_l, wall, wall + $e]);
  }
  translate([0, (ysize - stab_l) / 2, thickness - $e]) {
    translate([wall, 0, 0]) cube([wall, stab_l,wall + $e]);
    translate([xsize - wall * 2, 0, 0]) cube([wall, stab_l, wall + $e]);
  }
}

module window() {
  z0 = -$e;
  z1 = thickness - win_flat;
  d = thickness - win_flat;

  // chamfered part
  // see https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids
  points = [
    [win_x - d, win_y - d, z0],
    [win_x + win_xsize + d, win_y - d, z0],
    [win_x + win_xsize + d, win_y + win_ysize + d, z0],
    [win_x - d, win_y + win_ysize + d, z0],
    [win_x, win_y, z1],
    [win_x + win_xsize, win_y, z1],
    [win_x + win_xsize, win_y + win_ysize, z1],
    [win_x, win_y + win_ysize, z1],
  ];
  faces = [
    [0,1,2,3], [4,5,1,0], [7,6,5,4],
    [5,6,2,1], [6,7,3,2], [7,4,0,3]
  ];
  polyhedron(points, faces);

  // vertical part
  translate([win_x, win_y, -$e])
    cube([win_xsize, win_ysize, thickness + $e * 2]);
}

difference() {
  plate();
  window();
}
