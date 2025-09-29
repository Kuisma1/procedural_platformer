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
	
function world_get_door_directions(_world, _subroom_x, _subroom_y) {
	var _directions = [DIRECTION.RIGHT,
					   DIRECTION.DOWN,
					   DIRECTION.LEFT,
					   DIRECTION.UP];
	for (var _i = 0; _i < 4; _i++) {
		var _direction = _directions[_i];
		if _direction == DIRECTION.RIGHT {
			var _subroom2_x = _subroom_x + 1;
			var _subroom2_y = _subroom_y;
		} else if _direction == DIRECTION.DOWN {
			var _subroom2_x = _subroom_x;
			var _subroom2_y = _subroom_y + 1;
		} else if _direction == DIRECTION.LEFT {
			var _subroom2_x = _subroom_x - 1;
			var _subroom2_y = _subroom_y;
		} else if _direction == DIRECTION.UP {
			var _subroom2_x = _subroom_x;
			var _subroom2_y = _subroom_y - 1;
		}
	}
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