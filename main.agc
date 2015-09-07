#include "player.agc"
#include "hazard.agc"
#include "file.agc"
#include "background.agc"
// Project: Strawbirdie+ 
// Created: 2015-08-11

// set window properties
SetWindowTitle( "Strawbirdie+" )

// set display properties
SetOrientationAllowed( 0, 0, 1, 1 ) //force landscape
SetDisplayAspect(-1)

splash = CreateSprite(0) //splash screen
SetSpriteSize(splash, -1, 100)
SetSpriteDepth(splash, 1)

#insert "types.agc"

global gSpeed#
global gTargetSpeed#
gSpeed# = 20
gTargetSpeed# = 20
global lastTick# = 0
global timeSinceLastTick# = 0
global gGameTime# = 0
global gNextLevel# = 45
global gGameMode
global gNextSpawn#
global gNextEffect#
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

//starting functions
SetSyncRate(settings.FPS, 0)
SetRandomSeed(GetMilliseconds()) //seed the rng
global p1 as player
global hazards as hazard[10]
global gActiveHazards as integer
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
	dec gNextSpawn#, timeSinceLastTick#
	dec gNextEffect#, timeSinceLastTick#

	inc p1.score, (timeSinceLastTick# * gSpeed# * 10)
    updatePlayer()
	
	if gNextLevel# < 0
		if gActiveHazards < 10 then inc gActiveHazards
		gNextLevel# = 45
		inc gTargetSpeed#, 5
	endif
	
	if gSpeed# < gTargetSpeed#
		inc gSpeed#, timeSinceLastTick#
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
	gNextEffect# = 20
	gGameTime# = 0
	gGameMode = 1
	gSpeed# = 20
	gTargetSpeed# = 20
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
	
	buttons.bgmDown = CreateSprite(0)
	SetSpriteSize(buttons.bgmDown, -1 , 10)
	SetSpritePosition(buttons.bgmDown, 50, 35)
	buttons.bgmUp = CreateSprite(0)
	SetSpriteSize(buttons.bgmUp, -1, 10)
	SetSpritePosition(buttons.bgmUp, 65, 35)
	
	buttons.sfxDown = CreateSprite(0)
	SetSpriteSize(buttons.sfxDown, -1 , 10)
	SetSpritePosition(buttons.sfxDown, 50, 50)
	buttons.sfxUp = CreateSprite(0)
	SetSpriteSize(buttons.sfxUp, -1, 10)
	SetSpritePosition(buttons.sfxUp, 65, 50)
endfunction

function closeOptions()
	DeleteSprite(buttons.fpsToggle)
	DeleteSprite(buttons.back)
	DeleteSprite(buttons.sfxDown)
	DeleteSprite(buttons.sfxUp)
	DeleteSprite(buttons.bgmDown)
	DeleteSprite(buttons.bgmUp)
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
		elseif GetSpriteHit(GetPointerX(), GetPointerY()) = buttons.bgmDown
			if settings.BGM > 0 then dec settings.BGM, 10
		elseif GetSpriteHit(GetPointerX(), GetPointerY()) = buttons.bgmUp
			if settings.BGM < 100 then inc settings.BGM, 10 
		elseif GetSpriteHit(GetPointerX(), GetPointerY()) = buttons.sfxDown
			if settings.SFX > 0 then dec settings.SFX, 10
		elseif GetSpriteHit(GetPointerX(), GetPointerY()) = buttons.sfxUp
			if settings.SFX < 100 then inc settings.SFX, 10
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
	printC("next effect:")
	print(str(gNextEffect#))
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
	printc("speed:")
	print(str(gSpeed#))
	printc("antigrav:")
	print(str(p1.antigravTime#))
	printc("sfx: ")
	print(str(settings.SFX))
	printc("bgm: ")
	print(str(settings.BGM))
endfunction
