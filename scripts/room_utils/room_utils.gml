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
}

/// @desc This function returns the given room in buffer form.
/// @param {Struct.Room} _room The room to get the buffer of
/// @return {Id.Buffer}
function room_get_buffer(_room) {
	var _buffer = buffer_create(6 * buffer_sizeof(buffer_s32), buffer_fixed, 1);
	buffer_write(_buffer, buffer_s32, _room.x);
	buffer_write(_buffer, buffer_s32, _room.y);
	buffer_write(_buffer, buffer_s32, _room.width);
	buffer_write(_buffer, buffer_s32, _room.height);
	buffer_write(_buffer, buffer_s32, _room.biome);
	buffer_write(_buffer, buffer_s32, _room.structure);
	return _buffer;
}

/// @desc This function returns the room of the given buffer of a room.
/// @param {Id.Buffer} _buffer The buffer to return the room for
/// @return {Struct.Room}
function room_get_from_buffer(_buffer) {
	buffer_seek(_buffer, buffer_seek_start, 0);
	var _x = buffer_read(_buffer, buffer_s32);
	var _y = buffer_read(_buffer, buffer_s32);
	var _w = buffer_read(_buffer, buffer_s32);
	var _h = buffer_read(_buffer, buffer_s32);
	var _biome = buffer_read(_buffer, buffer_s32);
	var _structure = buffer_read(_buffer, buffer_s32);
	return new Room(_x, _y, _w, _h, _biome, _structure);
}