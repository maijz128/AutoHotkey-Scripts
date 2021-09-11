#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; 记录鼠标位置，按键自动点击

#Persistent
#SingleInstance

SetTitleMatchMode, 2


#IfWinActive, 第一會所新片
{
    ;Send !n
    MsgBox You pressed Yes.
    Sleep, 10000
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