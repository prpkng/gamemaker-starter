if room != rm_Game {
    exit;
}

if keyboard_check_pressed(vk_escape) {
    paused = !paused;
    
    if paused = false {
        paused_surf = -1;
        instance_activate_layer("Instances");
        surface_free(paused_surf);
    }

}
