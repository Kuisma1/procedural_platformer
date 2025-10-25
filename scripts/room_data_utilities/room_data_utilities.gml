function RoomData(_x, _y, _width, _height, _biome, _structure) : Rectangle(_x, _y, _width, _height) constructor {
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	biome = _biome;
	structure = _structure;
	subrooms = array_create(_width);
	for (var _subroom_x = 0; _subroom_x < _width; _subroom_x++) {
		subrooms[_subroom_x] = array_create(_height);
	}
}

function room_data_get_buffer_header_size(_room_data) {
	return 6 * buffer_sizeof(buffer_s32);
}

function room_data_get_buffer_size(_room_data) {
	var _size = room_data_get_buffer_header_size(_room_data);
	for (var _subroom_x = 0; _subroom_x < _room_data.width; _subroom_x++) {
		for (var _subroom_y = 0; _subroom_y < _room_data.height; _subroom_y++) {
			var _subroom_data = _room_data.subrooms[_subroom_x][_subroom_y];
			_size += buffer_sizeof(buffer_s32) + subroom_data_get_buffer_size(_subroom_data);
		}
	}
	return _size;
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
	for (var _subroom_x = 0; _subroom_x < _room_data.width; _subroom_x++) {
		for (var _subroom_y = 0; _subroom_y < _room_data.height; _subroom_y++) {
			var _subroom_data = _room_data.subrooms[_subroom_x][_subroom_y];
			var _subroom_buffer = subroom_data_get_buffer(_subroom_data);
			var _subroom_buffer_size = buffer_get_size(_subroom_buffer);
			buffer_write(_buffer, buffer_s32, _subroom_buffer_size);
			buffer_copy(_subroom_buffer, 0, _subroom_buffer_size, _buffer, buffer_tell(_buffer));
			buffer_seek(_buffer, buffer_seek_relative, _subroom_buffer_size);
			buffer_delete(_subroom_buffer);
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
	//Subrooms
	var _subrooms = array_create(_w);
	for (var _subroom_x = 0; _subroom_x < _w; _subroom_x++) {
	    _subrooms[_subroom_x] = array_create(_h);
	}
	for (var _subroom_x = 0; _subroom_x < _w; _subroom_x++) {
		for (var _subroom_y = 0; _subroom_y < _h; _subroom_y++) {
			var _subroom_buffer_size = buffer_read(_buffer, buffer_s32);
			var _subroom_buffer = buffer_create(_subroom_buffer_size, buffer_fixed, 1);
			buffer_copy(_buffer, buffer_tell(_buffer), _subroom_buffer_size, _subroom_buffer, 0);
			buffer_seek(_buffer, buffer_seek_relative, _subroom_buffer_size);
			var _subroom_data = subroom_data_get_from_buffer(_subroom_buffer);
			buffer_delete(_subroom_buffer);
			_subrooms[_subroom_x][_subroom_y] = _subroom_data;
		}
	}
	var _room = new RoomData(_x, _y, _w, _h, _biome, _structure);
	_room.subrooms = _subrooms;
	return _room;
}