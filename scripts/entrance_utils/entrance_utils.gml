function Entrance(_x, _y) constructor {
	x = _x;
	y = _y;
}

function entrance_get_buffer_size() {
	return 2 * buffer_sizeof(buffer_f32);
}

function entrance_get_buffer(_entrance) {
	var _buffer = buffer_create(entrance_get_buffer_size(), buffer_fixed, 1);
}

function entrance_get_from_buffer(_buffer) {
	var _x = buffer_read(_buffer, buffer_f32);
	var _y = buffer_read(_buffer, buffer_f32);
	var _entrance = new Entrance(_x, _y);
	return _entrance;
}