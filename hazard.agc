function createHazards()
    
    for i = 0 to 5
		resetHazard(i)
	next i
	
endfunction

function resetHazard( i as integer)
	hazardClock# = ( timer() - gGameTime#)
	hazardChance# = 80 * ( hazardClock# / 180) * 0.9
	SetTextString(hazardNumber, Str(hazardChance#))
	DeleteSprite(hazards[i].sprite)
		RNG = random(0, 99)
		if RNG > hazardChance#
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
		if GetSpriteCollision(hazards[i].sprite, p1.sprite) = 1
			collisionUpdate(hazards[i].hazardType)
			resetHazard(i)
		endif
		if GetSpriteX(hazards[i].sprite) < -20 then resetHazard(i)
	next i
endfunction

function collisionUpdate(i as integer)
	if i = 0 then inc p1.score
	if i = 1 then dec p1.health
endfunction
