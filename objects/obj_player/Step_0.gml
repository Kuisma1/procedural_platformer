var _right = keyboard_check(ord("D"));
var _left = keyboard_check(ord("A"));
var _jump = keyboard_check_pressed(vk_space);
var _jump_released = keyboard_check_released(vk_space);

h_speed = walk_speed * (_right - _left);

var _acceleration = v_speed < 0 ? jump_acceleration : fall_acceleration;

v_speed += _acceleration;

if _jump {
	v_speed = -jump_speed;
}

if _jump_released && v_speed < 0 {
	v_speed *= 0.5;
}

if place_meeting(x + h_speed, y, obj_tile) {
	while !place_meeting(x + sign(h_speed), y, obj_tile) {
		x += sign(h_speed);
	}
	h_speed = 0;
}

if place_meeting(x, y + v_speed, obj_tile) {
	while !place_meeting(x, y + sign(v_speed), obj_tile) {
		y += sign(v_speed);
	}
	v_speed = 0;
}

x += h_speed;
y += v_speed;