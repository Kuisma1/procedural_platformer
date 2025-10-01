/// @desc This function returns the room at the given subroom point according to the seed of the given world.
/// @param {Struct.World} _world The world to use the seed of
/// @param {Real} _subroom_x The x-coordinate of the subroom point to generate the room at
/// @param {Real} _subroom_y The y-coordinate of the subroom point to generate the room at
function generate_room(_world, _subroom_x, _subroom_y) {
	return world_get_candidate_room(_world, _subroom_x, _subroom_y);
}

/// @desc This function returns a structure of the given structure type at the given subroom coordinates according to the seed of the given world.
/// @param {Struct.World} _world The world to use the seed of
/// @param {Real} _subroom_x The x-coordinate of the subroom point to generate the structure at
/// @param {Real} _subroom_y The y-coordinate of the subroom point to generate the structure at
/// @param {Real} _structure_type The type of structure to generate
/// @return {Array<Struct.Room>}
function generate_structure(_world, _subroom_x, _subroom_y, _structure_type) {
	if _structure_type == STRUCTURE.STRONGHOLD {
		var _rooms = [new Room(_subroom_x - 2, _subroom_y - 2, 5, 5)];
		
		var _affected = rooms_difference(world_get_overlapping_candidate_rooms(_world, _rooms), _rooms);
		var _all_rooms = array_concat(_rooms, _affected);
		return _all_rooms;
	}
}