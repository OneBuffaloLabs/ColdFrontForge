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
├── CREATOR_COMMUNITIES.md       # Target platform upload tracking and URLs
├── LISTING.md                   # Clean, copy-paste copy for maker platforms
├── README.md                    # GitHub repo presentation and documentation
├── STRUCTURE.md                 # Architecture guide (optional / reference)
├── SUMMARY.md                   # Under 120-character single-sentence summary
└── [project-slug].scad          # Primary parametric OpenSCAD source code
```
