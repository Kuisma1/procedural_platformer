draw_set_color(c_white);
for (var _i = 0; _i < array_length(world.rooms_list); _i++) {
	var _room = world.rooms_list[_i];
	
	draw_rectangle(SUBROOM_SIZE * _room.x, 
				   SUBROOM_SIZE * _room.y, 
				   SUBROOM_SIZE * (_room.x + _room.width) - 1,
				   SUBROOM_SIZE * (_room.y + _room.height) - 1, 
				   true);
}

draw_set_color(c_lime);
draw_text(0, 0, string(floor(mouse_x / SUBROOM_SIZE)) + ", " + string(floor(mouse_y / SUBROOM_SIZE)));