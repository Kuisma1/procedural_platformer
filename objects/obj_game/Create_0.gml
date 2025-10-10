#macro SUBROOM_PIXEL_SIZE 32

world = new World(0);

world_load_room(world, 0, 0);

current_room = world_get_room(world, 0, 0);

instantiate_room(current_room);