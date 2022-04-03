#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
Coordmode,Mouse,Client 
SendMode Input
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
#Include RandomBezier.ahk 
#Include InventoryData.ahk
#Include FunctionsFromAhk2.ahk
;WinGetClientPos is backported from ahk2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;randombezier creates a more humanlike mousemovement
; T500 is time in ms for the mouse move eg 500 milliseconds

; put all xy from inventorydata into an array, for topleft invslot u need array index 1 and 2 for bottom right 119 and 120
;see InventoryData.ahk for more details
arrayInvXY := [A1x, A1y, A2x, A2y, A3x, A3y, A4x, A4y, A5x, A5y, B1x, B1y, B2x, B2y, B3x, B3y, B4x, B4y, B5x, B5y, C1x, C1y, C2x, C2y, C3x, C3y, C4x, C4y, C5x, C5y, D1x, D1y, D2x, D2y, D3x, D3y, D4x, D4y, D5x, D5y, E1x, E1y, E2x, E2y, E3x, E3y, E4x, E4y, E5x, E5y, F1x, F1y, F2x, F2y, F3x, F3y, F4x, F4y, F5x, F5y, G1x, G1y, G2x, G2y, G3x, G3y, G4x, G4y, G5x, G5y, H1x, H1y, H2x, H2y, H3x, H3y, H4x, H4y, H5x, H5y, I1x, I1y, I2x, I2y, I3x, I3y, I4x, I4y, I5x, I5y, J1x, J1y, J2x, J2y, J3x, J3y, J4x, J4y, J5x, J5y, K1x, K1y, K2x, K2y, K3x, K3y, K4x, K4y, K5x, K5y, L1x, L1y, L2x, L2y, L3x, L3y, L4x, L4y, L5x, L5y]

; create a random sleep delay which is randomized each time sleep is called
RandMs1Min := 200
RandMs1Max := 300

RandSleep(x,y) 
{
    Random, rand, %x%, %y%
    Sleep %rand%
}

; xy of the top left beast in the beastary book (+ random offset, see invdata.ahk)
BeastX := 100 + rndOff()
BeastY := 200 + rndOff()

; check if game is 800x600 windowed mode; 0x14CF0000 is windowed, not minimized etc
checkWindow()
{
    
    WinGetClientPos(WindowX,WindowY,WindowWidth,WindowHeight,"Path of Exile")
    WinGet, vWinStyle, Style, Path of Exile
    if  (WindowWidth != 800 or WindowHeight != 600 or vWinStyle != 0x14CF0000)
    {
        MsgBox, Error: set game to 800x600 windowed mode!
        ExitApp  
    }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;hotkeys;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; store 10 beasts in bestiary orbs +++++++++++++++++++++++++++++++++++++++++++++
F5::
WinActivate, Path of Exile
checkWindow()
;we start putting beasts in colum "B" then into "C", "D" etc, 
;we dont start in colum "A" so instead of i= 1 we start i = 11 
;since Arraykey 11 and 12 hold info for: B1X and B1Y 

i := 11

Loop, 10  
{
;pick Bestiary Orbs from A1
RandomBezier( 0, 0, A1x, A1y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)
}
return

; store 20 beasts in bestiary orbs +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
F6::
WinActivate, Path of Exile
checkWindow()

;we start putting beast in colum "B" then into "C", "D" etc, 
;we dont start in colum "A" so instead of i= 1 we start i = 11 
;since Arraykey 11 and 12 hold info for: B1X and B1Y 

i := 11

Loop, 10  
{
;pick Bestiary Orbs from A1
RandomBezier( 0, 0, A1x, A1y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}


;start with i = 31 since already but 5 beats in 2. and 3. columns
i := 31

Loop, 10  
{
;pick Bestiary Orbs from A2
RandomBezier( 0, 0, A2x, A2y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}
return

; store 30 beasts in bestiary orbs +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
F7::
WinActivate, Path of Exile
checkWindow()

;we start putting beast in colum "B" then into "C", "D" etc, 
;we dont start in colum "A" so instead of i= 1 we start i = 11 
;since Arraykey 11 and 12 hold info for: B1X and B1Y 

i := 11

Loop, 10  
{
;pick Bestiary Orbs from A1
RandomBezier( 0, 0, A1x, A1y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}


;start with i = 31 since already but 5 beats in 2. and 3. columns
i := 31

Loop, 10  
{
;pick Bestiary Orbs from A2
RandomBezier( 0, 0, A2x, A2y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}

;start with i = 51 since already but 5 beats in 2. 3. 4. 5. columns
i := 51

Loop, 10  
{
;pick Bestiary Orbs from A3
RandomBezier( 0, 0, A3x, A3y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}
return

; store 40 beasts in bestiary orbs +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
F8::
WinActivate, Path of Exile
checkWindow()

;we start putting beast in colum "B" then into "C", "D" etc, 
;we dont start in colum "A" so instead of i= 1 we start i = 11 
;since Arraykey 11 and 12 hold info for: B1X and B1Y 

i := 11

Loop, 10  
{
;pick Bestiary Orbs from A1
RandomBezier( 0, 0, A1x, A1y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}


;start with i = 31 since already but 5 beats in 2. and 3. columns
i := 31

Loop, 10  
{
;pick Bestiary Orbs from A2
RandomBezier( 0, 0, A2x, A2y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}

;start with i = 51 since already but 5 beats in 2. 3. 4. 5. columns
i := 51

Loop, 10  
{
;pick Bestiary Orbs from A3
RandomBezier( 0, 0, A3x, A3y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}

;start with i = 71 since already but 5 beats in 2. 3. 4. 5. 6 7 columns
i := 71

Loop, 10  
{
;pick Bestiary Orbs from A4
RandomBezier( 0, 0, A4x, A4y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}
return

; store 50 beasts in bestiary orbs +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
F9::
WinActivate, Path of Exile
checkWindow()

;we start putting beast in colum "B" then into "C", "D" etc, 
;we dont start in colum "A" so instead of i= 1 we start i = 11 
;since Arraykey 11 and 12 hold info for: B1X and B1Y 

i := 11

Loop, 10  
{
;pick Bestiary Orbs from A1
RandomBezier( 0, 0, A1x, A1y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}


;start with i = 31 since already but 5 beats in 2. and 3. columns
i := 31

Loop, 10  
{
;pick Bestiary Orbs from A2
RandomBezier( 0, 0, A2x, A2y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}

;start with i = 51 since already but 5 beats in 2. 3. 4. 5. columns
i := 51

Loop, 10  
{
;pick Bestiary Orbs from A3
RandomBezier( 0, 0, A3x, A3y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}

;start with i = 71 since already but 5 beats in 2. 3. 4. 5. 6 7 columns
i := 71

Loop, 10  
{
;pick Bestiary Orbs from A4
RandomBezier( 0, 0, A4x, A4y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}

;start with i = 91 since already but 5 beats in 2. 3. 4. 5. 6 7 9  columns
i := 91

Loop, 10  
{
;pick Bestiary Orbs from A5
RandomBezier( 0, 0, A5x, A5y, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click, Right
RandSleep(RandMs1Min,RandMs1Max)
;orberize beast from book
RandomBezier( 0, 0, BeastX, BeastY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

;put orb into inventory
;get xy of invslot

InvSlotX := arrayInvXY[i]
i++
InvSlotY := arrayInvXY[i]
i++
RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
RandSleep(RandMs1Min,RandMs1Max)
Click
RandSleep(RandMs1Min,RandMs1Max)

}
return




ESC::EXITAPP