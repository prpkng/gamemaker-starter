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
moveSpd = 1.5;
xspd = 0;
yspd = 0;

// Jumping
grav = .275/2;
terminalVel = 3;
jumpSpd = -3;
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
currentFloorPlat = noone;

idleSprite = spr_PlayerIdle;
runSprite = spr_PlayerRun;


partSystem = part_system_create(part_PlayerWalkParticles);
part_system_depth(partSystem, 300);



/// @desc Gets input
function getInput() {
    
    rightInput = sign(InputCheck(INPUT_VERB.RIGHT));
    leftInput = sign(InputCheck(INPUT_VERB.LEFT));
    jumpInputPressed = InputPressed(INPUT_VERB.JUMP);
    jumpInputReleased = InputReleased(INPUT_VERB.JUMP);
}

function applyJumpBuffering() {
    var dt = delta_time / 1000000;
    
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

/// @desc The X movement and collision detection
function movementX() {
    moveDir = rightInput - leftInput;
    xspd = moveDir * moveSpd;
    
    // X collision
    var _subPixel = 0.5;
    if place_meeting(x + xspd, y, obj_Wall) {
        
        // Scoot up to wall precisely
        var _pixelCheck = _subPixel * sign(xspd);
        while !place_meeting(x + _pixelCheck, y, obj_Wall) {
            x += _pixelCheck;
        }
        
        // Collide
        xspd = 0;
    }
    
    // Actually move now
    x += xspd;
}
function applyGravity() {
    yspd += grav;
    if yspd > terminalVel { yspd = terminalVel }
}
function applyCoyoteTime() {
    var dt = delta_time / 1000000
    coyoteCounter -= dt;

    if coyoteCounter > 0 {
        // Reset jump count if grounded
        jumpCount = 0;
    } else {
        // Otherwise, make sure the player cannot do an extra jump after falling of a ledge
        if jumpCount == 0 { jumpCount = 1; }  
    }
}
function applyJump() {
    sprite_index = spr_PlayerJump;
    jumpBuffered = false;
    jumpBufferTimer = 0;
    coyoteCounter = 0;
    
    // Increase jumpCount
    jumpCount++;
    
    setGrounded(false);
    isJumping = true;
    yspd = jumpSpd;
}
function releaseJump() {
    yspd -= yspd * jumpReleaseFactor;
}

function checkCeilingCollision() {
    _subPixel = 0.5;
    if yspd < 0 && place_meeting(x, y + yspd, obj_Wall) {
           
        // Scoot up to wall precisely
        var _pixelCheck = _subPixel * sign(yspd);
        while !place_meeting(x, y+_pixelCheck, obj_Wall) { 
            y += _pixelCheck;
        }
        
        // Collide
        yspd = 0;
    }
}

function checkFloorCollision() {
    var _clampYspd = max(0, yspd);
    var _list = ds_list_create();
    var _array = array_create(0);
    array_push(_array, obj_Wall, obj_SemiSolidWall);

    _array[0] = obj_Wall;
    _array[1] = obj_SemiSolidWall;

    var _listSize = instance_place_list(x, y+1 + _clampYspd + movePlatMaxYspd, _array, _list, false);

    // Loop through all 

    for (var i = 0; i < _listSize; i++) 
    {
    	var _listInst = _list[|i];
        
        // Avoid magnetism
        if (_listInst.yspd <= yspd || instance_exists(currentFloorPlat)) 
            && (_listInst.yspd > 0 || place_meeting(x, y+1 + _clampYspd, _listInst))
        {
            //Return a solid wall or any semisolid walls that are below the player
            if _listInst.object_index == obj_Wall 
                || object_is_ancestor(_listInst.object_index, obj_Wall)
                || floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.yspd)
            {
                 if !instance_exists(currentFloorPlat) 
                    ||_listInst.bbox_top + _listInst.yspd <= currentFloorPlat.bbox_top + currentFloorPlat.yspd 
                    || _listInst.bbox_top + _listInst.yspd <= bbox_bottom
                {
                    currentFloorPlat = _listInst;
                }
            }
        }
        
    }

    ds_list_destroy(_list);
}
function ensureStandingOnPlatform() {
    // One last check to make sure the floor platform is actually below us

    if instance_exists(currentFloorPlat) && !place_meeting(x, y + movePlatMaxYspd, currentFloorPlat) {
        currentFloorPlat = noone;
    }

    if instance_exists(currentFloorPlat) {
        //Scoot up to platform precisely
        _subPixel = .5;
        while !place_meeting(x, y + _subPixel, currentFloorPlat) && !place_meeting(x, y, obj_Wall) {
            y += _subPixel;
        }
        
        if currentFloorPlat.object_index == obj_SemiSolidWall 
            || object_is_ancestor(currentFloorPlat.object_index, obj_SemiSolidWall) {
            while place_meeting(x, y, currentFloorPlat) { y -= _subPixel; }
        }
        
        y = floor(y);
        
        
        
        yspd = 0;
        setGrounded(true);
    }

    
    y += yspd;
}

function xMoveWithPlatform() {
    var movePlatXSpd = 0;
    if instance_exists(currentFloorPlat) {
         movePlatXSpd = currentFloorPlat.xspd; 
    }
    
    if place_meeting(x + movePlatXSpd, y, obj_Wall) {
        
        // Scoot up to wall precisely
        _subPixel = 0.5;
        var _pixelCheck = _subPixel * sign(movePlatXSpd);
        while !place_meeting(x + _pixelCheck, y, obj_Wall) {
            x += _pixelCheck;
        }
        
        // Collide
        movePlatXSpd = 0;
    }
    
    
    // Actually move now
    x += movePlatXSpd;
}

function ySnapToPlatform() {
    if instance_exists(currentFloorPlat) 
        && (currentFloorPlat.yspd != 0
        || currentFloorPlat.object_index == obj_SemiSolidMovingPlatform
        || currentFloorPlat.object_index == obj_SemiSolidWall
        || object_is_ancestor(currentFloorPlat.object_index, obj_SemiSolidMovingPlatform)
        || object_is_ancestor(currentFloorPlat.object_index, obj_SemiSolidWall) ) 
    {
        show_debug_message("standing on vertical moving platform");
        //Snap to the top of the floor platform (un-floor our y variable so it's not choppy
        if !place_meeting(x, currentFloorPlat.bbox_top, obj_Wall) 
            && currentFloorPlat.bbox_top >= bbox_bottom - movePlatMaxYspd {
                y = currentFloorPlat.bbox_top;
                show_debug_message("Snap to platform");
        }
        
        // Going up into a solid wall while on a semisolid platform
        if currentFloorPlat.yspd < 0 && place_meeting(x, y + currentFloorPlat.yspd, obj_Wall) {
            // Get pushed down through the platform
            if currentFloorPlat.object_index == obj_SemiSolidWall
            || object_is_ancestor(currentFloorPlat.object_index, obj_SemiSolidWall)
            {
                // Get pushed down
                _subPixel = .25;
                while place_meeting(x, y + currentFloorPlat.yspd, obj_Wall) { y += _subPixel; }
                    
                // If we got pushed into a solid wall while going downwards, push ourselves back out
                while place_meeting(x, y, obj_Wall) { y -= _subPixel; }
                y = round(y);    
            }
            
            setGrounded(false);
        }
    }
}

function updateAnimations() {
    if abs(xspd != 0) {
        image_xscale = xspd < 0 ? -1 : 1;
    }
    
    if (isGrounded) {
        image_speed = 1;
        if abs(xspd) == 0 {
            sprite_index = idleSprite;
        } else {
            sprite_index = runSprite;
        }
    } else {
    }
}

print("Initializing player...");