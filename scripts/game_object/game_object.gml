function game_create_and_load_world(_game, _world_id, _world_seed) {
	// Initialize world data and world object
	var _world_data = new WorldData(_world_id, _world_seed);
	var _world = instance_create_layer(0, 0, "World", obj_world);
	// Initialize references
	_world.data = _world_data;
	_game.data.world = _world_data;
	current_world = _world;
}

function game_load_world(_game, _world_id) {
	// TODO
}

function game_unload_world(_game) {
	var _world = _game.current_world;
	_game.current_world = noone;
	instance_destroy(_world);
	_game.data.world = undefined;
}

/*
game_unload_world
game_load_world
game_save
game_delete_world
game_pause
game_unpause
