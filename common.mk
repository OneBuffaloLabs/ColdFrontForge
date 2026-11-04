# =============================================================================
# Cold Front Forge - Shared OpenSCAD Build Configuration
# =============================================================================

# Cross-platform shell configuration
ifeq ($(OS),Windows_NT)
  # Detect Git Bash sh.exe on Windows for seamless POSIX tool execution
  ifneq ($(wildcard C:/PROGRA~1/Git/bin/sh.exe),)
    SHELL := C:/PROGRA~1/Git/bin/sh.exe
  else ifneq ($(wildcard C:/Program\ Files/Git/bin/sh.exe),)
    SHELL := C:/Program\ Files/Git/bin/sh.exe
  endif
endif

# OpenSCAD Binary Auto-Detection (CLI vs. Flatpak)
OPENSCAD ?= $(shell \
	if command -v openscad >/dev/null 2>&1; then \
		echo "openscad"; \
	elif command -v flatpak >/dev/null 2>&1 && flatpak info org.openscad.OpenSCAD >/dev/null 2>&1; then \
		echo "flatpak run org.openscad.OpenSCAD"; \
	elif [ -f "/c/Program Files/OpenSCAD/openscad.com" ]; then \
		echo "/c/Program\ Files/OpenSCAD/openscad.com"; \
	elif [ -f "/c/Program Files/OpenSCAD (Nightly)/openscad.com" ]; then \
		echo "/c/Program\ Files/OpenSCAD\ (Nightly)/openscad.com"; \
	else \
		echo "none"; \
	fi)

ifeq ($(OPENSCAD),none)
$(error OpenSCAD binary not found. Please install via apt ('sudo apt install openscad'), Flatpak, or add OpenSCAD to your PATH)
endif

SCAD_FLAGS ?= --hardwarnings
