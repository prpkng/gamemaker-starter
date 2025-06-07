if keyboard_check_pressed(vk_backtick) {
    is_enabled = !is_enabled;
}

if !is_enabled { exit; }

handle_basic_input_box();