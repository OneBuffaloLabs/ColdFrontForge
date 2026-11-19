// ==========================================
// CREALITY K2 SE TOOL KIT HOLDER
// ==========================================

/* [Mounting Specifications] */
// Distance measured left-edge to left-edge
hole_spacing = 104.96; 
// 3.2mm for a precision slip-fit with a 2.8mm M3 bolt
screw_diameter = 3.2;  

/* [Main Body Dimensions] */
width = 140;           
depth = 68;            
thickness = 4.1;       
backplate_height = 30; 

$fn = 64;
epsilon = 0.01;

module tool_holder() {
    difference() {
        // ======================================
        // ADDITIVE SHAPES (The Solid Body)
        // ======================================
        union() {
            // Backplate
            cube([width, thickness, backplate_height]);
            
            // Main Shelf
            cube([width, depth, thickness]);
            
            // Glue Stick Cup
            translate([45, 38, -25]) 
                cylinder(h=25, d=30); 

            // Mechanical Grease Cup
            translate([75, 38, -25]) 
                cylinder(h=25, d=24); 
                
            // Front Accessory Hook
            translate([132, depth, 0]) 
                cube([8, 17, thickness]); 
            translate([132, depth + 17 - thickness, 0]) 
                cube([8, thickness, 10]); 
        }

        // ======================================
        // SUBTRACTIVE SHAPES (Holes & Slots)
        // ======================================
        
        // MOUNTING HOLES (M3)
        translate([(width/2) - (hole_spacing/2), -epsilon, backplate_height/2])
            rotate([-90, 0, 0]) 
                cylinder(h=thickness + 2, d=screw_diameter);
                
        translate([(width/2) + (hole_spacing/2), -epsilon, backplate_height/2])
            rotate([-90, 0, 0]) 
                cylinder(h=thickness + 2, d=screw_diameter);

        // ROW 1: BACK
        // Flush Cutters
        translate([45, 12, -epsilon]) cube([34, 12, thickness + 2]);

        // Scraper Slot
        translate([85, 12, -epsilon]) cube([42, 3, thickness + 2]);

        // ROW 2: MIDDLE
        // Wrench Slide-In Slot (4mm neck groove)
        translate([15, 35, -epsilon]) cylinder(h=thickness + 2, d=4.0);
        translate([13, 35, -epsilon]) cube([4.0, 35, thickness + 2]);
        // Glue Stick Inner Hole (25mm)
        translate([45, 38, -23]) cylinder(h=30, d=25);

        // Grease Tube Inner Hole (19mm)
        translate([75, 38, -22]) cylinder(h=30, d=21);

        // Nozzle Brush Hole
        translate([95, 38, -epsilon]) cylinder(h=thickness + 2, d=13);

        // Flash Drive Slot (12 x 4.5mm)
        translate([112, 35, -epsilon]) cube([12, 5, thickness + 2]);

        // ROW 3: FRONT EDGE
        // L-Shaped Socket Wrench (11.2mm)
        translate([35, 60, -epsilon]) cylinder(h=thickness + 2, d=11.3);

        // Small Screwdriver
        translate([48, 60, -epsilon]) cylinder(h=thickness + 2, d=3.0);

        // Allen Keys (High-precision lock-fit)
        translate([58, 60, -epsilon]) cylinder(h=thickness + 2, d=1.9); 
        translate([68, 60, -epsilon]) cylinder(h=thickness + 2, d=2.4); 
        translate([78, 60, -epsilon]) cylinder(h=thickness + 2, d=2.9); 
        translate([88, 60, -epsilon]) cylinder(h=thickness + 2, d=3.4); 

        // Nozzle Cleaning Tool
        translate([98, 60, -epsilon]) cylinder(h=thickness + 2, d=2.0);
    }
}

tool_holder();