COMMON_MK ?= $(wildcard ../common.mk ../../common.mk ../../../common.mk ../../../../common.mk ../../../../../common.mk)
include $(firstword $(COMMON_MK))

SCAD_FILE ?= frost-bite.scad

TARGETS   := models/single/frost-bite.stl \
             models/multi-color-flush/frost-bite-flush-body.stl \
             models/multi-color-flush/frost-bite-flush-snowflake.stl \
             models/multi-color-embossed/frost-bite-embossed-body.stl \
             models/multi-color-embossed/frost-bite-embossed-snowflake.stl

.PHONY: all clean single flush embossed

all: $(TARGETS)

single:   models/single/frost-bite.stl
flush:    models/multi-color-flush/frost-bite-flush-body.stl models/multi-color-flush/frost-bite-flush-snowflake.stl
embossed: models/multi-color-embossed/frost-bite-embossed-body.stl models/multi-color-embossed/frost-bite-embossed-snowflake.stl

models/single/frost-bite.stl: $(SCAD_FILE)
	@mkdir -p $(@D)
	@echo "--> Rendering [single] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="single"' $(SCAD_FILE)

models/multi-color-flush/frost-bite-flush-body.stl: $(SCAD_FILE)
	@mkdir -p $(@D)
	@echo "--> Rendering [flush body] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="body"' -D 'LOGO_STYLE="flush"' $(SCAD_FILE)

models/multi-color-flush/frost-bite-flush-snowflake.stl: $(SCAD_FILE)
	@mkdir -p $(@D)
	@echo "--> Rendering [flush snowflake] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="snowflake"' -D 'LOGO_STYLE="flush"' $(SCAD_FILE)

models/multi-color-embossed/frost-bite-embossed-body.stl: $(SCAD_FILE)
	@mkdir -p $(@D)
	@echo "--> Rendering [embossed body] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="body"' -D 'LOGO_STYLE="embossed"' $(SCAD_FILE)

models/multi-color-embossed/frost-bite-embossed-snowflake.stl: $(SCAD_FILE)
	@mkdir -p $(@D)
	@echo "--> Rendering [embossed snowflake] -> $@"
	$(OPENSCAD) $(SCAD_FLAGS) -d $(@:.stl=.deps) -o $@ -D 'PART="snowflake"' -D 'LOGO_STYLE="embossed"' $(SCAD_FILE)

clean:
	rm -f $(TARGETS) models/*/*.deps

-include $(wildcard models/*/*.deps)
