var dt = delta_time / 1000000

// Gather input
getInput();

// X movement
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

// Y movement
    
    // Gravity
    yspd += grav;
    if yspd > terminalVel { yspd = terminalVel }
        

    coyoteCounter -= dt;

    if coyoteCounter > 0 {
        // Reset jump count if grounded
        jumpCount = 0;
    } else {
        // Otherwise, make sure the player cannot do an extra jump after falling of a ledge
        if jumpCount == 0 { jumpCount = 1; }  
    }
        
    

    // Jump        
    if jumpBuffered && jumpCount < jumpMaxCount {
        jumpBuffered = false;
        jumpBufferTimer = 0;
        coyoteCounter = 0;
        
        // Increase jumpCount
        jumpCount++;
        
        setGrounded(false);
        isJumping = true;
        yspd = jumpSpd;
    }
    if (jumpInputReleased && yspd < 0 && isJumping) {
        yspd -= yspd * jumpReleaseFactor;
    }
    if (isJumping && yspd >= 0) isJumping = false;
    
    // Ceiling collision
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

    // Floor collision

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

    // Final moving platform collisions and movement

    // X - Move X according to platform movement
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
    

    // Y - Snap player to currentFloorPlat if it's moving vertically
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