world = noone;

game_create_world("test_world", 0);
game_load_world(self, "test_world");

world_load_room(world, 1000, 0);
world_instantiate_room(world, 1000, 0);