include <constants.scad>;
include <rounded.scad>;

// fudge amount to overlap solids to make the model manifold
$e = 0.001;

// Diameter of push button aperture
// Actual diameter is about 7.5, but we need to allow for paint.
button_d = 8.5;

// Diameter of knob aperture
knob_d = 10;

// Thickness of top plate
top_th = 3;

// Minimum thickness around glazing
min_th = 0.8;

// window size
// calculated using actual position of screen; win_margin allows
// a larger gap around the OLED itself to make the screen visible off-axis.
win_cx = 47;
win_cy = 43.5;
win_margin = 3;
win_sx = 66 + 2 * win_margin;
win_sy = 33 + 2 * win_margin;

glass_th = 3;
glass_margin_x = 5.5;
glass_margin_y = 3;

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

      translate([win_cx, win_cy]) rounded_square([win_sx, win_sy], 2, center =true);
    }
  }
}

module stabilizers() {
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

module glass() {
  translate([win_cx, win_cy, min_th])
    
    linear_extrude(height = top_th)
      square([win_sx + glass_margin_x * 2, win_sy + glass_margin_y * 2], center = true);
}

module triangle(size) {
  scale([size / 5, size / 5])
    translate([0, -3/5])
      rotate(-30)
        circle(d = 5, $fn = 3);
}

module arrows() {
  translate([0, 0, -$e]) {
    linear_extrude(layer * 2) {
      translate([sockets[0][0], kby_top]) triangle(7);
      translate([sockets[1][0], kby_top]) rotate(180) triangle(7);
    }
  }
}

difference() {
  union() {
    plate();
    stabilizers();
  }
  glass();
  arrows();
}
