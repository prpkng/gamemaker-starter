/// @desc A console command
/// @param {String} name The command name
/// @param {String} description The command description
/// @param {Function} on_execute Callled when the command is executed
function ConsoleCommand(name, description, on_execute) constructor {
    self.name = name;
    self.description = description;
    self.on_execute = on_execute;
}