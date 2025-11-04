function world_generation_get_biome(_world, _subroom_x, _subroom_y) { // Placeholder
	return perlin2D(_subroom_x, _subroom_y, 30, _world.seed) > 0.5 ? BIOME.CAVERNS : BIOME.LUSH_CAVES;
}

function world_generation_get_doorways(_world, _subroom_x, _subroom_y) {
    var _doorways = {};
    var _h1 = hash2(_subroom_x, _subroom_y);
    var _directions = [{name: "right", dx: 1, dy: 0},
					   {name: "left", dx: -1, dy: 0},
					   {name: "down", dx: 0, dy: 1},
					   {name: "up", dx: 0, dy: -1}];
    for (var i = 0; i < array_length(_directions); i++) {
        var _direction = _directions[i];
        var _h2 = hash2(_subroom_x + _direction.dx, _subroom_y + _direction.dy);
        var _combined = hash3(min(_h1, _h2), max(_h1, _h2), _world.seed);
        struct_set(_doorways, _direction.name, hash_to_random01(_combined) < 0.3);
    }
    return {"right": true, "left": true, "down": true, "up": true}; //_doorways;
}

// PLACEHOLDER FOR TO HELP WITH ROOM GENERATION
function world_generation_get_subroom_tiles(_world, _subroom_x, _subroom_y) {
	var _doorways = world_generation_get_doorways(_world, _subroom_x, _subroom_y);
	var _r = _doorways.right;
	var _l = _doorways.left;
	var _d = _doorways.down;
	var _u = _doorways.up;
	var _tiles = [[1, 1, 1, 1, 1, 1, !_l, !_l, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [!_u, 0, 0, 0, 0, 0, 0, 0, !_d],
				  [!_u, 0, 0, 0, 0, 0, 0, 0, !_d],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 0, 0, 0, 0, 0, 0, 0, 1],
				  [1, 1, 1, 1, 1, 1, !_r, !_r, 1]];
	return _tiles;
}

function array_blit(_dest_array, _src_array, _dest_x, _dest_y) {
	var _src_width = array_length(_src_array);
	var _src_height = array_length(_src_array[0]);
	for (var _x = 0; _x < _src_width; _x++) {
		for (var _y = 0; _y < _src_height; _y++) {
			_dest_array[_dest_x + _x][_dest_y + _y] = _src_array[_x][_y];
		}
	}
}