if mouse_check_button_pressed(mb_left) {
	var _subroom_x = floor(mouse_x / SUBROOM_PIXEL_SIZE);
	var _subroom_y = floor(mouse_y / SUBROOM_PIXEL_SIZE);
	structure = [new Room(_subroom_x - 2, _subroom_y - 2, 5, 5),
				 new Room(_subroom_x + 3, _subroom_y, 3, 3)];
	var _overlapping_candidates = world_get_overlapping_candidate_rooms(world, structure);
	affected = rooms_difference(_overlapping_candidates, structure);
}

// A change example