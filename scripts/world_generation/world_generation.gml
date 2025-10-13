function world_generation_generate_room(_world_data, _subroom_x, _subroom_y) {
	var _rect = rectangle_tiling_get_rectangle(_subroom_x, _subroom_y, _world_data.seed);
	var _biome = world_generation_get_biome(_world_data, _rect.x + floor(_rect.width / 2), _rect.y + floor(_rect.height / 2));
	var _structure = STRUCTURE.NONE;
	var _x = _rect.x;
	var _y = _rect.y;
	var _width = _rect.width;
	var _height = _rect.height;
	var _room_data = new Room(_x, _y, _width, _height, _biome, _structure);
	// Initialize subrooms
	for (var _room_subroom_x = _x; _room_subroom_x < _x + _width; _room_subroom_x++) {
		for (var _room_subroom_y = _y; _room_subroom_y < _y + _height; _room_subroom_y++) {
			var _subroom_data = new Subroom(_room_subroom_x, _room_subroom_y, false, false);
			var _doorways = world_generation_get_doorways(_world_data, _room_subroom_x, _room_subroom_y);
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

function world_generation_get_biome(_world_data, _subroom_x, _subroom_y) { // Placeholder
	return perlin2D(_subroom_x, _subroom_y, 30, _world_data.seed) > 0.5 ? BIOME.CAVERNS : BIOME.LUSH_CAVES;
}

function world_generation_get_doorways(_world_data, _subroom_x, _subroom_y) {
    var _doorways = {};
    var _h1 = hash2(_subroom_x, _subroom_y);
    var _directions = [{name: "right", dx: 1, dy: 0},
					   {name: "left", dx: -1, dy: 0},
					   {name: "down", dx: 0, dy: 1},
					   {name: "up", dx: 0, dy: -1}];
    for (var i = 0; i < array_length(_directions); i++) {
        var _direction = _directions[i];
        var _h2 = hash2(_subroom_x + _direction.dx, _subroom_y + _direction.dy);
        var _combined = hash3(min(_h1, _h2), max(_h1, _h2), _world_data.seed);
        struct_set(_doorways, _direction.name, hash_to_random01(_combined) < 0.3);
    }
    return _doorways;
}