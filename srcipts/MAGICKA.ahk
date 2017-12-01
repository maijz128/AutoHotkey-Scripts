
#Persistent
#SingleInstance

SetTitleMatchMode, 1

#IfWinActive, MAGICKA
{

    $t::
        TargetSelf()
        return
    $g::
        TargetGround()
        return
    $z::
        wwwww()
        TargetSelf()
        return
    $x::
        sdfff()
        TargetGround()
        return
    $c::
        sdqqq()
        TargetGround()
        return
    $v::
        sdrrr()
        TargetGround()
        return

}

;BEGIN Game Functions

TargetSelf(){
    PressKeyOnce("MButton")
}

TargetGround(){
    Send {LShift Down}
    PressKeyOnce("MButton")
    Send {LShift Up}       
}

;END Game Functions


;BEGIN Game Skills

wwwww(){
    PressKey("w", 5, 10)
}

sdfff(){
    PressKeyOnce("s")
    PressKeyOnce("d")
    PressKey("f", 3, 10)
}

sdqqq(){
    PressKeyOnce("s")
    PressKeyOnce("d")
    PressKey("q", 3, 10)
}

sdrrr(){
    PressKeyOnce("s")
    PressKeyOnce("d")
    PressKey("r", 3, 10)
}

qrqrq(){
    PressKeyOnce("q")
    PressKeyOnce("r")
    PressKeyOnce("q")
    PressKeyOnce("r")
    PressKeyOnce("q")
}

;END Game Skills


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