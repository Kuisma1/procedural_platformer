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