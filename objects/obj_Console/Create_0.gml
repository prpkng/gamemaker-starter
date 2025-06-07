is_enabled = false;

global.commands = []
buffered_lines = []

AddConsoleCommand(new ConsoleCommand("help", "Shows a list of commands", function () {
    print("WOW");
    
    var _text = "Commands:\n";
    
    for (var i = 0; i < array_length(global.commands); i++) {
    	_text += "  [c_yellow]" + global.commands[i].name + "[/c] - ";
        _text += global.commands[i].description + "\n";
    }
    
    return _text;
}))


AddConsoleCommand(new ConsoleCommand("quit", "Close the application", function () {
    game_end();
}))

AddConsoleCommand(new ConsoleCommand("restart", "Restart the current room", function () {
    room_goto(room);
}))


input_text = "";

supported_chars = [
    "0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j", "k","l",
    "m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I",
    "J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","!","\"","#","$","%","&",
    "(",
")","*","+","-",".","/",":",";","<","=",">","?","@","[","\\","]","^","_","`",
    "{","|","}","~", " "
]

hold_backspace_counter = 0;

/// @desc Submits a text input to the buffer and handles it
/// @param {String} text Description
function submit_text(text) {
    var _output = ""
    
    for (var i = 0; i < array_length(global.commands); i++) {
    	if global.commands[i].name == text {
            var _tmp = global.commands[i].on_execute();
            
            if _tmp == undefined {
                _output = "[alpha,0.7][slant]Ran command '" + text + "'";
            } else {
                _output = _tmp;
            }
            
            break;
        }
    }
    
    if _output == "" {
        _output = "[#aa1010][slant]Command not found: '" + text + "'";
    }
    
    array_push(buffered_lines, _output);
}

function handle_basic_input_box() { 
    if keyboard_check_pressed(vk_backspace) && keyboard_check(vk_control) {
        do {
            input_text = string_delete(input_text, string_length(input_text) - 1, 1);
            
        } until string_char_at(input_text, string_length(input_text)-1) == " " 
            or string_length(input_text) <= 0
    }
    else if keyboard_check_pressed(vk_enter) {
        submit_text(input_text);
        input_text = "";
    } else if keyboard_check_pressed(vk_backspace) {
        input_text = string_delete(input_text, string_length(input_text), 1);
        hold_backspace_counter = -10;
    }
    
    if keyboard_check(vk_backspace) {
        hold_backspace_counter++;
        if hold_backspace_counter > 2 {
            hold_backspace_counter = 0;
            input_text = string_delete(input_text, string_length(input_text), 1);
        }
    }
    
    if keyboard_check_pressed(vk_anykey) and array_contains(supported_chars, keyboard_lastchar) {
        input_text += keyboard_lastchar;
    }
}
