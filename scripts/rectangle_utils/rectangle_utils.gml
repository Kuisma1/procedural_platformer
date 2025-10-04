function Rectangle(_x, _y, _width, _height) constructor {
	x = _x;
	y = _y;
	width = _width;
	height = _height;
}

function get_rectangle(_x, _y, _seed) {
	var _line_cluster = get_line_cluster(_x, _y, _seed);
	expand_lines(_line_cluster);
	var _rectangle = find_rectangle(_line_cluster, _x, _y);
	return _rectangle;
}

function rectangle_difference(_rect1, _rect2) {
    // Compute intersection
    var _ix1 = max(_rect1.x, _rect2.x);
    var _iy1 = max(_rect1.y, _rect2.y);
    var _ix2 = min(_rect1.x + _rect1.width, _rect2.x + _rect2.width);
    var _iy2 = min(_rect1.y + _rect1.height, _rect2.y + _rect2.height);
    // If no overlap, return recA as is
    if (_ix1 >= _ix2 || _iy1 >= _iy2) {
        return [_rect1];
    }
    var _result = [];
    // Left strip
    if (_rect1.x < _ix1) {
        array_push(_result, new Rectangle(_rect1.x, _rect1.y, _ix1 - _rect1.x, _rect1.height));
    }
    // Right strip
    if (_ix2 < _rect1.x + _rect1.width) {
        array_push(_result, new Rectangle(_ix2, _rect1.y, (_rect1.x + _rect1.width) - _ix2, _rect1.height));
    }
    // Top strip
    if (_rect1.y < _iy1) {
        array_push(_result, new Rectangle(_ix1, _rect1.y, _ix2 - _ix1, _iy1 - _rect1.y));
    }
    // Bottom strip
    if (_iy2 < _rect1.y + _rect1.height) {
        array_push(_result, new Rectangle(_ix1, _iy2, _ix2 - _ix1, (_rect1.y + _rect1.height) - _iy2));
    }
    return _result;
}

function rectangles_difference(_rects1, _rects2) {
    var _results = [];
	
	var _count1 = array_length(_rects1);
	for (var _i = 0; _i < _count1; _i++) {
		var _rooms_to_process = [_rects1[_i]];
		var _count2 = array_length(_rects2);
		
		for (var _j = 0; _j < _count2; _j++) {
			var _new_rooms = [];
			for (var _k = 0; _k < array_length(_rooms_to_process); _k++) {
				_new_rooms = array_concat(_new_rooms, rectangle_difference(_rooms_to_process[_k], _rects2[_j]));
			}
			_rooms_to_process = _new_rooms;
		}
		_results = array_concat(_results, _rooms_to_process);
	}
	return _results;
}

function get_overlapping_rectangles(_rects, _seed) {
	var _overlapping_rects = [];
	for (var _i = 0; _i < array_length(_rects); _i++) {
		var _rect = _rects[_i];
		for (var _x = _rect.x; _x < _rect.x + _rect.width; _x++) {
			for (var _y = _rect.y; _y < _rect.y + _rect.height; _y++) {
				var _candidate_to_add = get_rectangle(_x, _y, _seed);
				var _added = false;
				for (var _j = 0; _j < array_length(_overlapping_rects); _j++) {
					var _candidate_to_check = _overlapping_rects[_j];
					if (_candidate_to_add.x == _candidate_to_check.x 
					 && _candidate_to_add.y == _candidate_to_check.y) {
						_added = true;
						break;
					}
				}
				if (!_added) {
					array_push(_overlapping_rects, _candidate_to_add);
				}
			}
		}
	}
	return _overlapping_rects;
}