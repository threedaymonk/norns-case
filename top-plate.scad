include <constants.scad>;

// fudge amount to overlap solids to make the model manifold
$e = 0.001;

// Diameter of push button aperture
// Actual diameter is about 7.5;
button_d = 9;

// Diameter of knob aperture
// Actual diameter is about 11.5mm
knob_d = 13;

// Thickness of top plate
top_th = 1.4;

// window size
// calculated using actual position of screen; win_d allows
// a larger gap around the OLED itself to make the screen visible off-axis.
win_d = 2;
win_x = 14 - win_d;
win_y = 27 - win_d;
win_sx = 66 + 2 * win_d;
win_sy = 33 + 2 * win_d;

// vertical flat portion of window before chamfer
win_flat = 1;

// length of wall_th stabiliser bars
stab_l = 25;

module plate() {
  linear_extrude(height = top_th) {
    difference() {
      translate([size_x/2, size_y/2]) hull() {
        for(i = [-1, 1], j = [-1, 1]) {
          translate([i * (size_x / 2 - corner_r), j * (size_y / 2 - corner_r)]) {
            circle(r = corner_r);
          }
        }
      }

      for(xy = buttons) translate(xy) circle(d = button_d);
      for(xy = knobs) translate(xy) circle(d = knob_d);

      // Screw holes (mirrored in y because we're flipped)
      for (screw_mount = screw_mounts)
        translate([screw_mount[0], size_y - screw_mount[1]])
          circle(d = screw_hole_d);
    }
  }

  translate([(size_x - stab_l) / 2, 0, 0]) {
    translate([0, wall_th, 0])
      cube([stab_l, wall_th, wall_th + top_th]);
    translate([0, size_y - wall_th * 2, 0])
      cube([stab_l, wall_th, wall_th + top_th]);
  }
  translate([0, (size_y - stab_l) / 2, 0]) {
    translate([wall_th, 0, 0])
      cube([wall_th, stab_l, wall_th + top_th]);
    translate([size_x - wall_th * 2, 0, 0])
      cube([wall_th, stab_l, wall_th + top_th]);
  }
}

module window() {
  z0 = -$e;
  z1 = top_th - win_flat;
  d = top_th - win_flat;

  // chamfered part
  // see https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids
  points = [
    [win_x - d, win_y - d, z0],
    [win_x + win_sx + d, win_y - d, z0],
    [win_x + win_sx + d, win_y + win_sy + d, z0],
    [win_x - d, win_y + win_sy + d, z0],
    [win_x, win_y, z1],
    [win_x + win_sx, win_y, z1],
    [win_x + win_sx, win_y + win_sy, z1],
    [win_x, win_y + win_sy, z1],
  ];
    faces = [
      [0,1,2,3], [4,5,1,0], [7,6,5,4],
      [5,6,2,1], [6,7,3,2], [7,4,0,3]
    ];
      polyhedron(points, faces);

      // vertical part
      translate([win_x, win_y, -$e])
        cube([win_sx, win_sy, top_th + $e * 2]);
}

difference() {
  plate();
  window();
}
