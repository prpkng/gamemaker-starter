if event_data != pointer_null && event_data[? "event_type"] == "sprite event" {
    switch (event_data[? "message"]) {
        case "player_step":
            part_particles_burst(partSystem, x, y, part_PlayerWalkParticles);
        break;
    }
}