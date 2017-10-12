#NoTrayIcon
#Persistent
#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;;*******************************************************
; CUSTOM SHORTCUTS
;*******************************************************

;-------------------------------------------------------
; Replace default calculator
;-------------------------------------------------------
^NumpadEnter::Run "C:\Program Files (x86)\Moffsoft FreeCalc\MoffFreeCalc.exe"
;-------------------------------------------------------

;-------------------------------------------------------
; Call Listary
;-------------------------------------------------------
; With Alt + Space
!Space::Send !+^{=}
; With the down button of the mouse
XButton1::Send !+^{)}
;-------------------------------------------------------

;-------------------------------------------------------
; Switch between the desktops
;-------------------------------------------------------
; With the up button of the mouse
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