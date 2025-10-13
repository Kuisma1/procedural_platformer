/// @desc This function loads the room at the given subroom point into the given world either by generating or by loading from the disk. It also saves it related rooms to the disk.
/// @param {Struct.World} _world The world to load to room into
/// @param {Real} _subroom_x The x-coordinate of the subroom to load the room of
/// @param {Real} _subroom_y The y-coordinate of the subroom to load the room of
/// @return {Undefined}
function world_load_room2(_world, _subroom_x, _subroom_y) {
	// If the room already exists in memory, don't do anything
	if world_room_exists(_world, _subroom_x, _subroom_y) {
		show_debug_message("Room already in memory");
		return;
	}
	// If the room already exists on disk, load it into memory
	if disk_room_exists(_subroom_x, _subroom_y) {
		var _room = disk_get_room(_subroom_x, _subroom_y);
		world_set_room(_world, _room);
		show_debug_message("Room loaded from disk");
		return;
	}
	/*
	// Generate all nearby ungenerated structures, save them onto disk
	for (var _x = _subroom_x - STRUCTURE_GENERATION_RADIUS; _x <= _subroom_x + STRUCTURE_GENERATION_RADIUS; _x++) {
		for (var _y = _subroom_y - STRUCTURE_GENERATION_RADIUS; _y <= _subroom_y + STRUCTURE_GENERATION_RADIUS; _y++) {
			if _x == 40 && _y == 20 {
				if !world_room_exists(_world, _x, _y) && !disk_room_exists(_x, _y) {
					disk_set_rooms(world_generate_structure(_world, _x, _y, STRUCTURE.STRONGHOLD));
					show_debug_message("Structure generated");
				}
			}
		}
	}
	// If the room now exists on disk, load it into memory
	if disk_room_exists(_subroom_x, _subroom_y) {
		var _room = disk_get_room(_subroom_x, _subroom_y);
		world_set_room(_world, _room);
		show_debug_message("Room loaded from disk after generating structure");
		return;
	}
	*/
	// Otherwise, generate the room
	var _room = world_generate_room(_world, _subroom_x, _subroom_y);
	disk_set_room(_room);
	world_set_room(_world, _room);
	show_debug_message("Room loaded using standard room generation");
}

/// @desc This function unloads the room at the given subroom point in the given world. It also saves the unloaded room onto the disk.
/// @param {Struct.World} _world The world to unload the room in
/// @param {Real} _subroom_x The x-coordinate of the subroom point to unload the room at
/// @param {Real} _subroom_y The y-coordinate of the subroom point to unload the room at
function world_unload_room2(_world, _subroom_x, _subroom_y) {
	// If the room doesn't exist in memory, do nothing
	if !world_room_exists(_world, _subroom_x, _subroom_y) {
		show_debug_message("Room didn't exist in memory, nothing was unloaded");
		return;
	}
	// Otherwise, set the room on disk and remove from memory
	disk_set_room(world_get_room(_world, _subroom_x, _subroom_y));
	world_remove_room(_world, _subroom_x, _subroom_y);
	show_debug_message("Room unloaded");
}