COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

HOLDER_SCAD ?= k2_se_tool_holder.scad
PLATE_SCAD  ?= assets/cad/k2_se_test_plate.scad

TARGETS     := models/tool-holder/k2_se_tool_holder.stl \
               models/test-plate/k2_se_test_plate.stl

.PHONY: all clean tool-holder test-plate

all: $(TARGETS)

tool-holder: models/tool-holder/k2_se_tool_holder.stl
test-plate:  models/test-plate/k2_se_test_plate.stl

models/tool-holder/k2_se_tool_holder.stl: $(HOLDER_SCAD)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [tool-holder] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ $(HOLDER_SCAD)

models/test-plate/k2_se_test_plate.stl: $(PLATE_SCAD)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [test-plate] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ $(PLATE_SCAD)

clean:
	@$(call RM_F,$(TARGETS) models/*/*.deps)

-include $(wildcard models/*/*.deps)
