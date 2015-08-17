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
endtype

type player
	sprite as integer
	health as integer
	score as integer
	velocity#
	invincibleTime#
endtype

type spritesheet
	player as integer
	strawberry as integer
	monster as integer
	cloud as integer
	popsicle as integer
endtype

global gSpeed#
gSpeed# = 20
global lastTick# = 0
global timeSinceLastTick# = 0
global gGameTime# = 0
global gGameMode
global gNextSpawn#
					
global sprites as spritesheet
loadSprites()					
													//temporary debug stuff
global hazardChance#
//global hazardNumber
//hazardNumber = CreateText("")

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
    debugInfo()
	Sync()
loop


function mainGame()
	previousTick# = lastTick#
	lastTick# = timer()
	timeSinceLastTick# = lastTick# - previousTick#
	inc gGameTime#, timeSinceLastTick#
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
	SetSpriteAngle(p1.sprite, p1.velocity#/1.5)
	
	SetSpritePosition(p1.sprite, 25, GetSpriteY(p1.sprite) + (p1.velocity# * timeSinceLastTick#))
	
	if p1.invincibleTime# > 0
		if mod(timer()*10, 3) = 0
			SetSpriteColorAlpha(p1.sprite, 0)
		else
			SetSpriteColorAlpha(p1.sprite, 255)
			dec p1.invincibleTime#, timeSinceLastTick#
		endif
	endif
	
	//if(getSpriteY(p1.sprite) < 0) then SetSpritePosition(p1.sprite, 10, 0)
	//if(GetSpriteY(p1.sprite) > 85) then SetSpritePosition(p1.sprite, 10, 85)
	updateHazards()

endfunction	
	
function startGame()
	deleteSprite(start)
	createPlayer()
	createHazards()
	lastTick# = timer()
	gNextSpawn# = 1
	gGameTime# = 0
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

function loadSprites()
	sprites.player = LoadImage("frame-1.png")
	sprites.monster = LoadImage("monster.png")
	sprites.strawberry = LoadImage("strawberry.png")
	sprites.cloud = LoadImage("cloud.png")
	sprites.popsicle = LoadImage("cherry.png")
endfunction

function gameOver()
	for i = 0 to 5
		DeleteSprite(hazards[i].sprite)
	next i
	DeleteSprite(p1.sprite)
	showMenu()
endfunction

function debugInfo()
	PrintC("FPS:")
	print(screenFPS())
	printC("last tick:")
	print(str(timeSinceLastTick#))
	printC("hazard chance:")
	print(str(hazardChance#))
	printC("next spawn:")
	print(str(gNextSpawn#))
	printC("game time:")
	print(str(gGameTime#))
	printC("score:")
	print(str(p1.score))
	printC("health:")
	print(str(p1.health))
	printC("i-time:")
	print(str(p1.invincibleTime#))
endfunction
