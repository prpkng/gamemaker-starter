

global.commands = []
AddConsoleCommand(new ConsoleCommand("help", ["?"], "Shows a list of commands", function () {
    var _text = "Commands:\n";
    
    for (var i = 0; i < array_length(global.commands); i++) {
    	_text += "  [c_yellow]" + global.commands[i].name + "[/c] - ";
        _text += global.commands[i].description + "\n";
    }
    
    return _text;
}))


AddConsoleCommand(new ConsoleCommand("quit", ["exit"], "Close the application", function () {
    game_end();
}))

AddConsoleCommand(new ConsoleCommand("restart", ["r"], "Restart the current room", function () {
    room_goto(room);
}))

AddConsoleCommand(new ConsoleCommand("scout", ["fly"], 
    "Spawns a scout at the location of the player", function () {
    
    with (obj_Player) {
        if object_index == obj_FlyingScout {
            instance_change(obj_Player, true);
        } else {
            instance_change(obj_FlyingScout, true);
        }
    }
}));