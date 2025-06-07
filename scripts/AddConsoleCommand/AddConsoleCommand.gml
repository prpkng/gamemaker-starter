/// @desc Adds a command to the global console command list
/// @param {Struct.Command} command Command
function AddConsoleCommand(command){
    if is_array(global.commands) {
        array_push(global.commands, command);
    } else {
        global.commands = [command];
    }
}