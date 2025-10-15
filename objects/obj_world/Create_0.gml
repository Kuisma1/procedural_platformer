data = new WorldData(, 111);

world_data_clear_disk(data);

show_debug_message("START --------------------------------------");
world_load_room(self, 0, 0);
world_load_room(self, 0, 0);
world_unload_room(self, 0, 0);

world_unload_room(self, 10, 0);