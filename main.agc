#include "player.agc"
#include "hazard.agc"
// Project: Strawbirdie+ 
// Created: 2015-08-11

// set window properties
SetWindowTitle( "Strawbirdie+" )
//SetWindowSize( 1024, 768, 0 )

// set display properties
//SetVirtualResolution( 1920, 1080 )
SetOrientationAllowed( 0, 0, 1, 1 ) //force landscape
SetDisplayAspect(-1)
SetClearColor( 255, 128, 128)

splash = CreateSprite(0) //splash screen
SetSpriteSize(splash, -1, 100)
SetSpriteDepth(splash, 1)

type hazard
	sprite as integer
	hazardType as integer
	speed#
	notcolliding as integer
endtype

type player
	sprite as integer
	health as integer
	score as integer
	velocity#
endtype

global gSpeed#
gSpeed# = 15
global lastTick# = 0
global timeSinceLastTick# = 0
global gGameTime# = 0
global gGameMode
					
													//temporary debug stuff
global hazardNumber
hazardNumber = CreateText("")

//starting functions
SetSyncRate(60, 0)
SetRandomSeed(GetMilliseconds()) //seed the rng
//player = createPlayer()
global p1 as player
global hazards as hazard[6]
//image = LoadImage("frame-1.png")
global start as integer
showMenu()

DeleteSprite(splash) //end loading


do //main game loop
    if gGameMode = 0 then gameMenu()
    if gGameMode = 1 then mainGame()
    print(screenFPS())
	Sync()
loop


function mainGame()
	previousTick# = lastTick#
	lastTick# = timer()
	timeSinceLastTick# = lastTick# - previousTick#
	print(str(timeSinceLastTick#))
    if GetPointerState() = 1
		dec p1.velocity#, (75 * timeSinceLastTick#)
	else
		inc p1.velocity#, (60 * timeSinceLastTick#)
	endif
	
	if GetSpriteY(p1.sprite) < 0 //make sure it doesn't go out of bounds
		p1.velocity# = (0 - p1.velocity# * 0.9)
		if p1.velocity# < 35 then p1.velocity# = 35
	endif
	if GetSpriteY(p1.sprite) > 85 
		p1.velocity# = (0 - p1.velocity# * 0.9)
		if p1.velocity# > -35 then p1.velocity# = -35
	endif
	
	SetSpritePosition(p1.sprite, 10, GetSpriteY(p1.sprite) + (p1.velocity# * timeSinceLastTick#))
	//if(getSpriteY(p1.sprite) < 0) then SetSpritePosition(p1.sprite, 10, 0)
	//if(GetSpriteY(p1.sprite) > 85) then SetSpritePosition(p1.sprite, 10, 85)
	updateHazards()

endfunction	
	
function startGame()
	deleteSprite(start)
	createPlayer()
	createHazards()
	lastTick# = timer()
	gGameTime# = lastTick#
	gGameMode = 1
endfunction

function gameMenu()
	if GetPointerState() = 1
		if GetSpriteHit(GetPointerX(), GetPointerY()) = start then startGame()
	endif
    //endif
endfunction

function showMenu()
	start = CreateSprite(0)
	SetSpritePosition(start, 50, 20)
	SetSpriteSize(start, 20, 10)
	gGameMode = 0
endfunction
