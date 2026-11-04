COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= ghostface-ball.scad
OUT_DIR   ?= models

TARGETS   := $(OUT_DIR)/ghostface-ball-top.stl \
             $(OUT_DIR)/ghostface-ball-bottom.stl \
             $(OUT_DIR)/ghostface-ball-ring.stl \
             $(OUT_DIR)/ghostface-ball-front-ring.stl \
             $(OUT_DIR)/ghostface-ball-button.stl \
             $(OUT_DIR)/ghostface-ball-filler.stl \
             $(OUT_DIR)/ghostface-ball-chips-black.stl \
             $(OUT_DIR)/ghostface-ball-chips-white.stl

.PHONY: all clean top bottom ring front_ring front-ring button filler chips_black chips_white

all: $(TARGETS)

top:          $(OUT_DIR)/ghostface-ball-top.stl
bottom:       $(OUT_DIR)/ghostface-ball-bottom.stl
ring:         $(OUT_DIR)/ghostface-ball-ring.stl
front_ring:   $(OUT_DIR)/ghostface-ball-front-ring.stl
front-ring:   $(OUT_DIR)/ghostface-ball-front-ring.stl
button:       $(OUT_DIR)/ghostface-ball-button.stl
filler:       $(OUT_DIR)/ghostface-ball-filler.stl
chips_black:  $(OUT_DIR)/ghostface-ball-chips-black.stl
chips_white:  $(OUT_DIR)/ghostface-ball-chips-white.stl

$(OUT_DIR)/ghostface-ball-front-ring.stl: $(SCAD_FILE)
	@mkdir -p $(OUT_DIR)
	@echo "--> Rendering [front_ring] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="front_ring"' $(SCAD_FILE)

$(OUT_DIR)/ghostface-ball-chips-%.stl: $(SCAD_FILE)
	@mkdir -p $(OUT_DIR)
	@echo "--> Rendering [chips_$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="chips_$*"' $(SCAD_FILE)

$(OUT_DIR)/ghostface-ball-%.stl: $(SCAD_FILE)
	@mkdir -p $(OUT_DIR)
	@echo "--> Rendering [$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="$*"' $(SCAD_FILE)

clean:
	rm -f $(TARGETS) $(wildcard $(OUT_DIR)/*.deps)

-include $(wildcard $(OUT_DIR)/*.deps)
