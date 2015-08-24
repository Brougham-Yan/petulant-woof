function makeBackground()
	bg.foreground1 = CreateSprite(0)
	bg.foreground2 = CreateSprite(0)
	bg.background1 = CreateSprite(0)
	bg.background2 = CreateSprite(0)
	
	SetSpriteColorAlpha(bg.foreground1, 0)
	SetSpriteColorAlpha(bg.foreground2, 0)
	
	SetSpriteSize(bg.foreground1, 100, 100)
	SetSpriteSize(bg.foreground2, 100, 100)
	SetSpriteSize(bg.background1, 100, 100)
	SetSpriteSize(bg.background2, 100, 100)
	
	SetSpriteX(bg.foreground2, 100)
	SetSpriteX(bg.background2, 100)	
	
	bg.red# = 55
	bg.green# = 55
	bg.blue# = 36
	
	SetSpriteColor(bg.background1, 55, 55, 36, 255)
	SetSpriteColor(bg.background1, 55, 55, 36, 255)
	
	SetSpriteDepth(bg.background1, 101)
	SetSpriteDepth(bg.background2, 101)
	SetSpriteDepth(bg.foreground1, 100)
	SetSpriteDepth(bg.foreground2, 100)
endfunction

function updateBackground()
	SetSpriteX(bg.foreground1, GetSpriteX(bg.foreground1) - (gSpeed# * timeSinceLastTick#))
	SetSpriteX(bg.foreground2, GetSpriteX(bg.foreground2) - (gSpeed# * timeSinceLastTick#))
	SetSpriteX(bg.background1, GetSpriteX(bg.background1) - (gSpeed# * timeSinceLastTick# * 0.1))
	SetSpriteX(bg.background2, GetSpriteX(bg.background2) - (gSpeed# * timeSinceLastTick# * 0.1))
	if GetSpriteX(bg.foreground1) < - 100 then SetSpriteX(bg.foreground1, GetSpriteX(bg.foreground1) + 100)
	if GetSpriteX(bg.foreground1) < 0 then SetSpriteX(bg.foreground2, GetSpriteX(bg.foreground1) + 100)
	if GetSpriteX(bg.background1) < - 100 then SetSpriteX(bg.background1, GetSpriteX(bg.background1) + 100)
	if GetSpriteX(bg.background1) < 0 then SetSpriteX(bg.background2, GetSpriteX(bg.background1) + 100)
	
	select gActiveHazards
		case 6:
			updateColours(55, 55, 36)
		endcase
		case 7:
			updateColours(216, 152, 82)
		endcase
		case 8:
			updateColours(22, 206, 226)
		endcase
		case 9:
			updateColours(124, 115, 242)
		endcase
		case 10:
			updateColours(84, 201, 50)
		endcase
	endselect
endfunction

function updateColours(r#, g#, b#)
	if bg.red# > r# 
		dec bg.red#, timeSinceLastTick# * 7
	else
		inc bg.red#, timeSinceLastTick# * 7
	endif
	if bg.green# > g# 
		dec bg.green#, timeSinceLastTick# * 7
	else
		inc bg.green#, timeSinceLastTick# * 7
	endif
	if bg.blue# > b# 
		dec bg.blue#, timeSinceLastTick# * 7
	else
		inc bg.blue#, timeSinceLastTick# * 7
	endif
	
	SetSpriteColor(bg.background1, bg.red#, bg.green#, bg.blue#, 255)
	SetSpriteColor(bg.background2, bg.red#, bg.green#, bg.blue#, 255)
endfunction
