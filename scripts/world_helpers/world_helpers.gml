function world_room_exists(_world, _subroom_x, _subroom_y) {
	var _subroom_key = string(_subroom_x) + "_" + string(_subroom_y);
	return !is_undefined(struct_get(_world.rooms, _subroom_key));
}

function world_room_exists_on_disk(_world, _subroom_x, _subroom_y) {
    var _chunk_x = floor(_subroom_x / CHUNK_SIZE);
    var _chunk_y = floor(_subroom_y / CHUNK_SIZE);
    var _chunk_key  = string(_chunk_x) + "_" + string(_chunk_y);
    var _chunk_filepath = _world.filepath + "/chunks/chunk_" + _chunk_key;
    var _rooms_bounds_filepath = _chunk_filepath + "/rooms.bounds";

    if !file_exists(_rooms_bounds_filepath) {
        return false;
    }

    var _buffer = buffer_load(_rooms_bounds_filepath);
    buffer_seek(_buffer, buffer_seek_start, 0);
    var _exists = false;
    while (buffer_tell(_buffer) < buffer_get_size(_buffer)) {
        var _room_x = buffer_read(_buffer, buffer_s32);
        var _room_y = buffer_read(_buffer, buffer_s32);
        var _room_width = buffer_read(_buffer, buffer_s32);
        var _room_height = buffer_read(_buffer, buffer_s32);
        if (_subroom_x >= _room_x && _subroom_x < _room_x + _room_width
        &&  _subroom_y >= _room_y && _subroom_y < _room_y + _room_height) {
            _exists = true;
            break;
        }
    }

    buffer_delete(_buffer);
    return _exists;
}