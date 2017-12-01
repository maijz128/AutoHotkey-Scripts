#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent
#SingleInstance

SetTitleMatchMode, 1

global isActive := false

#IfWinActive, Cuphead
{
    $x::
        isActive := !isActive
        if (isActive){
            Send {x down}
        } else {
            Send {x up}
        }
        return

    $f12::
        isActive := false
}




;BEGIN ClassLib 

PressKey(key, count:=1, interval:=100)
{
    Loop %count%
    {
        Send {%key% Down}
        Sleep, 1
        Send {%key% Up}
        Sleep, %interval%
    }
}

PressKeyOnce(key, sleep:=1){
    Send {%key% Down}
    Sleep, %sleep%
    Send {%key% Up}
}

;END ClassLib 