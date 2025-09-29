var _right = keyboard_check(ord("D"));
var _left = keyboard_check(ord("A"));
var _jump = keyboard_check_pressed(vk_space);
var _jump_released = keyboard_check_released(vk_space);

h_speed = walk_speed * (_right - _left);

var _grav = v_speed < 0 ? jump_acceleration : fall_acceleration;

v_speed += _grav;

if _jump && place_meeting(x, y + 1, obj_tile) {
	v_speed = -15;
}

if _jump_released && v_speed < 0 {
	v_speed = v_speed / 5;
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

y += v_speed;
x += h_speed;