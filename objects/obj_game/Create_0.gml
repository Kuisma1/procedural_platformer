world = noone;

game_create_world("test_world", 0);
game_load_world(self, "test_world");

show_debug_message(world_get_room(world, 0, 0));
