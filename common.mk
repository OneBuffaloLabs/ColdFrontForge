# =============================================================================
# Cold Front Forge - Shared OpenSCAD Build Configuration
# =============================================================================

# Export library search path for vendored BOSL2 in lib/
COMMON_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
export OPENSCADPATH := $(COMMON_DIR)/lib

# Define newline for multi-command macro expansion
define _NL


endef

ifeq ($(OS),Windows_NT)
    # -------------------------------------------------------------------------
    # Windows Environment (Git Bash / MSYS sh vs. Native CMD)
    # -------------------------------------------------------------------------
    ifneq (,$(findstring sh,$(SHELL)))
        # Git Bash / sh on Windows
        OPENSCAD ?= $(strip $(shell \
            if [ -f "C:/Program Files/OpenSCAD (Nightly)/openscad.com" ]; then \
                echo '"C:/Program Files/OpenSCAD (Nightly)/openscad.com"'; \
            elif [ -f "C:/Program Files/OpenSCAD/openscad.com" ]; then \
                echo '"C:/Program Files/OpenSCAD/openscad.com"'; \
            elif command -v openscad.com >/dev/null 2>&1; then \
                command -v openscad.com; \
            elif command -v openscad >/dev/null 2>&1; then \
                command -v openscad; \
            else \
                echo "none"; \
            fi))

        MKDIR    = mkdir -p "$(1)"
        RM_F     = $(if $(strip $(1)),rm -f $(1))
        SYNC_DIR = if [ -d "$(1)" ]; then mkdir -p "$(2)" && cp -R "$(1)/." "$(2)/"; else echo "Warning: Vault path not found: $(1)"; fi
        DEVNULL  = /dev/null
    else
        # Native cmd.exe on Windows
        OPENSCAD ?= $(strip $(shell cmd.exe /c "\
            if exist \"C:\Program Files\OpenSCAD (Nightly)\openscad.com\" (\
                echo \"C:\Program Files\OpenSCAD (Nightly)\openscad.com\"\
            ) else if exist \"C:\Program Files\OpenSCAD\openscad.com\" (\
                echo \"C:\Program Files\OpenSCAD\openscad.com\"\
            ) else if exist \"%LOCALAPPDATA%\Programs\OpenSCAD (Nightly)\openscad.com\" (\
                echo \"%LOCALAPPDATA%\Programs\OpenSCAD (Nightly)\openscad.com\"\
            ) else if exist \"%LOCALAPPDATA%\Programs\OpenSCAD\openscad.com\" (\
                echo \"%LOCALAPPDATA%\Programs\OpenSCAD\openscad.com\"\
            ) else (\
                where openscad.com 2>nul || where openscad 2>nul || echo none\
            )"))

        MKDIR    = if not exist "$(subst /,\,$(1))" mkdir "$(subst /,\,$(1))"
        RM_F     = $(if $(strip $(1)),-del /Q /F $(subst /,\,$(1)) 2>nul || (exit 0))
        SYNC_DIR = powershell -NoProfile -Command "if (Test-Path '$(subst /,\,$(1))') { New-Item -ItemType Directory -Force -Path '$(subst /,\,$(2))' | Out-Null; Copy-Item -Recurse -Force '$(subst /,\,$(1))\*' '$(subst /,\,$(2))' } else { Write-Host 'Warning: Vault path not found: $(1)' -ForegroundColor Yellow }"
        DEVNULL  = nul
    endif
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

    MKDIR    = mkdir -p $(1)
    RM_F     = $(if $(strip $(1)),rm -f $(1))
    SYNC_DIR = if [ -d "$(1)" ]; then mkdir -p "$(2)" && cp -R "$(1)/." "$(2)/"; else echo "Warning: Vault path not found: $(1)"; fi
    DEVNULL  = /dev/null
endif

ifeq ($(OPENSCAD),none)
ifeq ($(OS),Windows_NT)
$(error OpenSCAD binary not found. Please install OpenSCAD Nightly or ensure openscad is in your PATH)
else
$(error OpenSCAD binary not found. Please install via apt ('sudo apt install openscad') or Flatpak)
endif
endif

SCAD_FLAGS ?= --hardwarnings
