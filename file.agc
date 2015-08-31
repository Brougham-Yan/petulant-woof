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
