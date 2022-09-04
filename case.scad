$fs = $preview ? 1 : 0.1;
$fa = $preview ? 3 : 1;

include <lib/rounded.scad>

corner_r = 6;
base_thickness = 3.3;
wall_thickness = 2.1;
size_x = 92.5;
size_y = 87.5;
size_z = 40.05;

module shell() {
  difference() {
    rounded_bottom_cube(
      [size_x, size_y, size_z],
      r = corner_r,
      square_off = 1
    );
    translate([wall_thickness, wall_thickness, base_thickness])
      rounded_bottom_cube(
        [size_x - 2 * wall_thickness,
         size_y - 2 * wall_thickness,
         size_z],
        r = corner_r - wall_thickness
      );
  }
}

module screw_boss_neg(thickness) {
  head_d = 5;
  shaft_d = 2.6;
  head_depth = 2;

  translate([0, 0, -1]) {
    cylinder(d = head_d, h = head_depth + 1);
    cylinder(d = shaft_d, h = thickness + 2);
  }
}

module screw_boss_pos(thickness, h) {
  inner_d = 4;
  outer_d = 6;

  translate([0, 0, thickness - 1])
    linear_extrude(height = 1 + h)
      difference() {
        circle(d = outer_d);
        circle(d = inner_d);
      }
}

module grill(length, width, pitch, count, h = 100) {
  translate([-pitch * floor(count / 2), 0, 0])
    for (i = [0 : count - 1])
      hull() for(j = [-1, 1])
      translate([pitch * i, (length - width) / 2 * j, 0])
        cylinder(d = width, h = h);
}

screw_mounts = [
  // x, y, height above inner base
  [7.10, 7.10, 1.7],
  [85.5, 7.10, 1.7],
  [27.2, 80.3, 4.3],
  [85.5, 80.3, 4.3],
];

module negatives() {
  // Screw holes
  for (screw_mount = screw_mounts)
    translate([screw_mount[0], screw_mount[1], 0])
      screw_boss_neg(thickness = base_thickness);

  // Grill
  translate([size_x / 2, size_y / 2, -1])
    grill(length = 38, width = 2.4, pitch = 3.975, count = 9, h=10);

  // USB
  translate([-10, 29.7, 9.5]) rounded_cube([20, 15, 17.3], r = 1);
  translate([-10, 47.7, 9.5]) rounded_cube([20, 15, 17.3], r = 1);
  translate([-10, 66.2, 9.5]) rounded_cube([20, 16.5, 14.3], r = 1);

  // Micro SD
  translate([size_x - 6.2, 48.5, -10]) rounded_cube([20, 15.4, 18.3], r = 1);

  // Sockets
  translate([35.5, size_y, 22.5]) rotate([90, 0, 0]) cylinder(d = 8, h = 20, center = true);
  translate([48, size_y, 22.5]) rotate([90, 0, 0]) cylinder(d = 8, h = 20, center = true);

  // Labels
  translate([35.5, size_y - 0.5, 30]) rotate([-90, 180, 0]) linear_extrude(10)
    text("IN", size = 4, halign = "center", font = "Liberation Sans:style=Bold");
  translate([48, size_y - 0.5, 30]) rotate([-90, 180, 0]) linear_extrude(10)
    text("OUT", size = 4, halign = "center", font = "Liberation Sans:style=Bold");


  // Power in
  translate([72.1, size_y - 10, 6.9]) rounded_cube([12.6, 20, 7.5], r = 1);

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
  translate([31, size_y - wall_thickness - 1, 8]) cube([36, 1.5, 9]);
}

module positives() {
  // Screw bosses
  for (screw_mount = screw_mounts)
    translate([screw_mount[0], screw_mount[1], 0])
      screw_boss_pos(thickness = base_thickness, h = screw_mount[2]);
}

difference() {
  shell();
  negatives();
}
positives();
