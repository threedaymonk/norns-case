MAKEFLAGS += -j4

OUTPUTS = case.stl top-plate.stl knob.stl

.PHONY: all clean

all: $(OUTPUTS)

%.stl: %.scad
	openscad -o $@ $<

%.svg: %.scad
	openscad -o $@ $<

top-plate.stl: top-plate.scad constants.scad

case.stl: case.scad rounded.scad constants.scad

clean:
	rm -f $(OUTPUTS)
