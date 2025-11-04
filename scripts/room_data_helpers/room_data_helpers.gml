function RoomData(_x, _y, _width, _height, _biome, _structure, _tiles) : Rectangle(_x, _y, _width, _height) constructor {
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	biome = _biome;
	structure = _structure;
	tiles = _tiles;
}

function room_data_get_buffer_header_size(_room_data) {
	return 6 * buffer_sizeof(buffer_s32);
}

function room_data_get_buffer_tiles_size(_room_data) {
	return buffer_sizeof(buffer_s32) * (SUBROOM_WIDTH * _room_data.width * SUBROOM_HEIGHT * _room_data.height);
}

function room_data_get_buffer_size(_room_data) {
	return room_data_get_buffer_header_size(_room_data) + room_data_get_buffer_tiles_size(_room_data);
}

function room_data_get_buffer(_room_data) {
	var _buffer = buffer_create(room_data_get_buffer_size(_room_data), buffer_fixed, 1);
	// Header
	buffer_write(_buffer, buffer_s32, _room_data.x);
	buffer_write(_buffer, buffer_s32, _room_data.y);
	buffer_write(_buffer, buffer_s32, _room_data.width);
	buffer_write(_buffer, buffer_s32, _room_data.height);
	buffer_write(_buffer, buffer_s32, _room_data.biome);
	buffer_write(_buffer, buffer_s32, _room_data.structure);
	// Subrooms
	for (var _tile_x = 0; _tile_x < SUBROOM_WIDTH * _room_data.width; _tile_x++) {
		for (var _tile_y = 0; _tile_y < SUBROOM_HEIGHT * _room_data.height; _tile_y++) {
			var _tile = _room_data.tiles[_tile_x][_tile_y];
			buffer_write(_buffer, buffer_s32, _tile);
		}
	}
	return _buffer;
}

/// @desc This function returns the room of the given buffer of a room.
/// @param {Id.Buffer} _buffer The buffer to return the room for
/// @return {Struct.RoomData}
function room_data_get_from_buffer(_buffer) {
	buffer_seek(_buffer, buffer_seek_start, 0);
	//Header
	var _x = buffer_read(_buffer, buffer_s32);
	var _y = buffer_read(_buffer, buffer_s32);
	var _w = buffer_read(_buffer, buffer_s32);
	var _h = buffer_read(_buffer, buffer_s32);
	var _biome = buffer_read(_buffer, buffer_s32);
	var _structure = buffer_read(_buffer, buffer_s32);
	var _tiles = [];
	
	for (var _tile_x = 0; _tile_x < SUBROOM_WIDTH * _w; _tile_x++) {
		for (var _tile_y = 0; _tile_y < SUBROOM_HEIGHT * _h; _tile_y++) {
			var _tile = buffer_read(_buffer, buffer_s32);
			_tiles[_tile_x][_tile_y] = _tile;
		}
	}
	var _room = new RoomData(_x, _y, _w, _h, _biome, _structure, _tiles);
	return _room;
}