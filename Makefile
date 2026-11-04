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

# Printer Mods
PROJECT_K2_SE  := projects/functional/printer-mods/k2-se-tool-holder

# TCG Tools & Storage
TCG_DIR        := projects/functional/tcg
PROJECT_CADDY  := $(TCG_DIR)/cold-snap-desk-caddy
PROJECT_SORTER := $(TCG_DIR)/cold-snap-sorter
PROJECT_WEDGE  := $(TCG_DIR)/cold-snap-wedge
TCG_ALL        := $(PROJECT_CADDY) $(PROJECT_SORTER) $(PROJECT_WEDGE)

# Contest Submissions
PROJECT_FROST  := projects/contests/creality-cloud/bottle-can-opener/entry-1-frost-bite

# All active projects across the workshop
PROJECTS := $(SPHERES_ALL) $(LOGOS_ALL) $(PROJECT_K2_SE) $(TCG_ALL) $(PROJECT_FROST)
PROJECTS_CLEAN := $(addsuffix _clean,$(PROJECTS))

# CAD Source Files for Lint Verification
SCAD_SRCS := projects/contests/creality-cloud/bottle-can-opener/entry-1-frost-bite/frost-bite.scad \
             projects/decor/slasher-spheres/billy-ball/billy-ball.scad \
             projects/decor/slasher-spheres/ghostface-ball/ghostface-ball.scad \
             projects/decor/slasher-spheres/jason-ball/jason-ball.scad \
             projects/decor/snapfit-logos/bills/snapfit_bills.scad \
             projects/decor/snapfit-logos/clearance-tester/clearance_tester.scad \
             projects/functional/printer-mods/k2-se-tool-holder/k2_se_tool_holder.scad \
             projects/functional/printer-mods/k2-se-tool-holder/assets/cad/k2_se_test_plate.scad \
             projects/functional/tcg/cold-snap-desk-caddy/cold-snap-desk-caddy.scad \
             projects/functional/tcg/cold-snap-desk-caddy/cold-snap-desk-caddy-pro.scad \
             projects/functional/tcg/cold-snap-desk-caddy/cold-snap-desk-caddy-xl.scad \
             projects/functional/tcg/cold-snap-sorter/cold-snap-sorter.scad \
             projects/functional/tcg/cold-snap-wedge/cold-snap-wedge.scad \
             projects/helpers/pokeball/core.scad \
             projects/helpers/pokeball/filler.scad
LINT_TARGETS := $(addprefix lint-,$(SCAD_SRCS))

.PHONY: all clean lint check help $(PROJECTS) $(PROJECTS_CLEAN) $(LINT_TARGETS) \
        slasher-spheres spheres billy billy-ball ghostface ghostface-ball jason jason-ball \
        snapfit-logos logos bills tester clearance-tester \
        printer-mods k2-se tool-holder \
        tcg caddy desk-caddy sorter wedge \
        contests frost-bite

all: $(PROJECTS)

$(PROJECTS):
	@echo ">>> Building $@..."
	$(MAKE) -C $@

# Category Shortcuts
slasher-spheres spheres: $(SPHERES_ALL)
snapfit-logos logos:     $(LOGOS_ALL)
tcg:                     $(TCG_ALL)
printer-mods:            $(PROJECT_K2_SE)
contests:                $(PROJECT_FROST)

# Individual Project Shortcuts
billy billy-ball:                  $(PROJECT_BILLY)
ghostface ghostface-ball:          $(PROJECT_GHOST)
jason jason-ball:                  $(PROJECT_JASON)
bills:                             $(PROJECT_BILLS)
tester clearance-tester:           $(PROJECT_TESTER)
k2-se tool-holder:                 $(PROJECT_K2_SE)
caddy desk-caddy:                  $(PROJECT_CADDY)
sorter:                            $(PROJECT_SORTER)
wedge:                             $(PROJECT_WEDGE)
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

help:
	@echo "Cold Front Forge Build System"
	@echo ""
	@echo "Targets:"
	@echo "  make all             Build all project STLs (parallelizable with -j)"
	@echo "  make clean           Remove all compiled STLs and dependency graphs"
	@echo "  make lint            Syntax and warning verification on all .scad models"
	@echo ""
	@echo "Categories:"
	@echo "  make slasher-spheres Build all Slasher Sphere Pokéball models"
	@echo "  make snapfit-logos   Build all Snap-Fit display emblems"
	@echo "  make printer-mods    Build 3D printer hardware upgrades"
	@echo "  make tcg             Build all TCG organization accessories"
	@echo "  make contests        Build contest entry models"
	@echo ""
	@echo "Individual Project Targets:"
	@echo "  make billy           Billy the Puppet Slasher Sphere"
	@echo "  make ghostface       Ghostface Slasher Sphere"
	@echo "  make jason           Jason Voorhees Slasher Sphere"
	@echo "  make bills           Snap-Fit Buffalo Bills Logo"
	@echo "  make tester          Snap-Fit Clearance Tester"
	@echo "  make tool-holder     Creality K2 SE Enclosure Tool Holder"
	@echo "  make caddy           Cold Snap Desk Caddy (Standard, Pro, XL)"
	@echo "  make sorter          Cold Snap Sorter Bay & Frost Links"
	@echo "  make wedge           Cold Snap Wedge Card Dividers"
	@echo "  make frost-bite      Frost-Bite Bottle & Can Opener"
