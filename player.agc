function createPlayer ()
	p1.sprite = CreateSprite(LoadImage("frame-1.png"))
	SetSpriteSize(p1.sprite, -1, 15)
	SetSpritePosition(p1.sprite, 10, 50)
	p1.velocity# = 0.0
	p1.score = 0
	//SetSpriteVisible(p1.sprite, 0)
	p1.health = 3
endfunction
