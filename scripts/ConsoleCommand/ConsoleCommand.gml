/// @desc A console command
/// @param {String} name The command name
/// @param {Array} aliases Other possible names to the command
/// @param {String} description The command description
/// @param {Function} on_execute Callled when the command is executed
function ConsoleCommand(name, aliases, description, on_execute) constructor {
    self.name = name;
    self.aliases = is_array(aliases) ? aliases : [];
    self.description = description;
    self.on_execute = on_execute;
}


