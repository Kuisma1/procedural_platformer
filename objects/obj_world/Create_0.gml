var _world = new World(0);

var _example_structure = [
    new Room(0, 0, 5, 5),
    new Room(6, 0, 4, 4)
];

var _overlapping_candidates = world_get_overlapping_candidate_rooms(_world, _example_structure);
var _affected = rooms_difference(_overlapping_candidates, _example_structure);
show_debug_message("Affected: " + string(_affected));