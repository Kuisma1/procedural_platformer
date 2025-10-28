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
		show_debug_message("Room at " + string(_subroom_x) + "," + string(_subroom_y) + " was loaded from disk.");
	} else {
		// TODO: redo world_generation to handle world object instead of world_data
		var _room = world_generation_generate_room(_world, _subroom_x, _subroom_y);
		world_set_room_to_disk(_world, _room);
		world_set_room(_world, _room);
		show_debug_message("Room at " + string(_subroom_x) + "," + string(_subroom_y) + " generated, saved to disk and loaded.");
	}
}

function world_instantiate_room(_world, _subroom_x, _subroom_y) {
	var _room_data = world_get_room(_world, _subroom_x, _subroom_y);
	room_width = _room_data.width * SUBROOM_WIDTH * TILE_SIZE;
	room_height = _room_data.height * SUBROOM_HEIGHT * TILE_SIZE;
	var _room = instance_create_layer(0, 0, "Room", obj_room);
	_room.data = _room_data;
	for (var _sx = 0; _sx < _room_data.width; _sx++) {
		for (var _sy = 0; _sy < _room_data.height; _sy++) {
			var _subroom_data = _room_data.subrooms[_sx][_sy];
			var _subroom = instance_create_layer(_sx * SUBROOM_WIDTH * TILE_SIZE,
												 _sy * SUBROOM_HEIGHT * TILE_SIZE,
												 "Subrooms", obj_subroom);
			_subroom.data = _subroom_data;
			for (var _tx = 0; _tx < SUBROOM_WIDTH; _tx++) {
				for (var _ty = 0; _ty < SUBROOM_HEIGHT; _ty++) {
					if _subroom_data.tiles[_tx][_ty] == 1 {
						var _tile = instance_create_layer((_sx * SUBROOM_WIDTH + _tx) * TILE_SIZE,
														  (_sy * SUBROOM_HEIGHT + _ty) * TILE_SIZE,
													      "Tiles", obj_tile);
						array_push(_subroom.tiles, _tile);
					}
				}
			}
			_subroom.room_ = _room;
			_room.subrooms[_sx][_sy] = _subroom;
		}
	}
	var _player_x = (_subroom_x - _room_data.x) * SUBROOM_WIDTH * TILE_SIZE + SUBROOM_WIDTH / 2 * TILE_SIZE;
	var _player_y = (_subroom_y - _room_data.y) * SUBROOM_HEIGHT * TILE_SIZE + SUBROOM_HEIGHT / 2 * TILE_SIZE;
	var _player = instance_create_layer(_player_x, _player_y, "Player", obj_player);
	array_push(_room.entities, _player);
	_room.world = _world;
	_world.instantiated_room = _room;
	show_debug_message("Room at " + string(_subroom_x) + "," + string(_subroom_y) + " was instantiated.");
}

function world_uninstantiate_room(_world) {
	instance_destroy(_world.instantiated_room);
	_world.instantiated_room = noone;
	show_debug_message("Current room was uninstantiated.");
}

function world_unload_room(_world, _subroom_x, _subroom_y) {
	if !world_room_exists(_world, _subroom_x, _subroom_y) {
		show_debug_message("Tried to unload room at " + string(_subroom_x) + "," + string(_subroom_y) + " but it was not loaded.");
	} else {
		var _room = world_get_room(_world, _subroom_x, _subroom_y);
		world_set_room_to_disk(_world, _room);
		world_remove_room(_world, _subroom_x, _subroom_y);
		show_debug_message("Room at " + string(_subroom_x) + "," + string(_subroom_y) + " was unloaded.")
	}
}

function world_save_rooms(_world) {
	var _rooms = world_get_rooms(_world);
	for (var _i = 0; _i < array_length(_rooms); _i++) {
		world_set_room_to_disk(_world, _rooms[_i]);
	}
}