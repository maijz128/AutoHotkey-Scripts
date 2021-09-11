#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;#Persistent
#SingleInstance

SetTitleMatchMode, 1

global isActive := false
global isTarget := false
global SLEEP_TIME := 300 
global TARGET_KEY := e



Loop {
    IfWinActive ahk_exe starhorizon.exe
    {
        if isActive {
            Send e
        }
    }
    Sleep, SLEEP_TIME
}

#IfWinActive ahk_exe starhorizon.exe
{
    $d::
        isActive := !isActive
        return
    $f12::
        isActive := false
        return
}






;BEGIN ClassLib 

PressKey(key, count:=1, interval:=100)
{
    Loop %count%
    {
        Send %key%
        Sleep, %interval%
    }
}

PressKeyOnce(key, sleep:=1){
    Send {%key% Down}
    Sleep, %sleep%
    Send {%key% Up}
}

;END ClassLib 