<!--
STRUCTURE.md Template
Purpose: Reference scaffold for standard Cold Front Forge project directories.
-->

# Standard Project Directory Structure

Use this folder architecture across all 3D printing and parametric CAD projects:

```text
[project-name]/
├── assets/
│   ├── cad/                     # Source 2D vectors or meshes imported by OpenSCAD (SVG, DXF, STL)
│   │   └── [project-slug]-emblem.svg
│   └── media/                   # Visual presentation and documentation
│       ├── photos/              # Real-world physical prints, finishes, EDC shots
│       │   └── hero.jpg
│       └── renders/             # Slicer screenshots or OpenSCAD preview renders
│           ├── hero.png
│           └── hero-side.png
├── models/
│   ├── single/                  # Standard single-extruder / single-material meshes
│   │   ├── [project-slug]-single.stl
│   │   └── [project-slug]-single.3mf
│   ├── multi-color-flush/       # Flush / Inlaid two-tone components & slicer projects
│   │   ├── [project-slug]-flush-body.stl
│   │   ├── [project-slug]-flush-insert.stl
│   │   └── [project-slug]-flush.3mf
│   └── multi-color-embossed/    # Raised / Embossed tactile variants & slicer projects
│       ├── [project-slug]-embossed-body.stl
│       ├── [project-slug]-embossed-insert.stl
│       └── [project-slug]-embossed.3mf
├── src/
│   └── [project-slug].scad      # Primary parametric OpenSCAD source code
├── CREATOR_COMMUNITIES.md       # Target platform upload tracking and URLs
├── LISTING.md                   # Clean, copy-paste copy for maker platforms
├── Makefile                     # Project-level build automation and STL export
├── README.md                    # GitHub repo presentation and documentation
├── STRUCTURE.md                 # Architecture guide (optional / reference)
└── SUMMARY.md                   # Under 120-character single-sentence summary
```

## Multi-Module Projects (`src/`)

For larger project suites with shared base libraries, companion parts, or families of pattern variants (such as `snapnote`), organize `src/` as follows:

```text
src/
├── [project-slug].scad          # Unified entry point & part_to_render dispatcher
├── [project-slug]_base.scad     # Shared base geometry and reusable modules
├── [companion-part].scad        # Standalone companion assembly (e.g., caddy, dock)
└── patterns/                    # Optional subfolder for 3+ grouped variant modules
    └── pattern_[group].scad
```

- **Single Entry Point:** `Makefile` targets `src/[project-slug].scad` and passes `-D 'part_to_render="<part>"'` to export each STL into `models/`.
- **Modular Imports:** Use `use <...>` from the entry point so helper and pattern files provide modules without emitting duplicate top-level geometry.
- **Keep `src/` Flat Until Needed:** Only introduce subfolders (e.g., `patterns/`, `components/`) when grouping 3 or more related variant files.
