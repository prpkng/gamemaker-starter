if keyboard_check_pressed(vk_f11) {
    window_set_showborder(!window_get_showborder());
    if window_get_showborder() {
        window_set_size(display_get_width()/2, display_get_height()/2);
        window_center()
    } else { 
        window_set_size(display_get_width(), display_get_height());
        window_set_position(0, 0);
    }
    
}

if !instance_exists(obj_Player) exit;
    
var _camWidth = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);

var _destX = obj_Player.x - _camWidth / 2 + offsetX;
var _destY = obj_Player.y - _camHeight / 2 + offsetY;

// Clamp camera pos to view width
_destX = clamp(_destX, 0, room_width - _camWidth);
_destY = clamp(_destY, 0, room_height - _camHeight);

x += (_destX - x) * followSpeed;
y += (_destY - y) * followSpeed;


camera_set_view_pos(view_camera[0], x, y);