function Exit(_x, _y, _width, _height, _destination_subroom_x, _destination_subroom_y) constructor {
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	destination_subroom_x = _destination_subroom_x;
	destination_subroom_y = _destination_subroom_y;
}

function exit_get_buffer_size() {
	return 4 * buffer_sizeof(buffer_f32) + 2 * buffer_sizeof(buffer_s32);
}

function exit_get_buffer(_exit) {
	var _buffer = buffer_create(exit_get_buffer_size(), buffer_fixed, 1);
}

function exit_get_from_buffer(_buffer) {
	var _x = buffer_read(_buffer, buffer_f32);
	var _y = buffer_read(_buffer, buffer_f32);
	var _width = buffer_read(_buffer, buffer_f32);
	var _height = buffer_read(_buffer, buffer_f32);
	var _destination_subroom_x = buffer_read(_buffer, buffer_s32);
	var _destination_subroom_y = buffer_read(_buffer, buffer_s32);
	var _exit = new Exit(_x, _y, _width, _height, _destination_subroom_x, _destination_subroom_y);
	return _exit;
}