function world_room_exists(_world, _subroom_x, _subroom_y) {
	var _subroom_key = string(_subroom_x) + "_" + string(_subroom_y);
	return !is_undefined(struct_get(_world.rooms, _subroom_key));
}

function world_get_room(_world, _subroom_x, _subroom_y) {
	var _subroom_key = string(_subroom_x) + "_" + string(_subroom_y);
	return struct_get(_world.rooms, _subroom_key);
}

function world_get_rooms(_world) {
	return _world.rooms_list;
}

function world_set_room(_world, _room_data) {
	for (var _x = _room_data.x; _x < _room_data.x + _room_data.width; _x++) {
		for (var _y = _room_data.y; _y < _room_data.y + _room_data.height; _y++) {
			var _subroom_key = string(_x) + "_" + string(_y);
			_world.rooms[$ _subroom_key] = _room_data;
		}
	}
	array_push(_world.rooms_list, _room_data);
}

function world_remove_room(_world, _subroom_x, _subroom_y) {
	if !world_room_exists(_world, _subroom_x, _subroom_y) return;
	var _room_data = world_get_room(_world, _subroom_x, _subroom_y);
	for (var _x = _room_data.x; _x < _room_data.x + _room_data.width; _x++) {
		for (var _y = _room_data.y; _y < _room_data.y + _room_data.height; _y++) {
			var _subroom_key = string(_x) + "_" + string(_y);
			struct_remove(_world.rooms, _subroom_key);
		}
	}
	array_delete(_world.rooms_list, array_get_index(_world.rooms_list, _room_data), 1);
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

function world_get_room_from_disk(_world, _subroom_x, _subroom_y) {
	// --- Step 1: which chunk does this query point belong to ---
    var _chunk_x = floor(_subroom_x / CHUNK_SIZE);
    var _chunk_y = floor(_subroom_y / CHUNK_SIZE);
    var _chunk_key  = string(_chunk_x) + "_" + string(_chunk_y);
    var _chunk_filepath = _world.filepath + "/chunks/chunk_" + _chunk_key;
    var _rooms_bounds_filepath = _chunk_filepath + "/rooms.bounds";
	
	// --- Step 2: if no directory for chunk, no rooms here ---
    if !directory_exists(_chunk_filepath) {
        return undefined;
    }
	
	// --- Step 3: load buffer and scan all room bounds ---
    var _buffer = buffer_load(_rooms_bounds_filepath);
    buffer_seek(_buffer, buffer_seek_start, 0);

    var _room_found_x = undefined;
    var _room_found_y = undefined;
    var _room_found_w = undefined;
    var _room_found_h = undefined;

    while (buffer_tell(_buffer) < buffer_get_size(_buffer)) {
        var _room_x = buffer_read(_buffer, buffer_s32);
        var _room_y = buffer_read(_buffer, buffer_s32);
        var _room_width = buffer_read(_buffer, buffer_s32);
        var _room_height = buffer_read(_buffer, buffer_s32);

        // --- Step 4: check if point lies within this room ---
        if (_subroom_x >= _room_x && _subroom_x < _room_x + _room_width
        &&  _subroom_y >= _room_y && _subroom_y < _room_y + _room_height) {
            _room_found_x = _room_x;
            _room_found_y = _room_y;
            _room_found_w = _room_width;
            _room_found_h = _room_height;
            break;
        }
    }

    buffer_delete(_buffer);
	
	// --- Step 5: if no room was found ---
    if (is_undefined(_room_found_x)) {
        return undefined;
    }
	
	// --- Step 6: load actual room data ---
    var _origin_chunk_x = floor(_room_found_x / CHUNK_SIZE);
    var _origin_chunk_y = floor(_room_found_y / CHUNK_SIZE);
    var _origin_chunk_key = string(_origin_chunk_x) + "_" + string(_origin_chunk_y);
    var _origin_chunk_filepath = _world.filepath + "/chunks/chunk_" + _origin_chunk_key;
    var _rooms_filepath  = _origin_chunk_filepath + "/rooms";
	
	var _room_key  = string(_room_found_x) + "_" + string(_room_found_y);
    var _room_filepath = _rooms_filepath + "/room_" + _room_key + ".bin";
	
	if !file_exists(_room_filepath) {
        return undefined;
    }
	
	var _room_buffer = buffer_load(_room_filepath);
    var _room = room_data_get_from_buffer(_room_buffer);
    buffer_delete(_room_buffer);

    return _room;
}

function world_set_room_to_disk(_world, _room_data) {
	// Determine which chunks the room overlaps
	var _chunk_x_min = floor(_room_data.x / CHUNK_SIZE);
	var _chunk_x_max = floor((_room_data.x + _room_data.width - 1) / CHUNK_SIZE);
	var _chunk_y_min = floor(_room_data.y / CHUNK_SIZE);
	var _chunk_y_max = floor((_room_data.y + _room_data.height - 1) / CHUNK_SIZE);
	// For each overlapping chunk, update rooms.bounds
	for (var _chunk_x = _chunk_x_min; _chunk_x <= _chunk_x_max; _chunk_x++) {
		for (var _chunk_y = _chunk_y_min; _chunk_y <= _chunk_y_max; _chunk_y++) {
			var _chunk_key  = string(_chunk_x) + "_" + string(_chunk_y);
            var _chunk_filepath = _world.filepath + "/chunks/chunk_" + _chunk_key;
            var _rooms_bounds_filepath = _chunk_filepath + "/rooms.bounds";
			
			// Ensure chunk directory exists
            if !directory_exists(_chunk_filepath) {
                directory_create(_chunk_filepath);
            }
			
			// Load or create buffer
            var _buffer = undefined;
            if file_exists(_rooms_bounds_filepath) {
                _buffer = buffer_load(_rooms_bounds_filepath);
                buffer_seek(_buffer, buffer_seek_end, 0);
            } else {
                _buffer = buffer_create(0, buffer_grow, 1);
            }
			
			// Append absolute room coordinates
            buffer_write(_buffer, buffer_s32, _room_data.x);
            buffer_write(_buffer, buffer_s32, _room_data.y);
            buffer_write(_buffer, buffer_s32, _room_data.width);
            buffer_write(_buffer, buffer_s32, _room_data.height);
			
			// Save + cleanup
            buffer_save(_buffer, _rooms_bounds_filepath);
            buffer_delete(_buffer);
		}
	}
	// Save the actual room data into the chunk containing its origin
    var _origin_chunk_x = floor(_room_data.x / CHUNK_SIZE);
    var _origin_chunk_y = floor(_room_data.y / CHUNK_SIZE);
    var _origin_chunk_key = string(_origin_chunk_x) + "_" + string(_origin_chunk_y);
    var _origin_chunk_filepath = _world.filepath + "/chunks/chunk_" + _origin_chunk_key;
    var _rooms_filepath = _origin_chunk_filepath + "/rooms";

    // Ensure rooms/ subdirectory exists
    if !directory_exists(_rooms_filepath) {
        directory_create(_rooms_filepath);
    }
	
	var _room_key = string(_room_data.x) + "_" + string(_room_data.y);
    var _room_filepath = _rooms_filepath + "/room_" + _room_key + ".bin";

    var _room_buffer = room_data_get_buffer(_room_data);
    buffer_save(_room_buffer, _room_filepath);
    buffer_delete(_room_buffer);
}