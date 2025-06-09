if keyboard_check_pressed(vk_f1) {
    is_debug_log = !is_debug_log;
    show_debug_log(is_debug_log);
}

global.clock.Update();


// INPUT MANAGEMENT


global.clock.SetInput("right", sign(InputCheck(INPUT_VERB.RIGHT)));
global.clock.SetInput("left", sign(InputCheck(INPUT_VERB.LEFT)));
global.clock.SetInput("jumpPress", InputPressed(INPUT_VERB.JUMP));
global.clock.SetInput("jumpRelease", InputReleased(INPUT_VERB.JUMP));