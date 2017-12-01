#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; 记录鼠标位置，按键自动点击

#Persistent
#SingleInstance

SetTitleMatchMode, 1

; 变量区
global mouseX := 0
global mouseY := 0

#IfWinActive, Sid Meier's Civilization VI
{

    $d::
        ;MouseMove, %mouseX%, %mouseY%
        build(mouseX, mouseY)
        return
    $f::
        recordMousePosition()
        return

}

; 工人建造推荐改良设施
build(targetX, targetY)
{
    ; 记录当前鼠标位置
    MouseGetPos, xpos, ypos 

    ; 移动鼠标到推荐图标位置，并点击建造:
    MouseMove, %targetX%, %targetY% 
    MouseClick

    ; 恢复鼠标位置
    MouseMove, %xpos%, %ypos%   
}

; 记录当前鼠标位置
recordMousePosition()
{
    MouseGetPos, xpos, ypos
    mouseX = %xpos%
    mouseY = %ypos%
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