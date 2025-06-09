

var _guiW = window_get_width();
var _guiH = window_get_height();

display_set_gui_size(_guiW, _guiH);

var _surfW = surface_get_width(application_surface);
var _surfH = surface_get_height(application_surface);

if !surface_exists(pp_surface) {
    pp_surface = surface_create(_surfW, _surfH);
}
shader_set(shd_CrtShader);
surface_set_target(pp_surface);
draw_surface(application_surface, 0, 0);
surface_reset_target();
shader_reset();

var _texture = surface_get_texture(application_surface);
var _texelW = texture_get_texel_width(_texture);
var _texelH = texture_get_texel_height(_texture);

shader_set(shd_PixelScaling);
gpu_set_tex_filter(true);
shader_set_uniform_f(shader_get_uniform(shd_PixelScaling, "u_vTexelSize"), _texelW, _texelH);
shader_set_uniform_f(shader_get_uniform(shd_PixelScaling, "u_vScale"), _guiW/_surfW, _guiH/_surfH);
draw_surface_stretched(pp_surface, 0, 0, _guiW, _guiH);
shader_reset();
gpu_set_tex_filter(false);

