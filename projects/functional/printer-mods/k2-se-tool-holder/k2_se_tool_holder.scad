// ==========================================
// CREALITY K2 SE TOOL KIT HOLDER
// ==========================================

/* [Mounting Specifications] */
hole_spacing = 104.96; 
screw_diameter = 4.5;  

/* [Main Body Dimensions] */
width = 140;           
depth = 68;            
thickness = 4.0;       
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
            translate([75, 38, -20]) 
                cylinder(h=20, d=24); 
                
            // Front Accessory Hook
            translate([132, depth, 0]) 
                cube([8, 17, thickness]); 
            translate([132, depth + 17 - thickness, 0]) 
                cube([8, thickness, 10]); 
        }

        // ======================================
        // SUBTRACTIVE SHAPES (Holes & Slots)
        // ======================================
        
        // MOUNTING HOLES (M4)
        translate([(width/2) - (hole_spacing/2), -epsilon, backplate_height/2])
            rotate([-90, 0, 0]) 
                cylinder(h=thickness + 2, d=screw_diameter);
                
        translate([(width/2) + (hole_spacing/2), -epsilon, backplate_height/2])
            rotate([-90, 0, 0]) 
                cylinder(h=thickness + 2, d=screw_diameter);

        // --- ROW 1: BACK ---
        
        // Flush Cutters (Tightened to 34mm width)
        translate([45, 12, -epsilon]) cube([34, 12, thickness + 2]);
        
        // Scraper Slot (Tightened to 3mm thickness)
        translate([85, 12, -epsilon]) cube([42, 3, thickness + 2]);

        // --- ROW 2: MIDDLE ---
        
        // Wrench Slide-In Slot
        translate([15, 35, -epsilon]) cylinder(h=thickness + 2, d=4.0);
        translate([13, 35, -epsilon]) cube([4.0, 35, thickness + 2]);
        
        // Glue Stick Inner Hole 
        translate([45, 38, -23]) cylinder(h=30, d=25);
        
        // Grease Tube Inner Hole 
        translate([75, 38, -18]) cylinder(h=30, d=19);
        
        // Nozzle Brush Hole
        translate([95, 38, -epsilon]) cylinder(h=thickness + 2, d=13);
        
        // Flash Drive Slot 
        translate([112, 35, -epsilon]) cube([12, 4.5, thickness + 2]);

        // --- ROW 3: FRONT EDGE ---
        
        // L-Shaped Socket Wrench 
        translate([35, 60, -epsilon]) cylinder(h=thickness + 2, d=11.2);
        
        // Small Screwdriver 
        translate([48, 60, -epsilon]) cylinder(h=thickness + 2, d=3.0);
        
        // Allen Keys (+0.2mm clearance to lock the hex corners in upright)
        translate([58, 60, -epsilon]) cylinder(h=thickness + 2, d=1.8); // 1.6mm tool
        translate([68, 60, -epsilon]) cylinder(h=thickness + 2, d=2.4); // 2.2mm tool
        translate([78, 60, -epsilon]) cylinder(h=thickness + 2, d=2.7); // 2.5mm tool
        translate([88, 60, -epsilon]) cylinder(h=thickness + 2, d=3.2); // 3.0mm tool
        
        // Nozzle Cleaning Tool
        translate([98, 60, -epsilon]) cylinder(h=thickness + 2, d=2.0);
    }
}

// Render the part
tool_holder();