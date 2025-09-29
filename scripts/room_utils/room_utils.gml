function Room(_x, _y, _width, _height) constructor {
	x = _x;
	y = _y;
	width = _width;
	height = _height;
}

function room_difference(_room1, _room2) {
    // Compute intersection
    var _ix1 = max(_room1.x, _room2.x);
    var _iy1 = max(_room1.y, _room2.y);
    var _ix2 = min(_room1.x + _room1.width, _room2.x + _room2.width);
    var _iy2 = min(_room1.y + _room1.height, _room2.y + _room2.height);
    // If no overlap, return recA as is
    if (_ix1 >= _ix2 || _iy1 >= _iy2) {
        return [_room1];
    }
    var _result = [];
    // Left strip
    if (_room1.x < _ix1) {
        array_push(_result, new Room(_room1.x, _room1.y, _ix1 - _room1.x, _room1.height));
    }
    // Right strip
    if (_ix2 < _room1.x + _room1.width) {
        array_push(_result, new Room(_ix2, _room1.y, (_room1.x + _room1.width) - _ix2, _room1.height));
    }
    // Top strip
    if (_room1.y < _iy1) {
        array_push(_result, new Room(_ix1, _room1.y, _ix2 - _ix1, _iy1 - _room1.y));
    }
    // Bottom strip
    if (_iy2 < _room1.y + _room1.height) {
        array_push(_result, new Room(_ix1, _iy2, _ix2 - _ix1, (_room1.y + _room1.height) - _iy2));
    }
    return _result;
}

function rooms_difference(_rooms1, _rooms2) {
    var _results = [];
	
	var _count1 = array_length(_rooms1);
	for (var _i = 0; _i < _count1; _i++) {
		var _rooms_to_process = [_rooms1[_i]];
		var _count2 = array_length(_rooms2);
		
		for (var _j = 0; _j < _count2; _j++) {
			var _new_rooms = [];
			for (var _k = 0; _k < array_length(_rooms_to_process); _k++) {
				_new_rooms = array_concat(_new_rooms, room_difference(_rooms_to_process[_k], _rooms2[_j]));
			}
			_rooms_to_process = _new_rooms;
		}
		_results = array_concat(_results, _rooms_to_process);
	}
	return _results;
}