# Frost Bite — Can Tab Opener & Keychain

Frost Bite is a compact, everyday-carry keychain tool designed to pop soda and beer can pull tabs without tearing up your fingernails. The bottom sleeve slides directly over standard beverage tabs, giving you the upward leverage needed to open cans with minimal effort.

Modeled from scratch in OpenSCAD, it features a slim 5 mm profile, a reinforced eyelet that fits standard split keyrings, and bridging clearances that let it print completely flat on the build plate without supports.

FEATURES

• Direct Leverage: The 24 mm deep internal sleeve slides fully over standard can tabs for clean lifting leverage without bending the tab.
• Pocket Ready: At 5 mm thick, it rides flat on keychains or in pockets without extra bulk.
• Zero Supports: The internal horizontal slot bridges cleanly on standard 0.4 mm setups with no support material required.
• Multiple Styles: Includes files for a clean debossed single-color print, a flush two-tone inlay, and a raised 0.6 mm embossed logo.
• Open Source: Full parametric code and source models are available on GitHub under Cold Front Forge.

MODEL VARIANTS & PROJECT FILES

Files are provided as pre-configured .3mf projects and individual .stl meshes:

• Single Color (Plate / Profile 1): Uses a debossed snowflake emblem. Prints in one run with no filament swaps or pauses.
• Multi-Color Flush (Plate / Profile 2): Features an inlaid two-tone snowflake sitting completely flush with the top face.
• Multi-Color Embossed (Plate / Profile 3): Features a two-tone snowflake raised 0.6 mm above the top surface for tactile contrast.

Note for multi-color slicers (Creality Print, Bambu Studio, OrcaSlicer): If you are importing raw STLs instead of opening the 3MF project, select both the body and snowflake STL files together and load them as a single multi-part object to maintain alignment.

RECOMMENDED PRINT SETTINGS

• Orientation: Flat on the bed, face up (no supports needed).
• Material: PETG or PLA+ recommended for leverage strength (standard PLA works for casual use).
• Layer Height: 0.20 mm.
• Wall Loops: 4 perimeters (essential for reinforcement around the tab sleeve and keyring eyelet).
• Top / Bottom Shells: 5 top, 4 bottom.
• Infill: 25% to 30% Gyroid.
• Brim: None required on clean PEI or smooth build sheets.

MULTI-COLOR SETUP (AMS / CFS)

• Prime Tower: Enabled (35 mm width, 5 mm brim recommended).
• Sparse Layers: Turn on "No sparse layers (beta)" to skip tower extrusion on the first 4.2 mm while only the main body prints.
• Top Surface Pattern: Monotonic or Monotonic Line.
• Purge Volumes: Set dark-to-light flushing to 250–300 mm³ to prevent dark filament bleed into the snowflake.

Designed by Cold Front Forge. Open-source under Creative Commons (CC BY-NC-SA 4.0).
