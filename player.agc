function createPlayer ()
	p1.sprite = CreateSprite(sprites.player)
	SetSpriteSize(p1.sprite, -1, 15)
	SetSpritePosition(p1.sprite, 25, 50)
	p1.velocity# = 0.0
	p1.invincibleTime# = 0.0
	p1.antigravTime# = 0.0
	p1.score = 0
	p1.health = 3
endfunction

function updatePlayer()
	if GetPointerState() = 1
		dec p1.velocity#, (75 * timeSinceLastTick#)
	else
		inc p1.velocity#, (60 * timeSinceLastTick#)
	endif
	
	if GetSpriteY(p1.sprite) < 0 //make sure it doesn't go out of bounds
		p1.velocity# = (0 - p1.velocity# * 0.9)
		if p1.antigravTime# > 0
			if p1.velocity# > -35 then p1.velocity# = -35
		else
			if p1.velocity# < 35 then p1.velocity# = 35
		endif
	endif
	if GetSpriteY(p1.sprite) > 85 
		p1.velocity# = (0 - p1.velocity# * 0.9)
		if p1.antigravTime# > 0
			if p1.velocity# < 35 then p1.velocity# = 35
		else
			if p1.velocity# > -35 then p1.velocity# = -35
		endif
	endif
	
	if p1.antigravTime# > 0
		SetSpriteAngle(p1.sprite, -p1.velocity#/1.5)
		SetSpritePosition(p1.sprite, 25, GetSpriteY(p1.sprite) + (-p1.velocity# * timeSinceLastTick#))
		dec p1.antigravTime#, timeSinceLastTick#
		if p1.antigravTime# = 0
			SetSpriteFlip(p1.sprite, 0, 0)
		elseif p1.antigravTime# < 0
			SetSpriteFlip(p1.sprite, 0, 0)
		endif
	else
		SetSpriteAngle(p1.sprite, p1.velocity#/1.5)
		SetSpritePosition(p1.sprite, 25, GetSpriteY(p1.sprite) + (p1.velocity# * timeSinceLastTick#))
	endif
	if p1.invincibleTime# > 0
		if mod(timer()*10, 3) = 0
			SetSpriteColorAlpha(p1.sprite, 0)
		else
			SetSpriteColorAlpha(p1.sprite, 255)
			dec p1.invincibleTime#, timeSinceLastTick#
		endif
	endif
endfunction
