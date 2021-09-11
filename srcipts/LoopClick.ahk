#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent
#SingleInstance

SLEEP_TIME := 1 
canClick := false



Loop {
    If (canClick){
        Click
    }

    Sleep, SLEEP_TIME
}


$F10::
    canClick := !canClick
    return
$F12::
    canClick := false
    return   
