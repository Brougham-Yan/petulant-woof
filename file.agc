function writeScores()
	file = OpenToWrite("scores.dat")
	WriteInteger(file, gHighScore)
	CloseFile(file)
endfunction

function resetScores()
	file = OpenToWrite("scores.dat")
	writeInteger(file, 0)
	CloseFile(file)
endfunction

function readScores()
	if GetFileExists("scores.dat") = 1
		file = OpenToRead("scores.dat")
		gHighScore = ReadInteger(file)
		CloseFile(file)
	else
		resetScores()
	endif
endfunction

function loadSprites()
	sprites.player = LoadImage("spaceship.png")
	sprites.monster = LoadImage("ufo.png")
	sprites.strawberry = LoadImage("strawberry.png")
	sprites.cloud = LoadImage("cloud.png")
	sprites.popsicle = LoadImage("cherry.png")
	sprites.background = LoadImage("background.png")
	sprites.warning = LoadImage("warning.png")
endfunction
