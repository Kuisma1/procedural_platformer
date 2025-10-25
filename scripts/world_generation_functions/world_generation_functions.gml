function world_generation_generate_room(_world, _subroom_x, _subroom_y) {
	var _rect = rectangle_tiling_get_rectangle(_subroom_x, _subroom_y, _world.seed);
	var _biome = world_generation_get_biome(_world, _rect.x + floor(_rect.width / 2), _rect.y + floor(_rect.height / 2));
	var _structure = STRUCTURE.NONE;
	var _x = _rect.x;
	var _y = _rect.y;
	var _width = _rect.width;
	var _height = _rect.height;
	var _room_data = new RoomData(_x, _y, _width, _height, _biome, _structure);
	// Initialize subrooms
	for (var _room_subroom_x = _x; _room_subroom_x < _x + _width; _room_subroom_x++) {
		for (var _room_subroom_y = _y; _room_subroom_y < _y + _height; _room_subroom_y++) {
			var _subroom_data = new SubroomData(_room_subroom_x, _room_subroom_y, false, false);
			var _doorways = world_generation_get_doorways(_world, _room_subroom_x, _room_subroom_y);
			var r = !_doorways.right;
			var l = !_doorways.left;
			var d = !_doorways.down;
			var u = !_doorways.up;
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
			_subroom_data.tiles = _tiles;
			_room_data.subrooms[_room_subroom_x - _x][_room_subroom_y - _y] = _subroom_data;
		}
	}
	return _room_data;
}

function world_generation_generate_structure(_world_data, _subroom_x, _subroom_y, _structure_type) {
	// TODO
}