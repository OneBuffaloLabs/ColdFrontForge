COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= src/snapnote.scad
OUT_DIR   ?= models

CORE_PARTS         := caddy base
CHECKLIST_PARTS    := check bullet lines
PRODUCTIVITY_PARTS := 2x2 habit top3
DRAFTING_PARTS     := dots panels iso
GAMES_PARTS        := xo dotbox
PARTS              := $(CORE_PARTS) $(CHECKLIST_PARTS) $(PRODUCTIVITY_PARTS) $(DRAFTING_PARTS) $(GAMES_PARTS)

CORE_TARGETS         := $(foreach p,$(CORE_PARTS),$(OUT_DIR)/snapnote-$(p).stl)
CHECKLIST_TARGETS    := $(foreach p,$(CHECKLIST_PARTS),$(OUT_DIR)/checklists/snapnote-$(p).stl)
PRODUCTIVITY_TARGETS := $(foreach p,$(PRODUCTIVITY_PARTS),$(OUT_DIR)/productivity/snapnote-$(p).stl)
DRAFTING_TARGETS     := $(foreach p,$(DRAFTING_PARTS),$(OUT_DIR)/drafting/snapnote-$(p).stl)
GAMES_TARGETS        := $(foreach p,$(GAMES_PARTS),$(OUT_DIR)/games/snapnote-$(p).stl)
TARGETS              := $(CORE_TARGETS) $(CHECKLIST_TARGETS) $(PRODUCTIVITY_TARGETS) $(DRAFTING_TARGETS) $(GAMES_TARGETS)

SCAD_DEPS := $(SCAD_FILE) \
             src/snapnote_stencil_base.scad \
             src/snapnote_caddy.scad \
             src/patterns/pattern_checklists.scad \
             src/patterns/pattern_productivity.scad \
             src/patterns/pattern_drafting.scad \
             src/patterns/pattern_games.scad

.PHONY: all clean checklists productivity drafting games $(PARTS)

all: $(TARGETS)

checklists: $(CHECKLIST_TARGETS)
productivity: $(PRODUCTIVITY_TARGETS)
drafting: $(DRAFTING_TARGETS)
games: $(GAMES_TARGETS)

$(CORE_PARTS): %: $(OUT_DIR)/snapnote-%.stl
$(CHECKLIST_PARTS): %: $(OUT_DIR)/checklists/snapnote-%.stl
$(PRODUCTIVITY_PARTS): %: $(OUT_DIR)/productivity/snapnote-%.stl
$(DRAFTING_PARTS): %: $(OUT_DIR)/drafting/snapnote-%.stl
$(GAMES_PARTS): %: $(OUT_DIR)/games/snapnote-%.stl

$(OUT_DIR)/snapnote-%.stl: $(SCAD_DEPS)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="$*"' $(SCAD_FILE)

$(OUT_DIR)/checklists/snapnote-%.stl: $(SCAD_DEPS)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [checklists/$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="$*"' $(SCAD_FILE)

$(OUT_DIR)/productivity/snapnote-%.stl: $(SCAD_DEPS)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [productivity/$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="$*"' $(SCAD_FILE)

$(OUT_DIR)/drafting/snapnote-%.stl: $(SCAD_DEPS)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [drafting/$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="$*"' $(SCAD_FILE)

$(OUT_DIR)/games/snapnote-%.stl: $(SCAD_DEPS)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [games/$*] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'part_to_render="$*"' $(SCAD_FILE)

clean:
	@$(call RM_F,$(TARGETS) $(wildcard $(OUT_DIR)/*.deps) $(wildcard $(OUT_DIR)/*/*.deps))

-include $(wildcard $(OUT_DIR)/*.deps $(OUT_DIR)/*/*.deps)
