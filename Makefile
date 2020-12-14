SOURCES = $(wildcard *.scad)
OUTPUTS = $(patsubst %.scad,%.stl,$(SOURCES))

.PHONY: all clean

all: $(OUTPUTS)

norns-case.stl:
	@echo "Download the case STL by JHC from this thread and save it here as norns-case.stl"
	@echo "https://llllllll.co/t/norns-shield-case-designs/30347/224"
	@echo
	@false

%.stl: %.scad norns-case.stl
	openscad -o $@ $<

clean:
	rm -f $(OUTPUTS)
