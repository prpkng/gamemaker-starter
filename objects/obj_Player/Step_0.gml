var dt = delta_time / 1000000

getInput();

applyJumpBuffering();

// X movement
movementX();

// Y movement
applyGravity();
applyCoyoteTime();

if jumpBuffered && jumpCount < jumpMaxCount {
    applyJump();
}

if (jumpInputReleased && yspd < 0 && isJumping) {
    releaseJump();
}

if (isJumping && yspd >= 0) isJumping = false;
    
checkCeilingCollision();
checkFloorCollision();

ensureStandingOnPlatform();

// Final moving platform collisions and movement

// X - Move X according to platform movement
xMoveWithPlatform();    
    
// Y - Snap player to currentFloorPlat if it's moving vertically
ySnapToPlatform();

updateAnimations();