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

function world_get_room_from_memory(_world, _subroom_x, _subroom_y) {
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
}
	
function world_get_room_from_disk(_world, _subroom_x, _subroom_y) {
	var _chunk_x = floor(_subroom_x / CHUNK_WIDTH);
	var _chunk_y = floor(_subroom_y / CHUNK_HEIGHT);
	var _chunk_key = string(_chunk_x) + "_" + string(_chunk_y);
	var _rooms_bounds_filepath = "world/chunks/chunk_" + _chunk_key + "/rooms.bounds";
	var _buffer = buffer_load(_rooms_bounds_filepath);
	var _rooms_bounds_count = buffer_get_size(_buffer) div (4 * buffer_sizeof(buffer_s32));
	for (var _i = 0; _i < _rooms_bounds_count; _i++) {
		var _x = buffer_read(_buffer, buffer_s32);
		var _y = buffer_read(_buffer, buffer_s32);
		var _width = buffer_read(_buffer, buffer_s32);
		var _height = buffer_read(_buffer, buffer_s32);
		if (_x <= _subroom_x && _subroom_x < _x + _width && _y <= _subroom_y && _subroom_y < _y + _height) {
			var _chunk2_x = floor(_x / CHUNK_WIDTH);
			var _chunk2_y = floor(_y / CHUNK_HEIGHT);
			var _chunk2_key = string(_chunk2_x) + "_" + string(_chunk2_y);
			var _chunk2 = _world.chunks[$ _chunk2_key];
			var _chunk2_rooms_count = array_length(_chunk2.rooms);
			for (var _j = 0; _j < _chunk2_rooms_count; _j++) {
				var _room2 = _chunk2.rooms[_j];
				if (_room2.x == _x && _room2.y == _y) {
					buffer_delete(_buffer);
					return _room2;
				}
			}
		}
	}
}

function world_get_room(_world, _subroom_x, _subroom_y) {
	// 1. attempt to get room from memory
	if world_room_exists_in_memory(_world, _subroom_x, _subroom_y) {
		return world_get_room_from_memory(_world, _subroom_x, _subroom_y);
	}
	// 2. attempt to get room from the disk
	if world_room_exists_on_disk(_world, _subroom_x, _subroom_y) {
		//return world_get_room_from_disk(_world, _subroom_x, _subroom_y)
	}
	// 3. Generate all nearby ungenerated structures and look for room in them
	
	// 4. Generate the room at subroom_x, subroom_y using standard generation
}