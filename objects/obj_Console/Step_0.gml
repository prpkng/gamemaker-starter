if keyboard_check_pressed(vk_backtick) {
    is_enabled = !is_enabled;
    
    InputPlayerSetGhost(is_enabled);
}

if !is_enabled { exit; }

if keyboard_check_pressed(vk_up) {
    input_text = last_input;
}

if keyboard_check_pressed(vk_tab) {
    var _completion = "";
    for (var i = 0; i < array_length(global.commands); i++) {
        var _command = global.commands[i];
        var _texts = [_command.name];
        _texts = array_concat(_texts, _command.aliases);
        
        for (var j = 0; j < array_length(_texts); j++) {
            var _cmd = _texts[j];
            // Using this to ensure completion only from start of the word
            // (yes, it's kinda ugly and maybe I'll improve this later)
            if string_count("```"+input_text, "```"+_cmd) > 0 {
             	_completion = _cmd;
            }
        }
    }
    if _completion != "" { input_text = _completion; }
}

handle_basic_input_box();