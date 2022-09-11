module rounded_square(size = [1, 1], r = 0.5, center = false) {
	size = (size[0] == undef) ? [size, size] : size;
  sx = size[0]; sy = size[1];

	shift = (center == false) ? [r, r] : [r - sx/2, r - sy/2];

	translate(shift) minkowski() {
    square([sx - r*2, sy - r*2]);
    circle(r = r);
  }
}

module rounded_cube(size = [1, 1, 1], r = 0.5, center = false) {
	size = (size[0] == undef) ? [size, size, size] : size;
  sx = size[0]; sy = size[1]; sz = size[2];

	shift = (center == false) ? [r, r, r] : [r - sx/2, r - sy/2, r - sz/2];

	translate(shift) minkowski() {
    cube([sx - r*2, sy - r*2, sz - r*2]);
    if ($children == 0) sphere(r = r);
    else children();
  }
}

module rounded_bottom_cube(size, r = 1, center = false, square_off = 0) {
  rounded_cube(size, r, center) {
    hull() {
      intersection() {
        translate ([0, 0, -square_off]) sphere(r = r);
        cylinder(r = r, h = r * 2, center = true);
      }
      cylinder(r = r, h = r);
    }
  }
}
