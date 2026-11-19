COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= src/buffalo-wing-magnet.scad
OUT_DIR   ?= models/v1

TARGETS   := $(OUT_DIR)/buffalo-wing-magnet-base-white.stl \
             $(OUT_DIR)/buffalo-wing-magnet-wing-orange.stl \
             $(OUT_DIR)/buffalo-wing-magnet-celery-green.stl

.PHONY: all clean base wing celery

all: $(TARGETS)

base:   $(OUT_DIR)/buffalo-wing-magnet-base-white.stl
wing:   $(OUT_DIR)/buffalo-wing-magnet-wing-orange.stl
celery: $(OUT_DIR)/buffalo-wing-magnet-celery-green.stl

$(OUT_DIR)/buffalo-wing-magnet-base-white.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [base] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'render_mode="base"' $(SCAD_FILE)

$(OUT_DIR)/buffalo-wing-magnet-wing-orange.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [wing] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'render_mode="wing"' $(SCAD_FILE)

$(OUT_DIR)/buffalo-wing-magnet-celery-green.stl: $(SCAD_FILE)
	@$(call MKDIR,$(OUT_DIR))
	@echo "--> Rendering [celery] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'render_mode="celery"' $(SCAD_FILE)

clean:
	@$(call RM_F,$(TARGETS) $(wildcard $(OUT_DIR)/*.deps))

-include $(wildcard $(OUT_DIR)/*.deps)
