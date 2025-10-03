
/// @description This function gives the candidate room given by the standard world generation at a given subroom.
/// @param {Struct.World} _world The world to use the seed of
/// @param {Real} _subroom_x The x-coordinate to be covered by the candidate room
/// @param {Real} _subroom_y The y-coordinate to be covered by the candidate room
/// @return {Struct.Room}
function world_get_candidate_room(_world, _subroom_x, _subroom_y) {
	var _rect = get_rectangle(_subroom_x, _subroom_y, _world.seed);
	var _room = new Room(_rect.x, _rect.y, _rect.w, _rect.h);
	return _room;
}

/// @desc This function returns an array of candidate rooms that overlap the given array of rooms.
/// @param {Struct.World} _world The world to use the seed of
/// @param {Array<Struct.Room>} _rooms The group of rooms
/// @return {Array<Struct.Room>}
function world_get_overlapping_candidate_rooms(_world, _rooms) {
	var _candidate_rooms = [];
	for (var _i = 0; _i < array_length(_rooms); _i++) {
		var _room = _rooms[_i];
		for (var _x = _room.x; _x < _room.x + _room.width; _x++) {
			for (var _y = _room.y; _y < _room.y + _room.height; _y++) {
				var _candidate_to_add = world_get_candidate_room(_world, _x, _y);
				var _added = false;
				for (var _j = 0; _j < array_length(_candidate_rooms); _j++) {
					var _candidate_to_check = _candidate_rooms[_j];
					if (_candidate_to_add.x == _candidate_to_check.x 
					 && _candidate_to_add.y == _candidate_to_check.y) {
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

function world_get_door_directions(_world, _subroom_x, _subroom_y) {
    var _doors = {};
    var _h1 = hash2(_subroom_x, _subroom_y);
    var _directions = [{name: "right", dx: 1, dy: 0},
					   {name: "left", dx: -1, dy: 0},
					   {name: "down", dx: 0, dy: 1},
					   {name: "up", dx: 0, dy: -1}];
    for (var i = 0; i < array_length(_directions); i++) {
        var _direction = _directions[i];
        var _h2 = hash2(_subroom_x + _direction.dx, _subroom_y + _direction.dy);
        var _combined = hash3(min(_h1, _h2), max(_h1, _h2), _world.seed);
        struct_set(_doors, _direction.name, hash_to_random01(_combined) < 0.3);
    }
    return _doors;
}

function world_get_biome(_world, _subroom_x, _subroom_y) { // Placeholder
	return perlin2D(_subroom_x, _subroom_y, 10, _world.seed) > 0.5 ? BIOME.CAVERNS : BIOME.LUSH_CAVES;
}