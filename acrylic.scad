include <constants.scad>;

// Diameter of push button aperture
// Actual diameter is about 7.5;
button_d = 8;

// Diameter of knob aperture
// Actual diameter is about 11.5mm
knob_d = 12;

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
