function world_generation_generate_room(_world, _subroom_x, _subroom_y) {
	var _rect = rectangle_tiling_get_rectangle(_subroom_x, _subroom_y, _world.seed);
	var _biome = world_generation_get_biome(_world, _rect.x + floor(_rect.width / 2), _rect.y + floor(_rect.height / 2));
	var _structure = STRUCTURE.NONE;
	var _x = _rect.x;
	var _y = _rect.y;
	var _width = _rect.width;
	var _height = _rect.height;
	var _tiles = [[]];
	for (var _sx = 0; _sx < _width; _sx++) {
		for (var _sy = 0; _sy < _height; _sy++) {
			var _subroom_tiles = world_generation_get_subroom_tiles(_world, _x + _sx, _y + _sy)
			array_blit(_tiles, _subroom_tiles, SUBROOM_WIDTH * _sx, SUBROOM_HEIGHT * _sy);
		}
	}
	var _room_data = new RoomData(_x, _y, _width, _height, _biome, _structure, _tiles);
	return _room_data;
}

function world_generation_generate_structure(_world_data, _subroom_x, _subroom_y, _structure_type) {
	// TODO
}