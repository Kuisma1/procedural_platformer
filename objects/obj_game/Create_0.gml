world = noone;

game_delete_world("test_world")
game_create_world("test_world", 0);
game_load_world(self, "test_world");

world_load_room(world, 0, 0);

var _room = world_get_room(world, 0, 0);
show_debug_message(_room);

world_unload_room(world, 0, 0);