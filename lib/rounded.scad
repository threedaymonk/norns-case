module rounded_cube(size = [1, 1, 1], r = 0.5, center = false) {
	size = (size[0] == undef) ? [size, size, size] : size;

	shift = (center == false) ?
		[r, r, r] :
		[r - (size[0] / 2), r - (size[1] / 2), r - (size[2] / 2)];

	translate(shift)
    minkowski() {
      cube([size[0] - (r * 2), size[1] - (r * 2), size[2] - (r * 2)]);
      sphere(r = r);
    }
}

module rounded_bottom_cube(size, r = 1, center = false, square_off = 0) {
  x = size[0]; y = size[1] ? size[1] : x; z = size[2] ? size[2] : x;
  if (center) {
    hull() for (i = [-1, 1], j = [-1, 1]) {
      translate([(x/2 - r) * i, (y/2 - r) * j, (z/2 - r) * -1]) {
        intersection() {
          cube(r * 2, center = true);
          translate([0, 0, -square_off]) sphere(r = r);
        }
      }
      translate([(x/2 - r) * i, (y/2 - r) * j, (z/2 - r) * 1])
        cylinder(r = r, h = 2 * r, center = true);
    }
  } else {
    translate([x/2, y/2, z/2])
      rounded_bottom_cube([x, y, z], r, true, square_off);
  }
}
