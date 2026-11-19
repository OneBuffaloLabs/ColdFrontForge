// ==========================================
// SNAPFIT CLEARANCE TESTER (6mm Premium Version)
// ==========================================

/* [Global Settings] */
$fn = 64;
// Match premium base thickness
test_thickness = 6.0; 
// Match pocket depth
pocket_depth = 2.5;
// Match insert thickness
insert_thickness = 3.0; 

block_size = 20;

/* [Clearances to Test] */
test_a = 0.05;
test_b = 0.10;
test_c = 0.15;

module test_pocket(clearance_val, label) {
    difference() {
        // The Base Block
        cube([block_size, block_size, test_thickness]);
        
        // The Pocket
        translate([5 - clearance_val, 5 - clearance_val, test_thickness - pocket_depth])
            cube([10 + (clearance_val*2), 10 + (clearance_val*2), pocket_depth + 0.01]);
            
        // Label (Etched into bottom)
        // Centered on X and Y, cuts 0.5mm deep into the bottom
        translate([block_size/2, block_size/2, 0.5])
            rotate([180, 0, 0])
                linear_extrude(1)
                    text(label, size=4, halign="center", valign="center");
    }
}

module test_insert() {
    cube([10, 10, insert_thickness]);
}

// --- RENDER SELECTION ---
// 1. Export the Base with 3 pockets
translate([0, 0, 0]) test_pocket(test_a, "0.05");
translate([25, 0, 0]) test_pocket(test_b, "0.10");
translate([50, 0, 0]) test_pocket(test_c, "0.15");

// 2. Export ONE insert (standard 10mm)
translate([25, 25, 0]) test_insert();