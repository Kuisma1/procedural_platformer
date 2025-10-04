function world_get_rectangle(_world, _subroom_x, _subroom_y) {
	return get_rectangle(_subroom_x, _subroom_y, _world.seed);
}

function world_get_door_directions(_world, _subroom_x, _subroom_y) {
    var _doors = {};
    var _h1 = hash2(_subroom_x, _subroom_y);
    var _directions = [{name: "right", dx: 1, dy: 0},
					   {name: "left", dx: -1, dy: 0},
					   {name: "down", dx: 0, dy: 1},
					   {name: "up", dx: 0, dy: -1}];
    for (var i = 0; i < array_length(_directions); i++) {
        var _direction = _directions[i];
        var _h2 = hash2(_subroom_x + _direction.dx, _subroom_y + _direction.dy);
        var _combined = hash3(min(_h1, _h2), max(_h1, _h2), _world.seed);
        struct_set(_doors, _direction.name, hash_to_random01(_combined) < 0.3);
    }
    return _doors;
}

function world_get_biome(_world, _subroom_x, _subroom_y) { // Placeholder
	return perlin2D(_subroom_x, _subroom_y, 30, _world.seed) > 0.5 ? BIOME.CAVERNS : BIOME.LUSH_CAVES;
}