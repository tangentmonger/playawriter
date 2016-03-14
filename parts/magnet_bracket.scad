magnet_side = 5; //mm
magnet_wall_thickness = 1; //mm
magnet_up = 5; //mm
magnet_holder_width = magnet_side + 2*magnet_wall_thickness;

spoke_diameter = 2.5; //mm

clip_length = 15; //mm
clip_wall_thickness = 1; //mm

clip_gap = spoke_diameter / 3; //mm
clip_diameter = spoke_diameter + (2 * clip_wall_thickness);

brace_thickness = 2; 

top_brace_up = magnet_up + magnet_side + magnet_wall_thickness;
top_brace_height = clip_length - top_brace_up;
brace_length = magnet_side + magnet_wall_thickness;
brace_across = spoke_diameter/2;

bottom_brace_height = magnet_up - magnet_wall_thickness;

$fn = 20;




// clip
rotate([0,90,0])  {
difference(){
	union() {
		cylinder(h = clip_length, d = clip_diameter); //clip wall
		translate([spoke_diameter/2, -magnet_holder_width/2, -magnet_wall_thickness+magnet_up]) cube([magnet_side + magnet_wall_thickness, magnet_holder_width, magnet_holder_width]); //magnet holder

		translate([0, -magnet_holder_width/2, -magnet_wall_thickness+magnet_up]) cube([spoke_diameter/2, magnet_holder_width, magnet_holder_width]); //magnet slide guide

		translate([brace_across, -brace_thickness/2, top_brace_up]) rotate([0,-90,-90]) linear_extrude(brace_thickness) polygon(points=[[0,0],[0, brace_length],[top_brace_height,clip_wall_thickness],[top_brace_height,0]]); //top brace

		#translate([brace_across, -brace_thickness/2]) rotate([0,-90,-90]) linear_extrude(brace_thickness) polygon(points=[[0,0],[bottom_brace_height,0],[bottom_brace_height, brace_length],[0,clip_wall_thickness]]); //top brace

		//translate([spoke_diameter/2, -brace_thickness/2, magnet_up + magnet_side]) #cube([magnet_side + magnet_wall_thickness, brace_thickness, clip_length - magnet_side - magnet_up ]);//top brace
	}
	cylinder(h = clip_length, d = spoke_diameter); //hole for spoke
	translate([-clip_diameter,-clip_gap/2]) cube([clip_diameter, clip_gap, clip_length]); //gap to get it on
	translate([spoke_diameter/2, -magnet_side/2, magnet_up]) cube([magnet_side, magnet_side, magnet_side]); //maget space

	translate([-spoke_diameter/2 - clip_wall_thickness, -magnet_side/2, magnet_up]) cube([spoke_diameter+clip_wall_thickness, magnet_side, magnet_side]); //magnet going through clipspace
}
}