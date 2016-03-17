magnet_centre_to_axle = 65;
spokes = 10;


squooj_factor = 0.5; //mm
magnet_side = 5 + squooj_factor; //mm
magnet_wall_thickness = 1; //mm
magnet_up = 5; //mm
magnet_holder_width = magnet_side + 2*magnet_wall_thickness;

spoke_diameter = 2.5 + squooj_factor; //mm

clip_length = 15; //mm
clip_wall_thickness = 2; //mm

clip_gap = spoke_diameter / 2; //mm
clip_diameter = spoke_diameter + (2 * clip_wall_thickness);

fudge = 0.0001; // fix for "Object isn't a valid 2-manifold!"

brace_thickness = 2; 

top_brace_up = magnet_up + magnet_side + magnet_wall_thickness - fudge;
top_brace_height = clip_length - top_brace_up;
brace_length = magnet_side + magnet_wall_thickness;
brace_across = spoke_diameter/2;

bottom_brace_height = magnet_up - magnet_wall_thickness;


connector_length = magnet_centre_to_axle * sin((360/spokes)/2); //half length for mirror later
connector_width = magnet_holder_width;
connector_height = 3;

$fn = 20;

translate([magnet_centre_to_axle,0,0]) clip();
rotate([0,0,360/spokes]) translate([magnet_centre_to_axle,0,0]) mirror([0,1,0]) clip();


module clip()
{
translate([-magnet_side/2 - magnet_up,0,0]){
rotate([0,90,0])  {
difference(){
	union() {
		cylinder(h = clip_length, d = clip_diameter); //clip wall
		translate([spoke_diameter/2, -magnet_holder_width/2, -magnet_wall_thickness+magnet_up]) cube([magnet_side + magnet_wall_thickness, magnet_holder_width, magnet_holder_width]); //magnet holder

		translate([0, -magnet_holder_width/2, -magnet_wall_thickness+magnet_up]) cube([spoke_diameter/2, magnet_holder_width, magnet_holder_width]); //magnet slide guide

		translate([brace_across, -brace_thickness/2, top_brace_up]) rotate([0,-90,-90]) linear_extrude(brace_thickness) polygon(points=[[0,0],[0, brace_length],[top_brace_height,clip_wall_thickness],[top_brace_height,0]]); //top brace

		translate([brace_across, -brace_thickness/2]) rotate([0,-90,-90]) linear_extrude(brace_thickness) polygon(points=[[0,0],[bottom_brace_height,0],[bottom_brace_height, brace_length],[0,clip_wall_thickness]]); //top brace
	
		translate([magnet_side+magnet_wall_thickness + spoke_diameter/2 -connector_height, 0, magnet_up - magnet_wall_thickness]) rotate(-[(360/spokes)/2],0,0) cube([connector_height, connector_length,  connector_width]);// connector

	}
	cylinder(h = clip_length, d = spoke_diameter); //hole for spoke
	translate([-clip_diameter,-clip_gap/2]) cube([clip_diameter, clip_gap, clip_length]); //gap to get it on
	translate([spoke_diameter/2, -magnet_side/2, magnet_up]) cube([magnet_side, magnet_side, magnet_side]); //maget space

	translate([-spoke_diameter/2 - clip_wall_thickness, -magnet_side/2, magnet_up]) cube([spoke_diameter+clip_wall_thickness, magnet_side, magnet_side]); //magnet going through clipspace
}
}
}
}