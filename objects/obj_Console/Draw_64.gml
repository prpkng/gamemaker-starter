var _width = display_get_gui_width();
var _height = display_get_gui_height()/2;

if !is_enabled { exit; }

// DRAW BG
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(0, 0, _width, _height, false);

var cur_y = _height - 34;

for (var i = array_length(buffered_lines)-1; i>=0; i--) {
    var buffer_txt = scribble("[fnt_Monogram][scale,2]"+buffered_lines[i]);
    buffer_txt = buffer_txt.wrap(window_get_width()/2.0, 300);
    cur_y -= buffer_txt.get_height();
    buffer_txt.draw(8, cur_y);	
}


// DRAW FRAME
draw_set_alpha(1);
draw_set_color(c_white);

draw_rectangle_lines(2, _height-28, _width-2, _height-2, 2, c_white);
//draw_rectangle(4, 361, window_get_width()-3, 391, true);


// DRAW COMPLETION
if string_length(input_text) > 0 {
    var _completion = "";
    for (var i = 0; i < array_length(global.commands); i++) {
        var _cmd = global.commands[i].name;
        if string_count(input_text, _cmd) > 0 {
         	_completion = _cmd;
        }
    }

    draw_text_scribble(10, _height-29, "[c_gray][fnt_Monogram][scale,2]"+_completion);

}



// DRAW INPUT TEXT
var txt = scribble("[fnt_Monogram][scale,2]"+input_text);
//var txt = scribble(input_text);
txt.draw(10, _height-29);


// DRAW BAR

if sin(current_time / 100.0) > 0 {
    draw_rectangle(8 + 2 + txt.get_width(),_height-23, 8 + 2 + txt.get_width() + 1, _height-6, false);
}

