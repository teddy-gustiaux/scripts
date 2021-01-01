#NoTrayIcon
#Persistent
#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2 ; A window's title can contain WinTitle anywhere inside it to be a match. 

;*******************************************************
; SETUP
;*******************************************************

;-------------------------------------------------------
; Global configuration
;-------------------------------------------------------
EnableAzertyShortcuts := false
switchedDesktop := false
;-------------------------------------------------------

;-------------------------------------------------------
; OSD for volume
;-------------------------------------------------------
Gui, VolumeGui:New
Gui VolumeGui:+LastFound +AlwaysOnTop -Caption +ToolWindow ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, VolumeGui:Color, FFD54F ; Set background color
Gui, VolumeGui:Font, s32 w600, Arial ; Set a large font size (32-point).
Gui, VolumeGui:Font,, Ubuntu Condensed ; Preferred font.
Gui, VolumeGui:Add, Text, vOSDVolumeTextValue +Center, UNMUTE
;-------------------------------------------------------

;-------------------------------------------------------
; OSD for microphone
;-------------------------------------------------------
Gui, MicrophoneGui:New
Gui MicrophoneGui:+LastFound +AlwaysOnTop -Caption +ToolWindow ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, MicrophoneGui:Color, ef5350 ; Set background color
Gui, MicrophoneGui:Font, s32 w600, Arial ; Set a large font size (32-point).
Gui, MicrophoneGui:Font,, Ubuntu Condensed ; Preferred font.
Gui, MicrophoneGui:Add, Text, vOSDMicrophoneTextValue w500 +Center, Default text
;-------------------------------------------------------

;;*******************************************************
; CUSTOM SHORTCUTS
;*******************************************************

;-------------------------------------------------------
; For debug purposes only - Reload the script
;-------------------------------------------------------
; CapsLock::Reload
;-------------------------------------------------------

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
XButton1::Send !+^{[}
^RButton::Send !+^{[}
;-------------------------------------------------------

;-------------------------------------------------------
; Switch between the desktops
;-------------------------------------------------------
; With the up button of the mouse
#If
^XButton1:: switchDesktop() ;
XButton2:: switchDesktop() ;

; Function to switch between the desktops
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
#If ; All special Alt-tab actions are not affected by #IfWin or #If.
~RButton & MButton::AltTabMenu
~RButton & WheelDown::AltTab
~RButton & WheelUp::ShiftAltTab
;-------------------------------------------------------

;-------------------------------------------------------
; Toggle main microphone mute
; Here, 10 is the ID of my microphone.
;-------------------------------------------------------
ShowMicrophoneOSD(CustomText)	
{
    SetTimer, HideMicrophoneOSD, 500 ; Hide after specified delay
    GuiControl, MicrophoneGui:Text, OSDMicrophoneTextValue, %CustomText% ; Set text
    Gui, MicrophoneGui:Show, x1325 y900 NoActivate ; NoActivate avoids deactivating the currently active window.
    return
}

HideMicrophoneOSD()
{
    Gui, MicrophoneGui:Hide,
}

Pause::
    SoundSet, +1, MASTER, mute, 10
    SoundGet, microphone_mute , , mute, 10
    ; -Var := "Microphone MUTE is " . microphone_mute
    if (microphone_mute = "ON")
    {
        showMicrophoneOSD("Microphone MUTED")
    } else {
        showMicrophoneOSD("Microphone ON AIR")
    }
    SetTimer, HideMicrophoneOSD, -2000
return

RemoveToolTip:
    ToolTip
return
;-------------------------------------------------------

;-------------------------------------------------------
; Adjust volume by scrolling the mouse wheel over the taskbar
;-------------------------------------------------------
MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

ShowVolumeOSD(CustomText)	
{
    SetTimer, HideVolumeOSD, 500 ; Hide after specified delay
    GuiControl, VolumeGui:Text, OSDVolumeTextValue, %CustomText% ; Set text
    Gui, VolumeGui:Show, xCenter y900 NoActivate ; NoActivate avoids deactivating the currently active window.
    return
}

HideVolumeOSD()
{
    Gui, VolumeGui:Hide,
}

#If (MouseIsOver("ahk_class Shell_TrayWnd") or MouseIsOver("ahk_class Shell_SecondaryTrayWnd"))
    WheelUp::
    Send {Volume_Up}
    SoundGet, master_volume
    ShowVolumeOSD(Round(master_volume))
return
WheelDown::
    Send {Volume_Down}
    SoundGet, master_volume
    ShowVolumeOSD(Round(master_volume))
return
MButton::
    Send {Volume_Mute}
    Sleep, 100 
    SoundGet, Mute, Master, MUTE
    if (Mute = "ON")
    {
        ShowVolumeOSD("MUTE")
    } else {
        ShowVolumeOSD("UNMUTE")
    }
return
;-------------------------------------------------------

;-------------------------------------------------------
; Toggle bookmarks toolbar in Firefox when pressing "`"
;-------------------------------------------------------
#If WinActive("ahk_class MozillaWindowClass")
SC029::
	Send {Alt}
	Sleep 1
	Send {Right}
	Sleep 1
	Send {Right}
	Sleep 1
	Send {Down}
	Sleep 1
	Send {Right}
	Sleep 1
	Send {Down}
	Sleep 1
	Send {Enter 2}
return
;-------------------------------------------------------

;=======================================================
; FOR AZERTY LAYOUT
;=======================================================

;-------------------------------------------------------
; Send backtick when pressing "²"
;-------------------------------------------------------
#If EnableAzertyShortcuts
+SC029::Send {U+0060} ; `
;-------------------------------------------------------

;-------------------------------------------------------
; Send capital accented letters
;-------------------------------------------------------
#If EnableAzertyShortcuts
^+9::Send {U+00C7} ; Ç
^+0::Send {U+00C0} ; À
^+7::Send {U+00C8} ; È
^+2::Send {U+00C9} ; É
;-------------------------------------------------------
