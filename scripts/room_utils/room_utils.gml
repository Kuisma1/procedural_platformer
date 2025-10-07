/// @desc Constructor for the world struct
/// @param {Real} _x The x-coordinate of the room
/// @param {Real} _y The y-coordinate of the room
/// @param {Real} _width The width of the room
/// @param {Real} _height The height of the room
function Room(_x, _y, _width, _height, _biome, _structure) : Rectangle(_x, _y, _width, _height) constructor {
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

/// @desc This function returns the given room in buffer form.
/// @param {Struct.Room} _room The room to get the buffer of
/// @return {Id.Buffer}
function room_get_buffer(_room) {
	var _buffer = buffer_create(6 * buffer_sizeof(buffer_s32) + (_room.width * _room.height) * subroom_get_buffer_size(), buffer_fixed, 1);
	// Header
	buffer_write(_buffer, buffer_s32, _room.x);
	buffer_write(_buffer, buffer_s32, _room.y);
	buffer_write(_buffer, buffer_s32, _room.width);
	buffer_write(_buffer, buffer_s32, _room.height);
	buffer_write(_buffer, buffer_s32, _room.biome);
	buffer_write(_buffer, buffer_s32, _room.structure);
	// Subrooms
	for (var _subroom_x = _room.x; _subroom_x < _room.x + _room.width; _subroom_x++) {
		for (var _subroom_y = _room.y; _subroom_y < _room.y + _room.height; _subroom_y++) {
			var _local_subroom_x = _subroom_x - _room.x;
			var _local_subroom_y = _subroom_y - _room.y;
			var _subroom_buffer = subroom_get_buffer(_room.subrooms[_local_subroom_x][_local_subroom_y]);
			buffer_copy(_subroom_buffer, 0, subroom_get_buffer_size(), _buffer,
						6 * buffer_sizeof(buffer_s32) + (_room.width * (_local_subroom_y) + (_local_subroom_x)) * subroom_get_buffer_size());
			buffer_delete(_subroom_buffer);
		}
	}
	return _buffer;
}

/// @desc This function returns the room of the given buffer of a room.
/// @param {Id.Buffer} _buffer The buffer to return the room for
/// @return {Struct.Room}
function room_get_from_buffer(_buffer) {
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
		for (var _subroom_y = 0; _subroom_y < _h; _subroom_y++) {
			var _subroom_buffer = buffer_create(subroom_get_buffer_size(), buffer_fixed, 1);
			var _room_buffer_offset = 6 * buffer_sizeof(buffer_s32) + (_subroom_y * _w + _subroom_x) * subroom_get_buffer_size();
			buffer_copy(_buffer, _room_buffer_offset, subroom_get_buffer_size(), _subroom_buffer, 0);
			var _subroom = subroom_get_from_buffer(_subroom_buffer);
			buffer_delete(_subroom_buffer);
			_subrooms[_subroom_x][_subroom_y] = _subroom;
		}
	}
	var _room = new Room(_x, _y, _w, _h, _biome, _structure);
	_room.subrooms = _subrooms;
	return _room;
}