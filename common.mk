# =============================================================================
# Cold Front Forge - Shared OpenSCAD Build Configuration
# =============================================================================

ifeq ($(OS),Windows_NT)
    # -------------------------------------------------------------------------
    # Windows Environment
    # -------------------------------------------------------------------------
    # OpenSCAD Binary Auto-Detection (Prioritize Nightly, then standard installs, then PATH)
    OPENSCAD ?= $(strip $(shell \
        if exist "C:\Program Files\OpenSCAD (Nightly)\openscad.com" (\
            echo "C:\Program Files\OpenSCAD (Nightly)\openscad.com"\
        ) else if exist "C:\Program Files\OpenSCAD\openscad.com" (\
            echo "C:\Program Files\OpenSCAD\openscad.com"\
        ) else if exist "%LOCALAPPDATA%\Programs\OpenSCAD (Nightly)\openscad.com" (\
            echo "%LOCALAPPDATA%\Programs\OpenSCAD (Nightly)\openscad.com"\
        ) else if exist "%LOCALAPPDATA%\Programs\OpenSCAD\openscad.com" (\
            echo "%LOCALAPPDATA%\Programs\OpenSCAD\openscad.com"\
        ) else (\
            where openscad.com >nul 2>&1 && (echo openscad.com) || (\
                where openscad >nul 2>&1 && (echo openscad) || (echo none)\
            )\
        )))

    # Cross-platform directory creation and file deletion macros
    MKDIR   = if not exist "$(subst /,\,$(1))" mkdir "$(subst /,\,$(1))"
    RM_F    = $(if $(strip $(1)),-del /Q /F $(subst /,\,$(1)) 2>nul || (exit 0))
    DEVNULL = nul
else
    # -------------------------------------------------------------------------
    # POSIX / Linux / macOS Environment
    # -------------------------------------------------------------------------
    # OpenSCAD Binary Auto-Detection (CLI vs. Flatpak)
    OPENSCAD ?= $(strip $(shell \
        if command -v openscad >/dev/null 2>&1; then \
            echo "openscad"; \
        elif command -v flatpak >/dev/null 2>&1 && flatpak info org.openscad.OpenSCAD >/dev/null 2>&1; then \
            echo "flatpak run org.openscad.OpenSCAD"; \
        elif command -v flatpak >/dev/null 2>&1 && flatpak info org.openscad.OpenSCAD.Devel >/dev/null 2>&1; then \
            echo "flatpak run org.openscad.OpenSCAD.Devel"; \
        else \
            echo "none"; \
        fi))

    MKDIR   = mkdir -p $(1)
    RM_F    = $(if $(strip $(1)),rm -f $(1))
    DEVNULL = /dev/null
endif

ifeq ($(OPENSCAD),none)
ifeq ($(OS),Windows_NT)
$(error OpenSCAD binary not found. Please install OpenSCAD Nightly or ensure openscad is in your PATH)
else
$(error OpenSCAD binary not found. Please install via apt ('sudo apt install openscad') or Flatpak)
endif
endif

SCAD_FLAGS ?= --hardwarnings
