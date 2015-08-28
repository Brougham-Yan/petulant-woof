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
