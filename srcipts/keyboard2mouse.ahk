#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#Persistent
#SingleInstance 

#Include %A_ScriptDir%\logger.ahk

global testLogger := new Logger("keyboard2mouse.test.log")
loging(msg){ 
    ; testLogger.log(msg)
}



; 变量区
global mouseX := 0
global mouseY := 0
global workerA := new Worker()



SetTitleMatchMode, 1
#IfWinActive ahk_exe notepad++.exe
{
    # Ctrl + F6 
    $^F6::workerA.pause()
    $^F7::workerA.resume() 
    $^F8::workerA.readData() 
    $^F9::workerA.saveData()
    $^F11::workerA.resetData()
    $^F10::workerA.enterRecord()
    $^F12::workerA.quitRecord()

    
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

handle(keyName){
    workerA.handle(keyName)
}


Class Worker {
    paused := false
    isRecord := False
    keyMap := {}
    filename := ""
    testData := {"keyA": "valueA"}

    __New(filename = "keyboard2mouse.data.txt"){
        this.filename := filename
    }

    test(){
        v := this.testData["keyA"]
        if(this.testData.HasKey("keyA")){
            send %v%
            loging(v)
        }
    }

    log(msg){
        loging(msg)
    }

    pause(){
        this.paused := true
        this.showMessage("pause")
        this.log("pause")
    }

    resume(){
        this.paused := false
        this.showMessage("resume")
        this.log("resume")
    }

    enterRecord(){
        this.isRecord := True
        this.log("enter record...")
        this.showMessage("enter record")
    }

    quitRecord(){
        this.isRecord := False
        this.log("quit record")
        this.showMessage("quit record.")
    }

    resetData(){
        this.keyMap := {}
        this.log("reset data")
        this.showMessage("reset data")
    }

    readData(){
        filename := this.filename
        IfNotExist, %filename% 
        {
            this.log("not exist data file.")
            return
        }
        this.log("read data...")
        Loop, read, %filename% 
        {
            If (A_LoopReadLine = ""){
                Continue
            }
            array := StrSplit(A_LoopReadLine, ",", " `t")
            keyName := array[1]
            xpos := array[2]
            ypos := array[3]

            this.keyMap[keyName] := {"x": xpos, "y": ypos}
            this.log(" key_" . keyName . " x_" . xpos . " y_" . ypos)
        }
        this.log("read data done.")
        this.showMessage("read data")
    }

    saveData(){
        this.log("start save data ...")

        dataLines := ""
        array := this.keyMap
        For key, value in array
        {
            keyName := key
            xpos := value["x"]
            ypos := value["y"]

            if(keyName != "" && xpos != "" && ypos != ""){
                line := keyName . "," . xpos . "," . ypos . "`n"
                dataLines := dataLines . line

                this.log(" key_" . keyName . " x_" . xpos . " y_" . ypos) 
            }

        }
        if(dataLines == ""){
            this.log("save data failed: data is empty!")
            this.showMessage("save data failed")
        }else{
            filename := this.filename
            IfExist, %filename% 
            {
                FileDelete, %filename%
            }
            FileAppend, %dataLines%, %filename%

            this.log("save data succeed.")
            this.showMessage("save data succeed")
        }
    }

    handle(keyName){
        if(this.paused){
            send %keyName%
            return
        } 

        this.log("handle key: " . keyName)
        ; this.log("is record: " . (this.isRecord ? "true" : "false") )

        if(this.isRecord){
            MouseGetPos, xpos, ypos 
            this.keyMap[keyName] := { "x": xpos, "y": ypos}

            this.log("record key: " . keyName . " x: " . xpos . " y: " . ypos)
        }else{
            if(this.keyMap.HasKey(keyName)){
                targetX := this.keyMap[keyName]["x"]
                targetY := this.keyMap[keyName]["y"]
                this.click(targetX, targetY)

                this.log("target x: " . targetX . " target y: " . targetY) 
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

MaxLength(Array)
{
	For each, item in Array
		If (StrLen(item) > MaxLength)
			MaxLength := StrLen(item)
	return MaxLength
}

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

