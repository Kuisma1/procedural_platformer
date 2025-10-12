/// @desc Constructor for the world struct
/// @param {Real} _seed The world seed
function World(_seed) constructor {
	seed = _seed;
	rooms = {};
	rooms_list = [];
}

/// @desc This function sets the given room to the given world (in memory).
/// @param {Struct.World} _world The world to set the room in
/// @param {Struct.Room} _room The room to set
/// @return {Undefined}
function world_set_room(_world, _room) {
	for (var _x = _room.x; _x < _room.x + _room.width; _x++) {
		for (var _y = _room.y; _y < _room.y + _room.height; _y++) {
			var _subroom_key = string(_x) + "_" + string(_y);
			_world.rooms[$ _subroom_key] = _room;
		}
	}
	array_push(_world.rooms_list, _room);
}

/// @desc This function sets the given rooms to the given world (in memory).
/// @param {Struct.World} _world The world to set the room in
/// @param {Array<Struct.Room>} _rooms The rooms to set
/// @return {Undefined}
function world_set_rooms(_world, _rooms) {
	for (var _i = 0; _i < array_length(_rooms); _i++) {
		world_set_room(_world, _rooms[_i]);
	}
}

/// @desc This function returns the room in the given world at the given subroom point.
/// @param {Struct.World} _world The world to get the room from
/// @param {Real} _subroom_x The x-coordinate of the subroom point
/// @param {Real} _subroom_y The y-coordinate of the subroom point
/// @return {Struct.Room}
function world_get_room(_world, _subroom_x, _subroom_y) {
	var _subroom_key = string(_subroom_x) + "_" + string(_subroom_y);
	return struct_get(_world.rooms, _subroom_key);
}

/// @desc This function removes the room at the given subroom point in the given world.
/// @param {Struct.World} _world The world to remove the room from
/// @param {Real} _subroom_x The x-coordinate of the subroom point
/// @param {Real} _subroom_y The y-coordinate of the subroom point
/// @return {Undefined}
function world_remove_room(_world, _subroom_x, _subroom_y) {
	if !world_room_exists(_world, _subroom_x, _subroom_y) return;
	var _room = world_get_room(_world, _subroom_x, _subroom_y);
	for (var _x = _room.x; _x < _room.x + _room.width; _x++) {
		for (var _y = _room.y; _y < _room.y + _room.height; _y++) {
			var _subroom_key = string(_x) + "_" + string(_y);
			struct_remove(_world.rooms, _subroom_key);
		}
	}
	array_delete(_world.rooms_list, array_get_index(_world.rooms_list, _room), 1);
}

/// @desc This function returns true if a room exists in the given world at the given subroom point, false otherwise.
/// @param {Struct.World} _world The world to check
/// @param {Real} _subroom_x The x-coordinate of the subroom point
/// @param {Real} _subroom_y The y-coordinate of the subroom point
/// @return {Bool}
function world_room_exists(_world, _subroom_x, _subroom_y) {
	var _subroom_key = string(_subroom_x) + "_" + string(_subroom_y);
	return !is_undefined(struct_get(_world.rooms, _subroom_key));
}