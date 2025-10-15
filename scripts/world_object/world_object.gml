function world_load_room(_world, _subroom_x, _subroom_y) {
	show_debug_message("Attempting to load room");
	var _world_data = _world.data;
	if world_data_room_exists(_world_data, _subroom_x, _subroom_y) {
		show_debug_message("- Room was already in memory");
	} else if world_data_room_exists_on_disk(_world_data, _subroom_x, _subroom_y) {
		var _room_data = world_data_get_room_from_disk(_world_data, _subroom_x, _subroom_y);
		world_data_set_room(_world_data, _room_data);
		show_debug_message("- Room was found on disk and loaded");
	} else {
		var _room_data = world_generation_generate_room(_world_data, _subroom_x, _subroom_y);
		world_data_set_room_to_disk(_world_data, _room_data);
		world_data_set_room(_world_data, _room_data);
		show_debug_message("- Room was generated");
	}
}

function world_unload_room(_world, _subroom_x, _subroom_y) {
	show_debug_message("Attempting to unload room");
	var _world_data = _world.data;
	if !world_data_room_exists(_world_data, _subroom_x, _subroom_y) {
		show_debug_message("- Room was not loaded");
	} else {
		world_data_set_room_to_disk(_world_data, world_data_get_room(_world_data, _subroom_x, _subroom_y));
		world_data_remove_room(_world_data, _subroom_x, _subroom_y);
		show_debug_message("- Room unloaded");
	}
}

function world_save(_world) {
	var _world_data = _world.data;
	world_data_set_rooms_to_disk(_world_data, world_data_get_rooms(_world_data));
	// Save worldwide info
	// Save player info
}