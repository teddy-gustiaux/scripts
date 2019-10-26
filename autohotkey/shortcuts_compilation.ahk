#NoTrayIcon
#Persistent
#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;*******************************************************
; SETUP
;*******************************************************

;-------------------------------------------------------
; For debug purposes only - Reload the script
;-------------------------------------------------------
; CapsLock::Reload
;-------------------------------------------------------

;-------------------------------------------------------
; OSD for volume
;-------------------------------------------------------
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, FFD54F  ; Set background color
Gui, Font, s32 w600, Arial  ; Set a large font size (32-point).
Gui, Font,, Ubuntu Condensed  ; Preferred font.
Gui, Add, Text, vOSDTextValue +Center, UNMUTE
;-------------------------------------------------------

;;*******************************************************
; CUSTOM SHORTCUTS
;*******************************************************

;-------------------------------------------------------
; Keep window on top
;-------------------------------------------------------
#If ; Context-insensitive hotkey
!+^T::  Winset, Alwaysontop, , A
;-------------------------------------------------------

;-------------------------------------------------------
; Replace default calculator
;-------------------------------------------------------
#If
^NumpadEnter::Run "C:\Program Files (x86)\Moffsoft FreeCalc\MoffFreeCalc.exe"
;-------------------------------------------------------

;-------------------------------------------------------
; Call Listary
;-------------------------------------------------------
; With Alt + Space
#If
!Space::Send !+^{=}
; With the down button of the mouse
#If
XButton1::Send !+^{)}
^RButton::Send !+^{)}
;-------------------------------------------------------

;-------------------------------------------------------
; Switch between the desktops
;-------------------------------------------------------
; With the up button of the mouse
#If
^XButton1:: switchDesktop() ;
XButton2:: switchDesktop() ;

; Function to switch between the desktops
switchedDesktop := false
switchDesktop() 
{
	global switchedDesktop
    if switchedDesktop
    {
        SendEvent ^#{Right}
        switchedDesktop := false
    }
    else
    {
        SendEvent ^#{Left}
        switchedDesktop := true
    }
}
;-------------------------------------------------------

;-------------------------------------------------------
; Cycle through open windows with the mouse
;-------------------------------------------------------
#If
~RButton & MButton::AltTabMenu
~RButton & WheelDown::AltTab
~RButton & WheelUp::ShiftAltTab
;-------------------------------------------------------

;-------------------------------------------------------
;  Adjust volume by scrolling the mouse wheel over the taskbar
;-------------------------------------------------------
MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

ShowOSD(CustomText) 
{
	SetTimer, HideOSD, 500  ; Hide after specified delay
	GuiControl, Text, OSDTextValue, %CustomText%  ; Set text
	Gui, Show, xCenter y900 NoActivate  ; NoActivate avoids deactivating the currently active window.
	return
}

HideOSD()
{
	Gui, Hide,
}

#If MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::
	Send {Volume_Up}
	SoundGet, master_volume
	ShowOSD(Round(master_volume))
return
WheelDown::
	Send {Volume_Down}
	SoundGet, master_volume
	ShowOSD(Round(master_volume))
return
MButton::
	Send {Volume_Mute}
	Sleep, 100 
	SoundGet, Mute, Master, MUTE
	if (Mute = "ON")
	{
		ShowOSD("MUTE")
	} else {
		ShowOSD("UNMUTE")
	}
return
;-------------------------------------------------------

;-------------------------------------------------------
; Send capital accented letters
;-------------------------------------------------------
#If
^+9::Send {U+00C7} ; Ç
^+0::Send {U+00C0} ; À
^+7::Send {U+00C8} ; È
^+2::Send {U+00C9} ; É
;-------------------------------------------------------