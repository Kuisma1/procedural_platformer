function World(_seed) constructor {
	seed = _seed;
	chunks = {};
}

function Chunk(_x, _y) constructor {
	x = _x;
	y = _y;
	overlapping_rooms = [];
}

/// @description This function gives the candidate room given by the standard world generation at a given subroom.
/// @param {Struct.World} _world The world to use the seed of
/// @param {Real} _subroom_x The x-coordinate to be covered by the candidate room
/// @param {Real} _subroom_y The y-coordinate to be covered by the candidate room
/// @return {Struct.Room}
function world_get_candidate_room(_world, _subroom_x, _subroom_y) {
	var _rect = pos_find_rectangle(_subroom_x, _subroom_y, _world.seed);
	var _room = new Room(_rect.x, _rect.y, _rect.w, _rect.h);
	return _room;
}

/// @desc This function returns an array of candidate rooms that overlap the given array of rooms.
/// @param {Struct.World} _world The world to use the seed of
/// @param {Array<Struct.Room>} _rooms The group of rooms
/// @return {Array<Struct.Room>}
function world_get_overlapping_candidate_rooms(_world, _rooms) {
	var _candidate_rooms = [];
	var _count = array_length(_rooms);
	for (var _i = 0; _i < _count; _i++) {
		var _room = _rooms[_i];
		for (var _x = _room.x; _x < _room.x + _room.width; _x++) {
			for (var _y = _room.y; _y < _room.y + _room.height; _y++) {
				var _candidate_to_add = world_get_candidate_room(_world, _x, _y);
				var _added = false;
				var _candidate_count = array_length(_candidate_rooms);
				for (var _j = 0; _j < _candidate_count; _j++) {
					var _candidate_to_check = _candidate_rooms[_j];
					if (_candidate_to_add.x == _candidate_to_check.x && _candidate_to_add.y == _candidate_to_check.y) {
						_added = true;
						break;
					}
				}
				if (!_added) {
					array_push(_candidate_rooms, _candidate_to_add);
				}
			}
		}
	}
	return _candidate_rooms;
}

/// @desc This runction returns whether a room intersecting the given subroom point is on the disk
function world_room_exists_on_disk(_world, _subroom_x, _subroom_y) {
	var _chunk_x = floor(_subroom_x / CHUNK_WIDTH);
	var _chunk_y = floor(_subroom_y / CHUNK_HEIGHT);
	var _chunk_key = string(_chunk_x) + "_" + string(_chunk_y);
	var _chunk_filepath = "world/chunks/chunk_" + _chunk_key;
	if !file_exists(_chunk_filepath) {
		return false;
	}
	var _rooms_bounds_filepath = _chunk_filepath + "/rooms.bounds";
	var _buffer = buffer_load(_rooms_bounds_filepath);
	var _room_bounds_count = buffer_get_size(_buffer) div (4 * buffer_sizeof(buffer_s32));
	for (var _i = 0; _i < _room_bounds_count; _i++) {
		var _x = buffer_read(_buffer, buffer_s32);
		var _y = buffer_read(_buffer, buffer_s32);
		var _width = buffer_read(_buffer, buffer_s32);
		var _height = buffer_read(_buffer, buffer_s32);
		if (_x <= _subroom_x && _subroom_x < _x + _width && _y <= _subroom_y && _subroom_y < _y + _height) {
			buffer_delete(_buffer);
			return true;
		}
	}
	buffer_delete(_buffer);
	return false;
}


function world_structure_anchor_exists_on_disk(_world, _anchor_x, _anchor_y) {
	var _chunk_x = floor(_anchor_x / CHUNK_WIDTH);
	var _chunk_y = floor(_anchor_y / CHUNK_HEIGHT);
	var _chunk_key = string(_chunk_x) + "_" + string(_chunk_y);
	var _chunk_filepath = "world/chunks/chunk_" + _chunk_key;
	if !file_exists(_chunk_filepath) {
		return false;
	}
	var _structures_anchors_filepath = _chunk_filepath + "/structures.anchors";
	var _buffer = buffer_load(_structures_anchors_filepath);
	var _structures_anchors_count = buffer_get_size(_buffer) div (2 * buffer_sizeof(buffer_s32));
	for (var _i = 0; _i < _structures_anchors_count; _i++) {
		var _x = buffer_read(_buffer, buffer_s32);
		var _y = buffer_read(_buffer, buffer_s32);
		if _x == _anchor_x && _y == _anchor_y {
			buffer_delete(_buffer);
			return true;
		}
	}
	return false;
}

function world_save_structure_anchor_to_disk(_world, _anchor_x, _anchor_y) {
	var _chunk_x = floor(_anchor_x / CHUNK_WIDTH);
	var _chunk_y = floor(_anchor_y / CHUNK_HEIGHT);
	var _chunk_key = string(_chunk_x) + "_" + string(_chunk_y);
	var _structures_anchors_path = "world/chunks/chunk_" + _chunk_key + "/structures.anchors";
	if file_exists(_structures_anchors_path) {
		var _buffer = buffer_load(_structures_anchors_path);
		buffer_seek(_buffer, buffer_seek_end, 0);
		buffer_write(_buffer, buffer_s32, _anchor_x);
		buffer_write(_buffer, buffer_s32, _anchor_y);
		buffer_save(_buffer, _structures_anchors_path);
		buffer_delete(_buffer);
	} else {
		var _buffer = buffer_create(2 * buffer_sizeof(buffer_s32), buffer_grow, 1);
		buffer_write(_buffer, buffer_s32, _anchor_x);
		buffer_write(_buffer, buffer_s32, _anchor_y);
		buffer_save(_buffer, _structures_anchors_path);
		buffer_delete(_buffer);
	}
}

function world_room_exists_in_memory(_world, _subroom_x, _subroom_y) {
	var _chunk_x = floor(_subroom_x / CHUNK_WIDTH);
	var _chunk_y = floor(_subroom_y / CHUNK_HEIGHT);
	var _chunk_key = string(_chunk_x) + "_" + string(_chunk_y);
	var _chunk = struct_get(_world.chunks, _chunk_key);
	if is_undefined(_chunk) return false;
	var _overlapping_rooms_count = array_length(_chunk.overlapping_rooms);
	for (var _i = 0; _i <_overlapping_rooms_count; _i++) {
		var _overlapping_room = _chunk.overlapping_rooms[_i];
		if _overlapping_room.x <= _subroom_x && _subroom_x < _overlapping_room.x + _overlapping_room.width
		   && _overlapping_room.y <= _subroom_y && _subroom_y < _overlapping_room.y + _overlapping_room.height {
			   return true;
		   }
	}
	return false;
}

/// @desc This function looks for a room on the disk and saves it into memory
function world_load_room_from_disk(_world, _subroom_x, _subroom_y) {
	var _chunk_x = floor(_subroom_x / CHUNK_WIDTH);
	var _chunk_y = floor(_subroom_y / CHUNK_HEIGHT);
	var _chunk_key = string(_chunk_x) + "_" + string(_chunk_y);
	
	var _rooms_bounds_filepath = "world/chunks/chunk_" + _chunk_key + "/rooms.bounds";
	
	var _bounds_buffer = buffer_load(_rooms_bounds_filepath);
	var _overlapping_rooms_count = buffer_get_size(_bounds_buffer) div (4 * buffer_sizeof(buffer_s32));
	
	for (var _i = 0; _i < _overlapping_rooms_count; _i++) {
		var _x = buffer_read(_bounds_buffer, buffer_s32);
		var _y = buffer_read(_bounds_buffer, buffer_s32);
		var _width = buffer_read(_bounds_buffer, buffer_s32);
		var _height = buffer_read(_bounds_buffer, buffer_s32);
		// Does this room contain the queried subroom point?
		if (_x <= _subroom_x && _subroom_x < _x + _width 
		 && _y <= _subroom_y && _subroom_y < _y + _height) {
			// Delete buffer holding room bounds
			buffer_delete(_bounds_buffer);
			// Determine owning chunk of room (top-left corner)
            var _owner_chunk_x = floor(_x / CHUNK_WIDTH);
            var _owner_chunk_y = floor(_y / CHUNK_HEIGHT);
            var _owner_chunk_key = string(_owner_chunk_x) + "_" + string(_owner_chunk_y);
			// Load the actual room file from the owner chunk
            var _room_path = "world/chunks/chunk_" + _owner_chunk_key + "/rooms/room_" + string(_x) + "_" + string(_y) + ".bin";
			var _room_buffer = buffer_load(_room_path);
			var _room = room_create_from_buffer(_room_buffer);
			var _chunk = _world.chunks[$ _owner_chunk_key];
			if is_undefined(_chunk) {
                _chunk = new Chunk(_owner_chunk_x, _owner_chunk_y);
                _world.chunks[$ _owner_chunk_key] = _chunk;
            }
			// Save room into memory
            array_push(_chunk.overlapping_rooms, _room);
			buffer_delete(_room_buffer);
            return; // loaded successfully
		}
	}
}

/// @desc Save a room to disk (both its owning chunk + overlap chunks)
/// @param {Struct.World} _world
/// @param {Struct.Room}  _room
function world_save_room_to_disk(_world, _room) {
    // --- 1. Determine owning chunk (top-left corner) ---
    var _owner_chunk_x = floor(_room.x / CHUNK_WIDTH);
    var _owner_chunk_y = floor(_room.y / CHUNK_HEIGHT);
    var _owner_chunk_key = string(_owner_chunk_x) + "_" + string(_owner_chunk_y);
    var _owner_chunk_path = "world/chunks/chunk_" + _owner_chunk_key;
	var _owner_rooms_path = _owner_chunk_path + "/rooms";
    // Ensure directory exists (pseudo, depends on your filesystem helper)
    if !directory_exists(_owner_rooms_path) {
        directory_create(_owner_rooms_path);
    }

    // --- 2. Save full room struct into its file ---
    var _room_path = _owner_rooms_path + "/room_" + string(_room.x) + "_" + string(_room.y) + ".bin";
    var _buffer = room_create_buffer(_room);
    buffer_save(_buffer, _room_path);
    buffer_delete(_buffer);

    // --- 3. Update rooms.bounds in all overlapping chunks ---
    var _min_chunk_x = floor(_room.x / CHUNK_WIDTH);
    var _max_chunk_x = floor((_room.x + _room.width - 1) / CHUNK_WIDTH);
    var _min_chunk_y = floor(_room.y / CHUNK_HEIGHT);
    var _max_chunk_y = floor((_room.y + _room.height - 1) / CHUNK_HEIGHT);

    for (var _cx = _min_chunk_x; _cx <= _max_chunk_x; _cx++) {
        for (var _cy = _min_chunk_y; _cy <= _max_chunk_y; _cy++) {
            var _chunk_key = string(_cx) + "_" + string(_cy);
            var _chunk_path = "world/chunks/chunk_" + _chunk_key;
            if !directory_exists(_chunk_path) {
                directory_create(_chunk_path);
            }
            
            var _bounds_path = _chunk_path + "/rooms.bounds";
            var _bounds_buffer;
            if file_exists(_bounds_path) {
                _bounds_buffer = buffer_load(_bounds_path);
                buffer_seek(_bounds_buffer, buffer_seek_end, 0);
            } else {
                _bounds_buffer = buffer_create(4 * buffer_sizeof(buffer_s32), buffer_grow, 1);
            }

            // Append this room’s bounding box
            buffer_write(_bounds_buffer, buffer_s32, _room.x);
            buffer_write(_bounds_buffer, buffer_s32, _room.y);
            buffer_write(_bounds_buffer, buffer_s32, _room.width);
            buffer_write(_bounds_buffer, buffer_s32, _room.height);

            buffer_save(_bounds_buffer, _bounds_path);
            buffer_delete(_bounds_buffer);
        }
    }
}

function world_structure_at_anchor(_world, _anchor_x, _anchor_y) {
	if _anchor_x == 100 && _anchor_y == 100 {
		return STRUCTURE.STRONGHOLD;
	} else {
		return STRUCTURE.NONE;
	}
}

/// @desc This function loads the room containing the given subroom point into memory. If the room is loaded for the first time, its also saved onto the disk. All rooms loaded at the same time are saved onto the disk.
function world_load_room(_world, _subroom_x, _subroom_y) {
	// 1. If the room is already in memory, do nothing.
	if world_room_exists_in_memory(_world, _subroom_x, _subroom_y) {
		show_debug_message("Loading room: Room already loaded");
		return;
	}
	// If the room is on the disk, load it into memory
	if world_room_exists_on_disk(_world, _subroom_x, _subroom_y) {
		world_load_room_from_disk(_world, _subroom_x, _subroom_y);
		show_debug_message("Loading room: Room found on disk and loaded");
		return;
	}
	
	// 3. Generate all nearby ungenerated structures and save them to disk
	for (var _candidate_anchor_x = _subroom_x - STRUCTURE_GENERATION_RADIUS; _candidate_anchor_x <= _subroom_x + STRUCTURE_GENERATION_RADIUS; _candidate_anchor_x++) {
		for (var _candidate_anchor_y = _subroom_y - STRUCTURE_GENERATION_RADIUS; _candidate_anchor_y <= _subroom_y + STRUCTURE_GENERATION_RADIUS; _candidate_anchor_y++) {
			var _structure = world_structure_at_anchor(_world, _candidate_anchor_x, _candidate_anchor_y);
			if _structure == STRUCTURE.STRONGHOLD {
				var _anchor_x = _candidate_anchor_x;
				var _anchor_y = _candidate_anchor_y;
				if !world_structure_anchor_exists_on_disk(_world, _anchor_x, _anchor_y) {
					var _structure_rooms = [new Room(_candidate_anchor_x - 5, _candidate_anchor_y - 5, 11, 11)];
					var _affected_rooms = rooms_difference(world_get_overlapping_candidate_rooms(_world, _structure_rooms), _structure_rooms);
					var _together = array_concat(_structure_rooms, _affected_rooms);
					var _rooms_count = array_length(_together);
					for (var _i = 0; _i < _rooms_count; _i++) {
						var _room = _together[_i];
						world_save_room_to_disk(_world, _room);
					}
					world_save_structure_anchor_to_disk(_world, _anchor_x, _anchor_y);
				}
			}
		}
	}
	// 4. Attempt to load the room from the disk again
	// If the room is on the disk, load it into memory
	if world_room_exists_on_disk(_world, _subroom_x, _subroom_y) {
		world_load_room_from_disk(_world, _subroom_x, _subroom_y);
		show_debug_message("Loading room: Room found on disk after structure generation, and loaded");
		return;
	}
	// 5. Generate the room at subroom_x, subroom_y using standard generation
	var _room = world_get_candidate_room(_world, _subroom_x, _subroom_y)
}

// Saves the room in memory containing 
function world_unload_room(_world, _subroom_x, _subroom_y) {
	// ...
}

/// @desc This function returns the room containing the given subroom point if it's found in memory, undefined otherwise.
function world_get_room(_world, _subroom_x, _subroom_y) {
	if world_room_exists_in_memory(_world, _subroom_x, _subroom_y) {
		var _chunk_x = floor(_subroom_x / CHUNK_WIDTH);
		var _chunk_y = floor(_subroom_y / CHUNK_HEIGHT);
		var _chunk_key = string(_chunk_x) + "_" + string(_chunk_y);
		var _chunk = _world.chunks[$ _chunk_key];
		var _overlapping_rooms_count = array_length(_chunk.overlapping_rooms);
		for (var _i = 0; _i < _overlapping_rooms_count; _i++) {
			var _overlapping_room = _chunk.overlapping_rooms[_i];
			if (_overlapping_room.x <= _subroom_x && _subroom_x < _overlapping_room.x + _overlapping_room.width && _overlapping_room.y <= _subroom_y && _subroom_y < _overlapping_room.y + _overlapping_room.height) {
				return _overlapping_room;
			}
		}
	} else {
		return undefined;
	}
}