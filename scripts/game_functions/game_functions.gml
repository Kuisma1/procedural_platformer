function game_create_world(_id, _seed) {
	var _world_filepath = "worlds/" + _id;
	if directory_exists(_world_filepath) {
		show_debug_message("Tried to create world with id: " + _id + ", but a world with the given id already existed.");
	} else {
		var _seed_buffer = buffer_create(buffer_sizeof(buffer_s32), buffer_fixed, 1);
		buffer_write(_seed_buffer, buffer_s32, _seed);
		var _seed_filepath = _world_filepath + "/seed.bin";
		buffer_save(_seed_buffer, _seed_filepath);
		buffer_delete(_seed_buffer);
		var _chunks_filepath = _world_filepath + "/chunks";
		directory_create(_chunks_filepath);
		show_debug_message("New world with id: " + _id + " was created on disk");
	}
}

function game_delete_world(_id) {
	var _world_filepath = "worlds/" + _id;
	if directory_exists(_world_filepath) {
		directory_destroy(_world_filepath);
		show_debug_message("World with id: " + _id + " was deleted from the disk.");
	} else {
		show_debug_message("Tried to remove world with id: " + _id + ", but no world with that id existed.");
	}
}

function game_load_world(_game, _id) {
	var _world_filepath = "worlds/" + _id;
	if directory_exists(_world_filepath) {
		// Read seed from disk
		var _seed_filepath = + _world_filepath + "/seed.bin";
		var _seed_buffer = buffer_load(_seed_filepath);
		var _seed = buffer_read(_seed_buffer, buffer_s32);
		buffer_delete(_seed_buffer);
		// Create world object and initialize its variables
		var _world = instance_create_layer(0, 0, "World", obj_world);
		_world.seed = _seed;
		_world.rooms = {};
		_world.instantiated_room = noone;
		_world.filepath = _world_filepath;
		_world.game = _game;
		// World initial actions
		world_load_room(_world, 0, 0);
		world_instantiate_room(_world, 0, 0);
		// Store world to game
		_game.world = _world;
		show_debug_message("World with id: " + _id + " loaded successfully.");
	} else {
		show_debug_message("World with id: " + _id + " doesn't exist.");
	}
}

function game_save_world(_game) {
	world_save_rooms(_game.world);
	show_debug_message("Current world saved.");
}

function game_unload_world(_game) {
	game_save_world(_game);
	instance_destroy(_game.world);
	_game.world = noone;
	show_debug_message("Current world unloaded.");
}