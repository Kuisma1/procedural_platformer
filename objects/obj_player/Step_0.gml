var _right = keyboard_check(ord("D"));
var _left = keyboard_check(ord("A"));
var _down = keyboard_check(ord("S"));
var _up = keyboard_check(ord("W"));

var _moving = _right || _left || _down || _up;
var _move_dir = _moving ? point_direction(0, 0, _right - _left, _down - _up) : undefined;

if !is_undefined(_move_dir) {
	h_speed = lengthdir_x(move_speed, _move_dir);
	v_speed = lengthdir_y(move_speed, _move_dir);
} else {
	h_speed = 0;
	v_speed = 0;
}

x += h_speed;
y += v_speed;