
if !is_enabled { exit; }

// DRAW BG
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(0, 0, window_get_width(), 400, false);

var cur_y = 360;

for (var i = array_length(buffered_lines)-1; i>=0; i--) {
    var buffer_txt = scribble(buffered_lines[i]);
    buffer_txt = buffer_txt.wrap(window_get_width()/2.0, 300);
    cur_y -= buffer_txt.get_height();
    buffer_txt.draw(6, cur_y);	
}


// DRAW FRAME
draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(3, 360, window_get_width()-4, 390, true);
draw_rectangle(4, 361, window_get_width()-3, 391, true);

// DRAW INPUT TEXT
var txt = scribble(input_text);
txt.draw(8, 363);

// DRAW BAR

if sin(current_time / 100.0) > 0 {
    draw_rectangle(8 + 2 + txt.get_width(),365, 8 + 2 + txt.get_width() + 2, 385, false);
}

