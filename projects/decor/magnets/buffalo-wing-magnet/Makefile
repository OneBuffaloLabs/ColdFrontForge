COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= buffalo-wing-magnet.scad
OUT_DIR   ?= models/v1

TARGETS   := $(OUT_DIR)/buffalo-wing-magnet.stl

.PHONY: all clean

all: $(TARGETS)

$(OUT_DIR)/buffalo-wing-magnet.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [all] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="all"' $(SCAD_FILE)

clean:
	@$(call RM_F,$(TARGETS) $(wildcard $(OUT_DIR)/*.deps))

-include $(wildcard $(OUT_DIR)/*.deps)
