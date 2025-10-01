#macro SUBROOM_PIXEL_SIZE 32

world = new World(0);



show_debug_message("TEST BEGIN ------------------------------------------>");

var _structure = generate_structure(world, 0, 0, STRUCTURE.STRONGHOLD);

show_debug_message("Structure rooms: " + string(_structure));

disk_set_rooms(_structure);

show_debug_message("Room at structure anchor: " + string(disk_get_room(0, 0)));