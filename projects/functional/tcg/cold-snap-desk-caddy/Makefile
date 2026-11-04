COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

OUT_DIR ?= models

TARGETS := $(OUT_DIR)/cold-snap-desk-caddy.stl \
           $(OUT_DIR)/cold-snap-desk-caddy-pro.stl \
           $(OUT_DIR)/cold-snap-desk-caddy-xl.stl

.PHONY: all clean standard pro xl

all: $(TARGETS)

standard: $(OUT_DIR)/cold-snap-desk-caddy.stl
pro:      $(OUT_DIR)/cold-snap-desk-caddy-pro.stl
xl:       $(OUT_DIR)/cold-snap-desk-caddy-xl.stl

$(OUT_DIR)/%.stl: %.scad
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ $<

clean:
	@$(call RM_F,$(TARGETS) $(wildcard $(OUT_DIR)/*.deps))

-include $(wildcard $(OUT_DIR)/*.deps)
