function createHazards()
    
    for i = 0 to 5
		hazards[i].hazardType = -1
	next i
	
endfunction

function resetHazard( i as integer)
	hazardChance# = pow(0.95, ( gGameTime#/ 12 )) * 90
	if hazardChance# < 60 then hazardChance# = 60
	//hazardChance# = 80 *  * 0.9
	DeleteSprite(hazards[i].sprite)
		RNG = random(0, 99)
		if RNG < 10
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
			if random(0,9) < 3
				hazards[i].hazardType = 2 // cloud
				hazards[i].sprite = CreateSprite(sprites.cloud)
				hazards[i].speed# = gSpeed#
				SetSpriteSize(hazards[i].sprite, -1, 18)
				SetSpritePosition(hazards[i].sprite, 110, random(5, 77))
			else
				hazards[i].hazardType = 1 //bird
				hazards[i].sprite = CreateSprite(sprites.monster)
				SetSpriteSize(hazards[i].sprite, -1, 15)
				if random(0,9) < 3
					SetSpritePosition(hazards[i].sprite, -25, random(5, 80))
					hazards[i].speed# = -gSpeed# * 0.4
				else
					SetSpritePosition(hazards[i].sprite, 110, random(5, 80))
					hazards[i].speed# = gSpeed# * 1.4
					SetSpriteFlip(hazards[i].sprite, 1, 0)
				endif
			endif
		endif
	SetSpriteDepth(hazards[i].sprite, 50)
	
	for j = 0 to 5
		checkCollision(i, j)
	next j		
endfunction

function updateHazards()
	for i = 0 to 5
		if hazards[i].hazardType = -1
		else
			if hazards[i].hazardType = -2
				alpha = GetSpriteColorAlpha(hazards[i].sprite)
				if alpha < 251 then SetSpriteColorAlpha(hazards[i].sprite, alpha + 5)
			endif
			SetSpritePosition(hazards[i].sprite, GetSpriteX(hazards[i].sprite) - (hazards[i].speed# * timeSinceLastTick#), GetSpriteY(hazards[i].sprite))
			if GetSpriteCollision(hazards[i].sprite, p1.sprite) = 1
				collisionUpdate(i)
			endif		
			if GetSpriteX(hazards[i].sprite) < (-15 - GetSpriteWidth(hazards[i].sprite)) then setHazardInactive(i)
			if GetSpriteX(hazards[i].sprite) > 115 then setHazardInactive(i)
		endif
	next i
	
	gNextSpawn# = (gNextSpawn# - timeSinceLastTick#)
	if gNextSpawn# < 0 then spawnHazard()
endfunction

function collisionUpdate(i as integer)
	if hazards[i].hazardType = 0
		inc p1.score
		setHazardInactive(i)
		exitfunction
	elseif hazards[i].hazardType = 1 
		if p1.invincibleTime# > 0
		else
			dec p1.health
			p1.invincibleTime# = 1.5
			if p1.health < 1 then gameOver()
		endif
		exitfunction
	elseif hazards[i].hazardType = 3
		inc p1.health
		if p1.health > 5 then p1.health = 5
		setHazardInactive(i)
		exitfunction
	elseif hazards[i].hazardType = 2 
		cloudCover(i)
		exitfunction
	elseif hazards[i].hazardType = -1
		exitfunction
	endif
endfunction

function checkCollision(i as integer, j as integer)
	if i = j then exitfunction
	if hazards[j].hazardType = -2 then exitfunction
	if GetSpriteCollision(hazards[i].sprite, hazards[j].sprite) = 1 then resetHazard(i)
endfunction

function setHazardInactive(i as integer)
	DeleteSprite(hazards[i].sprite)
	hazards[i].hazardType = -1
endfunction

function spawnHazard()
	for i = 0 to 5
		if hazards[i].hazardType = -1
			resetHazard(i)
			gNextSpawn# = random(5, 20)
			gNextSpawn# = gNextSpawn#/10
			exitfunction
		endif
	next i
	gNextSpawn# = 0.5	
endfunction

function cloudCover(i as integer)
	hazards[i].hazardType = -2
	setspritesize(hazards[i].sprite, -1, 85)
	SetSpriteY(hazards[i].sprite, 7.5)
	SetSpriteDepth(hazards[i].sprite, 9)
	SetSpriteColorAlpha(hazards[i].sprite, 0)
endfunction
