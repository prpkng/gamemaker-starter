if !paused { exit; }
    

if !surface_exists(paused_surf) {
    var _shouldDisable = false;
    if paused_surf == -1 {
        _shouldDisable = true;
    }
    
    paused_surf = surface_create(room_width, room_height);
    surface_set_target(paused_surf);
    with (all) {
        if visible and layer_get_visible(layer) {
            draw_self();
        }
    }
    surface_reset_target();
    
    if _shouldDisable {
        instance_deactivate_layer("Instances");
        instance_activate_object(id);
    }
} else {
    draw_surface(paused_surf, 0, 0);
    
    draw_set_alpha(0.5);
    draw_rectangle_color(0, 0, room_width, room_height, c_black, c_black, c_black, 
        c_black, false);
    
    draw_set_alpha(1);
    
    scribble_anim_wave(2, 0.5, 0.15);
    scribble("[wave][aqua][fa_center][fa_middle]PAUSED").draw(
        camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0])/2, 
        -20+camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0])/2
    );
}