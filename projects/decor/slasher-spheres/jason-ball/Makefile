COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= jason-ball.scad
OUT_DIR   ?= models

TARGETS   := $(OUT_DIR)/jason-ball-top.stl \
             $(OUT_DIR)/jason-ball-bottom.stl \
             $(OUT_DIR)/jason-ball-ring.stl \
             $(OUT_DIR)/jason-ball-front-ring.stl \
             $(OUT_DIR)/jason-ball-button.stl \
             $(OUT_DIR)/jason-ball-filler.stl \
             $(OUT_DIR)/jason-ball-chips-black.stl \
             $(OUT_DIR)/jason-ball-chips-red.stl \
             $(OUT_DIR)/jason-ball-chips-silver.stl

.PHONY: all clean top bottom ring front_ring front-ring button filler chips_black chips_red chips_silver

all: $(TARGETS)

top:          $(OUT_DIR)/jason-ball-top.stl
bottom:       $(OUT_DIR)/jason-ball-bottom.stl
ring:         $(OUT_DIR)/jason-ball-ring.stl
front_ring:   $(OUT_DIR)/jason-ball-front-ring.stl
front-ring:   $(OUT_DIR)/jason-ball-front-ring.stl
button:       $(OUT_DIR)/jason-ball-button.stl
filler:       $(OUT_DIR)/jason-ball-filler.stl
chips_black:  $(OUT_DIR)/jason-ball-chips-black.stl
chips_red:    $(OUT_DIR)/jason-ball-chips-red.stl
chips_silver: $(OUT_DIR)/jason-ball-chips-silver.stl

$(OUT_DIR)/jason-ball-front-ring.stl: $(SCAD_FILE)
	@mkdir -p $(OUT_DIR)
	@echo "--> Rendering [front_ring] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="front_ring"' $(SCAD_FILE)

$(OUT_DIR)/jason-ball-chips-%.stl: $(SCAD_FILE)
	@mkdir -p $(OUT_DIR)
	@echo "--> Rendering [chips_$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="chips_$*"' $(SCAD_FILE)

$(OUT_DIR)/jason-ball-%.stl: $(SCAD_FILE)
	@mkdir -p $(OUT_DIR)
	@echo "--> Rendering [$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="$*"' $(SCAD_FILE)

clean:
	rm -f $(TARGETS) $(wildcard $(OUT_DIR)/*.deps)

-include $(wildcard $(OUT_DIR)/*.deps)
