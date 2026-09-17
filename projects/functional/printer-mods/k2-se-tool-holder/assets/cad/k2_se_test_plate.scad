// ==========================================
// K2 SE TOOL HOLDER - MOUNTING TEST PLATE
// ==========================================

hole_spacing = 104.96; 
screw_diameter = 4.5;  

width = 140;           
backplate_height = 30; 
thickness = 4.0;       

$fn = 64;
epsilon = 0.01;

difference() {
    // The solid backplate lying flat on the build plate
    cube([width, backplate_height, thickness]);
    
    // Left Mounting Hole
    translate([(width/2) - (hole_spacing/2), backplate_height/2, -epsilon])
        cylinder(h=thickness + 2, d=screw_diameter);
        
    // Right Mounting Hole
    translate([(width/2) + (hole_spacing/2), backplate_height/2, -epsilon])
        cylinder(h=thickness + 2, d=screw_diameter);
}