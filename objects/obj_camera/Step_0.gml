var _right = keyboard_check(ord("D"));
var _left = keyboard_check(ord("A"));
var _down = keyboard_check(ord("S"));
var _up = keyboard_check(ord("W"));

h_speed = move_speed * (_right - _left);
v_speed = move_speed * (_down - _up);

x += h_speed;
y += v_speed;

x = clamp(x, 32, room_width - 32);
y = clamp(y, 32, room_height - 32);