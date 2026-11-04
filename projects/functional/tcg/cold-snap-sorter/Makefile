COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= cold-snap-sorter.scad

TARGETS   := models/assembly/cold-snap-sorter.stl \
             models/bay/cold-snap-sorter-bay.stl \
             models/links/cold-snap-sorter-links.stl \
             models/links/cold-snap-sorter-single-link.stl \
             models/links/cold-snap-sorter-quad-link.stl

.PHONY: all clean assembly bay links single_link quad_link

all: $(TARGETS)

assembly:    models/assembly/cold-snap-sorter.stl
bay:         models/bay/cold-snap-sorter-bay.stl
links:       models/links/cold-snap-sorter-links.stl
single_link: models/links/cold-snap-sorter-single-link.stl
quad_link:   models/links/cold-snap-sorter-quad-link.stl

models/assembly/cold-snap-sorter.stl: $(SCAD_FILE)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [assembly] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="both"' $(SCAD_FILE)

models/bay/cold-snap-sorter-bay.stl: $(SCAD_FILE)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [bay] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="bay"' $(SCAD_FILE)

models/links/cold-snap-sorter-links.stl: $(SCAD_FILE)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [links] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="links"' $(SCAD_FILE)

models/links/cold-snap-sorter-single-link.stl: $(SCAD_FILE)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [single_link] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="single_link"' $(SCAD_FILE)

models/links/cold-snap-sorter-quad-link.stl: $(SCAD_FILE)
	@$(call MKDIR,$(@D))
	@echo "--> Rendering [quad_link] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="quad_link"' $(SCAD_FILE)

clean:
	@$(call RM_F,$(TARGETS) models/*/*.deps)

-include $(wildcard models/*/*.deps)
