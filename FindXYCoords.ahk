#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

H::GoSub,MousePostion

MousePostion:
Coordmode,Tooltip,client
Coordmode,Mouse,client 
MouseGetPos,X,Y
Tooltip, Current Mouse Postion: %X%`,%Y%
Clipboard= x := %X% + rnd() `ny := %Y% + rnd()
SetTimer,ClearToolTip, 3000
Return

ClearToolTip:
SetTimer,ClearToolTip,Off
ToolTip,
Return