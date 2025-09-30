if !is_undefined(structure) {
	var _room_count = array_length(structure);
	for (var _i = 0; _i < _room_count; _i++) {
		var _room = structure[_i];
		draw_set_color(c_orange);
		draw_rectangle(SUBROOM_PIXEL_SIZE * _room.x, 
					   SUBROOM_PIXEL_SIZE * _room.y, 
					   SUBROOM_PIXEL_SIZE * (_room.x + _room.width) - 1, 
					   SUBROOM_PIXEL_SIZE * (_room.y + _room.height) - 1, 
					   false);
		draw_set_color(c_red);
		draw_rectangle(SUBROOM_PIXEL_SIZE * _room.x, 
					   SUBROOM_PIXEL_SIZE * _room.y, 
					   SUBROOM_PIXEL_SIZE * (_room.x + _room.width) - 1, 
					   SUBROOM_PIXEL_SIZE * (_room.y + _room.height) - 1, 
					   true);
	}
}

if !is_undefined(affected) {
	var _room_count = array_length(affected);
	for (var _i = 0; _i < _room_count; _i++) {
		var _room = affected[_i];
		draw_set_color(c_lime);
		draw_rectangle(SUBROOM_PIXEL_SIZE * _room.x, 
					   SUBROOM_PIXEL_SIZE * _room.y, 
					   SUBROOM_PIXEL_SIZE * (_room.x + _room.width) - 1, 
					   SUBROOM_PIXEL_SIZE * (_room.y + _room.height) - 1, 
					   false);
		draw_set_color(c_green);
		draw_rectangle(SUBROOM_PIXEL_SIZE * _room.x, 
					   SUBROOM_PIXEL_SIZE * _room.y, 
					   SUBROOM_PIXEL_SIZE * (_room.x + _room.width) - 1, 
					   SUBROOM_PIXEL_SIZE * (_room.y + _room.height) - 1, 
					   true);
	}
}

if !is_undefined(structure) && !is_undefined(affected) {
	var _rooms = array_concat(structure, affected);
	for (var _i = 0; _i < array_length(_rooms); _i++) {
		var _room = _rooms[_i];
		for (var _x = _room.x; _x < _room.x + _room.width; _x++) {
			for (var _y = _room.y; _y < _room.y + _room.height; _y++) {
				var _doors = world_get_door_directions(world, _x, _y);
				if _doors.right {
					draw_set_color(c_red);
					draw_line_width(SUBROOM_PIXEL_SIZE * (_x + 0.75), 
									SUBROOM_PIXEL_SIZE * (_y + 0.5),
									SUBROOM_PIXEL_SIZE * (_x + 1.25),
									SUBROOM_PIXEL_SIZE * (_y + 0.5),
									2);
				}
				if _doors.left {
					draw_set_color(c_red);
					draw_line_width(SUBROOM_PIXEL_SIZE * (_x - 0.25), 
									SUBROOM_PIXEL_SIZE * (_y + 0.5),
									SUBROOM_PIXEL_SIZE * (_x + 0.25),
									SUBROOM_PIXEL_SIZE * (_y + 0.5),
									2);
				}
				if _doors.down {
					draw_set_color(c_red);
					draw_line_width(SUBROOM_PIXEL_SIZE * (_x + 0.5), 
									SUBROOM_PIXEL_SIZE * (_y + 0.75),
									SUBROOM_PIXEL_SIZE * (_x + 0.5),
									SUBROOM_PIXEL_SIZE * (_y + 1.25),
									2);
				}
				if _doors.up {
					draw_set_color(c_red);
					draw_line_width(SUBROOM_PIXEL_SIZE * (_x + 0.5), 
									SUBROOM_PIXEL_SIZE * (_y + - 0.25),
									SUBROOM_PIXEL_SIZE * (_x + 0.5),
									SUBROOM_PIXEL_SIZE * (_y + 0.25),
									2);
				}
			}
		}
	}
}
