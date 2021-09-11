#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent
#SingleInstance


$1::!
$2::@
$3::#
$4::$
$5::
    PressKeyOnce("%")
    return
$6::^
$7::&
$8::*
$9::(
$0::)




PressKeyOnce(key, sleep:=1){
    Send {%key% Down}
    Sleep, %sleep%
    Send {%key% Up}
}