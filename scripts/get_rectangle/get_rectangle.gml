#macro GEN_CHUNK_WIDTH 3
#macro GEN_CHUNK_HEIGHT 3
#macro CLUSTER_CHUNK_RADIUS 2

function Line(_horizontal, _pos, _start, _end) constructor {
	horizontal = _horizontal;
	if _horizontal {
		y = _pos;
		x1 = _start;
		x2 = _end;
	} else {
		x = _pos;
		y1 = _start;
		y2 = _end;
	}
}

function pos_in_line(_x, _y, _line) {
    if (_line.horizontal) {
        return (_y == _line.y) && (_x >= _line.x1) && (_x <= _line.x2);
    } else {
        return (_x == _line.x) && (_y >= _line.y1) && (_y <= _line.y2);
    }
}

function pos_in_lines(_x, _y, _lines) {
    var _len = array_length(_lines);
    for (var i = 0; i < _len; i++) {
        if pos_in_line(_x, _y, _lines[i]) {
            return true;
        }
    }
    return false;
}

function LineCluster(_min_x, _min_y, _max_x, _max_y, _lines) constructor {
	min_x = _min_x;
	min_y = _min_y;
	max_x = _max_x;
	max_y = _max_y;
	lines = _lines;
}

function get_line_cluster(_x, _y, _seed) {
	var _cx = floor(_x / GEN_CHUNK_WIDTH);
	var _cy = floor(_y / GEN_CHUNK_HEIGHT);
	var _lines = [];
	for (var _line_cx = _cx - CLUSTER_CHUNK_RADIUS; _line_cx <= _cx + CLUSTER_CHUNK_RADIUS; _line_cx++) {
		for (var _line_cy = _cy - CLUSTER_CHUNK_RADIUS; _line_cy <= _cy + CLUSTER_CHUNK_RADIUS; _line_cy++) {
			var _horizontal = (_line_cx + _line_cy) % 2 == 0;
			var _old_seed = random_get_seed();
			random_set_seed(hash3(_line_cx, _line_cy, _seed));
			var _pos = _horizontal ? _line_cy * GEN_CHUNK_HEIGHT + irandom_range(1, GEN_CHUNK_HEIGHT - 1) : _line_cx * GEN_CHUNK_WIDTH + irandom_range(1, GEN_CHUNK_WIDTH - 1);
			random_set_seed(_old_seed);
			var _start = _horizontal ? _line_cx * GEN_CHUNK_WIDTH : _line_cy * GEN_CHUNK_HEIGHT;
			var _end = _horizontal ? (_line_cx + 1) *GEN_CHUNK_WIDTH : (_line_cy + 1) * GEN_CHUNK_HEIGHT;
			var _line = new Line(_horizontal, _pos, _start, _end);
			array_push(_lines, _line);
		}
	}
	return new LineCluster((_cx - CLUSTER_CHUNK_RADIUS) * GEN_CHUNK_WIDTH, 
						   (_cy - CLUSTER_CHUNK_RADIUS) * GEN_CHUNK_HEIGHT,
						   (_cx + CLUSTER_CHUNK_RADIUS + 1) * GEN_CHUNK_WIDTH, 
						   (_cy + CLUSTER_CHUNK_RADIUS + 1) * GEN_CHUNK_HEIGHT,
						   _lines);
}

function expand_lines(_line_cluster) {
	var _lines = _line_cluster.lines;
	for (var _i = 0; _i < array_length(_lines); _i++) {
		var _line = _lines[_i];
		var _horizontal = _line.horizontal;
		if _horizontal {
			var _new_x1 = _line.x1;
			while !pos_in_lines(_new_x1 - 1, _line.y, _lines) && _new_x1 - 1 >= _line_cluster.min_x {
				_new_x1--;
			}
			_new_x1--;
			var _new_x2 = _line.x2;
			while !pos_in_lines(_new_x2 + 1, _line.y, _lines) && _new_x2 + 1 <= _line_cluster.max_x {
				_new_x2++;
			}
			_new_x2++;
			var _new_line = new Line(_horizontal, _line.y, _new_x1, _new_x2);
			_lines[_i] = _new_line;
		} else {
			var _new_y1 = _line.y1;
			while !pos_in_lines(_line.x, _new_y1 - 1, _lines) && _new_y1 - 1 >= _line_cluster.min_y {
				_new_y1--;
			}
			_new_y1--;
			var _new_y2 = _line.y2;
			while !pos_in_lines(_line.x, _new_y2 + 1, _lines) && _new_y2 + 1 <= _line_cluster.max_y {
				_new_y2++;
			}
			_new_y2++;
			var _new_line = new Line(_horizontal, _line.x, _new_y1, _new_y2);
			_lines[_i] = _new_line;
		}
	}
}

function Rectangle(_x, _y, _w, _h) constructor {
	x = _x;
	y = _y;
	w = _w;
	h = _h;
}

function find_rectangle(_line_cluster, _x, _y) {
	if pos_in_lines(_x, _y, _line_cluster.lines) {
		_x++;
		_y++;
	}
	
	while !pos_in_lines(_x - 1, _y, _line_cluster.lines) _x--;
	var _rect_x1 = _x - 1;
	while !pos_in_lines(_x, _y - 1, _line_cluster.lines) _y--;
	var _rect_y1 = _y - 1;
	while !pos_in_lines(_x + 1, _y, _line_cluster.lines) _x++;
	var _rect_x2 = _x;
	while !pos_in_lines(_x, _y + 1, _line_cluster.lines) _y++;
	var _rect_y2 = _y;
	var _rectangle = new Rectangle(_rect_x1, _rect_y1, _rect_x2 - _rect_x1 + 1, _rect_y2 - _rect_y1 + 1);
	return _rectangle;
}

function get_rectangle(_x, _y, _seed) {
	var _line_cluster = get_line_cluster(_x, _y, _seed);
	expand_lines(_line_cluster);
	var _rectangle = find_rectangle(_line_cluster, _x, _y);
	return _rectangle;
}