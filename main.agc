
// Project: Strawbirdie+ 
// Created: 2015-08-11

// set window properties
SetWindowTitle( "Strawbirdie+" )
SetWindowSize( 1024, 768, 0 )

// set display properties
SetVirtualResolution( 1024, 768 )
SetOrientationAllowed( 1, 1, 1, 1 )



do
    

    Print( ScreenFPS() )
    Sync()
loop
