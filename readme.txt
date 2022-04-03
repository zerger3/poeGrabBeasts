Script clicks bestiary orb in your inventory, clicks on top left beast in beastiry book and puts it into the inventory.

run GrabBeast.ahk
run game in 800x600 windowed mode 


open beast book, filter beasts you want to put into beastary orbs
have inventory open and at least 10 beastary orbs in top left inventory slot
have empty inventory
if u want to put 20 beast into orbs then have 10 orbs in topleft slot and 10 more below it etc

Hotkeys:
F5 to put 10 beasts into orbs 
F6 to put 20 beasts into orbs
...
F9 to put 50 beasts into orbs  
ESC will stop/close the script


if ur coords are fucked edit inventoryslots.ahk, u can use the findxycoords.ahk script
"client" coordinates are used not screen or window

RandomBezier( 0, 0, InvSlotX, InvSlotY, "T500 RO")
is a more humanlike mousemove function. see RandomBezier.ahk for more details
T500: the time it takes the cursor to move from current postion to target position in milliseconds (1second = 1000 milliseconds) 
if u want faster movement, change these values in Grabbeasts.ahk
