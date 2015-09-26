function createPlayer ()
	p1.sprite = CreateSprite(sprites.player)
	SetSpriteSize(p1.sprite, -1, 15)
	SetSpritePosition(p1.sprite, 25, 50)
	SetSpriteShape(p1.sprite, 3)
	p1.velocity# = 0.0
	p1.invincibleTime# = 0.0
	p1.antigravTime# = 0.0
	p1.score = 0
	p1.health = 10
endfunction

function updatePlayer()
	select controlStyle
		case 0:
			if GetPointerState() = 1
				dec p1.velocity#, (75 * timeSinceLastTick#)
			else
				inc p1.velocity#, (60 * timeSinceLastTick#)
			endif
					
			if GetSpriteY(p1.sprite) < 0 //make sure it doesn't go out of bounds
				p1.velocity# = (0 - p1.velocity# * 0.9)
				
				if p1.invincibleTime# > 0
				else
					dec p1.health
					p1.invincibleTime# = 0.5
					if p1.health < 1 then gameOver()
				endif
				
				if p1.antigravTime# > 0
					if p1.velocity# > -35 then p1.velocity# = -35
				else
					if p1.velocity# < 35 then p1.velocity# = 35
				endif
			endif
			if GetSpriteY(p1.sprite) > 85 
				
				if p1.invincibleTime# > 0
				else
					dec p1.health
					p1.invincibleTime# = 0.5
					if p1.health < 1 then gameOver()
				endif
				
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
		endcase
		
		
		case 1:
			p1.velocity# = 0
			if p1.antigravTime# > 0
				if GetPointerState() = 1 then p1.target# =  100 - (GetPointerY() -7.5)
				dec p1.antigravTime#, timeSinceLastTick#
				if p1.antigravTime# = 0
					SetSpriteFlip(p1.sprite, 0, 0)
				elseif p1.antigravTime# < 0
					SetSpriteFlip(p1.sprite, 0, 0)
				endif
			else
				if GetPointerState() = 1 then p1.target# = GetPointerY() - 7.5
			endif
			
			if p1.target# > getSpriteY(p1.sprite) + 2.5
				setSpriteY(p1.sprite, getSpriteY(p1.sprite) + (25 * timeSinceLastTick#))
				SetSpriteAngle(p1.sprite, 5)
				if p1.target# < getSpriteY(p1.sprite) + 7.5 then p1.target# = GetSpriteY(p1.sprite)
			elseif p1.target# < getSpriteY(p1.sprite) - 2.5
				setSpriteY(p1.sprite, getSpriteY(p1.sprite) - (25 * timeSinceLastTick#))
				SetSpriteAngle(p1.sprite, -5)
				if p1.target# > getSpriteY(p1.sprite) + 7.5 then p1.target# = GetSpriteY(p1.sprite)
			else
				SetSpriteAngle(p1.sprite, 0)
			endif
			
		endcase
	endselect
	
	if p1.invincibleTime# > 0
		if mod(gGameTime# * 10, 3) = 0
			SetSpriteColorAlpha(p1.sprite, 0)
		else
			SetSpriteColorAlpha(p1.sprite, 255)
		endif
		dec p1.invincibleTime#, timeSinceLastTick#
		if p1.invincibleTime# < 0 then SetSpriteColorAlpha(p1.sprite, 255)
	endif
endfunction
