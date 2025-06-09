/// @desc Draws a rectangle using lines with width
/// @param {Real} x1
/// @param {Real} y1
/// @param {Real} x2
/// @param {Real} y2
/// @param {Real} width
/// @param {Constant.Color} [color]
function draw_rectangle_lines(x1, y1, x2, y2, width, color = c_white) {
    draw_set_color(color);
    var _hw = width/2;
    draw_line_width(x1, y1-_hw, x1, y2+_hw, width);
    draw_line_width(x1-_hw, y1, x2+_hw, y1, width);
    draw_line_width(x2, y1-_hw, x2, y2+_hw, width);
    draw_line_width(x1-_hw, y2, x2+_hw, y2, width);
}