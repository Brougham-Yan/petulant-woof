function createHazards()
    for i = 0 to 9
		hazards[i].hazardType = -1
	next i
endfunction

function resetHazard( i as integer)
	hazardChance# = pow(0.95, ( gGameTime#/ 10 )) * 90
	if hazardChance# < 40 then hazardChance# = 40
	DeleteSprite(hazards[i].sprite)
		RNG = random(0, 99)
		if RNG < 5
			hazards[i].hazardType = 3 //health
			hazards[i].sprite = createsprite(sprites.popsicle)
			hazards[i].speed# = gSpeed#
			SetSpriteSize(hazards[i].sprite, -1, 8)
			SetSpritePosition(hazards[i].sprite, 110, random(5, 87))
		elseif RNG < hazardChance#
			hazards[i].hazardType = 0 //strawberry
			hazards[i].sprite = CreateSprite(sprites.strawberry)
			hazards[i].speed# = gSpeed#
			SetSpriteSize(hazards[i].sprite, -1, 10)
			SetSpritePosition(hazards[i].sprite, 110, random(5, 85))
		else
			hazards[i].hazardType = 1 //UFO
			hazards[i].sprite = CreateSprite(sprites.monster)
			SetSpriteSize(hazards[i].sprite, -1, 15)
			if random(0,9) < 2
				SetSpritePosition(hazards[i].sprite, -30, random(5, 80))
				hazards[i].speed# = -gSpeed# * 0.4
			else
				SetSpritePosition(hazards[i].sprite, 110, random(5, 80))
				if random(0,6) < 2
					hazards[i].speed# = gSpeed# * 0.4
				else
					hazards[i].speed# = gSpeed# * 1.4
					SetSpriteFlip(hazards[i].sprite, 1, 0)
				endif
			endif
		endif
	SetSpriteDepth(hazards[i].sprite, 50)
	SetSpriteColor(hazards[i].sprite, 255, 255, 255, 255)
	SetSpriteShape(hazards[i].sprite, 2)
	
	for j = 1 to gActiveHazards
		checkCollision(i, j)
	next j		
endfunction

function updateHazards()
	for i = 0 to (gActiveHazards - 1)
		if hazards[i].hazardType = -1
		else
			if hazards[i].hazardType = -2
				alpha = GetSpriteColorAlpha(hazards[i].sprite)
				if alpha < 251 then SetSpriteColorAlpha(hazards[i].sprite, alpha + 5)
			elseif hazards[i].hazardType = -3
				inc hazards[i].speed#, 30
				if hazards[i].speed# > 255 
					hazards[i].speed# = 255
					hazards[i].hazardType = -4
				endif
				SetSpriteColorAlpha(hazards[i].sprite, hazards[i].speed#)
			elseif hazards[i].hazardType = -4
				dec hazards[i].speed#, 0.5
				if hazards[i].speed# < 0
					setHazardInactive(i)
				endif
				SetSpriteColorAlpha(hazards[i].sprite, hazards[i].speed#)
			endif
			SetSpritePosition(hazards[i].sprite, GetSpriteX(hazards[i].sprite) - (hazards[i].speed# * timeSinceLastTick#), GetSpriteY(hazards[i].sprite))
			if GetSpriteCollision(hazards[i].sprite, p1.sprite) = 1
				collisionUpdate(i)
			endif		
			if GetSpriteX(hazards[i].sprite) < (-30 - GetSpriteWidth(hazards[i].sprite)) then setHazardInactive(i)
			if GetSpriteX(hazards[i].sprite) > 130 then setHazardInactive(i)
			if hazards[i].hazardType = -3 then SetSpritePosition(hazards[i].sprite, 0, 0)
			if hazards[i].hazardType = -4 then SetSpritePosition(hazards[i].sprite, 0, 0)
		endif
	next i
	if gNextSpawn# < 0 then spawnHazard()
	if gNextEffect# < 5 
		if hazards[0].hazardType = -1 then warnHazard()
		if mod(gGameTime# * 10, 3) = 0
			SetSpriteColorAlpha(hazards[0].sprite, 0)
		else
			SetSpriteColorAlpha(hazards[0].sprite, 255)
		endif
	endif
	if gNextEffect# < 0 then startEffect()
endfunction

function collisionUpdate(i as integer)
	if hazards[i].hazardType = 0 //points hit
		inc p1.score, 500
		setHazardInactive(i)
		exitfunction
	elseif hazards[i].hazardType = 1  //enemy hit
		if p1.invincibleTime# > 0
		else
			dec p1.health, 3
			p1.invincibleTime# = 1.5
			if p1.health < 1 then gameOver()
		endif
		exitfunction
	elseif hazards[i].hazardType = 3 //health hit
		if p1.health < 10 then inc p1.health, 2		
		setHazardInactive(i)
		exitfunction
	elseif hazards[i].hazardType = -1 //inactive
		exitfunction
	endif
endfunction

function checkCollision(i as integer, j as integer)
	if i = j then exitfunction

	if GetSpriteCollision(hazards[i].sprite, hazards[j].sprite) = 1 
		resetHazard(i)
		exitfunction
	endif
	
	if hazards[i].hazardType = 1 //if it's an enemy
		if hazards[j].hazardType = 1 //and the one you're checking against is too
			if hazards[i].speed# < 0 //if it's coming from the left
				if hazards[j].speed# > 0 //and the other one is coming from the right
					SetSpriteSize(hazards[i].sprite, 400, 15)
					if GetSpriteCollision(hazards[i].sprite, hazards[j].sprite) = 1
						resetHazard(i)
						exitfunction
					endif
					SetSpriteSize(hazards[i].sprite, -1, 15)
				endif
			else //it's coming from the right
				if hazards[j].speed# < hazards[i].speed# //and the other one is moving slower than this one
					SetSpriteSize(hazards[j].sprite, 400, 15)
					if GetSpriteCollision(hazards[i].sprite, hazards[j].sprite) = 1
						resetHazard(i)
						SetSpriteSize(hazards[j].sprite, -1, 15)
						exitfunction
					endif
					SetSpriteSize(hazards[j].sprite, -1, 15)
				endif
			endif
		endif
	endif
	
endfunction

function setHazardInactive(i as integer)
	DeleteSprite(hazards[i].sprite)
	hazards[i].hazardType = -1
endfunction

function spawnHazard()
	for i = 1 to (gActiveHazards - 1)
		if hazards[i].hazardType = -1
			resetHazard(i)
			gNextSpawn# = random(3, 15)
			gNextSpawn# = gNextSpawn#/ gActiveHazards
			exitfunction
		endif
	next i
	gNextSpawn# = 0.5	
endfunction

function startEffect() //might change later so effects are based on level
	RNG = random(0,2)
	if RNG = 0
		cloudCover()
	elseif RNG = 1
		flashBomb()
	elseif RNG = 2
		antigrav()
	endif
	gNextEffect# = random(15, 45)
endfunction

function warnHazard()
	hazards[0].hazardType = 0
	hazards[0].sprite = CreateSprite(sprites.warning)
	SetSpritePosition(hazards[0].sprite, 90, 5)
	SetSpriteSize(hazards[0].sprite, -1, 15)
	SetSpriteDepth(hazards[0].sprite, 8)
	hazards[0].speed# = 0
endfunction

function cloudCover()
	DeleteSprite(hazards[0].sprite)
	hazards[0].hazardType = -2
	hazards[0].sprite = CreateSprite(sprites.cloud)
	setspritesize(hazards[0].sprite, -1, 85)
	setSpriteX(hazards[0].sprite, 110)
	SetSpriteY(hazards[0].sprite, 7.5)
	SetSpriteDepth(hazards[0].sprite, 9)
	SetSpriteColorAlpha(hazards[0].sprite, 0)
	hazards[0].speed# = gSpeed#
endfunction

function flashBomb()
	DeleteSprite(hazards[0].sprite)
	hazards[0].hazardType = -3
	hazards[0].sprite = CreateSprite(0)
	SetSpriteColorAlpha(hazards[0].sprite, 0)
	SetSpriteSize(hazards[0].sprite, 100, 100)
	SetSpritePosition(hazards[0].sprite, 0, 0)
	SetSpriteDepth(hazards[0].sprite, 8)
	hazards[0].speed# = 0.0
endfunction

function antigrav()
	DeleteSprite(hazards[0].sprite)
	hazards[0].hazardType = -1
	inc p1.antigravTime#, 5.0
	SetSpriteFlip(p1.sprite, 0, 1)
endfunction
