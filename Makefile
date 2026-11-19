# =============================================================================
# Cold Front Forge - Root Build Orchestrator
# =============================================================================
include common.mk

# Slasher Spheres
SPHERES_DIR    := projects/decor/slasher-spheres
PROJECT_BILLY  := $(SPHERES_DIR)/billy-ball
PROJECT_GHOST  := $(SPHERES_DIR)/ghostface-ball
PROJECT_JASON  := $(SPHERES_DIR)/jason-ball
SPHERES_ALL    := $(PROJECT_BILLY) $(PROJECT_GHOST) $(PROJECT_JASON)

# Snap-Fit Logos
LOGOS_DIR      := projects/decor/snapfit-logos
PROJECT_BILLS  := $(LOGOS_DIR)/bills
PROJECT_TESTER := $(LOGOS_DIR)/clearance-tester
LOGOS_ALL      := $(PROJECT_BILLS) $(PROJECT_TESTER)

# Magnets
MAGNETS_DIR          := projects/decor/magnets
PROJECT_BUFFALO_WING := $(MAGNETS_DIR)/buffalo-wing-magnet
MAGNETS_ALL          := $(PROJECT_BUFFALO_WING)

# Printer Mods
PROJECT_K2_SE  := projects/functional/printer-mods/k2-se-tool-holder

# Functional Desk & Organization
PROJECT_SNAPNOTE := projects/functional/snapnote

# TCG Tools & Storage
TCG_DIR        := projects/functional/tcg
PROJECT_CADDY  := $(TCG_DIR)/cold-snap-desk-caddy
PROJECT_SORTER := $(TCG_DIR)/cold-snap-sorter
PROJECT_WEDGE  := $(TCG_DIR)/cold-snap-wedge
PROJECT_EXHIBIT:= $(TCG_DIR)/cold-snap-exhibit
TCG_ALL        := $(PROJECT_CADDY) $(PROJECT_SORTER) $(PROJECT_WEDGE) $(PROJECT_EXHIBIT)

# Contest Submissions
PROJECT_FROST   := projects/contests/creality-cloud/bottle-can-opener/entry-1-frost-bite

# Helpers
PROJECT_HELPERS := projects/helpers/pokeball

# Vault Cache Synchronization (Configurable list of items from private Vault)
VAULT_DIR        ?= ../ColdFrontForge-Vault
VAULT_CACHE_DIR  ?= .vault-cache
VAULT_SYNC_ITEMS ?= commercial/tcg/cold-snap-tag

# All active projects across the workshop
PROJECTS := $(SPHERES_ALL) $(LOGOS_ALL) $(MAGNETS_ALL) $(PROJECT_K2_SE) $(PROJECT_SNAPNOTE) $(TCG_ALL) $(PROJECT_FROST)
PROJECTS_CLEAN := $(addsuffix _clean,$(PROJECTS))

# CAD Source Files for Lint Verification
SCAD_SRCS := $(PROJECT_FROST)/src/frost-bite.scad \
             $(PROJECT_BILLY)/src/billy-ball.scad \
             $(PROJECT_GHOST)/src/ghostface-ball.scad \
             $(PROJECT_JASON)/src/jason-ball.scad \
             $(PROJECT_BILLS)/src/snapfit_bills.scad \
             $(PROJECT_TESTER)/src/clearance_tester.scad \
             $(PROJECT_BUFFALO_WING)/src/buffalo-wing-magnet.scad \
             $(PROJECT_K2_SE)/src/k2-se-tool-holder.scad \
             $(PROJECT_K2_SE)/assets/cad/k2_se_test_plate.scad \
             $(PROJECT_SNAPNOTE)/src/snapnote.scad \
             $(PROJECT_SNAPNOTE)/src/snapnote_stencil_base.scad \
             $(PROJECT_SNAPNOTE)/src/snapnote_caddy.scad \
             $(PROJECT_SNAPNOTE)/src/patterns/pattern_checklists.scad \
             $(PROJECT_SNAPNOTE)/src/patterns/pattern_productivity.scad \
             $(PROJECT_CADDY)/src/cold-snap-desk-caddy.scad \
             $(PROJECT_CADDY)/src/cold-snap-desk-caddy-pro.scad \
             $(PROJECT_CADDY)/src/cold-snap-desk-caddy-xl.scad \
             $(PROJECT_SORTER)/src/cold-snap-sorter.scad \
             $(PROJECT_WEDGE)/src/cold-snap-wedge.scad \
             $(PROJECT_EXHIBIT)/src/cold-snap-exhibit.scad \
             $(PROJECT_HELPERS)/core.scad \
             $(PROJECT_HELPERS)/filler.scad
LINT_TARGETS := $(addprefix lint-,$(SCAD_SRCS))

.PHONY: all clean lint check status set-status set-stage sync-vault help $(PROJECTS) $(PROJECTS_CLEAN) $(LINT_TARGETS) \
        slasher-spheres spheres billy billy-ball ghostface ghostface-ball jason jason-ball \
        snapfit-logos logos bills tester clearance-tester \
        magnets buffalo-wing buffalo-wing-magnet \
        printer-mods k2-se tool-holder \
        snapnote \
        tcg caddy desk-caddy sorter wedge exhibit \
        contests frost-bite

all: $(PROJECTS)

$(PROJECTS):
	@echo ">>> Building $@..."
	$(MAKE) -C $@

# Category Shortcuts
slasher-spheres spheres: $(SPHERES_ALL)
snapfit-logos logos:     $(LOGOS_ALL)
magnets:                 $(MAGNETS_ALL)
tcg:                     $(TCG_ALL)
printer-mods:            $(PROJECT_K2_SE)
contests:                $(PROJECT_FROST)

# Individual Project Shortcuts
billy billy-ball:                  $(PROJECT_BILLY)
ghostface ghostface-ball:          $(PROJECT_GHOST)
jason jason-ball:                  $(PROJECT_JASON)
bills:                             $(PROJECT_BILLS)
tester clearance-tester:           $(PROJECT_TESTER)
buffalo-wing buffalo-wing-magnet:  $(PROJECT_BUFFALO_WING)
k2-se tool-holder:                 $(PROJECT_K2_SE)
snapnote:                          $(PROJECT_SNAPNOTE)
caddy desk-caddy:                  $(PROJECT_CADDY)
sorter:                            $(PROJECT_SORTER)
wedge:                             $(PROJECT_WEDGE)
exhibit:                           $(PROJECT_EXHIBIT)
frost-bite:                        $(PROJECT_FROST)

clean: $(PROJECTS_CLEAN)

$(PROJECTS_CLEAN):
	@echo ">>> Cleaning $(patsubst %_clean,%,$@)..."
	@$(MAKE) -C $(patsubst %_clean,%,$@) clean

# Validate syntax and hardwarnings across all project CAD files
lint check: $(LINT_TARGETS)
	@echo ">>> All CAD files passed lint checks."

$(LINT_TARGETS): lint-%:
	@echo "  Checking $*..."
	@$(OPENSCAD) -o - --export-format echo --hardwarnings "$*" >$(DEVNULL)

# Project Status Dashboard & Lifecycle Management
status:
	@$(PYTHON) scripts/repo_status.py

set-status set-stage:
	@$(PYTHON) scripts/repo_status.py --project "$(project)" --stage "$(stage)"

# Synchronize private commercial assets from Vault into local .vault-cache/
sync-vault:
	@echo ">>> Synchronizing Vault assets to $(VAULT_CACHE_DIR)..."
	@$(call MKDIR,$(VAULT_CACHE_DIR))
	$(foreach item,$(VAULT_SYNC_ITEMS),\
		@echo "  Syncing $(item)..."$(_NL)\
		@$(call SYNC_DIR,$(VAULT_DIR)/$(item),$(VAULT_CACHE_DIR)/$(item))$(_NL))
	@echo ">>> Vault synchronization complete."

help:
	$(info Cold Front Forge Build System)
	$(info )
	$(info Targets:)
	$(info   make all                               Build all project STLs (parallelizable with -j))
	$(info   make clean                             Remove all compiled STLs and dependency graphs)
	$(info   make lint                              Syntax and warning verification on all .scad models)
	$(info   make status                            Show project status dashboard)
	$(info   make set-status project=X stage=Y      Update project lifecycle stage (1-5 or name))
	$(info   make sync-vault                        Pull commercial assets from Vault into .vault-cache/)
	$(info )
	$(info Categories:)
	$(info   make slasher-spheres                   Build all Slasher Sphere Pokéball models)
	$(info   make snapfit-logos                     Build all Snap-Fit display emblems)
	$(info   make printer-mods                      Build 3D printer hardware upgrades)
	$(info   make tcg                               Build all TCG organization accessories)
	$(info   make contests                          Build contest entry models)
	$(info )
	$(info Individual Project Targets:)
	$(info   make billy                             Billy the Puppet Slasher Sphere)
	$(info   make ghostface                         Ghostface Slasher Sphere)
	$(info   make jason                             Jason Voorhees Slasher Sphere)
	$(info   make bills                             Snap-Fit Buffalo Bills Logo)
	$(info   make tester                            Snap-Fit Clearance Tester)
	$(info   make tool-holder                       Creality K2 SE Enclosure Tool Holder)
	$(info   make caddy                             Cold Snap Desk Caddy (Standard, Pro, XL))
	$(info   make sorter                            Cold Snap Sorter Bay & Frost Links)
	$(info   make wedge                             Cold Snap Wedge Card Dividers)
	$(info   make exhibit                           Cold Snap Exhibit Pedestal & Easel)
	$(info   make frost-bite                        Frost-Bite Bottle & Can Opener)
	@cd .
