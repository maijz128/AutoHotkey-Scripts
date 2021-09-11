#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent
#SingleInstance

SetTitleMatchMode, 1

#IfWinActive, *new 1
{
    $w::Up
    $s::Down
    $a::Left
    $d::Right

}


PressKeyOnce(key, sleep:=1){
    Send {%key% Down}
    Sleep, %sleep%
    Send {%key% Up}
}