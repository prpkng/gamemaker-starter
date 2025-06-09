if keyboard_check_pressed(vk_backtick) {
    is_enabled = !is_enabled;
    
    InputPlayerSetGhost(is_enabled);
}

if !is_enabled { exit; }

if keyboard_check_pressed(vk_tab) {
    var _completion = "";
    for (var i = 0; i < array_length(global.commands); i++) {
        var _cmd = global.commands[i].name;
        if string_count(input_text, _cmd) > 0 {
         	_completion = _cmd;
        }
    }
    if _completion != "" { input_text = _completion; }
}

handle_basic_input_box();