var _right = InputCheck(INPUT_VERB.RIGHT);
var _left = InputCheck(INPUT_VERB.LEFT);
var _jumpPressed = InputPressed(INPUT_VERB.JUMP);
var _jumpReleased = InputReleased(INPUT_VERB.JUMP);

switch current_state {

    case "idle": {
        sprite_index = spr_PlayerIdle;
         
        xspd = 0;
         
        if _right or _left {
            current_state = "move";
        }
        
        applyXMovement(); // Move X to respect environmental x speeds
         
        applyYMovement(); // Apply y movement to check for platforms coming from below
         
        followPlatform();
         
         
        if !checkGrounded() {
            current_state = "air";
        } else if _jumpPressed {
            applyJump    ();
        }
         
        break;
    }
    
    case "move": {
        sprite_index = spr_PlayerRun;
        
        xspd = (_right - _left) * moveSpd;
        
        if abs(xspd) <= 0.1 {
            current_state = "idle";
        }
        
        applyXMovement();
        
        applyYMovement(); // Apply y movement to check for platforms coming from below
        
        followPlatform();
        
        if !checkGrounded() {
            current_state = "air";
        } else if _jumpPressed {
            applyJump();
        }
        
        break;
    }
    
    case "air": {
        sprite_index = spr_PlayerJumpDown;
        
        // X movement
        
        xspd = (_right - _left) * moveSpd;
        applyXMovement();
        
        // Y movement
        
        yspd += isJumping ? ascendingGrav : descendingGrav;
        if yspd > terminalVel { yspd = terminalVel; }
        
        if (yspd > 0 or _jumpReleased) and isJumping {
            isJumping = false;
            yspd -= yspd * jumpReleaseFactor; 
        }
            
        applyYMovement(); // Apply y movement to check for platforms coming from below
        
        if checkGrounded() {
            spawnParticle(spr_LandParticles);
            if xspd == 0 {
                current_state = "idle";
            } else {
                current_state = "move";
            }
        }
    }
}

env_xspd = lerp(env_xspd, 0, 0.075);

var _dir = (_right - _left);
if _dir != 0 {
    image_xscale = (_right - _left) < 0 ? -1 : 1;
}