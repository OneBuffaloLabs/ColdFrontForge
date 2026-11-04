COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= [product-name].scad
OUT_DIR   ?= models

PARTS     ?= main accent plate
TARGETS   ?= $(foreach p,$(PARTS),$(OUT_DIR)/[product-name]-$(p).stl)

.PHONY: all clean $(PARTS)

all: $(TARGETS)

$(PARTS): %: $(OUT_DIR)/[product-name]-%.stl

$(OUT_DIR)/[product-name]-%.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="$*"' $(SCAD_FILE)

clean:
	@$(call RM_F,$(TARGETS) $(wildcard $(OUT_DIR)/*.deps))

-include $(wildcard $(OUT_DIR)/*.deps)
