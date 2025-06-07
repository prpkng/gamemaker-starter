var _targetX = xstart;
var _targetY = ystart;

if moveX {
    _targetX = xstart + cos(counter * rotSpeed / 60) * rotRange;
}
_targetY = ystart + sin(counter * rotSpeed / 60) * rotRange;

yspd = _targetY - y;
xspd = _targetX - x;
x = _targetX;
y = _targetY;

counter++;