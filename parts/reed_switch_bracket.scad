//origin = hole
$fn=10;

squooje_factor = 0.5;

hole_diameter = 6 + squooje_factor; //mm
part_height = 3;

lip_to_hole = 17;
hole_to_end = 20;
frame_width = 26;

overlap = 5;
inner_frame_length = 5;

hole_to_reed = 16;
reed_diameter = 2.5 + squooje_factor;
reed_length = 18;
bend_space = 2;
reed_full_length = reed_length+bend_space*2;
wall_width = 2;


difference(){
	union() {
		translate([-frame_width/2, -lip_to_hole]) cube([frame_width, lip_to_hole + hole_to_end, part_height]); //lowest flat part
		translate([-frame_width/2, -lip_to_hole - overlap, part_height]) cube([frame_width, overlap + inner_frame_length,  part_height]);//upper flat part
		translate([-frame_width/2, hole_to_reed, part_height + reed_diameter/2]) rotate([0,90,0]) cylinder(d=reed_diameter+2*wall_width, h=frame_width);//reed protector box
	}
	cylinder(d=hole_diameter, h=part_height); //screw hole
	translate([-frame_width/2, hole_to_reed, part_height + reed_diameter/2]) rotate([0,90,0]) cylinder(d=reed_diameter, h=frame_width); //reed hole
	translate([frame_width/2 - (frame_width - reed_full_length)/2, hole_to_reed - reed_diameter/2 - wall_width, part_height]) cube([(frame_width - reed_full_length)/2, reed_diameter/2+wall_width, reed_diameter]); //reed legs hole RHS

	translate([-frame_width/2 , hole_to_reed - reed_diameter/2 - wall_width, part_height]) #cube([(frame_width - reed_full_length)/2, reed_diameter/2+wall_width, reed_diameter]); //reed legs hole LHS
}