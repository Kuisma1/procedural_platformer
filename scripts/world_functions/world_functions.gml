function world_load_room(_world, _subroom_x, _subroom_y) {
	// 1. if room already loaded, do nothing
	// 2. if room exists on disk, load it
	// (2.5. generate nearby ungenerated structures, and check existence on disk again)
	// 3. otherwise generate the room, save it to disk and load it
	if world_room_exists(_world, _subroom_x, _subroom_y) {
		show_debug_message("Room at " + string(_subroom_x) + "," + string(_subroom_y) + " was already loaded.");
	} else if world_room_exists_on_disk(_world, _subroom_x, _subroom_y) {
		var _room = world_get_room_from_disk(_world, _subroom_x, _subroom_y);
		world_set_room(_world, _room);
	} else {
		// TODO: redo world_generation to handle world object instead of world_data
	}
}

function world_instantiate_room(_world, _subroom_x, _subroom_y) {
	
}

function world_uninstantiate_room(_world) {
	
}

function world_unload_room(_world, _subroom_x, _subroom_y) {
	// 1. save room to disk
	// 2. remove room from memory
}

function world_save_rooms(_world) {
	
}