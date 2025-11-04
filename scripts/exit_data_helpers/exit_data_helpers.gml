function ExitData(_x, _y, _width, _height, _type) constructor {
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	type = _type;
}

function exit_data_get_buffer_size(_exit_data) {
	return 4 * buffer_sizeof(buffer_f32) + string_byte_length(_exit_data.type) + 1;
}

function exit_data_get_buffer(_exit_data) {
	var _buffer = buffer_create(exit_data_get_buffer_size(_exit_data), buffer_fixed, 1);
	buffer_write(_buffer, buffer_f32, _exit_data.x);
	buffer_write(_buffer, buffer_f32, _exit_data.y);
	buffer_write(_buffer, buffer_f32, _exit_data.width);
	buffer_write(_buffer, buffer_f32, _exit_data.height);
	buffer_write(_buffer, buffer_string, _exit_data.type);
	return _buffer;
}

function exit_data_get_from_buffer(_buffer) {
	buffer_seek(_buffer, buffer_seek_start, 0);
	var _x = buffer_read(_buffer, buffer_f32);
	var _y = buffer_read(_buffer, buffer_f32);
	var _width = buffer_read(_buffer, buffer_f32);
	var _height = buffer_read(_buffer, buffer_f32);
	var _type = buffer_read(_buffer, buffer_string);
	var _exit_data = ExitData(_x, _y, _width, _height, _type);
	return _exit_data;
}