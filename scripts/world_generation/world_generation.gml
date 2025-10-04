/// @desc This function returns the room at the given subroom point according to the seed of the given world.
/// @param {Struct.World} _world The world to use the seed of
/// @param {Real} _subroom_x The x-coordinate of the subroom point to generate the room at
/// @param {Real} _subroom_y The y-coordinate of the subroom point to generate the room at
function world_generate_room(_world, _subroom_x, _subroom_y) {
	var _rect = world_get_rectangle(_world, _subroom_x, _subroom_y);
	var _biome = world_get_biome(_world, _subroom_x, _subroom_y);
	var _structure = STRUCTURE.NONE;
	var _room = new Room(_rect.x, _rect.y, _rect.width, _rect.height, _biome, _structure);
	return _room;
}

/// @desc This function returns a structure of the given structure type at the given subroom coordinates according to the seed of the given world.
/// @param {Struct.World} _world The world to use the seed of
/// @param {Real} _subroom_x The x-coordinate of the subroom point to generate the structure at
/// @param {Real} _subroom_y The y-coordinate of the subroom point to generate the structure at
/// @param {Real} _structure_type The type of structure to generate
/// @return {Array<Struct.Room>}
function world_generate_structure(_world, _subroom_x, _subroom_y, _structure_type) {
	if _structure_type == STRUCTURE.STRONGHOLD {
		var _biome = world_get_biome(_world, _subroom_x, _subroom_y);
		
		var _rooms = [new Room(_subroom_x - 3, _subroom_y - 3, 7, 7, _biome, STRUCTURE.STRONGHOLD),
				      new Room(_subroom_x + 4, _subroom_y, 4, 4, _biome, STRUCTURE.STRONGHOLD)];
		
		var _affected_rects = rectangles_difference(get_overlapping_rectangles(_rooms, _world.seed), _rooms);
		for (var _i = 0; _i < array_length(_affected_rects); _i++) {
			var _rect = _affected_rects[_i];
			array_push(_rooms, new Room(_rect.x, _rect.y, _rect.width, _rect.height, _biome, STRUCTURE.NONE));
		}
		return _rooms;
	}
}