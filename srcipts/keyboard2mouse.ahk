#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; #Include %A_ScriptDir%\vendor\logg\logg2.ahk

#Persistent
#SingleInstance 


loging(msg){ 
    ; logg(msg)
}

; Logger start
global logloc := A_WorkingDir . "\AHK_LOG.log"
global consolecol = "c000000"
global cfontcol = "c15bb10"
global consid = 0
global LogConts := ""
conmaxh = 1050
conmaxw = 500
conspadding = 10
conshide := true
; Logger end


; 变量区
global mouseX := 0
global mouseY := 0
global workerA := new Worker()



SetTitleMatchMode, 1
#IfWinActive ahk_exe notepad++.exe
{
     

    $^F11::reset()
    $^F10::enterRecord()
    $^F12::quitRecord()

    
    $q::handle("q")
    $w::handle("w")
    $e::handle("e")
    $r::handle("r")
    $t::handle("t")
    $y::handle("y")
    $u::handle("u")
    $i::handle("i")
    $o::handle("o")
    $p::handle("p")
    $[::handle("[")
    $]::handle("]")

    $a::handle("a")
    $s::handle("s")
    $d::handle("d")
    $f::handle("f")
    $g::handle("g")
    $h::handle("h")
    $j::handle("j")
    $k::handle("k")
    $l::handle("l")

    $z::handle("z")
    $x::handle("x")
    $c::handle("c")
    $v::handle("v")
    $b::handle("b")
    $n::handle("n")
    $m::handle("m")
}

test(){ 
    workerA.test() 
} 

enterRecord(){ 
    workerA.enterRecord() 
} 
quitRecord(){ 
    workerA.quitRecord() 
} 
handle(keyName){ 
    workerA.handle(keyName) 
}
reset(){
    workerA.reset();
}


Class Worker {
    isRecord := False
    keyMap := {"keyA": "valueA"}

    test(){
        v := this.keyMap["a"]
        if(this.keyMap.HasKey("a")){
            send %v%
        }
        loging(v)
    }

    enterRecord(){
        this.isRecord := True
        loging("enter record...")
        this.showMessage("enter record...")
    }

    quitRecord(){
        this.isRecord := False
        loging("quit record")
        this.showMessage("quit record.")
    }

    reset(){
        this.keyMap := {"keyA": "valueA"}
        this.showMessage("reset")
    }

    handle(keyName){
        loging("handle key: " . keyName)
        loging("is record: " . (this.isRecord ? "true" : "false") )

        if(this.isRecord){
            MouseGetPos, xpos, ypos 
            this.keyMap[keyName] := { "x": xpos, "y": ypos}

            loging("record key: " . keyName . " x: " . xpos . " y: " . ypos)
        }else{
            if(this.keyMap.HasKey(keyName)){
                targetX := this.keyMap[keyName]["x"]
                targetY := this.keyMap[keyName]["y"]
                this.click(targetX, targetY)

                loging("target x: " . targetX . " target y: " . targetY) 
            }else{
                send %keyName%
            }
        }
    }

    showMessage(msg){
        Gui, WorkerMSG: Destroy
        Gui, WorkerMSG: New, +Lastfound +AlwaysOnTop +ToolWindow +E0x08000000, Console
        Gui, WorkerMSG: color, "c000000"
        WinSet, Transparent, 180
        Gui, WorkerMSG: -Caption
        ; Gui, WorkerMSG: Font, S10, Consolas
        Gui, WorkerMSG: Font, "cDA4F49"
        Gui, WorkerMSG: Add, Text,, %msg%
        Gui, WorkerMSG: Show, x0 y0 autosize NoActivate
        sleep, 3000
        Gui, WorkerMSG: Destroy
    }

    click(targetX, targetY)
    {
        ; 记录当前鼠标位置
        MouseGetPos, xpos, ypos 

        ; 移动鼠标到指定位置:
        MouseMove, %targetX%, %targetY% 
        MouseClick

        ; 恢复鼠标位置
        MouseMove, %xpos%, %ypos%   
    }
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


; Logger
logg(msg)
{
	global
	if(msg == "C_C")
	{
		consoleClose()
		return
	}
	oldlogstate := ""
	if(consid != 0)
	{
		FileRead, oldlogstate, % logloc
		if(oldlogstate != "")
		{
			oldlogstate := "`r`n" . oldlogstate
		}
	}
	FileDelete, % logloc
	sleep, 10
	
	
	ntext := DateString() . ": " . msg . oldlogstate
	
	FileAppend, % ntext, % logloc
	
	if(consid = 0)
	{
	; +E0x20 ; <-- click through!
	GUI, Console: New, +Lastfound +AlwaysOnTop +ToolWindow +E0x08000000, Console
	gui, Console: color, %consolecol%
	WinSet, Transparent, 180
	Gui, Console: -Caption
	cbuwi := 17
	cbuhe := 14
	cbux := conmaxw-cbuwi-conspadding
	cbuy := 0
	gui, Console: Font, S7 center
	gui, add, button, gminConsole w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, _
	cbuy += 18
	gui, add, button, gslideConsole w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, <
	cbuy += 18
	gui, add, button, gclearConsole w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, C
	cbuy += 18
	gui, add, button, gsaveConsole w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, S
	cbuy += 18
	gui, add, button, gopenConsole w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, O
	cbuy += 18
	gui, add, button, gcloseConsole w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, X
	FileDelete, logloc
	sleep, 10
	}
	Gui, Console: +LastFound
	GuiControl, Hide, %LogConts%
	GuiControl, Disable, %LogConts%
	Gui, Color,, %consolecol%
	GuiControl, Text, %LogConts%, % ""
	Gui, Console: Font, S10, Consolas
	tWmax := conmaxw - (2*conspadding) - 25
	Gui, Console: Add, Edit, x%conspadding% y%conspadding% w%tWmax% %cfontcol% -VScroll -E0x200 HwndLogConts, % ntext
	ControlGetPos,,,, ctH,, ahk_id %LogConts%
	if(ctH + 2*conspadding > conmaxh)
	{
		ControlMove,,,,,conmaxh-2*conspadding, ahk_id %LogConts%
	}
	
	if(consid==0)
	{
	gui, Console: show, x0 y0 autosize NoActivate
	gui, Console: +LastFound
	consid := WinExist()
	}
	else
	{
	gui, Console: show, autosize NoActivate
	}

} ; END logg

minConsole:
	WinHide, ahk_id %consid%	
return

closeConsole:
	consoleClose()
return

consoleClose()
{
	gui, Console: Destroy
	consid := 0
}

saveConsole:
	GUI, Console: +OwnDialogs
	FileSelectFile, logsaveloc,S,% "Log " . DateString(true) . ".log",Save Log, Logs (*.log)
	if(logsaveloc)
	{
		filecopy, %logloc%, %logsaveloc%
	}
return

openConsole:
	run, %logloc%
return

slideConsole:
	if(conshide := ! conshide)
	{
	WinMove, ahk_id %consid%,,0,0
	}
	else
	{
	WinMove, ahk_id %consid%,,30 - conmaxw,0
	}
return

clearconsole:
	FileDelete, % logloc
	GuiControl, Text, %LogConts%, % ""
	ControlMove,,,,,30, ahk_id %LogConts%
	gui, Console: show, x0 y0 autosize NoActivate
return

DateString(filesafe = false)
{
	if(filesafe)
	{
		FormatTime, mcurrentTime, %A_Now%, yyyy-MM-dd HH-mm-ss
	}
	else
	{
		FormatTime, mcurrentTime, %A_Now%, yyyy-MM-dd HH:mm:ss
	}
	return mcurrentTime
}