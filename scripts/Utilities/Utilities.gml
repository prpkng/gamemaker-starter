
/// @desc Prints text with variable arguments
function print(){
    var _str = ""
    
    if argument_count == 0 { return; }
    for (var i = 0; i < argument_count; i++) {
    	_str += string(argument[i]);
    }
    
    show_debug_message_ext("[{0}] {1}: {2}", [date_time_string(date_current_datetime()), object_get_name(object_index), _str]);
}