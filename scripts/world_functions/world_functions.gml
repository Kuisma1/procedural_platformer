function world_load_room(_world, _subroom_x, _subroom_y) {
	// 1. if room already loaded, do nothing
	// 2. if room exists on disk, load it
	// (2.5. generate nearby ungenerated structures, and check existence on disk again)
	// 3. otherwise generate the room, save it to disk and load it
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