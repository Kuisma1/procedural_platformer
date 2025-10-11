if mouse_check_button(mb_left) {
	var _subroom_x = floor(mouse_x / SUBROOM_SIZE);
	var _subroom_y = floor(mouse_y / SUBROOM_SIZE);
	world_load_room(world, _subroom_x, _subroom_y);
}

if mouse_check_button(mb_right) {
	var _subroom_x = floor(mouse_x / SUBROOM_SIZE);
	var _subroom_y = floor(mouse_y / SUBROOM_SIZE);
	world_unload_room(world, _subroom_x, _subroom_y);
}

if keyboard_check_pressed(vk_space) {
	var _subroom_x = floor(mouse_x / SUBROOM_SIZE);
	var _subroom_y = floor(mouse_y / SUBROOM_SIZE);
	var _room = world_get_room(world, _subroom_x, _subroom_y);
	show_debug_message("Room: " + string(_room));
}