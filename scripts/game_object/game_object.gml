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
	if !directory_exists(_world_filepath) {
		// Initialize world data
		var _seed_filepath = + _world_filepath + "/seed.bin";
		var _seed_buffer = buffer_load(_seed_filepath);
		var _seed = buffer_read(_seed_buffer, buffer_s32);
		buffer_delete(_seed_buffer);
		var _world = instance_create_layer(0, 0, "World", obj_world);
		_world.seed = _seed;
		_world.rooms = {};
		_game.world = _world;
		// Load and instantiate first room
		// -- TODO --
		show_debug_message("World with id: " + _id + " loaded successfully.");
	} else {
		show_debug_message("World with id: " + _id + " doesn't exist.");
	}
}

function game_save_world(_game) {
	// save loaded rooms, the player and world metadata to disk
	// -- TODO --
}

function game_unload_world(_game) {
	// Save the world and then remove it from memory
	// -- TODO --
}