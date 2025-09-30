function World(_seed) constructor {
	seed = _seed;
}

function Chunk() constructor {
	room_lookup = {};
	rooms = {};
}

function world_set_room(_world, _room) {
	var _min_chunk_x = floor(_room.x / CHUNK_SIZE);
}