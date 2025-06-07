// @description Initialize Variables

// Define functions

function setGrounded(_val = true) {
    isGrounded = _val;
    coyoteCounter = _val ? coyoteTime : 0;
    if !_val {
        currentFloorPlat = noone;
    }
}

function checkForSemisolidPlatform(_x, _y) 
{
    // Create a return variable
    var _id = noone;
    
    // We must not be moving upwards, and then we check for a normal collision
    if yspd >= 0 && place_meeting(_x, _y, obj_SemiSolidWall) {
        
        // Create a ds list to store all colliding instances of obj_SemiSolidWall
        var _list = ds_list_create();
        var _listSize = instance_place_list(_x, _y, obj_SemiSolidWall, _list, false);
        
        // Loop through the colliding instances and only return one of which's top is below the player
        for (var i = 0; i < _listSize; i++) {
        	var _listInst = _list[|i];
            if floor(bbox_bottom <= ceil(_listInst.bbox_top - _listInst.yspd)) {
                // Return the id of a semisolid platform
                _id = _listInst;
                // Exit the loop early
                break;
            }
        }
        
        ds_list_destroy(_list);
    }
    return _id;
}



// Player variables
moveDir = 0;
moveSpd = 3;
xspd = 0;
yspd = 0;

// Jumping
grav = .275;
terminalVel = 6;
jumpSpd = -6;
jumpReleaseFactor = 0.75;
jumpMaxCount = 1;
jumpCount = jumpMaxCount;

isJumping = false;
isGrounded = false;

// Jump buffer
jumpBufferDuration = 0.135;
jumpBuffered = false;
jumpBufferTimer = 0;

// Coyote time
coyoteTime = 0.10;
coyoteCounter = 0;

// show_debug_overlay(true);
movePlatMaxYspd = 8;



function getInput() {
    var dt = delta_time / 1000000
    
    rightInput = sign(InputCheck(INPUT_VERB.RIGHT));
    leftInput = sign(InputCheck(INPUT_VERB.LEFT));
    jumpInputPressed = InputPressed(INPUT_VERB.JUMP);
    jumpInputReleased = InputReleased(INPUT_VERB.JUMP);
    
    if jumpInputPressed {
        jumpBufferTimer = jumpBufferDuration;
    }
    if jumpBufferTimer > 0 {
        jumpBuffered = true;
        jumpBufferTimer -= dt;
    } else {
        jumpBuffered = false;
    }
}

currentFloorPlat = noone;