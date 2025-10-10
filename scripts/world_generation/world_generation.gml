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
	for (var _room_subroom_x = 0; _room_subroom_x < _width; _room_subroom_x++) {
		for (var _room_subroom_y = 0; _room_subroom_y < _height; _room_subroom_y++) {
			var _subroom = new Subroom(_x + _room_subroom_x, _y + _room_subroom_y, false, false);
			// Get subroom doorway directions
			var _door_directions = world_get_door_directions(_world, _x + _room_subroom_x, _y + _room_subroom_y);
			// Initialize subroom tiles
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
			// Initialize subroom entrances and exits
			if _door_directions.right && _room_subroom_x == _width - 1 {
				_subroom.entrances.right = new Entrance(15, 7);
				_subroom.exits.right = new Exit(15, 6, 1, 2, _x + _width, _y + _room_subroom_y);
			} else if _door_directions.left && _room_subroom_x == 0 {
				_subroom.entrances.left = new Entrance(0, 7);
				_subroom.exits.left = new Exit(0, 6, 1, 2, _x - 1, _y + _room_subroom_y);
			} else if _door_directions.down && _room_subroom_y == _height - 1 {
				_subroom.entrances.down = new Entrance(7.5, 8);
				_subroom.exits.down = new Exit(7, 8, 2, 1, _x + _room_subroom_x, _y + _height);
			} else if _door_directions.up && _room_subroom_y == 0 {
				_subroom.entrances.up = new Entrance(7.5, 0);
				_subroom.exits.up = new Exit(7, 0, 2, 1, _x + _room_subroom_x, _y  - 1);
			}
			_room.subrooms[_room_subroom_x][_room_subroom_y] = _subroom;
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