/// @desc This function returns the room at the given subroom point according to the seed of the given world.
/// @param {Struct.World} _world The world to use the seed of
/// @param {Real} _subroom_x The x-coordinate of the subroom point to generate the room at
/// @param {Real} _subroom_y The y-coordinate of the subroom point to generate the room at
function world_generate_room(_world, _subroom_x, _subroom_y) {
	var _rect = world_get_rectangle(_world, _subroom_x, _subroom_y);
	var _biome = world_get_biome(_world, _rect.x + floor(_rect.width / 2), _rect.y + floor(_rect.height / 2));
	var _structure = STRUCTURE.NONE;
	var _x = _rect.x;
	var _y = _rect.y;
	var _width = _rect.width;
	var _height = _rect.height;
	var _room = new Room(_x, _y, _width, _height, _biome, _structure);
	// Initialize subrooms
	for (var _room_subroom_x = _x; _room_subroom_x < _x + _width; _room_subroom_x++) {
		for (var _room_subroom_y = _y; _room_subroom_y < _y + _height; _room_subroom_y++) {
			var _subroom = new Subroom(_room_subroom_x, _room_subroom_y, false, false);
			var _door_directions = world_get_door_directions(_world, _room_subroom_x, _room_subroom_y);
			var r = !_door_directions.right;
			var l = !_door_directions.left;
			var d = !_door_directions.down;
			var u = !_door_directions.up;
			var _tiles = [[1, 1, 1, 1, 1, 1, l, l, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [u, 0, 0, 0, 0, 0, 0, 0, d],
						  [u, 0, 0, 0, 0, 0, 0, 0, d],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 0, 0, 0, 0, 0, 0, 0, 1],
						  [1, 1, 1, 1, 1, 1, r, r, 1]];
			_subroom.tiles = _tiles;
			_room.subrooms[_room_subroom_x - _x][_room_subroom_y - _y] = _subroom;
		}
	}
	return _room;
}

/// @desc This function returns a structure of the given structure type at the given subroom coordinates according to the seed of the given world.
/// @param {Struct.World} _world The world to use the seed of
/// @param {Real} _subroom_x The x-coordinate of the subroom point to generate the structure at
/// @param {Real} _subroom_y The y-coordinate of the subroom point to generate the structure at
/// @param {Real} _structure_type The type of structure to generate
/// @return {Array<Struct.Room>}
function world_generate_structure(_world, _subroom_x, _subroom_y, _structure_type) {
	if _structure_type == STRUCTURE.STRONGHOLD {
		var _biome = world_get_biome(_world, _subroom_x, _subroom_y);
		
		var _rooms = [new Room(_subroom_x - 3, _subroom_y - 3, 7, 7, _biome, STRUCTURE.STRONGHOLD),
				      new Room(_subroom_x + 4, _subroom_y, 4, 4, _biome, STRUCTURE.STRONGHOLD)];
		
		var _affected_rects = rectangles_difference(get_overlapping_rectangles(_rooms, _world.seed), _rooms);
		for (var _i = 0; _i < array_length(_affected_rects); _i++) {
			var _rect = _affected_rects[_i];
			array_push(_rooms, new Room(_rect.x, _rect.y, _rect.width, _rect.height, _biome, STRUCTURE.NONE));
		}
		return _rooms;
	}
}

// **********************
// ****** HELPERS *******
// **********************

function world_get_rectangle(_world, _subroom_x, _subroom_y) {
	return get_rectangle(_subroom_x, _subroom_y, _world.seed);
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
	return perlin2D(_subroom_x, _subroom_y, 30, _world.seed) > 0.5 ? BIOME.CAVERNS : BIOME.LUSH_CAVES;
}