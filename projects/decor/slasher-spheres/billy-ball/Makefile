COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= billy-ball.scad
OUT_DIR   ?= models

TARGETS   := $(OUT_DIR)/billy-ball-top.stl \
             $(OUT_DIR)/billy-ball-bottom.stl \
             $(OUT_DIR)/billy-ball-ring.stl \
             $(OUT_DIR)/billy-ball-front-ring.stl \
             $(OUT_DIR)/billy-ball-button.stl \
             $(OUT_DIR)/billy-ball-filler.stl \
             $(OUT_DIR)/billy-chips-black.stl \
             $(OUT_DIR)/billy-chips-red.stl

.PHONY: all clean top bottom ring front_ring front-ring button filler chips_black chips_red

all: $(TARGETS)

top:          $(OUT_DIR)/billy-ball-top.stl
bottom:       $(OUT_DIR)/billy-ball-bottom.stl
ring:         $(OUT_DIR)/billy-ball-ring.stl
front_ring:   $(OUT_DIR)/billy-ball-front-ring.stl
front-ring:   $(OUT_DIR)/billy-ball-front-ring.stl
button:       $(OUT_DIR)/billy-ball-button.stl
filler:       $(OUT_DIR)/billy-ball-filler.stl
chips_black:  $(OUT_DIR)/billy-chips-black.stl
chips_red:    $(OUT_DIR)/billy-chips-red.stl

$(OUT_DIR)/billy-ball-front-ring.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [front_ring] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="front_ring"' $(SCAD_FILE)

$(OUT_DIR)/billy-chips-%.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [chips_$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="chips_$*"' $(SCAD_FILE)

$(OUT_DIR)/billy-ball-%.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="$*"' $(SCAD_FILE)

clean:
	@$(call RM_F,$(TARGETS) $(wildcard $(OUT_DIR)/*.deps))

-include $(wildcard $(OUT_DIR)/*.deps)
