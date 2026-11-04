COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= snapfit_bills.scad
OUT_DIR   ?= models/v2

TARGETS   := $(OUT_DIR)/snapfit-bills-base-white.stl \
             $(OUT_DIR)/snapfit-bills-insert-blue.stl \
             $(OUT_DIR)/snapfit-bills-insert-red.stl

.PHONY: all clean base blue red

all: $(TARGETS)

base: $(OUT_DIR)/snapfit-bills-base-white.stl
blue: $(OUT_DIR)/snapfit-bills-insert-blue.stl
red:  $(OUT_DIR)/snapfit-bills-insert-red.stl

$(OUT_DIR)/snapfit-bills-base-white.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [base] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="base"' $(SCAD_FILE)

$(OUT_DIR)/snapfit-bills-insert-blue.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [blue] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="blue"' $(SCAD_FILE)

$(OUT_DIR)/snapfit-bills-insert-red.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [red] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="red"' $(SCAD_FILE)

clean:
	@$(call RM_F,$(TARGETS) $(wildcard $(OUT_DIR)/*.deps))

-include $(wildcard $(OUT_DIR)/*.deps)
