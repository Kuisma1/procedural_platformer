function EntranceData(_id, _x, _y, _type) constructor {
	id = _id;
	x = _x;
	y = _y;
	type = _type;
}

function entrance_data_get_buffer_size(_entrance_data) {
	return string_byte_length(_entrance_data.id) + 1 + 2 * buffer_sizeof(buffer_f32) + string_byte_length(_entrance_data.type) + 1;
}

function entrance_data_get_buffer(_entrance_data) {
	var _buffer = buffer_create(entrance_data_get_buffer_size(_entrance_data), buffer_fixed, 1);
	buffer_write(_buffer, buffer_string, _entrance_data.id);
	buffer_write(_buffer, buffer_f32, _entrance_data.x);
	buffer_write(_buffer, buffer_f32, _entrance_data.y);
	buffer_write(_buffer, buffer_string, _entrance_data.type);
	return _buffer;
}

function entrance_data_get_from_buffer(_buffer) {
	buffer_seek(_buffer, buffer_seek_start, 0);
	var _id = buffer_read(_buffer, buffer_string);
	var _x = buffer_read(_buffer, buffer_f32);
	var _y = buffer_read(_buffer, buffer_f32);
	var _type = buffer_read(_buffer, buffer_string);
	var _entrance_data = EntranceData(_id, _x, _y, _type);
	return _entrance_data;
}