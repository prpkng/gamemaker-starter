scribble_font_bake_outline_and_shadow("fnt_Pixel", "fnt_PixelShadow", 3, 3, SCRIBBLE_OUTLINE.NO_OUTLINE, 0, false);
scribble_font_set_default("fnt_PixelShadow");

show_debug_message(game_save_id);

surface_resize(application_surface, 320, 180);
display_set_gui_size(640, 360);

global.clock = new IotaClock();
global.clock.SetUpdateFrequency(0);
global.clock.DefineInput("left", 0);
global.clock.DefineInput("right", 0);
global.clock.DefineInputMomentary("jumpPress", false);
global.clock.DefineInputMomentary("jumpRelease", false);


/// @desc  Gets a ini section or writes to it if not found
/// @param {String} section 
/// @param {String} key 
/// @param {Real} default_value
/// @return {Real} The current read value or the default one
function get_or_write(section, key, default_value) {
    if !ini_section_exists(section) || !ini_key_exists(section, key) {
        ini_write_real(section, key, default_value);
    }
    return ini_read_real(section, key, default_value);
}

// === LOAD SETTINGS ===
ini_open("settings.ini");

global.screen_width = get_or_write("window", "width", 1280);
global.screen_height = get_or_write("window", "height", 720);
global.screen_vsync = get_or_write("window", "vsync", 1);


ini_close();

// === APPLY SETTINGS ===

// Set vsync
display_reset(0, global.screen_vsync == 1);
window_set_size(global.screen_width, global.screen_height);
window_center()

is_debug_log = false;
instance_create_depth(0, 0, -400, obj_PauseManager);