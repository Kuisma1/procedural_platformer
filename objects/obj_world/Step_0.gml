if mouse_check_button_pressed(mb_left) {
	var _subroom_x = floor(mouse_x / SUBROOM_SIZE);
	var _subroom_y = floor(mouse_y / SUBROOM_SIZE);
	load_room(world, _subroom_x, _subroom_y);
}

if mouse_check_button_pressed(mb_right) {
	var _subroom_x = floor(mouse_x / SUBROOM_SIZE);
	var _subroom_y = floor(mouse_y / SUBROOM_SIZE);
	unload_room(world, _subroom_x, _subroom_y);
}