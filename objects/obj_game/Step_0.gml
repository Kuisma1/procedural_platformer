if keyboard_check_pressed(vk_space) {
	if current_world == noone {
		game_create_and_load_world(self, "test_world", 0);
	} else {
		game_unload_world(self);
	}
}