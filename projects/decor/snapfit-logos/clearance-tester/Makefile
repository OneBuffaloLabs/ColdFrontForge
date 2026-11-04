COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= clearance_tester.scad
TARGETS   := clearance_tester.stl

.PHONY: all clean

all: $(TARGETS)

clearance_tester.stl: $(SCAD_FILE)
	@echo "--> Rendering -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ $(SCAD_FILE)

clean:
	rm -f $(TARGETS) *.deps

-include $(wildcard *.deps)
