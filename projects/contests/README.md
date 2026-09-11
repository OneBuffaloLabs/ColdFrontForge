# 3D Printing Design Contests

Central registry and project workspace for design contest entries across supported 3D printing platforms.

## Platforms

- [Creality Cloud](./creality-cloud/README.md) — Contest designs, entries, and print profiles targeted for Creality Cloud competitions.
- [MakerWorld](./makerworld/README.md) — Parametric and multi-color models optimized for Bambu Lab / MakerWorld design challenges.
- [Printables](./printables/README.md) — Functional prints and themed design submissions for Prusa Printables contests.

## Directory Structure

```text
projects/contests/
├── creality-cloud/
│   ├── bottle-can-opener/
│   │   └── entry-1-frost-bite/
│   └── README.md
├── makerworld/
│   └── README.md
├── printables/
│   └── README.md
└── README.md
```

## Standard Workflow

1. **Scaffold Entry:** Create a folder inside the target platform using `<contest-name>/entry-<n>-<slug>/`.
2. **CAD Modeling:** Develop parametric OpenSCAD scripts (`.scad`) keeping dimensions, clearance offsets, and printer settings cleanly separated.
3. **Render & Export:** Generate `.stl` and `.3mf` assets using test-fitted tolerances.
4. **Documentation:** Include project notes, slicer orientation recommendations, and required contest tags in each entry directory.
