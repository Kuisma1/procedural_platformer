function World(_seed) constructor {
	seed = _seed;
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

/// @description This function returns a random tiling of the difference between two groups of rooms
/// @param {Struct.World} _world The world to use the seed of
/// @param {Array<Struct.Room>} _rooms1 The group of rooms to subtract from
/// @param {Array<Struct.Room>} _rooms2 The group of rooms to subtract
/// @return {Struct.Room}
function world_get_room_difference(_world, _rooms1, _rooms2) {
	
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

// Structure generation
function world_get_affected_rooms(_world, _structure_rooms) {
	var _candidate_rooms = world_get_overlapping_candidate_rooms(_world, _structure_rooms);
	var _affected_rooms = rooms_difference(_candidate_rooms, _structure_rooms);
	return _affected_rooms;
}

function world_generate_structure(_world, _structure, _anchor_x, _anchor_y) {
	if _structure == STRUCTURE.STRONGHOLD {
		var _room1 = new Room(_anchor_x - 2, _anchor_y - 2, 5, 5);
		var _room2 = new Room(_anchor_x + 3, _anchor_y, 3, 4);
		var _structure_rooms = [_room1, _room2];
		var _affected_rooms = world_get_affected_rooms(_world, _structure_rooms);
		var _structure_struct = {};
		_structure_struct[$ "structure"] = _structure_rooms;
		_structure_struct[$ "affected"] = _affected_rooms;
		return _structure_struct;
	}
}