for (var _subroom_x = 0; _subroom_x < data.width; _subroom_x++) {
	for (var _subroom_y = 0; _subroom_y < data.height; _subroom_y++) {
		var _subroom = subrooms[_subroom_x][_subroom_y];
		instance_destroy(_subroom);
	}
}