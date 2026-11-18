COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= cold-snap-exhibit.scad
OUT_DIR   ?= models

TARGETS   := $(OUT_DIR)/cold-snap-exhibit.stl \
             $(OUT_DIR)/cold-snap-exhibit-plaque.stl

.PHONY: all clean pedestal exhibit plaque

all: $(TARGETS)

pedestal exhibit: $(OUT_DIR)/cold-snap-exhibit.stl
plaque:           $(OUT_DIR)/cold-snap-exhibit-plaque.stl

$(OUT_DIR)/cold-snap-exhibit.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [pedestal] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="pedestal"' $(SCAD_FILE)

$(OUT_DIR)/cold-snap-exhibit-plaque.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [plaque] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="plaque"' $(SCAD_FILE)

clean:
	@$(call RM_F,$(TARGETS) $(wildcard $(OUT_DIR)/*.deps))

-include $(wildcard $(OUT_DIR)/*.deps)
