function makeBackground()
	bg.foreground1 = CreateSprite(sprites.stars)
	bg.foreground2 = CreateSprite(sprites.stars)
	bg.background1 = CreateSprite(sprites.background)
	bg.background2 = CreateSprite(sprites.background)
	
	//SetSpriteColorAlpha(bg.foreground1, 0)
	//SetSpriteColorAlpha(bg.foreground2, 0)
	
	SetSpriteSize(bg.foreground1, 100, 100)
	SetSpriteSize(bg.foreground2, 100, 100)
	SetSpriteSize(bg.background1, 100, 100)
	SetSpriteSize(bg.background2, 100, 100)
	
	SetSpriteX(bg.foreground2, 100)
	SetSpriteX(bg.background2, 100)	
	
	bg.red# = 220
	bg.green# = 83
	bg.blue# = 13
	
	SetSpriteColor(bg.background1, bg.red#, bg.green#, bg.blue#, 255)
	SetSpriteColor(bg.background1, bg.red#, bg.green#, bg.blue#, 255)
	
	SetSpriteDepth(bg.background1, 101)
	SetSpriteDepth(bg.background2, 101)
	SetSpriteDepth(bg.foreground1, 100)
	SetSpriteDepth(bg.foreground2, 100)
endfunction

function updateBackground()
	SetSpriteX(bg.foreground1, GetSpriteX(bg.foreground1) - (gSpeed# * timeSinceLastTick# * 0.05))
	SetSpriteX(bg.foreground2, GetSpriteX(bg.foreground2) - (gSpeed# * timeSinceLastTick# * 0.05))
	SetSpriteX(bg.background1, GetSpriteX(bg.background1) - (gSpeed# * timeSinceLastTick# * 0.005))
	SetSpriteX(bg.background2, GetSpriteX(bg.background2) - (gSpeed# * timeSinceLastTick# * 0.005))
	if GetSpriteX(bg.foreground1) < - 100 then SetSpriteX(bg.foreground1, GetSpriteX(bg.foreground1) + 100)
	if GetSpriteX(bg.foreground1) < 0 then SetSpriteX(bg.foreground2, GetSpriteX(bg.foreground1) + 100)
	if GetSpriteX(bg.background1) < - 100 then SetSpriteX(bg.background1, GetSpriteX(bg.background1) + 100)
	if GetSpriteX(bg.background1) < 0 then SetSpriteX(bg.background2, GetSpriteX(bg.background1) + 100)
	
	if bg.red# > bg.targetRed# 
		dec bg.red#, timeSinceLastTick# * 9
	else
		inc bg.red#, timeSinceLastTick# * 9
	endif
	if bg.green# > bg.targetGreen# 
		dec bg.green#, timeSinceLastTick# * 9
	else
		inc bg.green#, timeSinceLastTick# * 9
	endif
	if bg.blue# > bg.targetBlue# 
		dec bg.blue#, timeSinceLastTick# * 9
	else
		inc bg.blue#, timeSinceLastTick# * 9
	endif
	
	SetSpriteColor(bg.background1, bg.red#, bg.green#, bg.blue#, 255)
	SetSpriteColor(bg.background2, bg.red#, bg.green#, bg.blue#, 255)
endfunction

function updateColours(r#, g#, b#)
	bg.targetRed# = r#
	bg.targetGreen# = g#
	bg.targetBlue# = b#
endfunction
