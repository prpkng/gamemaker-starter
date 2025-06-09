// A state-machine based player controller built for versatility
event_inherited();

#macro FLOOR_OBJECTS [obj_Wall, obj_SemiSolidWall]

current_state = "idle";



#region Player parameters

moveSpd = 1.5;

jumpSpd = -3.25;
jumpReleaseFactor = 0.75;
jumpMaxCount = 1;
jumpCount = jumpMaxCount;
ascendingGrav = .275/2;
descendingGrav = .375/2;
terminalVel = 3.25;

// Other variables
isJumping = false;

xspd = 0;
yspd = 0;

env_xspd = 0;

movePlatMaxYspd = 8;
currentFloorPlat = noone;

_standingPlatforms = ds_list_create();

#endregion

// == FUNCTIONS ============

#region EFFECTS

/// @param {Asset.GMSprite} spr Particle sprite
function spawnParticle(spr) {
    instance_create_layer(x, y, layer, obj_Particle).set_sprite(spr);
}

#endregion

#region Y SECTION

/// @desc Checks for a platform beneath the player feet, checking for an array of possible "floor" instances
function determineStandingPlatform() { 
    var _clampYspd = max(0, yspd);
    var _platformCount = instance_place_list(x, y+1 + _clampYspd + movePlatMaxYspd, FLOOR_OBJECTS, _standingPlatforms, false);

    // Loop through all 

    for (var i = 0; i < _platformCount; i++) 
    {
    	var _currentPlat = _standingPlatforms[| i];
        
        // Avoid caching a platform when we should not (i.e. Jumping)
        if (_currentPlat.yspd <= yspd // If platform is moving upwards FASTER than the player 
            || instance_exists(currentFloorPlat)) // Or if the player is already standing at a platform
            && (_currentPlat.yspd > 0 || place_meeting(x, y+1 + _clampYspd, _currentPlat))
        {
            //Return a solid wall or any semisolid walls that are below the player
            if _currentPlat.object_index == obj_Wall 
                || object_is_ancestor(_currentPlat.object_index, obj_Wall)
                || floor(bbox_bottom) <= ceil(_currentPlat.bbox_top - _currentPlat.yspd)
            {
                 if !instance_exists(currentFloorPlat) 
                    ||_currentPlat.bbox_top + _currentPlat.yspd <= currentFloorPlat.bbox_top + currentFloorPlat.yspd 
                    || _currentPlat.bbox_top + _currentPlat.yspd <= bbox_bottom
                {
                    currentFloorPlat = _currentPlat;
                }
            }
        }
        
    }
    
    ds_list_clear(_standingPlatforms);
}

/// @desc Checks and make sure the player is standing on a valid platform and, if so, aligns its y position to it
function ensureStandingOnPlatform() {
    // Sets 'currentFloorPlat' to noone if said platform ins't below the player anymore
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
    }
}

/// @description Applies movement on the Y axis based on yspd and collision checks
function applyYMovement() {
    determineStandingPlatform();
    
    ensureStandingOnPlatform();
    
    // Then, we move  
    y += yspd;
}

#endregion

#region X SECTION

/// @description Applies movement on the X axis based on xspd
function applyXMovement() {
    // X UNIT
    
    var _xspd = xspd + env_xspd;
    
    var _subPixel = 0.5;
    if place_meeting(x + _xspd, y, obj_Wall) {
           
           // Scoot up to wall precisely
           var _pixelCheck = _subPixel * sign(_xspd);
           while !place_meeting(x + _pixelCheck, y, obj_Wall) {
               x += _pixelCheck;
           }
           
           // Collide
           _xspd = 0;
    }
        
    // Actually move now
    x += _xspd;
}

#endregion

#region PLATFORM FOLLOW

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
        //Snap to the top of the floor platform (un-floor our y variable so it's not choppy
        if !place_meeting(x, currentFloorPlat.bbox_top, obj_Wall) 
            && currentFloorPlat.bbox_top >= bbox_bottom - movePlatMaxYspd {
                y = currentFloorPlat.bbox_top;
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

/// @description Ensures player moves with platform when standing above one
function followPlatform() {
    if currentFloorPlat == noone { return; }
    
    xMoveWithPlatform();
    
    ySnapToPlatform();
}

#endregion

/// @desc Shorthand for checking if the currentStandingPlatform isn't noone
function checkGrounded() {
    return currentFloorPlat != noone;
}

/// @desc Triggers the player to jump and everything that comes with it
function applyJump() {
    current_state = "air";
    
    // TODO jump buffering and counters
    jumpBuffered = false;
    jumpBufferTimer = 0;
    coyoteCounter = 0;
    jumpCount++;

    
    // Spawn particles
    spawnParticle(spr_JumpParticles);
    
    
    //setGrounded(false);
    isJumping = true;
    yspd = jumpSpd;
    
    if currentFloorPlat != noone {
        if sign(xspd) == sign(currentFloorPlat.xspd) {
            env_xspd = currentFloorPlat.xspd;
        }
        if currentFloorPlat.yspd < 0 {
            yspd += currentFloorPlat.yspd/2;
        }
    }
    
    currentFloorPlat = noone;
}

print("Initialized player");