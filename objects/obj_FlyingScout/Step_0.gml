var _left = keyboard_check(vk_left);
var _right = keyboard_check(vk_right);
var _up = keyboard_check(vk_up);
var _down = keyboard_check(vk_down);

var _xdir = _right - _left;
var _ydir = _down - _up;

var _spd = keyboard_check(vk_shift) ? moveSpeed * 2 :moveSpeed

xspd = lerp(xspd, _xdir * _spd, 0.25);
yspd = lerp(yspd, _ydir * _spd, 0.25);


x += xspd;
y += yspd;