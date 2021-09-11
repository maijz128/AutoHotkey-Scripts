#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force


global logloc := A_WorkingDir . "\AHK_LOG.log"
global consolecol = "c000000"
global cfontcol = "c15bb10"
global consid = 0
global LogConts := ""
conmaxh = 1050
conmaxw = 500
conspadding = 10
conshide := true

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
	; gui, Console: Destroy
	fadeWin(consid, 1, true)
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
	; WinMove, ahk_id %consid%,,0,0
	slideWin(consid, 0,0,200)
	}
	else
	{
	; WinMove, ahk_id %consid%,,30-%conmaxw%,0
	slideWin(consid, 30,0,200,true)
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

fadeWin(msid, ms = 10, closeOnFinish = false, trans = 256)
{
	if(trans>=256)
	{
	WinGet, trans, Transparent, ahk_id %msid%
	}
	ntrans := trans-2
	WinSet, Transparent, %ntrans%, ahk_id %msid%
	if(ntrans>0)
	{
	sleep, ms
	fadeWin(msid, ms, closeOnFinish, ntrans)
	}
	else
	{
	if(closeOnFinish)
	{
	WinClose, ahk_id %msid%
	}
	}
}

slideWin(msid, tX = 0, tY = 0, T = 500, rightAlign = false, closeOnFinish = false, frst = true, dX = 0, dY = 0, step=0, maxStep=0)
{
	anint := 100
	winGetPos, wX,wY,wW,wH,ahk_id %msid%
	woX := wX
	if(rightAlign)
	{
	wX += wW
	}
	
	if(frst)
	{
	maxStep := Round(T/(anint + 0))
	dX := Round((tX - wX) / maxStep)
	dY := Round((tY - wY) / maxStep)
	}
	
	if(step<maxStep)
	{
		newX := woX + dX
		newY := wY + dY
		winMove, ahk_id %msid%,,newX,newY
		; sleep, anint-19
		slideWin(msid, tX, tY, T, rightAlign, closeOnFinish, false, dX, dY, step+1, maxStep)
	}
	else
	{
		if(rightAlign)
		{
			winMove, ahk_id %msid%,, tX-wW,tY
		}
		else
		{
			winMove, ahk_id %msid%,, tX,tY
		}
		if(closeOnFinish)
		{
			WinClose, ahk_id %msid%
		}
	}
}
