;==================================================

;AHK v2 functions for AHK v1
;[first released: 2017-03-26]
;[updated: 2018-04-05]

;use at your own risk
;warning: the RegDelete/RegDeleteKey/RegWrite functions are untested

;link:
;commands as functions (AHK v2 functions for AHK v1) - AutoHotkey Community
;https://autohotkey.com/boards/viewtopic.php?f=37&t=29689

;functions from AHK v2 not replicated:
;GuiCreate
;GuiCtrlFromHwnd
;GuiFromHwnd
;MenuCreate
;MenuFromHandle

;known issues/limitations:
;CallbackCreate - less functionality than the AHK v2 function
;ClipboardAll - binary variable
;FileAppend - binary variable (RAW)
;FileInstall - will only perform a FileCopy
;FileRead - binary variable (RAW)
;(IniRead) - AHK v2 handles a default value of multiple spaces as a blank
;InputBox - password character
;InputEnd - doesn't fully match AHK v2 function
;ListVars - can only list global variables
;(PostMessage/SendMessage) - currently do not support Var to mean &Var
;Type - doesn't fully match AHK v2 function (and misidentifies a Float as a String)
;WinGetClientPos - not giving the same results as AHK v2
;(WinWait/WinWaitActive) - I've assumed that WinWait/WinWaitActive will return an hWnd in future

;see also (re. functions):
;GitHub - cocobelgica/AutoHotkey-Future: Port of AutoHotkey v2.0-a built-in functions for AHK v1.1+
;https://github.com/cocobelgica/AutoHotkey-Future
;AutoHotkey-Future/Lib at master · cocobelgica/AutoHotkey-Future · GitHub
;https://github.com/cocobelgica/AutoHotkey-Future/tree/master/Lib
;Default/Portable installation StdLib - AutoHotkey Community
;https://autohotkey.com/boards/viewtopic.php?f=13&t=10434

;see also (re. GUIs):
;objects: backport AHK v2 Gui/Menu classes to AHK v1 - AutoHotkey Community
;https://autohotkey.com/boards/viewtopic.php?f=37&t=43530

;==================================================

BlockInput(Mode)
{
    if Mode in 1,0
        Mode := Mode ? "On" : "Off"
    BlockInput %Mode%
}
CallbackCreate(Function, Options:="", ParamCount:="")
{
    return RegisterCallback(Function, Options, ParamCount)
}
CallbackFree(Address)
{
    DllCall("kernel32\GlobalFree", Ptr,Address, Ptr)
}
CaretGetPos(ByRef OutputVarX:="", ByRef OutputVarY:="")
{
    local GUITHREADINFO, hWnd, hWndC, Mode, OriginX, OriginY, POINT, RECT, TID
    ;this works but there was an issue regarding A_CaretX/A_CaretY not updating correctly:
    ;OutputVarX := A_CaretX, OutputVarY := A_CaretY
    hWnd := WinExist("A")
    VarSetCapacity(GUITHREADINFO, A_PtrSize=8?72:48, 0)
    NumPut(A_PtrSize=8?72:48, &GUITHREADINFO, 0, "UInt") ;cbSize
    TID := DllCall("user32\GetWindowThreadProcessId", Ptr,hWnd, UIntP,0, UInt)
    DllCall("user32\GetGUIThreadInfo", UInt,TID, Ptr,&GUITHREADINFO)
    hWndC := NumGet(&GUITHREADINFO, A_PtrSize=8?48:28, "Ptr") ;hwndCaret
    OutputVarX := NumGet(&GUITHREADINFO, A_PtrSize=8?56:32, "Int") ;rcCaret ;x
    OutputVarY := NumGet(&GUITHREADINFO, A_PtrSize=8?60:36, "Int") ;rcCaret ;y
    Mode := SubStr(A_CoordModeCaret, 1, 1)
    VarSetCapacity(POINT, 8)
    NumPut(OutputVarX, &POINT, 0, "Int")
    NumPut(OutputVarY, &POINT, 4, "Int")
    DllCall("user32\ClientToScreen", Ptr,hWndC, Ptr,&POINT)
    OutputVarX := NumGet(&POINT, 0, "Int")
    OutputVarY := NumGet(&POINT, 4, "Int")
    if (Mode = "S") ;screen
        return
    else if (Mode = "C") ;client
    {
        VarSetCapacity(POINT, 8, 0)
        DllCall("user32\ClientToScreen", Ptr,hWnd, Ptr,&POINT)
        OriginX := NumGet(&POINT, 0, "Int")
        OriginY := NumGet(&POINT, 4, "Int")
    }
    else if (Mode = "W") ;window
    {
        VarSetCapacity(RECT, 16, 0)
        DllCall("user32\GetWindowRect", Ptr,hWnd, Ptr,&RECT)
        OriginX := NumGet(&RECT, 0, "Int")
        OriginY := NumGet(&RECT, 4, "Int")
    }
    OutputVarX -= OriginX, OutputVarY -= OriginY
}
Click(Params*)
{
    local i, Param, Args
    for i, Param in Params
        Args .= " " . Param
    Click %Args%
}
ClipboardAll(Data:="", Size:="")
{
    ;this function allows the ClipboardAll function to appear in an AHK v1 script without crashing it
    MsgBox warning: the ClipboardAll function doesn't work in AutoHotkey v1
}
ClipWait(SecondsToWait:="", Param:=1)
{
    ClipWait %SecondsToWait%, %Param%
    return !ErrorLevel
}
ControlAddItem(String, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local Hwnd, Class
    Control Add, %String%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if ErrorLevel
        return
    ControlGet Hwnd, Hwnd,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    WinGetClass Class, ahk_id %Hwnd%
    if InStr(Class, "ListBox")
        SendMessage 0x18B, 0, -1, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText% ;LB_GETCOUNT
    else if InStr(Class, "ComboBox")
        SendMessage 0x146, 0, -1, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText% ;CB_GETCOUNT
    return ErrorLevel
}
ControlChoose(N, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local Hwnd, Class
    ControlGet Hwnd, Hwnd,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    WinGetClass Class, ahk_id %Hwnd%
    if !(N = 0)
        Control Choose, %N%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    else if InStr(Class, "ListBox")
        SendMessage 0x185, 0, -1, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText% ;LB_SETSEL
    else if InStr(Class, "ComboBox")
        SendMessage 0x14E, 0, -1, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText% ;CB_SETCURSEL
    else
        ErrorLevel := 1
}
ControlChooseString(String, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local Hwnd, Class
    Control ChooseString, %String%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if ErrorLevel
        return
    ControlGet Hwnd, Hwnd,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    WinGetClass Class, ahk_id %Hwnd%
    if InStr(Class, "ListBox")
        SendMessage 0x188, 0, -1, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText% ;LB_GETCURSEL
    else InStr(Class, "ComboBox")
        SendMessage 0x147, 0, -1, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText% ;CB_GETCURSEL
    return ErrorLevel+1
}
ControlClick(ControlOrPos:="", WinTitle:="", WinText:="", WhichButton:="", ClickCount:="", Options:="", ExcludeTitle:="", ExcludeText:="")
{
    ControlClick %ControlOrPos%, %WinTitle%, %WinText%, %WhichButton%, %ClickCount%, %Options%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
ControlDeleteItem(String, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    Control Delete, %String%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlEditPaste(String, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    Control EditPaste, %String%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlFindItem(String, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, FindString, %String%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlFocus(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    ControlFocus %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
ControlGetChecked(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, Checked,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetChoice(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, Choice,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetCurrentCol(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, CurrentCol,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetCurrentLine(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, CurrentLine,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetEnabled(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, Enabled,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetExStyle(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, ExStyle,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetFocus(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGetFocus OutputVar, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if !ErrorLevel
        return OutputVar
}
ControlGetHwnd(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, Hwnd,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetLine(Index, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, Line, %Index%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetLineCount(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, LineCount,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetList(Options:="", Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, List, %Options%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetPos(ByRef X:="", ByRef Y:="", ByRef Width:="", ByRef Height:="", Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    ControlGetPos X, Y, Width, Height, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlGetSelected(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, Selected,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetStyle(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, Style,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetTab(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, Tab,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlGetText(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGetText OutputVar, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if !ErrorLevel
        return OutputVar
}
ControlGetVisible(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    ControlGet OutputVar, Visible,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
ControlHide(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    Control Hide,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlHideDropDown(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    Control HideDropDown,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlMove(X:="", Y:="", Width:="", Height:="", Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    ControlMove %Control%, %X%, %Y%, %Width%, %Height%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
ControlSend(Keys, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    ControlSend %Control%, %Keys%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
ControlSendRaw(Keys, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    ControlSendRaw %Control%, %Keys%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
ControlSetChecked(TrueFalseToggle, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local Boolean
    ControlGet Boolean, Checked,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if (TrueFalseToggle = "Toggle" || TrueFalseToggle == "-1")
        TrueFalseToggle := !Boolean
    if (TrueFalseToggle = "On" || TrueFalseToggle == "1")
        Control Check,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    else if (TrueFalseToggle = "Off" || TrueFalseToggle == "0")
        Control Uncheck,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlSetEnabled(TrueFalseToggle, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local Boolean
    ControlGet Boolean, Enabled,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if (TrueFalseToggle = "Toggle" || TrueFalseToggle == "-1")
        TrueFalseToggle := !Boolean
    if (TrueFalseToggle = "On" || TrueFalseToggle == "1")
        Control Enable,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    else if (TrueFalseToggle = "Off" || TrueFalseToggle == "0")
        Control Disable,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlSetExStyle(Value, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    Control ExStyle, %Value%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlSetStyle(Value, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    Control Style, %Value%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlSetTab(N, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    SendMessage 0x1330, %N%,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText% ;TCM_SETCURFOCUS
    Sleep 0
    SendMessage 0x130C, %N%,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText% ;TCM_SETCURSEL
}
ControlSetText(NewText, Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    ControlSetText %Control%, %NewText%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
ControlShow(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    Control Show,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlShowDropDown(Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    Control ShowDropDown,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
CoordMode(Param1, Param2:="Screen")
{
    CoordMode %Param1%, %Param2%
}
Critical(Param:="")
{
    Critical %Param%
}
DateAdd(DateTime, Time, TimeUnits)
{
    EnvAdd DateTime, %Time%, %TimeUnits%
    return DateTime
}
DateDiff(DateTime1, DateTime2, TimeUnits)
{
    EnvSub DateTime1, %DateTime2%, %TimeUnits%
    return DateTime1
}
DetectHiddenText(OnOrOff)
{
    if OnOrOff in 1,0
        OnOrOff := OnOrOff ? "On" : "Off"
    DetectHiddenText %OnOrOff%
}
DetectHiddenWindows(OnOrOff)
{
    if OnOrOff in 1,0
        OnOrOff := OnOrOff ? "On" : "Off"
    DetectHiddenWindows %OnOrOff%
}
DirCopy(Source, Dest, Flag:=0)
{
    FileCopyDir %Source%, %Dest%, %Flag%
    return !ErrorLevel
}
DirCreate(DirName)
{
    FileCreateDir %DirName%
    return !ErrorLevel
}
DirDelete(DirName, Recurse:=0)
{
    FileRemoveDir %DirName%, %Recurse%
    return !ErrorLevel
}
DirExist(FilePattern)
{
    local AttributeString := FileExist(FilePattern)
    return InStr(AttributeString, "D") ? AttributeString : ""
}
DirMove(Source, Dest, Flag:=0)
{
    FileMoveDir %Source%, %Dest%, %Flag%
    return !ErrorLevel
}
DirSelect(StartingFolder:="", Options:=1, Prompt:="")
{
    local OutputVar
    FileSelectFolder OutputVar, %StartingFolder%, %Options%, %Prompt%
    if !ErrorLevel
        return OutputVar
}
Download(URL, FileName)
{
    UrlDownloadToFile %URL%, %FileName%
    return !ErrorLevel
}
DriveEject(Drive:="", Retract:=false)
{
    Drive Eject, %Drive%, %Retract%
}
DriveGetCapacity(Path)
{
    local OutputVar
    DriveGet OutputVar, Capacity, %Path%
    return OutputVar
}
DriveGetFilesystem(Drive)
{
    local OutputVar
    DriveGet OutputVar, Filesystem, %Drive%
    return OutputVar
}
DriveGetLabel(Drive)
{
    local OutputVar
    DriveGet OutputVar, Label, %Drive%
    return OutputVar
}
DriveGetList(Type:="")
{
    local OutputVar
    DriveGet OutputVar, List, %Type%
    return OutputVar
}
DriveGetSerial(Drive)
{
    local OutputVar
    DriveGet OutputVar, Serial, %Drive%
    return OutputVar
}
DriveGetSpaceFree(Path)
{
    local OutputVar
    DriveSpaceFree OutputVar, %Path%
    return OutputVar
}
DriveGetStatus(Drive)
{
    local OutputVar
    DriveGet OutputVar, Status, %Drive%
    return OutputVar
}
DriveGetStatusCD(Drive:="")
{
    local OutputVar
    DriveGet OutputVar, StatusCD, %Drive%
    return OutputVar
}
DriveGetType(Drive)
{
    local OutputVar
    DriveGet OutputVar, Type, %Drive%
    return OutputVar
}
DriveLock(Drive)
{
    Drive Lock, %Drive%
}
DriveSetLabel(Drive, NewLabel:="")
{
    Drive Label, %Drive%, %NewLabel%
}
DriveUnlock(Drive)
{
    Drive Unlock, %Drive%
}
Edit()
{
    Edit
}
EnvGet(EnvVarName)
{
    local OutputVar
    EnvGet OutputVar, %EnvVarName%
    return OutputVar
}
EnvSet(EnvVar, Value:="")
{
    EnvSet %EnvVar%, %Value%
    return !ErrorLevel
}
Exit(ExitCode:=0)
{
    Exit %ExitCode%
}
ExitApp(ExitCode:=0)
{
    ExitApp %ExitCode%
}
FileAppend(Text, Filename:="", Options:="")
{
    local EOL, Encoding
    Encoding := A_FileEncoding
    EOL := "*"
    Loop Parse, Options, % " `t"
    {
        if (A_LoopField = "`n")
            EOL := ""
        else if (A_LoopField ~= "i)^(UTF-|CP)")
            Encoding := A_LoopField
    }
    FileAppend %Text%, %EOL%%Filename%, %Encoding%
    return !ErrorLevel
}
FileCopy(Source, Dest, Flag:=0)
{
    FileCopy %Source%, %Dest%, %Flag%
    return !ErrorLevel
}
FileCreateShortcut(Target, LinkFile, WorkingDir:="", Args:="", Description:="", IconFile:="", ShortcutKey:="", IconNumber:="", RunState:=1)
{
    FileCreateShortcut %Target%, %LinkFile%, %WorkingDir%, %Args%, %Description%, %IconFile%, %ShortcutKey%, %IconNumber%, %RunState%
    return !ErrorLevel
}
FileDelete(FilePattern)
{
    FileDelete %FilePattern%
    return !ErrorLevel
}
FileEncoding(Encoding:="")
{
    FileEncoding %Encoding%
}
FileGetAttrib(Filename:="")
{
    local OutputVar
    FileGetAttrib OutputVar, %Filename%
    if !ErrorLevel
        return OutputVar
}
FileGetShortcut(LinkFile, ByRef OutTarget:="", ByRef OutDir:="", ByRef OutArgs:="", ByRef OutDescription:="", ByRef OutIcon:="", ByRef OutIconNum:="", ByRef OutRunState:="")
{
    FileGetShortcut %LinkFile%, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
    return !ErrorLevel
}
FileGetSize(Filename:="", Units:="")
{
    local OutputVar
    FileGetSize OutputVar, %Filename%, %Units%
    if !ErrorLevel
        return OutputVar
}
FileGetTime(Filename:="", WhichTime:="M")
{
    local OutputVar
    FileGetTime OutputVar, %Filename%, %WhichTime%
    if !ErrorLevel
        return OutputVar
}
FileGetVersion(Filename:="")
{
    local OutputVar
    FileGetVersion OutputVar, %Filename%
    if !ErrorLevel
        return OutputVar
}
FileInstall(Source, Dest, Flag:=0)
{
    FileCopy %Source%, %Dest%, %Flag%
    return !ErrorLevel
}
FileMove(SourcePattern, DestPattern, Flag:=0)
{
    FileMove %SourcePattern%, %DestPattern%, %Flag%
    return !ErrorLevel
}
FileRead(Filename, Options:="")
{
    local OutputVar, Options2
    Loop Parse, Options, % " `t"
    {
        if (SubStr(A_LoopField, 1, 1) = "m")
            Options2 .= "*" A_LoopField " "
        else if (A_LoopField = "`n")
            Options2 .= "*t "
        else if (SubStr(A_LoopField, 1, 2) = "CP")
            Options2 .= "*" SubStr(A_LoopField, 2) " "
        else if (SubStr(A_LoopField, 1, 5) = "UTF-8")
            Options2 .= "*P65001 "
        else if (SubStr(A_LoopField, 1, 6) = "UTF-16")
            Options2 .= "*P1200 "
    }
    FileRead OutputVar, %Options2%%Filename%
    if !ErrorLevel
        return OutputVar
}
FileRecycle(FilePattern)
{
    FileRecycle %FilePattern%
    return !ErrorLevel
}
FileRecycleEmpty(DriveLetter:="")
{
    FileRecycleEmpty %DriveLetter%
    return !ErrorLevel
}
FileSelect(Options:=0, RootDir_Filename:="", Prompt:="", Filter:="")
{
    local OutputVar
    FileSelectFile OutputVar, %Options%, %RootDir_Filename%, %Prompt%, %Filter%
    if !ErrorLevel
        return OutputVar
}
FileSetAttrib(Attributes, FilePattern:="", Mode:="")
{
    if !RegExMatch(Attributes, "^[+\-\^]")
    {
        FileSetAttrib -RASHOT, %FilePattern%, % InStr(Mode, "D") ? (InStr(Mode, "F") ? 1 : 2) : 0, % !!InStr(Mode, "R")
        Attributes := "+" Attributes
    }
    FileSetAttrib %Attributes%, %FilePattern%, % InStr(Mode, "D") ? (InStr(Mode, "F") ? 1 : 2) : 0, % !!InStr(Mode, "R")
    return !ErrorLevel
}
FileSetTime(YYYYMMDDHH24MISS:="", FilePattern:="", WhichTime:="M", Mode:="")
{
    FileSetTime %YYYYMMDDHH24MISS%, %FilePattern%, %WhichTime%, % InStr(Mode, "D") ? (InStr(Mode, "F") ? 1 : 2) : 0, % !!InStr(Mode, "R")
    return !ErrorLevel
}
FormatTime(YYYYMMDDHH24MISS:="", Format:="")
{
    local OutputVar
    FormatTime OutputVar, %YYYYMMDDHH24MISS%, %Format%
    return OutputVar
}
GroupActivate(GroupName, R:="")
{
    GroupActivate %GroupName%, %R%
    return !ErrorLevel
}
GroupAdd(GroupName, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    GroupAdd %GroupName%, %WinTitle%, %WinText%,, %ExcludeTitle%, %ExcludeText%
}
GroupClose(GroupName, AR:="")
{
    GroupClose %GroupName%, %AR%
}
GroupDeactivate(GroupName, R:="")
{
    GroupDeactivate %GroupName%, %R%
}
Hotkey(Param1, Param2:="", Param3:="")
{
    Hotkey %Param1%, %Param2%, %Param3%
    if (InStr(Param1, "IfWin") || InStr(Param3, "UseErrorLevel"))
        return !ErrorLevel
}
ImageSearch(ByRef OutputVarX:="", ByRef OutputVarY:="", X1:="", Y1:="", X2:="", Y2:="", ImageFile:="")
{
    ImageSearch OutputVarX, OutputVarY, %X1%, %Y1%, %X2%, %Y2%, %ImageFile%
    return !ErrorLevel
}
IniDelete(Params*) ;Filename, Section, Key
{
    local Filename, Key, Section
    Filename := Params.1
    Section := Params.2
    Key := Params.3
    if (Params.Length() = 3)
        IniDelete %Filename%, %Section%, %Key%
    else if (Params.Length() = 2)
        IniDelete %Filename%, %Section%
    return !ErrorLevel
}
IniRead(Filename, Section:="", Key:="", Default:="")
{
    local OutputVar
    if (Default = "")
        Default := " "
    IniRead OutputVar, %Filename%, %Section%, %Key%, %Default%
    if !ErrorLevel
        return OutputVar
}
IniWrite(Value, Filename, Section, Key:="")
{
    IniWrite %Value%, %Filename%, %Section%, %Key%
    return !ErrorLevel
}
Input(Options:="", EndKeys:="", MatchList:="")
{
    local OutputVar
    Input OutputVar, %Options%, %EndKeys%, %MatchList%
    return OutputVar
}
InputBox(Params*) ;Text, Title, Options, Default
{
    local _, _X, _Y, _W, _H, _T, _P, _Err, Default, Options, Text, Title
    Text := Params.1
    Title := !Params.HasKey(2) ? A_ScriptName : (Params.2 = "") ? " " : Params.2
    Options := Params.3
    Default := Params.4

    ; v2 validates the value of a particular option:
    ; X and Y = integer (can be negative)
    ; W and H = postive integer only
    ; T = postive integer/float
    ; Credits to Lexikos [https://goo.gl/VjMTYu , https://goo.gl/ebEjon]
    RegExMatch(Options, "i)^[ \t]*(?:(?:X(?<X>-?\d+)|Y(?<Y>-?\d+)|W(?<W>\d+)"
        . "|H(?<H>\d+)|T(?<T>\d+(?:\.\d+)?)|(?<P>Password\S?)"
        . "|(?<Err>\S+)(*ACCEPT)"
        . ")(?=[ \t]|$)[ \t]*)*$", _)

    if (_Err != "")
        throw Exception("Invalid option.", -1, _Err)

    local OutputVar
    InputBox, OutputVar, %Title%, %Text%, % _P ? "HIDE" : "", %_W%, %_H%, %_X%, %_Y%,, %_T%, %Default%
    return OutputVar
}
InputEnd()
{
    Input
    return !ErrorLevel
}
KeyHistory()
{
    KeyHistory
}
KeyWait(KeyName, Options:="")
{
    KeyWait %KeyName%, %Options%
    return !ErrorLevel
}
ListHotkeys()
{
    ListHotkeys
}
ListLines(OnOrOff:="")
{
    if OnOrOff in 1,0
        OnOrOff := OnOrOff ? "On" : "Off"
    ListLines %OnOrOff%
}
ListVars()
{
    ; Limitation -> won't work if called from within a function
    global
    ListVars
}
MenuSelect(WinTitle:="", WinText:="", Menu:="", SubMenu1:="", SubMenu2:="", SubMenu3:="", SubMenu4:="", SubMenu5:="", SubMenu6:="", ExcludeTitle:="", ExcludeText:="")
{
    WinMenuSelectItem %WinTitle%, %WinText%, %Menu%, %SubMenu1%, %SubMenu2%, %SubMenu3%, %SubMenu4%, %SubMenu5%, %SubMenu6%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
MonitorGet(N:="", ByRef OutLeft:="", ByRef OutTop:="", ByRef OutRight:="", ByRef OutBottom:="")
{
    local Out
    SysGet Out, Monitor, %N%
    return (OutLeft != "" && OutTop != "" && OutRight != "" && OutBottom != "")
}
MonitorGetCount()
{
    local OutputVar
    SysGet OutputVar, MonitorCount
    return OutputVar
}
MonitorGetName(N:="")
{
    local OutputVar
    SysGet OutputVar, MonitorName
    return OutputVar
}
MonitorGetPrimary()
{
    local OutputVar
    SysGet OutputVar, MonitorPrimary
    return OutputVar
}
MonitorGetWorkArea(N:="", ByRef OutLeft:="", ByRef OutTop:="", ByRef OutRight:="", ByRef OutBottom:="")
{
    local Out
    SysGet Out, MonitorWorkArea, %N%
    return (OutLeft != "" && OutTop != "" && OutRight != "" && OutBottom != "")
}
MouseClick(WhichButton:="Left", X:="", Y:="", ClickCount:="", Speed:="", DU:="", R:="")
{
    MouseClick %WhichButton%, %X%, %Y%, %ClickCount%, %Speed%, %DU%, %R%
}
MouseClickDrag(WhichButton, X1:="", Y1:="", X2:="", Y2:="", Speed:="", R:="")
{
    MouseClickDrag %WhichButton%, %X1%, %Y1%, %X2%, %Y2%, %Speed%, %R%
}
MouseGetPos(ByRef OutputVarX:="", ByRef OutputVarY:="", ByRef OutputVarWin:="", ByRef OutputVarControl:="", Mode:=0)
{
    MouseGetPos OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, %Mode%
    OutputVarWin += 0
    if (Mode & 2)
        OutputVarControl += 0
}
MouseMove(X, Y, Speed:="", R:="")
{
    MouseMove %X%, %Y%, %Speed%, %R%
}
MsgBox(Params*) ;Text, Title, Options
{
    local Match, Options, Result, Temp, Text, Timeout, Title, Type
    static TypeArray := {"OK":0, "O":0, "OKCancel":1, "O/C":1, "OC":1, "AbortRetryIgnore":2, "A/R/I":2, "ARI":2
        , "YesNoCancel":3, "Y/N/C":3, "YNC":3, "YesNo":4, "Y/N":4, "YN":4, "RetryCancel":5, "R/C":5, "RC":5
        , "CancelTryAgainContinue":6, "C/T/C":6, "CTC":6, "Iconx":16, "Icon?":32, "Icon!":48, "Iconi":64
        , "Default2":256, "Default3":512, "Default4":768}

    Text := !Params.Length() ? "Press OK to continue." : Params.HasKey(1) ? Params.1 : ""
    Title := !Params.HasKey(2) ? A_ScriptName : (Params.2 = "") ? " " : Params.2
    Options := Params.3, Timeout := "", Type := 0
    if (Options)
    {
        Loop, Parse, Options, % " `t"
            (Temp := Abs(A_LoopField)) || (Temp := TypeArray[A_LoopField]) ? (Type |= Temp)
                : RegExMatch(A_LoopField, "Oi)^T(\d+\.?\d*)$", Match) ? Timeout := Match.1
                : 0
    }
    MsgBox % Type, % Title, % Text, % Timeout
    Loop Parse, % "Timeout,OK,Cancel,Yes,No,Abort,Ignore,Retry,Continue,TryAgain", % ","
        IfMsgBox % Result := A_LoopField
            break
    return Result
}
OutputDebug(Text)
{
    OutputDebug %Text%
}
Pause(Mode:="", OperateOnUnderlyingThread:=0)
{
    if Mode in 1,0,-1 ; On,Off,Toggle
        Mode := Mode == -1 ? "Toggle" : Mode ? "On" : "Off"
    Pause %Mode%, %OperateOnUnderlyingThread%
}
PixelGetColor(X, Y, AltSlow:="")
{
    local OutputVar
    PixelGetColor OutputVar, %X%, %Y%, %AltSlow% RGB ; v2 uses RGB
    if !ErrorLevel
        return OutputVar
}
PixelSearch(ByRef OutputVarX:="", ByRef OutputVarY:="", X1:="", Y1:="", X2:="", Y2:="", ColorID:="", Variation:=0, Fast:="")
{
    PixelSearch OutputVarX, OutputVarY, %X1%, %Y1%, %X2%, %Y2%, %ColorID%, %Variation%, %Fast% RGB
    return !ErrorLevel
}
PostMessage(Msg, wParam:="", lParam:="", Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    PostMessage %Msg%, %wParam%, %lParam%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    ErrorLevel := (ErrorLevel = "FAIL")
    ;PostMessage returns an empty string.
}
ProcessClose(PIDorName)
{
    Process Close, %PIDorName%
    return ErrorLevel
}
ProcessExist(PIDorName:="")
{
    Process Exist, %PIDorName%
    return ErrorLevel
}
ProcessSetPriority(Priority, PIDorName:="")
{
    Process Priority, %PIDorName%, %Priority%
    return ErrorLevel
}
ProcessWait(PIDorName, SecondsToWait:="")
{
    Process Wait, %PIDorName%, %SecondsToWait%
    return ErrorLevel
}
ProcessWaitClose(PIDorName, SecondsToWait:="")
{
    Process WaitClose, %PIDorName%, %SecondsToWait%
    return ErrorLevel
}
Random(Min:="", Max:="")
{
    local OutputVar
    Random OutputVar, %Min%, %Max%
    return OutputVar
}
RandomSeed(NewSeed)
{
    Random , %NewSeed%
}
RegDelete(Params*) ;KeyName, ValueName
{
    ;MsgBox, % "REGDELETE"
    if (Params.Length() = 1)
        Params[2] := "AHK_DEFAULT"
    if Params.Length()
    {
        if InStr(Params[1], "\")
            RegDelete % Params[1], % Params[2]
        else
            RegDelete % Params[1],, % Params[2]
    }
    else
    {
        if (A_LoopRegType = "KEY")
            ErrorLevel := 1
        else if (A_LoopRegName = "")
            RegDelete %A_LoopRegKey%, %A_LoopRegSubkey%, AHK_DEFAULT
        else
            RegDelete %A_LoopRegKey%, %A_LoopRegSubkey%, %A_LoopRegName%
    }
    return !ErrorLevel
}
RegDeleteKey(KeyName:="")
{
    ;MsgBox, % "REGDELETEKEY"
    if !(A_LoopRegSubkey = "")
        RegDelete %A_LoopRegKey%
    else if !(A_LoopRegKey = "")
        RegDelete %A_LoopRegKey%\%A_LoopRegSubkey%
    else
        RegDelete %KeyName%
    return !ErrorLevel
}
RegRead(Params*) ;KeyName, ValueName
{
    local OutputVar
    if Params.Length()
    {
        if InStr(Params[1], "\")
            RegRead OutputVar, % Params[1], % Params[2]
        else
            RegRead OutputVar, % Params[1],, % Params[2]
    }
    else
    {
        if (A_LoopRegType = "KEY")
            ErrorLevel := 1
        else
            RegRead OutputVar, %A_LoopRegKey%, %A_LoopRegSubkey%, %A_LoopRegName%
    }
    if !ErrorLevel
        return OutputVar
}
RegWrite(Params*) ;Value, ValueType, KeyName, ValueName
{
    ;if !(Params.3 = "HKEY_CURRENT_USER\Software\Microsoft\Notepad")
        ;MsgBox, % "REGWRITE`r`n" JEE_ObjPreview(Params)
    if (Params.Length() > 2)
    {
        if InStr(Params[3], "\")
            RegWrite % Params[2], % Params[3], % Params[4], % Params[1]
        else
            RegWrite % Params[2], % Params[3],, % Params[4], % Params[1]
    }
    else if (Params.Length() = 1)
    {
        if (A_LoopRegType = "KEY")
            ErrorLevel := 1
        else
            RegWrite %A_LoopRegType%, %A_LoopRegKey%, %A_LoopRegSubkey%, %A_LoopRegName%, % Params[1]
    }
    else if (Params.Length() = 0)
    {
        if (A_LoopRegType = "KEY")
            ErrorLevel := 1
        else if InStr(A_LoopRegType, "_SZ")
            RegWrite %A_LoopRegType%, %A_LoopRegKey%, %A_LoopRegSubkey%, %A_LoopRegName%, % ""
        else
            RegWrite %A_LoopRegType%, %A_LoopRegKey%, %A_LoopRegSubkey%, %A_LoopRegName%, 0
    }
    return !ErrorLevel
}
Reload()
{
    Reload
}
Run(Target, WorkingDir:="", Options:="", ByRef OutputVarPID:="")
{
    Run %Target%, %WorkingDir%, %Options%, OutputVarPID
    if InStr(Options, "UseErrorLevel")
        return !ErrorLevel
}
RunAs(User:="", Password:="", Domain:="")
{
    RunAs %User%, %Password%, %Domain%
}
RunWait(Target, WorkingDir:="", Options:="", ByRef OutputVarPID:="")
{
    RunWait %Target%, %WorkingDir%, %Options%, OutputVarPID
    return ErrorLevel
}
Send(Keys)
{
    Send %Keys%
}
SendEvent(Keys)
{
    SendEvent %keys%
}
SendInput(Keys)
{
    SendInput %Keys%
}
SendLevel(Level)
{
    SendLevel %Level%
}
SendMessage(Msg, wParam:="", lParam:="", Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="", Timeout:="")
{
    local MsgReply
    SendMessage %Msg%, %wParam%, %lParam%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%, %Timeout%
    MsgReply := (ErrorLevel = "FAIL") ? "" : ErrorLevel
    ErrorLevel := (ErrorLevel = "FAIL")
    return MsgReply
}
SendMode(Mode)
{
    SendMode %Mode%
}
SendPlay(Keys)
{
    SendPlay %Keys%
}
SendRaw(Keys)
{
    SendRaw %Keys%
}
SetCapsLockState(State:="")
{
    if State in 1,0
        State := State ? "On" : "Off"
    SetCapsLockState %State%
}
SetControlDelay(Delay)
{
    SetControlDelay %Delay%
}
SetDefaultMouseSpeed(Speed)
{
    SetDefaultMouseSpeed %Speed%
}
SetKeyDelay(Delay:="", PressDuration:="", Play:="")
{
    SetKeyDelay %Delay%, %PressDuration%, %Play%
}
SetMouseDelay(Delay, Play:="")
{
    SetMouseDelay %Delay%, %Play%
}
SetNumLockState(State:="")
{
    if State in 1,0
        State := State ? "On" : "Off"
    SetNumLockState %State%
}
SetRegView(RegView)
{
    SetRegView %RegView%
}
SetScrollLockState(State:="")
{
    if State in 1,0
        State := State ? "On" : "Off"
    SetScrollLockState %State%
}
SetStoreCapsLockMode(OnOrOff)
{
    if OnOrOff in 1,0
        OnOrOff := OnOrOff ? "On" : "Off"
    SetStoreCapsLockMode %OnOrOff%
}
SetTimer(Label:="", Period:="", Priority:=0)
{
    SetTimer %Label%, %Period%, %Priority%
}
SetTitleMatchMode(MatchModeOrSpeed)
{
    SetTitleMatchMode %MatchModeOrSpeed%
}
SetWinDelay(Delay)
{
    SetWinDelay %Delay%
}
SetWorkingDir(DirName)
{
    SetWorkingDir %DirName%
    return !ErrorLevel
}
Shutdown(Code)
{
    Shutdown %Code%
}
Sleep(DelayInMilliseconds)
{
    Sleep %DelayInMilliseconds%
}
Sort(String, Options:="")
{
    Sort String, %Options%
    return String
}
SoundBeep(Frequency:=523, Duration:=150)
{
    SoundBeep %Frequency%, %Duration%
}
SoundGet(ComponentType:="", ControlType:="", DeviceNumber:="")
{
    local OutputVar
    SoundGet OutputVar, %ComponentType%, %ControlType%, %DeviceNumber%
    if !ErrorLevel
        return OutputVar
}
SoundPlay(Filename, Wait:="")
{
    SoundPlay %Filename%, %Wait%
    return !ErrorLevel
}
SoundSet(NewSetting, ComponentType:="", ControlType:="", DeviceNumber:="")
{
    SoundSet %NewSetting%, %ComponentType%, %ControlType%, %DeviceNumber%
    return !ErrorLevel
}
SplitPath(Path, ByRef OutFileName:="", ByRef OutDir:="", ByRef OutExtension:="", ByRef OutNameNoExt:="", ByRef OutDrive:="")
{
    SplitPath % Path, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
}
StatusBarGetText(PartNum:=1, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    StatusBarGetText OutputVar, %PartNum%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if !ErrorLevel
        return OutputVar
}
StatusBarWait(BarText:="", Seconds:="", PartNum:=1, WinTitle:="", WinText:="", Interval:=50, ExcludeTitle:="", ExcludeText:="")
{
    StatusBarWait %BarText%, %Seconds%, %PartNum%, %WinTitle%, %WinText%, %Interval%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
StringCaseSense(OnOffLocale)
{
    StringCaseSense %OnOffLocale%
}
StrLower(String, T:="")
{
    local OutputVar
    StringLower OutputVar, String, %T%
    return OutputVar
}
StrUpper(String, T:="")
{
    local OutputVar
    StringUpper OutputVar, String, %T%
    return OutputVar
}
Suspend(Mode:="Toggle")
{
    if Mode in 1,0,-1 ; On,Off,Toggle
        Mode := Mode == -1 ? "Toggle" : Mode ? "On" : "Off"
    Suspend %Mode%
}
SysGet(SubCommand)
{
    local OutputVar
    SysGet OutputVar, %SubCommand%
    return OutputVar
}
Thread(Param1, Param2:="", Param3:="")
{
    Thread %Param1%, %Param2%, %Param3%
}
ToolTip(Text:="", X:="", Y:="", WhichToolTip:=1)
{
    ToolTip %Text%, %X%, %Y%, %WhichToolTip%
}
TraySetIcon(FileName:="", IconNumber:="", Freeze:="")
{
    Menu Tray, Icon, %FileName%, %IconNumber%, %Freeze%
}
TrayTip(Params*) ;Text, Title, Options
{
    local Num := 0, Options, Text, Title
    Text := !Params.HasKey(1) ? " " : (Params.1 = "") ? " " : Params.1
    Title := !Params.HasKey(2) ? "" : Params.2
    Options := Params.HasKey(3) ? Params.3 : 0
    Loop Parse, Options, % " `t"
    {
        (A_LoopField = "Iconi") ? (Num |= 1) : ""
        (A_LoopField = "Icon!") ? (Num |= 2) : ""
        (A_LoopField = "Iconx") ? (Num |= 3) : ""
        (A_LoopField = "Mute") ? (Num |= 16) : ""
        if A_LoopField is integer
            Num |= A_LoopField
    }
    TrayTip %Title%, %Text%,, %Num%
}
Type(Value)
{
    local m, f, e
    if IsObject(Value)
    {
        static nMatchObj  := NumGet(&(m, RegExMatch("", "O)", m)))
        static nBoundFunc := NumGet(&(f := Func("Func").Bind()))
        static nFileObj   := NumGet(&(f := FileOpen("*", "w")))
        static nEnumObj   := NumGet(&(e := ObjNewEnum({})))

        return ObjGetCapacity(Value) != ""  ? "Object"
             : IsFunc(Value)                ? "Func"
             : ComObjType(Value) != ""      ? "ComObject"
             : NumGet(&Value) == nBoundFunc ? "BoundFunc"
             : NumGet(&Value) == nMatchObj  ? "RegExMatchObject"
             : NumGet(&Value) == nFileObj   ? "FileObject"
             : NumGet(&Value) == nEnumObj   ? "Object::Enumerator"
             :                                "Property"
    }
    else if (ObjGetCapacity([Value], 1) != "")
        return "String"
    else
        return InStr(Value, ".") ? "Float" : "Integer"
}
WinActivate(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinActivate %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinActivateBottom(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinActivateBottom %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinClose(WinTitle:="", WinText:="", SecondsToWait:="", ExcludeTitle:="", ExcludeText:="")
{
    WinClose %WinTitle%, %WinText%, %SecondsToWait%, %ExcludeTitle%, %ExcludeText%
}
WinGetClass(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGetClass OutputVar, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
WinGetClientPos(ByRef X:="", ByRef Y:="", ByRef Width:="", ByRef Height:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local hWnd, RECT
    hWnd := WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText)
    VarSetCapacity(RECT, 16, 0)
    DllCall("user32\GetClientRect", Ptr,hWnd, Ptr,&RECT)
    DllCall("user32\ClientToScreen", Ptr,hWnd, Ptr,&RECT)
    X := NumGet(&RECT, 0, "Int"), Y := NumGet(&RECT, 4, "Int")
    Width := NumGet(&RECT, 8, "Int"), Height := NumGet(&RECT, 12, "Int")
}
WinGetControls(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, ControlList, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return StrSplit(OutputVar, "`n")
}
WinGetControlsHwnd(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar, ControlsHwnd, i
    WinGet OutputVar, ControlListHwnd, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    ControlsHwnd := StrSplit(OutputVar, "`n")
    for i in ControlsHwnd
        ControlsHwnd[i] += 0
    return ControlsHwnd
}
WinGetCount(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, Count, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
WinGetExStyle(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, ExStyle, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar + 0
}
WinGetID(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar + 0
}
WinGetIDLast(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, IDLast, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar + 0
}
WinGetList(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar, List
    WinGet OutputVar, List, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    List := []
    Loop % OutputVar
        List.Push(OutputVar%A_Index% + 0)
    return List
}
WinGetMinMax(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, MinMax, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
WinGetPID(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, PID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
WinGetPos(ByRef X:="", ByRef Y:="", ByRef Width:="", ByRef Height:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinGetPos X, Y, Width, Height, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinGetProcessName(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, ProcessName, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
WinGetProcessPath(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, ProcessPath, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
WinGetStyle(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, Style, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar + 0
}
WinGetText(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGetText OutputVar, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if !ErrorLevel
        return OutputVar
}
WinGetTitle(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGetTitle OutputVar, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
WinGetTransColor(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, TransColor, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
WinGetTransparent(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local OutputVar
    WinGet OutputVar, Transparent, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return OutputVar
}
WinHide(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinHide %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinKill(WinTitle:="", WinText:="", SecondsToWait:="", ExcludeTitle:="", ExcludeText:="")
{
    WinKill %WinTitle%, %WinText%, %SecondsToWait%, %ExcludeTitle%, %ExcludeText%
}
WinMaximize(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinMaximize %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinMinimize(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinMinimize %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinMinimizeAll()
{
    WinMinimizeAll
}
WinMinimizeAllUndo()
{
    WinMinimizeAllUndo
}
WinMove(Params*) ;X, Y [, Width, Height, WinTitle, WinText, ExcludeTitle, ExcludeText]
{
    local WinTitle, WinText, X, Y, Width, Height, ExcludeTitle, ExcludeText
    local Len
    if (Len := Params.Length())
    {
        if (Len > 2)
        {
            X            := Params[1]
            Y            := Params[2]
            Width        := Params[3]
            Height       := Params[4]
            WinTitle     := Params[5]
            WinText      := Params[6]
            ExcludeTitle := Params[7]
            ExcludeText  := Params[8]
            WinMove %WinTitle%, %WinText%, %X%, %Y%, %Width%, %Height%, %ExcludeTitle%, %ExcludeText%
        }
        else
        {
            X := Params[1]
            Y := Params[2]
            WinMove %X%, %y%
        }
    }
    else
        WinMove
}
WinMoveBottom(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinSet Bottom,, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinMoveTop(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinSet Top,, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinRedraw(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinSet Redraw,, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinRestore(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinRestore %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinSetAlwaysOnTop(Value:="Toggle", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local Hwnd
    WinGet Hwnd, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if (!Hwnd)
        return 0

    if Value in 1,0,-1 ; On,Off,Toggle
        Value := Value == -1 ? "Toggle" : Value ? "On" : "Off"

    if Value not in On,Off,Toggle
        throw Exception("Parameter #1 invalid.", -1) ; v2 raises an error

    WinSet AlwaysOnTop, %Value%, ahk_id %Hwnd%
    return 1
}
WinSetEnabled(Value, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local Hwnd
    WinGet Hwnd, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if (!Hwnd)
        return 0

    ; 1, 0 and -1 are compared as strings, non-integer values(e.g.: 1.0) are not allowed
    local Style
    if (Value = "Toggle" || Value == "-1")
    {
        WinGet Style, Style, ahk_id %Hwnd%
        Value := (Style & 0x8000000) ? "On" : "Off" ; WS_DISABLED = 0x8000000
    }

    if (Value = "On" || Value == "1")
        WinSet Enable,, ahk_id %Hwnd%
    else if (Value = "Off" || Value == "0")
        WinSet Disable,, ahk_id %Hwnd%
    else
        throw Exception("Paramter #1 invalid.", -1) ; v2 raises an error
    return 1
}
WinSetExStyle(N, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinSet ExStyle, %N%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
WinSetRegion(Options:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinSet Region, %Options%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
WinSetStyle(N, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinSet Style, %N%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
WinSetTitle(NewTitle, Params*) ;NewTitle [, WinTitle, WinText, ExcludeTitle, ExcludeText]
{
    local WinTitle, WinText, ExcludeTitle, ExcludeText
    if (Params.Length())
    {
        WinTitle     := Params[1]
        WinText      := Params[2]
        ExcludeTitle := Params[3]
        ExcludeText  := Params[4]
        WinSetTitle %WinTitle%, %WinText%, %NewTitle%, %ExcludeTitle%, %ExcludeText%
    }
    else
        WinSetTitle %NewTitle%
}
WinSetTransColor(ColorN, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local Hwnd
    WinGet Hwnd, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if (!Hwnd)
        return 0

    WinSet TransColor, %ColorN%, ahk_id %Hwnd%
    return 1
}
WinSetTransparent(N, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    local Hwnd
    WinGet Hwnd, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    if (!Hwnd)
        return 0

    WinSet Transparent, %N%, ahk_id %Hwnd%
    return 1
}
WinShow(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
    WinShow %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinWait(WinTitle:="", WinText:="", Seconds:="", ExcludeTitle:="", ExcludeText:="")
{
    WinWait %WinTitle%, %WinText%, %Seconds%, %ExcludeTitle%, %ExcludeText%
    return ErrorLevel ? 0 : WinExist()
}
WinWaitActive(WinTitle:="", WinText:="", Seconds:="", ExcludeTitle:="", ExcludeText:="")
{
    WinWaitActive %WinTitle%, %WinText%, %Seconds%, %ExcludeTitle%, %ExcludeText%
    return ErrorLevel ? 0 : WinExist()
}
WinWaitClose(WinTitle:="", WinText:="", Seconds:="", ExcludeTitle:="", ExcludeText:="")
{
    WinWaitClose %WinTitle%, %WinText%, %Seconds%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}
WinWaitNotActive(WinTitle:="", WinText:="", Seconds:="", ExcludeTitle:="", ExcludeText:="")
{
    WinWaitNotActive %WinTitle%, %WinText%, %Seconds%, %ExcludeTitle%, %ExcludeText%
    return !ErrorLevel
}

;A_TrayMenu.ClickCount
class A_TrayMenu
{
	static varClickCount := 2
	ClickCount[]
	{
		get
		{
			return this.varClickCount
		}
		set
		{
			Menu, Tray, Click, % value
			return this.varClickCount := value
		}
	}
}

;==================================================

;old version:
;CaretGetPos(ByRef OutputVarX:="", ByRef OutputVarY:="")
;{
;    OutputVarX := A_CaretX, OutputVarY := A_CaretY
;}

;hoped-for version (with added Format parameter):
;DateAdd(DateTime, Time, TimeUnits, Format:="yyyyMMddHHmmss")
;{
;    EnvAdd DateTime, %Time%, %TimeUnits%
;    if !(Format == "yyyyMMddHHmmss")
;        FormatTime DateTime, %DateTime%, %Format%
;    return DateTime
;}

;==================================================