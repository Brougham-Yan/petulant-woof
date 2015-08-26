#include "player.agc"
#include "hazard.agc"
#include "file.agc"
#include "background.agc"
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

type background
	foreground1 as integer
	foreground2 as integer
	background1 as integer
	background2 as integer
	red#
	green#
	blue#
endtype

type spritesheet
	player as integer
	strawberry as integer
	monster as integer
	cloud as integer
	popsicle as integer
endtype

type buttonsheet
	start as integer
	pause as integer
	quit as integer
	options as integer
	back as integer
	fpsToggle as integer
endtype

type options
	FPS as integer
	SFX as integer
	BGM as integer
endtype

global gSpeed#
gSpeed# = 25
global lastTick# = 0
global timeSinceLastTick# = 0
global gGameTime# = 0
global gNextLevel# = 45
global gGameMode
global gNextSpawn#
global gHighScore as integer
readScores()
initializeSettings()
					
global sprites as spritesheet
global buttons as buttonsheet
global settings as options
global bg as background
loadSprites()					
makeBackground()													
													//temporary debug stuff
global hazardChance#
//global hazardNumber
//hazardNumber = CreateText("")

//starting functions
SetSyncRate(settings.FPS, 0)
SetRandomSeed(GetMilliseconds()) //seed the rng
//player = createPlayer()
global p1 as player
global hazards as hazard[10]
global gActiveHazards as integer
//image = LoadImage("frame-1.png")
global start as integer
showMenu()

DeleteSprite(splash) //end loading


do //main game loop
    if gGameMode = 0 //main menu
		gameMenu()
		updateBackground() 
    elseif gGameMode = 1 //main game mode
		mainGame()
		updateBackground()
    elseif gGameMode = 2 //options menu
		gamePaused()
		updateBackground()
    elseif gGameMode = 3 //paused
		optionsMenu()
	endif
    debugInfo()
	Sync()
loop


function mainGame()
	if GetRawKeyPressed(27) = 1 then pause() //escape on PC/back button on Android
	previousTick# = lastTick#
	lastTick# = timer()
	timeSinceLastTick# = lastTick# - previousTick#
	inc gGameTime#, timeSinceLastTick#
	dec gNextLevel#, timeSinceLastTick#
	inc p1.score, (timeSinceLastTick# * 100)
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
	
	if gNextLevel# < 0
		if gActiveHazards < 10 then inc gActiveHazards
		gNextLevel# = 45
	endif
	updateHazards()
endfunction	
	
function startGame()
	hideMenu()
	createPlayer()
	createHazards()
	gActiveHazards = 6
	lastTick# = timer()
	gNextSpawn# = 1
	gGameTime# = 0
	gGameMode = 1
endfunction

function gameMenu()
	if GetPointerReleased() = 1
		if GetSpriteHit(GetPointerX(), GetPointerY()) = buttons.start then startGame()
		if GetSpriteHit(GetPointerX(), GetPointerY()) = buttons.options then openOptions()
	endif
endfunction

function showMenu()
	buttons.start = CreateSprite(0)
	SetSpritePosition(buttons.start, 50, 20)
	SetSpriteSize(buttons.start, 20, 10)
	buttons.options = CreateSprite(0)
	SetSpritePosition(buttons.options, 50, 60)
	setspritesize(buttons.options, 20, 10)
	gGameMode = 0
endfunction

function hideMenu()
	DeleteSprite(buttons.start)
	DeleteSprite(buttons.options)
endfunction

function loadSprites()
	sprites.player = LoadImage("frame-1.png")
	sprites.monster = LoadImage("monster.png")
	sprites.strawberry = LoadImage("strawberry.png")
	sprites.cloud = LoadImage("cloud.png")
	sprites.popsicle = LoadImage("cherry.png")
endfunction

function gameOver()
	for i = 0 to 9
		DeleteSprite(hazards[i].sprite)
	next i
	DeleteSprite(p1.sprite)
	showMenu()
	if p1.score > gHighScore
		gHighScore = p1.score
		writeScores()
	endif
endfunction

function pause()
	gGameMode = 2
	buttons.pause = CreateSprite(0)
	SetSpriteDepth(buttons.pause, 2)
	SetSpriteSize(buttons.pause, 100, 100)
	buttons.quit = CreateSprite(0)
	SetSpriteDepth(buttons.quit, 1)
	setspritesize(buttons.quit, 20, -1)
	SetSpritePosition(buttons.quit, 40, 70)
	setspritecolor(buttons.quit, 255, 0, 0, 255)
endfunction

function gamePaused()
	if GetPointerReleased() = 1
		if GetSpriteHit(GetPointerX(), GetPointerY()) = buttons.quit
			gameOver()
		elseif GetSpriteHit(GetPointerX(), GetPointerY()) = buttons.pause
			lastTick# = timer()
			gGameMode = 1
		endif
		DeleteSprite(buttons.pause)
		DeleteSprite(buttons.quit)
	endif
endfunction

function initializeSettings()
		settings.BGM = 100
		settings.SFX = 100
		settings.FPS = 60
endfunction

function openOptions()
	gGameMode = 3
	hideMenu()
	buttons.fpsToggle = CreateSprite(0)
	SetSpriteSize(buttons.fpsToggle, -1, 10)
	SetSpritePosition(buttons.fpsToggle, 50, 20)
	if settings.FPS = 30 then setspritecolor(buttons.fpsToggle, 127, 127, 127, 255)
	buttons.back = CreateSprite(0)
	SetSpriteSize(buttons.back, -1, 10)
	SetSpritePosition(buttons.back, 50, 80)
endfunction

function closeOptions()
	DeleteSprite(buttons.fpsToggle)
	DeleteSprite(buttons.back)
	showMenu()
	//save changes
endfunction

function optionsMenu()
	if GetPointerReleased() = 1
		if GetSpriteHit(GetPointerX(), GetPointerY()) = buttons.back
			closeOptions()
		elseif GetSpriteHit(GetPointerX(), GetPointerY()) = buttons.fpsToggle
			if settings.FPS = 30
				settings.FPS = 60
				SetSpriteColor(buttons.fpsToggle, 255, 255, 255, 255)
			else 
				settings.FPS = 30
				SetSpriteColor(buttons.fpsToggle, 127, 127, 127, 255)
			endif
			SetSyncRate(settings.FPS, 0)
		endif
	endif
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
	printC("highscore:")
	print(str(gHighScore))
	printC("health:")
	print(str(p1.health))
	printC("i-time:")
	print(str(p1.invincibleTime#))
	printC("nextlevel:")
	print(str(gNextLevel#))
	printC("activehazards:")
	print(str(gActiveHazards))
endfunction
