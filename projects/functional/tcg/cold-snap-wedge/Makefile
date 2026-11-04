COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= cold-snap-wedge.scad

TARGETS   := models/left/cold-snap-wedge-left.stl \
             models/right/cold-snap-wedge-right.stl \
             models/dual/cold-snap-wedge-dual.stl \
             models/left/cold-snap-wedge-left-v2.stl \
             models/right/cold-snap-wedge-right-v2.stl \
             models/dual/cold-snap-wedge-dual-v2.stl

.PHONY: all clean left right dual

all: $(TARGETS)

left:  models/left/cold-snap-wedge-left.stl models/left/cold-snap-wedge-left-v2.stl
right: models/right/cold-snap-wedge-right.stl models/right/cold-snap-wedge-right-v2.stl
dual:  models/dual/cold-snap-wedge-dual.stl models/dual/cold-snap-wedge-dual-v2.stl

models/left/cold-snap-wedge-left%.stl: $(SCAD_FILE)
	@mkdir -p $(@D)
	@echo "--> Rendering [left$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'hook_side=-1' $(SCAD_FILE)

models/right/cold-snap-wedge-right%.stl: $(SCAD_FILE)
	@mkdir -p $(@D)
	@echo "--> Rendering [right$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'hook_side=1' $(SCAD_FILE)

models/dual/cold-snap-wedge-dual%.stl: $(SCAD_FILE)
	@mkdir -p $(@D)
	@echo "--> Rendering [dual$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'hook_side=0' $(SCAD_FILE)

clean:
	rm -f $(TARGETS) models/*/*.deps

-include $(wildcard models/*/*.deps)
