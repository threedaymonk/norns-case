$fs = $preview ? 1 : 0.1;
$fa = $preview ? 3 : 2;
$e = 0.001;

// Main body diameter (mm) (at bottom, excluding skirt)
Diameter = 15;
// Total height (mm)
Height = 10;

ShaftDepth = 8.5; // [0.0:0.01:50.0]

// How far the shaft protrudes relative to the outer shell
// Negative values mean the shaft is inside the shell
ShaftOutset = 3;

// X/Y Offset to compensate for shrinking holes when printing. Increase if too tight. Decrease if too loose.
ShaftOffset = 0.18; // [-1.0:0.01:1.0]

KnurledShaftMajorDiameter = 6.0; // [3.0:0.01:15.0]

KnurlCount = 18;

// Knurled shaft.
// 6mm major diameter, 18 knurls, fits most pots.
module KnurledShaft(h, clearance=0, flare=0, d=6, count=18) {
  spacing = (d-2*clearance) * PI/count * 0.7;
  difference() {
    cylinder(h = h-clearance, d = d+2*clearance);
    SquareSerrations(h=h, d1=d+2*clearance, d2=d+2*clearance, fromz=0, toz=h,
      count=18, gapPct=30, rotationDeg=45, slant=0);
  }
  if (flare>0) Cone(h=d/2+flare*2, d=d+flare*2);
}

module SquareSerrations(h, d1, d2, fromz, toz, offset=0, count, gapPct=50, rotationDeg, slant) {
  baseD = DiameterAt(h, d1, d2, fromz);
  side = baseD*PI / count * (100-gapPct)/100;
  for (i=[0:count-1])
      rotate([0,0,360/count*i])
        translate([baseD/2+offset, 0, fromz])
          rotate([0, -slant, 0])
            rotate([0,0,rotationDeg])
              translate([-side/2, -side/2, 0])
                cube([side,side,toz-fromz]);
}

module Cone(h, d) {
  cylinder(h=h, d1=d, d2=0);
}

// Diameter of a slanted cylinder at height pos (lerp)
function DiameterAt(h, d1, d2, pos) = d1 - (d1-d2)*(pos/h);

module RoundedCylinder(h, d, r, corner_r=2) {
  r = (r == undef) ? d/2 : r;

  rotate_extrude() {
    intersection() {
      translate([r - corner_r, h - corner_r])
        circle(r = corner_r);
      square([r, h]);
    }
    polygon([
      [0, 0], [0, h], [r - corner_r, h], [r, h - corner_r], [r, 0]
    ]);
  }
}


rotate([180, 0, 0]) {
  difference() {
    union() {
      cylinder(h=Height, d=KnurledShaftMajorDiameter + 2);
      difference() {
        translate([0, 0, ShaftOutset])
          RoundedCylinder(h=Height, d=Diameter, corner_r=2);
        cylinder(h=ShaftDepth, d=Diameter - 4*0.4);
      }
    }
    translate([0, 0, -$e])
      KnurledShaft(h = ShaftDepth + $e,
                   flare=0.5,
                   clearance=ShaftOffset,
                   d=KnurledShaftMajorDiameter,
                   count=KnurlCount);
  }
}
