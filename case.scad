include <rounded.scad>
include <constants.scad>

module shell() {
  difference() {
    rounded_bottom_cube(
      [size_x, size_y, size_z],
      r = corner_r,
      square_off = 1
    );
    translate([wall_th, wall_th, base_th])
      rounded_bottom_cube(
        [size_x - 2 * wall_th,
         size_y - 2 * wall_th,
         size_z],
        r = corner_r - wall_th
      );
  }
}

module screw_boss_neg(thickness) {
  translate([0, 0, -1]) {
    cylinder(d = screw_head_d, h = screw_head_depth + 1);
    cylinder(d = screw_hole_d, h = thickness + 2);
  }
}

module screw_boss_pos(thickness, h) {
  translate([0, 0, thickness - 1])
    linear_extrude(height = 1 + h)
      difference() {
        circle(d = screw_boss_outer_d);
        circle(d = screw_boss_inner_d);
      }
}

module grill(length, width, pitch, count, h = 100) {
  translate([-pitch * floor(count / 2), 0, 0])
    for (i = [0 : count - 1])
      hull() for(j = [-1, 1])
      translate([pitch * i, (length - width) / 2 * j, 0])
        cylinder(d = width, h = h);
}

module negatives() {
  // Screw holes
  for (screw_mount = screw_mounts)
    translate([screw_mount[0], screw_mount[1], 0])
      screw_boss_neg(thickness = base_th);

  // Grill
  translate([size_x / 2, size_y / 2, -1])
    grill(length = 38, width = 2.4, pitch = 3.975, count = 9, h=10);

  // USB
  translate([-10, 29.7, 9.4]) rounded_cube([20, 15, 17.4], r = 1);
  translate([-10, 47.7, 9.4]) rounded_cube([20, 15, 17.4], r = 1);
  translate([-10, 66.2, 9.4]) rounded_cube([20, 16.5, 14.4], r = 1);

  // Micro SD
  translate([size_x - 6.2, 48.5, -10]) rounded_cube([20, 15.4, 18.4], r = 1);

  // Sockets
  for(xz = sockets)
    translate([xz[0], size_y, xz[1]]) rotate([90, 0, 0]) cylinder(d = 8, h = 20, center = true);

  // Power in
  translate([72.1, size_y - 10, 6.8]) rounded_cube([12.6, 20, 7.6], r = 1);

  // Feet
  foot_d = 10.5;
  foot_x = 10.9;
  foot_y = 14.4;
  foot_depth = 2;
  feet = [
    [foot_x, foot_y],
    [size_x - foot_x, foot_y],
    [foot_x, size_y - foot_y],
    [size_x - foot_x, size_y - foot_y],
  ];
  for (foot = feet)
    translate([foot[0], foot[1], -1])
      cylinder(d = foot_d, h = foot_depth + 1);

  // Blind connectors
  translate([31, size_y - wall_th - 1, 8]) cube([36, 1 + wall_th - 1.2, 9]);
}

module positives() {
  // Screw bosses
  for (screw_mount = screw_mounts)
    translate([screw_mount[0], screw_mount[1], 0])
      screw_boss_pos(thickness = base_th, h = screw_mount[2]);
}

difference() {
  shell();
  negatives();
}
positives();
