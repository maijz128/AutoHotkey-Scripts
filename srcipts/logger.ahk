#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force

; test
; logg := new Logger("logger.test.log")
; $t::
;     logg.log("test")
;     return


Class Logger{
    static consolecol := "c000000"
    static cfontcol := "c15bb10"
    static consid := 0
    static LogConts := ""

    logLocation := A_WorkingDir . "\AHK_LOG.log"
    conmaxh := 1050
    conmaxw := 500
    conspadding := 10
    conshide := true


    __New(logLocation = ""){
        if(logLocation != "")
            this.logLocation := logLocation
    }

    log(msg)
    {
        LogConts := Logger.LogConts
        consolecol := Logger.consolecol
        cfontcol := Logger.cfontcol
        conspadding := this.conspadding
        logLocation := this.logLocation

        if(msg == "C_C")
        {
            this.consoleClose()
            return
        }
        oldlogstate := ""
        if(Logger.consid != 0)
        {
            FileRead, oldlogstate, % logLocation
            if(oldlogstate != "")
            {
                oldlogstate := "`r`n" . oldlogstate
            }
        }
        FileDelete, % logLocation
        sleep, 10
        
        
        ntext := this.DateString() . ": " . msg . oldlogstate
        
        FileAppend, % ntext, % logLocation
        
        if(Logger.consid = 0)
        {
            this.initGUI()
        }
        Gui, Console: +LastFound
        GuiControl, Hide, %LogConts%
        GuiControl, Disable, %LogConts%
        Gui, Color,, %consolecol%
        GuiControl, Text, %LogConts%, % ""
        Gui, Console: Font, S10, Consolas
        tWmax := this.conmaxw - (2*conspadding) - 25
        Gui, Console: Add, Edit, x%conspadding% y%conspadding% w%tWmax% %cfontcol% -VScroll -E0x200 HwndLogConts, % ntext
        ControlGetPos,,,, ctH,, ahk_id %LogConts%
        if(ctH + 2*conspadding > this.conmaxh)
        {
            ControlMove,,,,,this.conmaxh-2*conspadding, ahk_id %LogConts%
        }
        
        if(Logger.consid == 0)
        {
            gui, Console: show, x0 y0 autosize NoActivate
            gui, Console: +LastFound
            Logger.consid := WinExist()
        }
        else
        {
            gui, Console: show, autosize NoActivate
        }

    } ; END logg

    initGUI(){
        LogConts := Logger.LogConts
        consolecol := Logger.consolecol
        cfontcol := Logger.cfontcol
        consid := Logger.consid
        conspadding := this.conspadding



        MinConsoleHwnd := 0
        SlideConsoleHwnd := 0
        ClearConsoleHwnd := 0
        SaveConsoleHwnd := 0
        OpenConsoleHwnd := 0
        CloseConsoleHwnd := 0



        ; +E0x20 ; <-- click through!
        GUI, Console: New, +Lastfound +AlwaysOnTop +ToolWindow +E0x08000000, Console
        gui, Console: color, %consolecol%
        WinSet, Transparent, 180
        Gui, Console: -Caption
        cbuwi := 17
        cbuhe := 14
        cbux := this.conmaxw-cbuwi-this.conspadding
        cbuy := 0
        gui, Console: Font, S7 center
        gui, add, button, hwndMinConsoleHwnd w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, _
        cbuy += 18
        ; trigger error
        ; gui, add, button, hwndSlideConsoleHwnd w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, <
        ; cbuy += 18
        gui, add, button, hwndClearConsoleHwnd w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, C
        cbuy += 18
        gui, add, button, hwndSaveConsoleHwnd w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, S
        cbuy += 18
        gui, add, button, hwndOpenConsoleHwnd w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, O
        cbuy += 18
        gui, add, button, hwndCloseConsoleHwnd w%cbuwi% h%cbuhe% x%cbux% y%cbuy%, X
        FileDelete, this.logLocation

        fn_minConsole := this.minConsole.Bind(this)
        fn_slideConsole := this.slideConsoleSimple.Bind(this)
        fn_clearConsole := this.clearConsole.Bind(this)
        fn_saveConsole := this.saveConsole.Bind(this)
        fn_openConsole := this.openConsole.Bind(this)
        fn_closeConsole := this.closeConsole.Bind(this)
		GuiControl +g, %MinConsoleHwnd%, % fn_minConsole
		GuiControl +g, %SlideConsoleHwnd%, % fn_slideConsole
		GuiControl +g, %ClearConsoleHwnd%, % fn_clearConsole
		GuiControl +g, %SaveConsoleHwnd%, % fn_saveConsole
		GuiControl +g, %OpenConsoleHwnd%, % fn_openConsole
		GuiControl +g, %CloseConsoleHwnd%, % fn_closeConsole

        sleep, 10

    
    }

    minConsole(){
        consid := Logger.consid
        WinHide, ahk_id %consid%
    }

    saveConsole(){
        logLocation := this.logLocation
        GUI, Console: +OwnDialogs
        FileSelectFile, logsaveloc,S,% "Log " . this.DateString(true) . ".log",Save Log, Logs (*.log)
        if(logsaveloc)
        {
            filecopy, %logLocation%, %logsaveloc%
        }
    }

    openConsole(){
        logLocation := this.logLocation
        run, %logLocation%
    }

    slideConsole(){
        consid := Logger.consid
        if(this.conshide := !this.conshide)
        {
            ; WinMove, ahk_id %Logger.consid%,,0,0
            this.slideWin(consid, 0,0,200)
        }
        else
        {
            ; WinMove, ahk_id %Logger.consid%,,30-%this.conmaxw%,0
            this.slideWin(consid, 30,0,200,true)
        }
    }

    slideConsoleSimple(){
        consid := Logger.consid
        if(this.conshide := !this.conshide)
        {
            WinActivate, ahk_id %consid%
            WinMove, ahk_id %consid%,,0,0
        }
        else
        {
            WinActivate, ahk_id %consid%
            WinMove, ahk_id %consid%,,30 - this.conmaxw,0
        }
    }

    clearConsole(){
        logLocation := this.logLocation
        LogConts := Logger.LogConts
        FileDelete, % logLocation
        GuiControl, Text, %LogConts%, % ""
        ControlMove,,,,,30, ahk_id %LogConts%
        gui, Console: show, x0 y0 autosize NoActivate        
    }

    closeConsole()
    {
        ; gui, Console: Destroy
        this.fadeWin(Logger.consid, 1, true)
        Logger.consid := 0
    }

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
            this.fadeWin(msid, ms, closeOnFinish, ntrans)
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
            this.slideWin(msid, tX, tY, T, rightAlign, closeOnFinish, false, dX, dY, step+1, maxStep)
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


}


