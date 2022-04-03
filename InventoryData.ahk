#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/* inventoryslots are sorted like an excel sheet:
A1 B1 C1 ... L1
A2 B2 C2 ... L2
A3 B3 C3 ... L3
A4 B4 C4 ... L4
A5 B5 C5 ... L5
*/

; function to generate a random offset for the x and y coordinate of the inventoryslots
rndOff()
{
Random, RandOff, -4, 4
return RandOff 
}

;----------------

A1x := 450 + rndOff()
A1y := 340 + rndOff()

A2x := 450 + rndOff()
A2y := 370 + rndOff()

A3x := 450 + rndOff()
A3y := 400 + rndOff()

A4x := 450 + rndOff()
A4y := 430 + rndOff()

A5x := 450 + rndOff()
A5y := 460 + rndOff()


B1x := 480 + rndOff()
B1y := 340 + rndOff()

B2x := 480 + rndOff()
B2y := 370 + rndOff()

B3x := 480 + rndOff()
B3y := 400 + rndOff()

B4x := 480 + rndOff()
B4y := 430 + rndOff()

B5x := 480 + rndOff()
B5y := 460 + rndOff()


C1x := 510 + rndOff()
C1y := 340 + rndOff()

C2x := 510 + rndOff()
C2y := 370 + rndOff()

C3x := 510 + rndOff()
C3y := 400 + rndOff()

C4x := 510 + rndOff()
C4y := 430 + rndOff()

C5x := 510 + rndOff()
C5y := 460 + rndOff()


D1x := 540 + rndOff()
D1y := 340 + rndOff()

D2x := 540 + rndOff()
D2y := 370 + rndOff()

D3x := 540 + rndOff()
D3y := 400 + rndOff()

D4x := 540 + rndOff()
D4y := 430 + rndOff()

D5x := 540 + rndOff()
D5y := 460 + rndOff()


E1x := 570 + rndOff()
E1y := 340 + rndOff()

E2x := 570 + rndOff()
E2y := 370 + rndOff()

E3x := 570 + rndOff()
E3y := 400 + rndOff()

E4x := 570 + rndOff()
E4y := 430 + rndOff()

E5x := 570 + rndOff()
E5y := 460 + rndOff()


F1x := 600 + rndOff()
F1y := 340 + rndOff()

F2x := 600 + rndOff()
F2y := 370 + rndOff()

F3x := 600 + rndOff()
F3y := 400 + rndOff()

F4x := 600 + rndOff()
F4y := 430 + rndOff()

F5x := 600 + rndOff()
F5y := 460 + rndOff()


G1x := 630 + rndOff()
G1y := 340 + rndOff()

G2x := 630 + rndOff()
G2y := 370 + rndOff()

G3x := 630 + rndOff()
G3y := 400 + rndOff()

G4x := 630 + rndOff()
G4y := 430 + rndOff()

G5x := 630 + rndOff()
G5y := 460 + rndOff()


H1x := 660 + rndOff()
H1y := 340 + rndOff()

H2x := 660 + rndOff()
H2y := 370 + rndOff()

H3x := 660 + rndOff()
H3y := 400 + rndOff()

H4x := 660 + rndOff()
H4y := 430 + rndOff()

H5x := 660 + rndOff()
H5y := 460 + rndOff()


I1x := 690 + rndOff()
I1y := 340 + rndOff()

I2x := 690 + rndOff()
I2y := 370 + rndOff()

I3x := 690 + rndOff()
I3y := 400 + rndOff()

I4x := 690 + rndOff()
I4y := 430 + rndOff()

I5x := 690 + rndOff()
I5y := 460 + rndOff()


J1x := 715 + rndOff()
J1y := 340 + rndOff()

J2x := 715 + rndOff()
J2y := 370 + rndOff()

J3x := 715 + rndOff()
J3y := 400 + rndOff()

J4x := 715 + rndOff()
J4y := 430 + rndOff()

J5x := 715 + rndOff()
J5y := 460 + rndOff()


K1x := 745 + rndOff()
K1y := 340 + rndOff()

K2x := 745 + rndOff()
K2y := 370 + rndOff()

K3x := 745 + rndOff()
K3y := 400 + rndOff()

K4x := 745 + rndOff()
K4y := 430 + rndOff()

K5x := 745 + rndOff()
K5y := 460 + rndOff()


L1x := 775 + rndOff()
L1y := 340 + rndOff()

L2x := 775 + rndOff()
L2y := 370 + rndOff()

L3x := 775 + rndOff()
L3y := 400 + rndOff()

L4x := 775 + rndOff()
L4y := 430 + rndOff()

L5x := 775 + rndOff()
L5y := 460 + rndOff()




































































