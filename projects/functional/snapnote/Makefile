COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= src/snapnote.scad
OUT_DIR   ?= models

PARTS     ?= caddy base check bullet lines
TARGETS   ?= $(foreach p,$(PARTS),$(OUT_DIR)/snapnote-$(p).stl)

.PHONY: all clean $(PARTS)

all: $(TARGETS)

$(PARTS): %: $(OUT_DIR)/snapnote-%.stl

$(OUT_DIR)/snapnote-%.stl: $(SCAD_FILE) src/snapnote_stencil_base.scad src/snapnote_caddy.scad src/patterns/pattern_checklists.scad
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="$*"' $(SCAD_FILE)

clean:
	@$(call RM_F,$(TARGETS) $(wildcard $(OUT_DIR)/*.deps))

-include $(wildcard $(OUT_DIR)/*.deps)
