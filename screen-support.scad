// make the curves smooth
$fs = 0.1;
$fa = 0.1;

// dimensions of the bottom block (length is inferred from pitch below)
height = 8.5;
width = 5.0;

// pin dimensions
pin_diameter = 2.0;
pin_height = 1.0;

// centre-to-centre distance between the two pins
pitch = 42.0;

hull() {
  cylinder(r = width / 2, h = height);

  translate([pitch, 0, 0])
    cylinder(r = width / 2, h = height);
}

cylinder(r = pin_diameter / 2, h = height + pin_height);

translate([pitch, 0, 0])
  cylinder(r = pin_diameter / 2, h = height + pin_height);
