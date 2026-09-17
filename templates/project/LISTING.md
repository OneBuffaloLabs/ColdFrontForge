<!--
LISTING.md Template
Purpose: Production-ready listing copy for creator communities (MakerWorld, Printables, Creality Cloud).
Formatting Rules:
1. Use clean, plain-text compatible structure (bullet points using •).
2. No emojis in headers or body copy.
3. Avoid hardcoded Markdown links in the primary body so it copies cleanly into platforms with WYSIWYG editors.
4. Keep the tone grounded, functional, human, and concise.
-->

# [Model Name] — [Short Subtitle / Primary Function]

[1-2 short paragraphs explaining what the model does, what problem it solves, and how it is used. Keep the phrasing simple, direct, and conversational.]

FEATURES

• [Primary Feature]: [Brief description of mechanical function or design choice].
• [Fitment / Compatibility]: [Dimensions, tolerances, or hardware it fits].
• [Zero Supports / Printability]: [Orientation and support-free details].
• Open Source: Full parametric OpenSCAD project files and source models available on GitHub under Cold Front Forge.

MODEL VARIANTS & FILES

[Files are provided as individual STLs and pre-configured 3MF project profiles:]

• [Variant 1 / Single Color]: [Description, e.g., standard single-material print].
• [Variant 2 / Multi-Color Flush]: [Description, e.g., flush inlaid multi-material print].
• [Variant 3 / Multi-Color Embossed]: [Description, e.g., raised tactile accent print].

[Note for multi-part models: If importing raw STLs instead of opening a 3MF project, select all component STL files together and load them as a single multi-part object to keep coordinates aligned.]

RECOMMENDED PRINT SETTINGS

• Orientation: [e.g., Flat on build plate, face up (no supports needed)].
• Material: [e.g., PLA+, PETG, or ABS].
• Layer Height: 0.20 mm.
• Wall Loops: [e.g., 4 perimeters for load-bearing areas].
• Top / Bottom Shells: [e.g., 5 top, 4 bottom].
• Infill: [e.g., 20% to 25% Gyroid].
• Brim: [e.g., None required on clean PEI or smooth build sheets].

<!-- OPTIONAL: MULTI-COLOR (AMS / CFS) SETTINGS (Remove if single-material only) -->

MULTI-COLOR SETUP (AMS / CFS)

• Prime Tower: Enabled (35 mm width, 5 mm brim).
• Sparse Layers: Turn on "No sparse layers (beta)" to skip priming on layers where only the base material prints.
• Top Surface Pattern: Monotonic or Monotonic Line.
• Purge Volumes: Adjust dark-to-light flushing volumes to prevent dark filament bleed into lighter details.

<!-- END OPTIONAL -->

Designed by Cold Front Forge. Open-source under Creative Commons (CC BY-NC-SA 4.0).
