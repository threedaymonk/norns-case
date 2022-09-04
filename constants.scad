$fs = $preview ? 1 : 0.1;
$fa = $preview ? 3 : 2;

size_x = 92.5;
size_y = 87.5;
size_z = 40.05;

corner_r = 6;

wall_th = 2.1;
base_th = 3.3;

screw_hole_d = 2.6;
screw_head_d = 5.5;
screw_head_depth = 2;
screw_boss_inner_d = 4;
screw_boss_outer_d = 6;
screw_mounts = [
  // x, y, height above inner base
  [7.10, 7.10, 1.7],
  [85.5, 7.10, 1.7],
  [27.2, 80.3, 4.3],
  [85.5, 80.3, 4.3],
];

// These are reversed in y relative to screws
// because the top is printed upside down
//
kby_top = 12.8;
kby_bottom = size_y - kby_top;
buttons = [
  [61.1, kby_top],
  [15.2, kby_bottom],
  [30.4, kby_bottom]
];
knobs = [
  [76.3, kby_top],
  [55.8, kby_bottom],
  [76.1, kby_bottom]
];

sockets = [
  // x, z
  [35.5, 22.5],
  [48, 22.5]
];
