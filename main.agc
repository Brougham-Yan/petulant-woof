#include "player.agc"
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
	velocity#
endtype

global gSpeed#
gSpeed# = 11
global timeSinceLastTick# = 0



//starting functions
SetSyncRate(60, 0)
SetRandomSeed(GetMilliseconds()) //seed the rng
//player = createPlayer()
global p1 as player
global hazards as hazard[6]
//image = LoadImage("frame-1.png")
start = CreateSprite(0)
SetSpritePosition(start, 50, 20)
SetSpriteSize(start, 20, 10)


DeleteSprite(splash) //end loading

menu:
do //main game loop
    
	if GetPointerState() = 1
		if GetSpriteHit(GetPointerX(), GetPointerY()) = start then goto mainGame
    endif
    
    
    print(screenFPS())
	Sync()
loop

mainGame:
gosub hideMenus
createPlayer()
createHazards()
lastTick# = timer()
do
	timeSinceLastTick# = timer() - lastTick#
	lastTick# = timer()
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
	
    Print( ScreenFPS() )
    Sync()
	
loop

hideMenus:
	SetSpriteVisible(start, 0)
return

function createHazards()
    
    for i = 0 to 5
		resetHazard(i)
	next i
endfunction

function resetHazard( i as integer)
		RNG = random(0, 99)
		if RNG < 80
			hazards[i].hazardType = 0 //strawberry
			hazards[i].sprite = CreateSprite(LoadImage("strawberry.png"))
			hazards[i].speed# = gSpeed#
			SetSpriteSize(hazards[i].sprite, -1, 10)
		else
			hazards[i].hazardType = 1 //bird
			hazards[i].sprite = CreateSprite(LoadImage("monster.png"))
			hazards[i].speed# = gSpeed# * 1.2
			SetSpriteSize(hazards[i].sprite, -1, 15)
		endif
		SetSpritePosition(hazards[i].sprite, random(100,200), random(0, 90))
			
endfunction

function updateHazards()
	for i = 0 to 5
		SetSpritePosition(hazards[i].sprite, GetSpriteX(hazards[i].sprite) - (hazards[i].speed# * timeSinceLastTick#), GetSpriteY(hazards[i].sprite))
		if GetSpriteX(hazards[i].sprite) < -20 then resetHazard(i)
	next i
endfunction
