function Subroom(_x, _y, _hidden, _focus_view) constructor {
	x = _x;
	y = _y;
	hidden = _hidden;
	focus_view = _focus_view;
	tiles = array_create(SUBROOM_WIDTH);
	for (var _tile_x = 0; _tile_x < SUBROOM_WIDTH; _tile_x++) {
		tiles[_tile_x] = array_create(SUBROOM_HEIGHT)
	}
}

function subroom_get_header_buffer_size(_subroom) {
	return 2 * buffer_sizeof(buffer_s32) + 2 * buffer_sizeof(buffer_bool);
}

function subroom_get_tiles_buffer_size(_subroom) {
	return SUBROOM_WIDTH * SUBROOM_HEIGHT * buffer_sizeof(buffer_s32);
}

function subroom_get_buffer_size(_subroom) {
	return subroom_get_header_buffer_size(_subroom) + subroom_get_tiles_buffer_size(_subroom);
}

function subroom_get_buffer(_subroom) {
	var _buffer = buffer_create(subroom_get_buffer_size(_subroom), buffer_fixed, 1);
	// Header
	buffer_write(_buffer, buffer_s32, _subroom.x);
	buffer_write(_buffer, buffer_s32, _subroom.y);
	buffer_write(_buffer, buffer_bool, _subroom.hidden);
	buffer_write(_buffer, buffer_bool, _subroom.focus_view);
	// Tiles
	for (var _tile_x = 0; _tile_x < SUBROOM_WIDTH; _tile_x++) {
		for (var _tile_y = 0; _tile_y < SUBROOM_HEIGHT; _tile_y++) {
			buffer_write(_buffer, buffer_s32, _subroom.tiles[_tile_x][_tile_y]);
		}
	}
	return _buffer;
}

function subroom_get_from_buffer(_buffer) {
	// Header
	var _x = buffer_read(_buffer, buffer_s32);
	var _y = buffer_read(_buffer, buffer_s32);
	var _hidden = buffer_read(_buffer, buffer_bool);
	var _focus_view = buffer_read(_buffer, buffer_bool);
	var _subroom = new Subroom(_x, _y, _hidden, _focus_view);
	// Tiles
	for (var _tile_x = 0; _tile_x < SUBROOM_WIDTH; _tile_x++) {
		for (var _tile_y = 0; _tile_y < SUBROOM_HEIGHT; _tile_y++) {
			_subroom.tiles[_tile_x][_tile_y] = buffer_read(_buffer, buffer_s32);
		}
	}
	return _subroom;
}